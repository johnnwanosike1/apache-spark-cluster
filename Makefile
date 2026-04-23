.PHONY: help init build up up-gluten down logs status clean data notebook

JUPYTER_URL  := http://localhost:8888
SCALE        ?= 1

help:
	@echo ""
	@echo "  make init          create local directories"
	@echo "  make build         docker compose build"
	@echo "  make up            start cluster in vanilla mode"
	@echo "  make up-gluten     start cluster with Gluten/Velox enabled"
	@echo "  make down          stop cluster"
	@echo "  make logs          tail spark-master logs"
	@echo "  make status        docker compose ps"
	@echo "  make data          generate benchmark data (SCALE=1)"
	@echo "  make clean         stop + delete all data"
	@echo "  make notebook      open JupyterLab in browser"
	@echo ""

init:
	mkdir -p data notebooks/results spark-events
	touch data/.gitkeep spark-events/.gitkeep
	@if [ ! -f .env ]; then cp .env.example .env && echo "Created .env from .env.example"; fi
	@echo "Directories created."

build:
	docker compose -f docker-compose-cluster.yml build --no-cache

up: init
	docker compose -f docker-compose-cluster.yml up -d
	@echo ""
	@echo "  Spark Master UI  →  http://localhost:8080"
	@echo "  History Server   →  http://localhost:18080"
	@echo "  JupyterLab       →  http://localhost:8888  (token: spark)"
	@echo ""
	@echo "Run 'make logs' to watch startup."

up-gluten: init
	GLUTEN_ENABLED=true docker compose -f docker-compose-cluster.yml up -d
	@echo ""
	@echo "  Gluten/Velox mode ENABLED"
	@echo "  Spark Master UI  →  http://localhost:8080"
	@echo "  JupyterLab       →  http://localhost:8888  (token: spark)"
	@echo ""

down:
	docker compose -f docker-compose-cluster.yml down

logs:
	docker compose -f docker-compose-cluster.yml logs -f spark-master

status:
	docker compose -f docker-compose-cluster.yml ps

data:
	@echo "Generating benchmark data (SCALE=$(SCALE)) inside notebook container..."
	docker compose exec notebook jupyter nbconvert --to notebook --execute \
		--ExecutePreprocessor.timeout=300 \
		/workspace/notebooks/05_generate_benchmark_data.ipynb \
		--output /workspace/notebooks/05_generate_benchmark_data.ipynb
	@echo "Done — data ready in ./data/"

clean:
	docker compose -f docker-compose-cluster.yml down
	rm -rf data/*.parquet data/parquet data/delta data/iceberg
	rm -rf spark-events/*
	@echo "Data cleared. JAR cache (ivy2/) and notebook results kept."

notebook:
	@which xdg-open > /dev/null 2>&1 && xdg-open $(JUPYTER_URL) || \
	 which open      > /dev/null 2>&1 && open      $(JUPYTER_URL) || \
	 echo "Open $(JUPYTER_URL) in your browser  (token: spark)"

nuke:
	docker compose -f docker-compose-cluster.yml down --rmi all --volumes --remove-orphans 2>/dev/null || true
	docker builder prune -f
	@echo "All images and cache removed. Run 'make build' to rebuild from scratch."

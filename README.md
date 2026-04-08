# Apache Spark 4.0.2 — Local Cluster with Gluten/Velox, Iceberg, Delta, JupyterLab 

A self-contained local Spark cluster with Gluten/Velox support, built on the official `spark:4.0.2-scala2.13-java17-python3-ubuntu` Docker image.

| Mode | Command | Description |
|---|---|---|
| **Vanilla** | `make up` | Standard JVM-based Spark execution |
| **Gluten/Velox** | `make up-gluten` | Native columnar execution via Gluten 1.6.0 + Velox |

## Stack

| Component | Version | Notes |
|---|---|---|
| Apache Spark | **4.0.2** | Scala 2.13, Java 17 |
| Apache Gluten | **1.6.0** | Velox backend — supports Spark 4.0.x |
| Apache Iceberg | **1.10.1** | `iceberg-spark-runtime-4.0_2.13` |
| Delta Lake | **4.0.1** | `delta-spark_2.13` |
| JupyterLab | latest | |
| Base OS | Ubuntu 22.04 | |

> **Note:** Gluten 1.6.0 was tested against Spark 4.0.1. Running on 4.0.2 produces a harmless
> `version not matched` warning — everything works correctly.

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│  Docker network: spark-net                               │
│                                                          │
│  spark-master   :8080 (UI)  :7077 (cluster)              │
│       ├── spark-worker-1   :8081                         │
│       └── spark-worker-2   :8082                         │
│                                                          │
│  spark-history  :18080                                   │
│  notebook       :8888  (JupyterLab)  :4040 (App UI)      │
└──────────────────────────────────────────────────────────┘
```

## Quick Start

```bash
# 1. Clone
git clone https://github.com/<your-username>/spark-cluster.git
cd spark-cluster

# 2. Init directories + .env
make init

# 3. Build image (~10 min first time — downloads Gluten JAR ~98 MB)
make build

# 4a. Vanilla mode
make up

# 4b. Gluten/Velox mode
make up-gluten

# 5. Generate benchmark data inside the notebook container
make data

# 6. Open JupyterLab
make notebook      # → http://localhost:8888  token: spark
```

## URLs

| Service | URL |
|---|---|
| Spark Master UI | http://localhost:8080 |
| Worker 1 | http://localhost:8081 |
| Worker 2 | http://localhost:8082 |
| History Server | http://localhost:18080 |
| JupyterLab | http://localhost:8888 (token: `spark`) |
| Spark App UI | http://localhost:4040 (active job only) |

## Project Structure

```
spark-cluster/
├── Dockerfile                        Spark 4.0.2 + Iceberg + Delta + Gluten
├── docker-compose.yml                master, 2 workers, history, notebook
├── docker-compose.override.yml       local resource overrides
├── entrypoint.sh                     role dispatcher + Gluten config injection
├── Makefile
├── conf/spark-defaults.conf          Iceberg, Delta, AQE, event log config
├── notebooks/
│   ├── 01_dataframe_basics.ipynb
│   ├── 02_caching_partitioning.ipynb
│   ├── 03_parquet_iceberg_delta.ipynb
│   ├── 04_streaming_udf_aqe.ipynb
│   ├── 05_generate_benchmark_data.ipynb
│   └── 06_benchmark_vanilla_vs_gluten.ipynb
├── scripts/
│   ├── generate_data.py
│   └── test_connection.py
├── data/                             Parquet data (git-ignored)
└── spark-events/                     History Server logs (git-ignored)
```

## Notebooks

| # | Notebook | Topic |
|---|---|---|
| 01 | DataFrame Basics | DataFrame API, SQL, window functions |
| 02 | Caching & Partitioning | persist, broadcast join, AQE |
| 03 | Parquet / Iceberg / Delta | formats, time travel, MERGE |
| 04 | Streaming, UDF, AQE | structured streaming, pandas UDF |
| 05 | Generate Benchmark Data | TPC-H style data generation |
| 06 | Benchmark Vanilla vs Gluten | TPC-H queries, timing, comparison chart |

## Benchmark Workflow

```bash
# 1. Start cluster
make up-gluten

# 2. Generate data (~150 MB, scale=1)
make data

# 3. Open JupyterLab → run notebook 06
make notebook
```

## How Gluten Config is Injected

`entrypoint.sh` appends Gluten settings to `spark-defaults.conf` at container startup
when `GLUTEN_ENABLED=true`. The Gluten JAR lives in `$SPARK_HOME/jars/` and is loaded
automatically — no `extraClassPath` needed.

## Makefile Reference

```bash
make init          # create directories, copy .env.example → .env
make build         # docker compose build
make up            # start vanilla cluster
make up-gluten     # start Gluten/Velox cluster
make down          # stop cluster
make logs          # tail spark-master logs
make status        # docker compose ps
make data          # generate TPC-H benchmark data
make clean         # stop + delete data
make nuke          # remove all images + builder cache
make notebook      # open JupyterLab in browser
```

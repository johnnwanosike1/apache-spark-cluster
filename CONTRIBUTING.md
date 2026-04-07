# Contributing

Contributions are welcome. This document explains how to work with the repo locally.

## Prerequisites

- Docker Desktop 4.x or Docker Engine + Compose v2
- Python 3.10+
- GNU Make
- x86-64 hardware (Gluten/Velox prebuilt JARs are x86-64 only)

## Local Development Workflow

```bash
# 1. Fork + clone
git clone https://github.com/<your-username>/spark-cluster.git
cd spark-cluster

# 2. Create a feature branch
git checkout -b feat/my-improvement

# 3. Make changes

# 4. Validate locally before pushing
make build                         # rebuilds the Docker image
docker compose config --quiet      # validates compose syntax
python -m py_compile scripts/*.py  # checks Python syntax

# 5. Commit and push
git add .
git commit -m "feat: describe your change"
git push origin feat/my-improvement

# 6. Open a pull request
```

## What to Check Before Opening a PR

- [ ] `docker compose config --quiet` passes
- [ ] `python -m py_compile scripts/generate_data.py scripts/test_connection.py` passes
- [ ] Notebook cells are valid JSON (`python -m json.tool notebooks/*.ipynb > /dev/null`)
- [ ] `entrypoint.sh` remains executable (`chmod +x entrypoint.sh`)
- [ ] New Spark or library versions are documented in `CHANGELOG.md`
- [ ] README is updated if the workflow or URLs change

## Updating Spark or Library Versions

Edit `Dockerfile`:

```dockerfile
ARG SPARK_VERSION=4.1.1    # update here
ARG GLUTEN_VERSION=1.6.0   # update here when Gluten 1.5 (Spark 4.x) is released
```

Also update the Python client version in `scripts/test_connection.py`:
```python
# pip install pyspark==<new-version>
```

## Adding a New Notebook Scenario

Add a new cell section to `notebooks/spark_scenarios_benchmark.ipynb`.
Keep the pattern: a Markdown header cell followed by one or more code cells.
All output should use `.show()` or `print()` — no saved state between cells.

## Reporting Issues

Please include:
- Host OS and Docker version (`docker --version`, `docker compose version`)
- Output of `docker compose logs spark-master` (first 50 lines)
- Whether the issue occurs in vanilla mode, Gluten mode, or both

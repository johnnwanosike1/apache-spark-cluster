# Changelog

All notable changes to this project are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

---

## [1.0.0] — 2026-04-07

### Added
- Apache Spark **4.1.1** cluster (Scala 2.13, Java 21) on official `spark:4.1.1` Docker image
- Custom `Dockerfile` — pre-downloads Iceberg 1.10.1, Delta Lake 4.1.0, and Gluten 1.4.0 JARs at build time; no `spark.jars.packages` at runtime
- `entrypoint.sh` — single script handles `master`, `worker`, `notebook`, and `history` roles; Gluten/Velox enabled or disabled at startup via `GLUTEN_ENABLED` env var
- `docker-compose.yml` — master + 2 workers + History Server + JupyterLab; vanilla/Gluten toggle via env var
- `docker-compose.override.yml` — local resource overrides without touching the main compose file
- `.env.example` — documents all supported environment variables
- `conf/spark-defaults.conf` — baseline config: AQE, event logging, Iceberg & Delta catalogs, Arrow
- `Makefile` — `make up`, `make up-gluten`, `make build`, `make data`, `make clean`, `make notebook`
- `scripts/generate_data.py` — TPC-H style Parquet data generator (orders, lineitem, customer); configurable scale factor
- `scripts/test_connection.py` — smoke test for Spark master connectivity
- `notebooks/spark_scenarios_benchmark.ipynb`:
  - **Part A** — 13 core Spark scenarios: DataFrame API, SQL window functions, caching, partitioning, broadcast join, Parquet, Iceberg, Delta Lake, Structured Streaming, UDFs, AQE
  - **Part B** — TPC-H benchmark (Q1, Q3, Q6, Q12, Q_window) with vanilla vs Gluten/Velox comparison chart
- `.github/workflows/ci.yml` — GitHub Actions: Dockerfile lint (hadolint), docker-compose validation, Python syntax check, notebook JSON validation

### Notes
- Gluten 1.4.x targets Spark 3.5; Spark 4.x support is planned for Gluten 1.5 (not released as of April 2026). On Spark 4.1.1 some operators fall back to JVM — safe and expected. See `Dockerfile` for the upgrade path.

---

## Roadmap

- [ ] Update to Gluten 1.5 once Spark 4.x support is released
- [ ] Add Spark Connect mode (separate compose profile)
- [ ] Add MinIO service for S3-compatible local object storage
- [ ] Add Nessie catalog option for Iceberg
- [ ] GitHub Actions job to build and push Docker image to GHCR

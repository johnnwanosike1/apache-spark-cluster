# Changelog

## [2.0.0] — 2026-04-07

### Changed
- **Spark downgrade: 4.1.1 → 3.5.8** — Gluten 1.4.x is fully compatible with
  Spark 3.5 / Scala 2.12. Spark 4.x support requires Gluten 1.5 (not yet released).
- Base image: `spark:3.5.8-scala2.12-java17-python3-ubuntu`
- Iceberg: `iceberg-spark-runtime-3.5_2.12:1.5.2` (was `4.0_2.13:1.10.1`)
- Delta Lake: `delta-spark_2.12:3.3.1` (was `delta-spark_4.1_2.13:4.1.0`)
- Python client: `pyspark==3.5.8`, `delta-spark==3.3.1`

### Fixed
- `entrypoint.sh`: restored full Gluten config including
  `spark.shuffle.manager=ColumnarShuffleManager` which is valid on Spark 3.5.

---

## [1.0.2] — 2026-04-07

### Fixed
- `entrypoint.sh`: `unset SPARK_SUBMIT_OPTS` and `unset SPARK_JAVA_OPTS` added
  to prevent `--conf` flags from leaking into `spark-class` / `launch_gateway`
  JVM invocations (`Unrecognized option: --conf` crash).
- `entrypoint.sh`: removed `spark.shuffle.manager=ColumnarShuffleManager` from
  Gluten config block — this class does not exist in Spark 4.x and caused a
  `ClassNotFoundException` JVM crash.

---

## [1.0.0] — 2026-04-07

### Added
- Initial release with Spark 4.1.1 cluster (Scala 2.13, Java 21)
- Dockerfile, entrypoint.sh, docker-compose.yml
- Iceberg 1.10.1 + Delta 4.1.0 + Gluten 1.6.0
- JupyterLab notebook with 13 scenarios + TPC-H benchmark
- Makefile, .env.example, CONTRIBUTING.md, GitHub Actions CI

## [3.0.0] — 2026-04-07

### Changed
- **Gluten upgrade: 1.4.0 → 1.6.0**
- Download URL: `https://dlcdn.apache.org/gluten/1.6.0/apache-gluten-1.6.0-bin-spark-3.5.tar.gz`
- New official URL format from `gluten.apache.org/downloads/`

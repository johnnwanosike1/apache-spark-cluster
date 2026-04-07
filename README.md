# Apache Spark 3.5.8 — Local Cluster with Gluten/Velox | Iceberg | Delta Lake | JupyterLab

A self-contained local Spark cluster with full Gluten/Velox support, built on the **official** `spark:3.5.8-scala2.12-java17-python3-ubuntu` Docker image.

| Mode | Command | Description |
|---|---|---|
| **Vanilla** | `make up` | Standard JVM-based Spark execution |
| **Gluten/Velox** | `make up-gluten` | Native columnar execution via Gluten 1.4 + Velox |

## Stack

| Component | Version | Notes |
|---|---|---|
| Apache Spark | **3.5.8** | Scala 2.12, Java 17 |
| Apache Gluten | **1.6.0** | Velox backend — fully compatible with Spark 3.5 |
| Apache Iceberg | **1.5.2** | `iceberg-spark-runtime-3.5_2.12` |
| Delta Lake | **3.3.1** | `delta-spark_2.12` |
| JupyterLab | latest | |
| Base OS | Ubuntu 22.04 | Required by Gluten prebuilt JARs |

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

# 3. Build image (~5 min first time)
make build

# 4a. Vanilla mode
make up

# 4b. Gluten/Velox mode
make up-gluten

# 5. Generate benchmark data (TPC-H style)
make data          # ~150 MB  (scale=1)
make data SCALE=5  # ~750 MB

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
├── Dockerfile                        Spark 3.5.8 + Iceberg + Delta + Gluten
├── docker-compose.yml                master, 2 workers, history, notebook
├── docker-compose.override.yml       local resource overrides
├── entrypoint.sh                     role dispatcher + Gluten config injection
├── Makefile
├── conf/spark-defaults.conf          Iceberg, Delta, AQE, event log config
├── notebooks/
│   └── spark_scenarios_benchmark.ipynb   Part A: scenarios / Part B: benchmark
├── scripts/
│   ├── generate_data.py              TPC-H style data generator
│   └── test_connection.py            smoke test
├── data/                             Parquet data (git-ignored)
├── spark-events/                     History Server logs (git-ignored)
└── .github/workflows/ci.yml
```

## Notebook Contents

### Part A — Core Scenarios
| # | Topic |
|---|---|
| 0 | SparkSession (vanilla / Gluten mode) |
| 1 | DataFrame API |
| 2 | Spark SQL — window functions, CTEs |
| 3 | Caching & Persist |
| 4 | Partitioning |
| 5 | Broadcast join |
| 6 | Parquet + partition pruning |
| 7 | Apache Iceberg — ACID, MERGE, Time Travel, Schema Evolution |
| 8 | Delta Lake — ACID, Time Travel, OPTIMIZE |
| 9 | Structured Streaming |
| 10 | UDF & Pandas UDF |
| 11 | AQE & explain() |

### Part B — Vanilla vs Gluten/Velox Benchmark
| # | Topic |
|---|---|
| 12 | Load TPC-H data |
| 13 | Queries + runner (Q1, Q3, Q6, Q12, Q_window) |
| 14 | Warmup |
| 15 | Run & save results |
| 16 | Verify Velox operators in plan |
| 17 | Comparison chart |

## Benchmark Workflow

```bash
# Run 1 — vanilla
make up && # execute Part B in notebook
# saves: notebooks/results/results_vanilla.json

# Run 2 — Gluten
make down && make up-gluten && # execute Part B in notebook
# saves: notebooks/results/results_gluten.json

# Chart is rendered in cell 17 once both files exist
```

## How Gluten Config is Injected

`entrypoint.sh` appends Gluten settings to `spark-defaults.conf` at container
startup when `GLUTEN_ENABLED=true`. This is the only correct approach —
`SPARK_SUBMIT_OPTS` with `--conf` flags crashes the JVM with
`Unrecognized option: --conf` because `spark-class` passes env vars raw to
the JVM process args parser.

## Makefile Reference

```bash
make init          # create directories, copy .env.example → .env
make build         # docker compose build
make up            # start vanilla cluster
make up-gluten     # start Gluten/Velox cluster
make down          # stop cluster
make logs          # tail spark-master logs
make status        # docker compose ps
make data          # generate TPC-H data (SCALE=1)
make data SCALE=5  # generate ~750 MB data
make clean         # stop + delete data
make notebook      # open JupyterLab in browser
```

## Upgrading to Spark 4.x + Gluten 1.5

When Gluten 1.5 (Spark 4.x support) is released, update `Dockerfile`:

```dockerfile
FROM spark:4.x.x-scala2.13-java21-python3-ubuntu
ARG GLUTEN_VERSION=1.5.x
# Update JAR name: gluten-velox-bundle-spark4.x_2.13-ubuntu_22.04-1.5.x.jar
# Remove spark.shuffle.manager from entrypoint Gluten block (renamed in Spark 4.x)
```

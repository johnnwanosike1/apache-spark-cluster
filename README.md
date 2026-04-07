# Apache Spark 4.1.1 — Local Cluster with Gluten/Velox

A self-contained local Spark cluster built on the **official Apache Spark 4.1.1** base image.
Supports two runtime modes switchable via a single environment variable:

| Mode | Command | Description |
|---|---|---|
| **Vanilla** | `make up` | Standard JVM-based Spark execution |
| **Gluten/Velox** | `make up-gluten` | Native columnar execution via Gluten + Velox |

> **Gluten compatibility note**  
> Gluten 1.4.x (latest stable) officially targets **Spark 3.2–3.5**.  
> Spark 4.x support is planned for **Gluten 1.5** (not released as of April 2026).  
> On Spark 4.1.1 some SQL operators may fall back to JVM — this is safe and expected.  
> Check physical plans for `Velox`-prefixed operators to confirm what was offloaded.

---

## Stack

| Component | Version |
|---|---|
| Apache Spark | **4.1.1** (Scala 2.13, Java 21) |
| Apache Iceberg | 1.10.1 |
| Delta Lake | 4.1.0 |
| Apache Gluten | 1.4.0 (Velox backend) |
| JupyterLab | latest |
| Base OS | Ubuntu 22.04 |

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
git clone https://github.com/ekuziel/apache-spark-cluster.git
cd spark-cluster

# 2. Create directories
make init

# 3. Build image (~5 min first time — downloads Spark + JARs)
make build

# 4a. Start in vanilla mode
make up

# 4b. Or start with Gluten/Velox
make up-gluten

# 5. Generate benchmark data (TPC-H style, ~150 MB)
make data          # default scale=1
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
├── Dockerfile                        # Spark 4.1.1 + Iceberg + Delta + Gluten
├── docker-compose.yml                # Cluster: master, 2 workers, history, notebook
├── entrypoint.sh                     # Role dispatcher + Gluten/vanilla switch
├── Makefile                          # Shortcuts
├── conf/
│   └── spark-defaults.conf           # Spark config (AQE, eventLog, Iceberg, Delta)
├── notebooks/
│   └── spark_scenarios_benchmark.ipynb  # Part A: scenarios  Part B: benchmark
├── scripts/
│   ├── generate_data.py              # TPC-H style Parquet data generator
│   └── test_connection.py            # Smoke test
├── data/                             # Parquet data (git-ignored)
├── spark-events/                     # Event logs for History Server (git-ignored)
└── .github/
    └── workflows/
        └── ci.yml                    # Validate Dockerfile syntax + Python scripts
```

## Notebook Contents

The notebook `spark_scenarios_benchmark.ipynb` has two parts:

### Part A — Core Scenarios
| # | Topic |
|---|---|
| 0 | SparkSession setup (vanilla / Gluten mode) |
| 1 | DataFrame API — filter, withColumn, aggregations |
| 2 | Spark SQL — window functions, CTEs |
| 3 | Caching & Persist — timing comparison |
| 4 | Partitioning — repartition vs coalesce |
| 5 | Broadcast join — plan comparison |
| 6 | Parquet — write, read, partition pruning |
| 7 | Apache Iceberg — ACID, MERGE, Time Travel, Schema Evolution |
| 8 | Delta Lake — ACID, Time Travel, OPTIMIZE + ZORDER |
| 9 | Structured Streaming — rate source, windowed aggregation |
| 10 | UDF & Pandas UDF |
| 11 | AQE & `explain()` — skewed join |

### Part B — Vanilla vs Gluten/Velox Benchmark
| # | Topic |
|---|---|
| 12 | Load TPC-H Parquet data |
| 13 | Benchmark queries (Q1, Q3, Q6, Q12, Q_window) + runner |
| 14 | Warmup |
| 15 | Run all queries, save JSON results |
| 16 | Verify Gluten operator offloading (`Velox` in plan) |
| 17 | Comparison chart (requires both vanilla + gluten result files) |

## Benchmark Workflow

```bash
# Step 1 — vanilla run
make up
# run notebook Part B → saves notebooks/results/results_vanilla.json

# Step 2 — Gluten run
make down
make up-gluten
# run notebook Part B → saves notebooks/results/results_gluten.json

# Step 3 — comparison chart rendered automatically in cell 17
```

## Makefile Reference

```bash
make init          # create directories
make build         # docker compose build
make up            # start vanilla cluster
make up-gluten     # start Gluten/Velox cluster
make down          # stop cluster
make logs          # tail spark-master logs
make status        # docker compose ps
make data          # generate benchmark data (SCALE=1)
make data SCALE=5  # generate ~750 MB data
make clean         # stop + delete data
make notebook      # open JupyterLab in browser
```

## Upgrading Gluten to Spark 4.x

When Gluten 1.5 (with Spark 4.x support) is released, update `Dockerfile`:

```dockerfile
ARG GLUTEN_VERSION=1.5.0   # update version

# Update JAR name to match new Spark 4.x artifact naming
RUN wget ... gluten-velox-bundle-spark4.1_2.13-ubuntu_22.04-${GLUTEN_VERSION}.jar ...
```

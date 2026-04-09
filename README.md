# Apache Spark 4.0.2 — Local Cluster with Gluten/Velox, Iceberg, Delta, JupyterLab

A local development environment for testing and benchmarking Spark features and performance.

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
├── Dockerfile
├── docker-compose.yml
├── docker-compose.override.yml
├── entrypoint.sh
├── Makefile
├── conf/
│   └── spark-defaults.conf
├── scripts/
│   ├── generate_data.py
│   └── test_connection.py
├── notebooks/
│   │
│   ├── 01_dataframe_basics.ipynb
│   ├── 02_caching_partitioning.ipynb
│   ├── 03_parquet_iceberg_delta.ipynb
│   ├── 04_streaming_udf_aqe.ipynb
│   ├── 05_generate_benchmark_data.ipynb
│   ├── 06_benchmark_vanilla_vs_gluten.ipynb
│   │
│   ├── gluten_velox/                        ← Gluten/Velox deep dives
│   │   ├── README.md
│   │   ├── 01_fallback_analysis.ipynb
│   │   ├── 02_velox_performance_deep_dive.ipynb
│   │   └── 03_off_heap_memory.ipynb
│   │
│   ├── performance_internals/               ← Query planning & optimization
│   │   ├── README.md
│   │   ├── 01_query_plan_deep_dive.ipynb
│   │   ├── 02_aqe_deep_dive.ipynb
│   │   ├── 03_memory_management.ipynb
│   │   └── 04_join_strategies.ipynb
│   │
│   ├── data_formats_storage/                ← File formats & storage
│   │   ├── README.md
│   │   ├── 01_format_benchmark.ipynb
│   │   ├── 02_iceberg_advanced.ipynb
│   │   └── 03_delta_advanced.ipynb
│   │
│   └── streaming/                           ← Structured Streaming
│       ├── README.md
│       ├── 01_structured_streaming_fundamentals.ipynb
│       ├── 02_streaming_iceberg.ipynb
│       └── 03_stateful_operations.ipynb
│
├── docs/                                    ← Troubleshooting guides
│   └── windows-tips.md
├── data/                                    ← Parquet data (git-ignored)
└── spark-events/                            ← History Server logs (git-ignored)
```

## Notebooks

### Core notebooks

| # | Notebook | Topic |
|---|---|---|
| 01 | DataFrame Basics | DataFrame API, SQL, window functions, CTEs |
| 02 | Caching & Partitioning | persist, broadcast join, partitioning strategies |
| 03 | Parquet / Iceberg / Delta | formats, ACID, time travel, MERGE |
| 04 | Streaming, UDF, AQE | structured streaming, pandas UDF, explain() |
| 05 | Generate Benchmark Data | TPC-H style data generation in Spark |
| 06 | Benchmark Vanilla vs Gluten | TPC-H queries, timing, comparison chart |

### `gluten_velox/` — Gluten/Velox deep dives

| Notebook | What you will learn |
|---|---|
| `01_fallback_analysis` | Which operators offload to Velox vs fall back to JVM, how to measure offload rate, why Python UDFs always fall back, decision tree for writing Gluten-friendly queries |

### `performance_internals/` — Query planning & optimization

| Notebook | What you will learn |
|---|---|
| `01_query_plan_deep_dive` | All `explain()` modes, reading physical plans, predicate pushdown into Parquet, join strategy selection, Spark UI guide |
| `02_aqe_deep_dive` | All 3 AQE features: partition coalescing, dynamic join conversion, skew join splitting — each with hands-on benchmarks |

### `data_formats_storage/` — File formats & storage

| Notebook | What you will learn |
|---|---|
| `01_format_benchmark` | Row vs columnar formats, Parquet/ORC/Avro/CSV write+read benchmark, column pruning, predicate pushdown, compression codec comparison |
| `02_iceberg_advanced` | ACID transactions, MERGE INTO, time travel, schema evolution, partition evolution, row-level DELETE/UPDATE, snapshot management, branching & tagging |
| `03_delta_advanced` | Transaction log internals, OPTIMIZE, ZORDER, VACUUM, Change Data Feed, time travel, RESTORE, schema enforcement/evolution, generated columns, data skipping |

### `streaming/` — Structured Streaming

| Notebook | What you will learn |
|---|---|
| `01_structured_streaming_fundamentals` | Stream-as-table model, file/memory sources, output modes, watermarking, sliding windows, checkpointing, metrics monitoring |

## Docs & Troubleshooting

Platform-specific tips and known issues are in the [`docs/`](docs/) folder.

| Guide | Content |
|---|---|
| [`docs/windows-tips.md`](docs/windows-tips.md) | Port binding errors (Hyper-V reserved ranges), CRLF line endings, executable bits, Docker memory |

## Benchmark Workflow

```bash
# 1. Start cluster
make up-gluten

# 2. Generate data (~150 MB, scale=1)
make data

# 3. Open JupyterLab → run notebook 06
make notebook
```

## Gluten/Velox Notes

- `Q_window` (window function with large shuffle) is skipped in Gluten mode — known
  limitation of Gluten 1.6.0, tracked upstream
- `spark.sql.ansi.enabled=false` is set in `spark-defaults.conf` — Gluten does not
  support ANSI mode
- `spark.shuffle.sort.bypassMergeThreshold=0` — disables shuffle writers incompatible
  with Gluten's columnar batch serializer

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

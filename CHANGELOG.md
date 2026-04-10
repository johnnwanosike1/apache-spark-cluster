# Changelog

All notable changes follow [Semantic Versioning](https://semver.org/):
- **MAJOR** — breaking stack change (Spark version, incompatible config)
- **MINOR** — new features, new notebooks, new tools
- **PATCH** — bug fixes, documentation, CI improvements

---

## [1.1.2] — 2026-04-10

### Added — Iceberg basics (10 notebooks) + Avro basics (10 notebooks)

#### `data_formats_storage/basics/iceberg/`
- `01_first_table` — Iceberg architecture (metadata.json + Avro manifests + Parquet data),
  CREATE TABLE via SQL and writeTo API, Hadoop catalog, Iceberg vs Delta comparison
- `02_reading_writing` — writeTo/append/overwritePartitions, fanout-enabled, partition pruning
- `03_snapshots` — Snapshot per write, .snapshots metadata, rollback_to_snapshot, expire_snapshots
- `04_time_travel` — VERSION AS OF, TIMESTAMP AS OF, tags as named checkpoints, snapshot diffs
- `05_partitioning` — Hidden partitioning transforms (years/months/days/hours/bucket/truncate),
  automatic partition pruning without explicit partition columns in SQL
- `06_schema_evolution` — ADD/DROP/RENAME columns (metadata-only), type promotion,
  column IDs vs names (true rename safety without data rewrite)
- `07_partition_evolution` — REPLACE PARTITION FIELD without data rewrite, mixed-layout
  reads, partition spec history per file
- `08_merge_upsert` — MERGE INTO (basic + 3-way + WHEN NOT MATCHED BY SOURCE),
  CDC upsert pattern, MoR vs CoW write modes
- `09_maintenance` — expire_snapshots, rewrite_data_files (binpack), rewrite_manifests,
  remove_orphan_files — maintenance schedule
- `10_metadata_tables` — All Iceberg metadata tables (.snapshots/.files/.manifests/
  .history/.partitions/.refs), table health dashboard

#### `data_formats_storage/basics/avro/`
- `01_reading_avro` — format("avro"), avroSchema reader option, ignoreMissingFiles,
  recursiveFileLookup, JAR verification
- `02_writing_avro` — Compression codecs (uncompressed/snappy/deflate/bzip2),
  explicit avroSchema on write, recordName/namespace
- `03_schema_definition` — All Avro types (primitive, record, array, map, union, enum),
  logical types (date/timestamp), Avro JSON to Spark StructType mapping
- `04_schema_evolution` — Backward/forward/full compatibility rules, add/remove with
  defaults, aliases for rename, reader vs writer schema pattern
- `05_nullable_unions` — ["null","T"] pattern, default value ordering, complex unions,
  null handling in Spark queries
- `06_nested_records` — Nested records, arrays of records, maps, dot notation access,
  explode patterns, flatten for analytics/Parquet storage
- `07_kafka_simulation` — Confluent wire format (magic byte + schema_id + payload),
  Schema Registry simulation, batch Avro deserialization in Spark
- `08_avro_vs_parquet` — Detailed benchmark: storage size, write/read speed, column
  pruning (Avro has none), predicate pushdown, when to use each format
- `09_avro_to_parquet` — Multi-version Avro landing zone, wide schema normalization,
  type conversion, partitioned Parquet output, row count validation
- `10_avro_compression` — Codec benchmark (uncompressed/snappy/deflate/bzip2/xz),
  compression per data type, Kafka vs storage codec recommendations

## [1.1.1] — 2026-04-09

### Fixed
- Added `spark-avro_2.13-4.0.2.jar` to Dockerfile — Avro is built-in since Spark 2.4
  but requires the external JAR to be deployed; without it `format("avro")` throws
  `AnalysisException: Failed to find data source: avro`

---

## [1.1.0] — 2026-04-09

### Added — Data Formats & Storage expansion

#### `data_formats_storage/`
- `04_iceberg_advanced_2.ipynb` — Change Data Feed for CDC pipelines, branching
  workflow (dev/staging/prod with fast-forward), MoR vs CoW compaction strategies,
  full metadata table observability, row-level delete performance
- `05_delta_advanced_2.ipynb` — Liquid Clustering (next-gen ZORDER), Deletion Vectors
  for fast row-level deletes, low-shuffle MERGE, dynamic partition overwrite,
  shallow/deep table cloning
- `06_parquet_internals.ipynb` — Parquet physical layout (row groups/column chunks/pages),
  encoding schemes (PLAIN_DICTIONARY/RLE/DELTA_BINARY_PACKED), column statistics and
  data skipping, row group size tuning, Parquet vs ORC internal comparison
- `07_avro_schema_registry.ipynb` — Avro binary format and schema definition, schema
  evolution (backward/forward/full compatibility), Schema Registry pattern simulation,
  Kafka→Avro→Parquet pipeline, Avro vs Parquet performance benchmark

---

## [1.0.1] — 2026-04-08

### Added — Learning Notebooks

New folder structure under `notebooks/` with deep-dive notebooks for self-study:

#### `gluten_velox/`
- `01_fallback_analysis.ipynb` — Gluten/Velox operator fallback analysis: which operators
  offload to Velox vs fall back to JVM, how to measure offload rate, Python UDF fallback,
  decision tree for writing Gluten-friendly queries
- `02_velox_performance_deep_dive.ipynb` — Why Velox outperforms JVM (SIMD vectorization,
  columnar processing, native Parquet reader), 18-query benchmark framework across all
  operator categories, vanilla vs Gluten speedup report with median/p25/p75 timings
- `03_off_heap_memory.ipynb` — Complete memory model (on-heap/off-heap/overhead/Velox
  native pool), GC pressure profiling in both modes, Tungsten off-heap configuration,
  Velox memory tuning, OOM error diagnosis guide with fixes

#### `performance_internals/`
- `01_query_plan_deep_dive.ipynb` — Reading `explain()` output, all plan modes, physical
  operators, predicate pushdown into Parquet, join strategy selection, Spark UI guide
- `02_aqe_deep_dive.ipynb` — All 3 AQE features: partition coalescing, dynamic join
  conversion, skew join splitting — each with hands-on benchmarks

#### `data_formats_storage/`
- `01_format_benchmark.ipynb` — Row vs columnar formats, Parquet/ORC/Avro/CSV
  write+read benchmark, column pruning, predicate pushdown, compression codec comparison
- `02_iceberg_advanced.ipynb` — ACID transactions, MERGE INTO, time travel, schema
  evolution, partition evolution, row-level DELETE/UPDATE, snapshot management,
  expire + compaction, branching & tagging
- `03_delta_advanced.ipynb` — Transaction log internals, OPTIMIZE, ZORDER, VACUUM,
  Change Data Feed, time travel, RESTORE, schema enforcement/evolution, generated
  columns, data skipping statistics

#### `streaming/`
- `01_structured_streaming_fundamentals.ipynb` — Stream-as-table model, file/memory
  sources, append/complete/update output modes, watermarking, sliding windows,
  checkpointing, metrics monitoring
- `02_streaming_iceberg.ipynb` — Exactly-once writes to Iceberg, atomic snapshot
  commits per micro-batch, time travel on streaming data, aggregated streaming sinks,
  online compaction while stream is running
- `03_stateful_operations.ipynb` — Session windows, `mapGroupsWithState` (VIP
  detection, running totals), `flatMapGroupsWithState` (conversion funnel analysis),
  state timeout strategies (ProcessingTime vs EventTime), RocksDB state store

---

## [1.0.0] — 2026-04-08

### Added
- Initial stable release with fully working Spark 4.0.2 + Gluten 1.6.0 stack
- Core notebooks 01–06 verified end-to-end
- Benchmark notebook: vanilla vs Gluten/Velox (Q1, Q3, Q6, Q12)
- Makefile, `.env.example`, GitHub Actions CI

### Stack
- **Apache Spark 4.0.2** — Scala 2.13, Java 17
- **Apache Gluten 1.6.0** — Velox backend, `spark-4.0` tarball from `dlcdn.apache.org`
- **Apache Iceberg 1.10.1** — `iceberg-spark-runtime-4.0_2.13`
- **Delta Lake 4.0.1** — `delta-spark_2.13`

### Fixed
- `spark.sql.ansi.enabled=false` — Gluten does not support ANSI mode
- `spark.shuffle.sort.bypassMergeThreshold=0` — disables shuffle writers incompatible
  with Gluten columnar batch serializer (`UnsupportedOperationException`)
- `Q_window` skipped in Gluten benchmark — known Gluten 1.6.0 limitation
- Notebook 05 `l_discount` type error — `rng.choice([0, 0.02, ...])` returns `int`;
  wrapped with `float()`
- Benchmark chart handles missing queries gracefully
- `spark.shuffle.sort.bypassMergeThreshold` moved to SparkSession builder — Spark 4.x
  prohibits changing static configs at runtime
- Removed `pyspark` pip package — caused `NoSuchMethodError: getConfiguredLocalDirs`
  due to duplicate JARs conflicting with `/opt/spark/jars/`
- Added standalone `py4j` pip package (PySpark Python binding dependency)
- `delta-spark` installed with `--no-deps` to prevent pip pulling duplicate `pyspark`

### CI
- `SHELL ["/bin/bash", "-o", "pipefail", "-c"]` added (hadolint DL4006)
- `DL3002` suppressed — `USER root` required for entrypoint to write `spark-defaults.conf`
- `chmod +x entrypoint.sh` before executable check (git on Windows loses executable bit)
- All file reads use `encoding="utf-8", errors="replace"` — handles non-UTF-8 bytes
- `spark-defaults.conf` key validation step
- Stale version ref check across docs and config files

---

## [0.9.1] — 2026-04-07

### Changed
- Gluten upgrade: 1.4.0 → 1.6.0
- Download URL updated to official Apache CDN: `dlcdn.apache.org/gluten/`
- `./scripts/` mounted into notebook container as `/workspace/scripts/`
- `make data` updated to run notebook 05 inside container via `nbconvert`

---

## [0.9.0] — 2026-04-07

### Added
- Initial working prototype: Spark 3.5.8 + Gluten 1.4.0
- Docker Compose: master, 2 workers, history server, notebook
- Spark 3.5.8 chosen for Gluten 1.4.x compatibility (Spark 4.x required Gluten 1.5+)
- `entrypoint.sh` injects Gluten config into `spark-defaults.conf` at startup
- `.gitattributes` with `*.sh eol=lf` to prevent Windows CRLF breaking shebangs
- `sed -i 's/\r//'` in Dockerfile as second line of defence against CRLF

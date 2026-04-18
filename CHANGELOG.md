# Changelog

All notable changes follow [Semantic Versioning](https://semver.org/):
- **MAJOR** — breaking stack change (Spark version, incompatible config)
- **MINOR** — new features, new notebooks, new tools
- **PATCH** — bug fixes, documentation, CI improvements

---

## [1.1.5] — 2026-04-17

### Added — Training notebooks

#### `notebooks/training/` (7 notebooks)
- `01_spark_architecture` — Driver/executor roles, deployment modes (client/cluster/local), execution hierarchy (Job→Stage→Task), lazy evaluation, fault tolerance via lineage, GC impact
- `02_dataframe_api` — select/selectExpr/withColumn/withColumnRenamed/drop, filter, sort, aggregations, all join types (inner/left/semi/anti/cross), union/unionByName, missing data (dropna/fillna/replace), repartition vs coalesce
- `03_spark_sql` — Temp views vs global views, window functions (rank/dense_rank/row_number/lag/lead/running totals), Catalyst optimizer phases, SQL functions (date/string/conditional)
- `04_udfs` — Python UDF with NULL handling, Pandas UDF (vectorized Series→Series), performance comparison built-in > Pandas UDF > Python UDF
- `05_structured_streaming` — Output modes (append/complete/update) rules, all trigger types, checkpointLocation (writeStream not readStream), watermarking for late data
- `06_performance_optimization` — StorageLevel variants, broadcast joins + threshold, AQE (coalesce/broadcast upgrade/skew), data skew solutions (salting/broadcast/repartition), explain() reading
- `07_pandas_api_on_spark` — pyspark.pandas API (df.pandas_api()), groupby/fillna/apply, toPandas() driver memory warning, to_spark(index_col) conversion

## [1.1.4] — 2026-04-10

### Added — Configuration notebooks + bug fixes

#### `notebooks/configuration/` (new folder)
- `01_active_configuration` — All explicitly configured parameters from spark-defaults.conf, live values from SparkSession, category (Cluster/SQL/AQE/Catalog/Shuffle/JVM), explanation, pandas HTML render
- `02_all_parameters` — All Spark parameters via getConf().getAll(), filter by prefix, keyword search, explicitly set vs default comparison, CSV export

#### Bug fixes (basics/ notebooks)
- `avro/01_reading_avro` — pyarrow.dataset Avro not supported → fastavro; .load(*args) → .load(list); glob strings → explicit list; ignoreMissingFiles removed
- `avro/03_schema_definition` — tuple nested structs → explicit StructType + Row(); print syntax error with quotes; multi-non-null union → informational cell + workaround
- `avro/04_schema_evolution` — .load(v1, v2) → .load([v1, v2])
- `avro/05_nullable_unions` — complex union write attempt → informational + JSON string workaround; quote syntax errors fixed
- `avro/06_nested_records` — tuple nested structs → Row(); array of tuples → array of Row()
- `avro/09_avro_to_parquet` — .load(*all_dirs) → .load(all_dirs)
- `csv/01_reading_csv` — glob string [12] → explicit list; missing glob import; \N unicode escape; quote multi-char error
- `csv/04_dirty_data` — .cache() required before _corrupt_record filter (Spark 4.x)
- `csv/05_large_csv` — csv_input_dir=DATA_DIR → glob *.csv only (CONFLICTING_DIRECTORY_STRUCTURES)
- `csv/06_encodings` — UTF-8-BOM not supported → Python BOM strip workaround (×2 cells)
- `csv/07_csv_vs_tsv` — quote multi-char error
- `csv/08_csv_transformations` — amount__ → amount (normalize_col_name result)
- `csv/10_streaming_csv` — _corrupt_record missing from schema
- `delta/02_reading_writing` — backslash continuation + .option() indentation error
- `delta/04_updates_deletes` — INSERT * → explicit INSERT; UPDATE subquery not supported → DeltaTable API
- `delta/06_optimize_zorder` — OPTIMIZE WHERE non-partition column → partitioned table
- `delta/07_schema_enforcement` — ALTER TABLE CHANGE COLUMN requires enableTypeWidening + correct syntax
- `delta/08_change_data_feed` — UPDATE LIMIT → collect IDs; backslash in f-string fixed
- `delta/09_partitioning` — Row.get() → getattr()
- `delta/10_maintenance` — retentionDurationCheck must be set BEFORE VACUUM
- `iceberg/02_reading_writing` — CREATE TABLE AS VALUES(1) → writeTo.createOrReplace()
- `iceberg/04_time_travel` — UPDATE LIMIT + subquery → collect IDs; backslash in f-string
- `iceberg/05_partitioning` — CREATE TABLE AS VALUES(1) → writeTo.partitionedBy()
- `iceberg/07_partition_evolution` — same VALUES(1) fix
- `iceberg/08_merge_upsert` — same VALUES(1) fix; tableProperty API
- `iceberg/09_maintenance` — UPDATE LIMIT fix
- `iceberg/10_metadata_tables` — UPDATE LIMIT fix
- `json/01_reading_json` — .cache() + count() before _corrupt_record filter
- `json/02_writing_json` — bz2 → bzip2 codec name
- `json/07_json_schema_validation` — .cache() + materialization before filter
- `orc/10_performance_tuning` — revenue → price column name
- `parquet/01_reading_parquet` — parquet(list) → parquet(*list)
- `parquet/03_partitioning` — missing glob import; os.listdir → .is_dir() filter
- `parquet/06_schema_evolution` — LONG→INT narrowing → try/except (Spark 4.x rejects)
- `parquet/09_nested_data` — groupBy("user.country") after select → F.col() directly
- `protobuf/02_proto_schema` — protoc FileNotFoundError → grpcio-tools + Python protobuf fallback
- `protobuf/04_spark_protobuf` — indentation error; FileNotFoundError wrap; pip install protobuf before import

#### README
- Added detailed notebook tables for basics/csv, basics/parquet, basics/delta, basics/iceberg, basics/avro
- Added configuration/ section to Project Structure and Notebooks

## [1.1.3] — 2026-04-09

### Added — ORC basics (10), JSON basics (10), Protobuf basics (10)

#### `data_formats_storage/basics/orc/`
- `01_reading_orc` — spark.read.orc, column pruning, predicate pushdown, stripe metadata, ORC vs Parquet size
- `02_writing_orc` — compression codecs (zlib/snappy/lz4/zstd), stripe size, bloom filters, sorted write
- `03_orc_internals` — 3-level index (file/stripe/row-index), column encodings (DIRECT/DICTIONARY/DELTA/RLE_V2), statistics
- `04_predicate_pushdown` — bloom filter + min/max skipping, supported predicates, explain() verification
- `05_orc_vs_parquet` — head-to-head benchmark, schema evolution limits, ecosystem, when to use each
- `06_hive_compatibility` — Hive-style partition discovery, ACID ORC format (base + delta), SerDe properties
- `07_complex_types` — StructType/ArrayType/MapType in ORC, nested column pruning, explode patterns
- `08_stripe_tuning` — stripe size vs query pattern benchmark, row index stride, production config template
- `09_orc_to_parquet` — migration pipeline, schema preservation, row count + checksum validation
- `10_performance_tuning` — slow baseline diagnosis, apply all optimizations, before/after benchmark, checklist

#### `data_formats_storage/basics/json/`
- `01_reading_json` — spark.read.json, multiLine mode, PERMISSIVE/DROPMALFORMED/FAILFAST, all options
- `02_writing_json` — compression codecs, date/timestamp formatting, single file coalesce, write modes
- `03_schema_inference` — inferSchema cost, samplingRatio danger, type conflicts, primitivesAsString, explicit schema
- `04_nested_json` — struct dot notation, explode/posexplode/explode_outer, from_json/to_json, get_json_object, flatten
- `05_json_streaming` — file-based streaming, Kafka JSON deserialization, from_json in Structured Streaming
- `06_json_performance` — JSON vs Parquet vs Avro size/speed benchmark, no column pruning, convert-first pattern
- `07_json_schema_validation` — PERMISSIVE + columnNameOfCorruptRecord, business rule validation, quarantine pipeline
- `08_json_rest_apis` — wrapped/paginated API responses, unwrapping with explode, multi-page normalization
- `09_json_to_parquet` — multi-day landing zone, incremental processing with checkpoint, row count validation
- `10_json_best_practices` — schema versioning, deduplication, production checklist, common pitfalls

#### `data_formats_storage/basics/protobuf/`
- `01_what_is_protobuf` — format overview, wire types, Protobuf vs JSON vs Avro, gRPC use case, Spark API
- `02_proto_schema` — proto3 syntax, all scalar types, nested messages, repeated fields, oneof, enums, field numbers
- `03_serialization` — wire format internals (varint/fixed/length-delimited), Python protobuf library, size benchmark
- `04_spark_protobuf` — from_protobuf/to_protobuf, descriptor file compilation, file format, Spark 4.0.2
- `05_schema_evolution` — field number permanence, reserved numbers, wire-compatible type changes, vs Avro evolution
- `06_protobuf_kafka` — Kafka + Protobuf architecture, Confluent SR wire format (magic byte + schema_id), streaming
- `07_protobuf_vs_json_avro` — comprehensive benchmark: size, speed, evolution, ecosystem, gRPC, decision guide
- `08_nested_protobuf` — nested message→StructType, repeated→ArrayType, map→MapType, oneof, flatten for analytics
- `09_protobuf_to_parquet` — binary landing zone, UDF-based deserializer, Parquet output, row count validation
- `10_protobuf_best_practices` — .proto design guidelines, descriptor management, Spark 4.0.2 checklist, full recap

## [1.1.2] — 2026-04-09

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

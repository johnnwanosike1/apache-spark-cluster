# Data Formats & Storage

File formats, compression, storage layout, and open table formats for analytical workloads.

| Notebook | What you will learn |
|---|---|
| `01_format_benchmark.ipynb` | Row vs columnar formats, Parquet/ORC/Avro/CSV write+read benchmark, column pruning, predicate pushdown, compression codec comparison |
| `02_iceberg_advanced.ipynb` | ACID transactions, MERGE INTO, time travel, schema evolution, partition evolution, row-level DELETE/UPDATE, snapshot management, branching & tagging |
| `03_delta_advanced.ipynb` | Transaction log internals, OPTIMIZE, ZORDER, VACUUM, Change Data Feed, time travel, RESTORE, schema enforcement/evolution, generated columns, data skipping |
| `04_iceberg_advanced_2.ipynb` | CDF for CDC pipelines, branching workflow (dev/staging/prod), MoR vs CoW compaction, metadata tables, row-level delete strategies |
| `05_delta_advanced_2.ipynb` | Liquid Clustering vs ZORDER, Deletion Vectors, low-shuffle MERGE, dynamic partition overwrite, shallow/deep clone |
| `06_parquet_internals.ipynb` | Row groups, column chunks, encoding schemes (dict/RLE/delta), column statistics, data skipping, row group size tuning, Parquet vs ORC internals |
| `07_avro_schema_registry.ipynb` | Avro format, schema evolution (backward/forward/full compatibility), Schema Registry pattern, Kafka→Avro→Parquet pipeline, Avro vs Parquet benchmark |

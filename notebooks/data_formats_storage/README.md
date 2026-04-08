# Data Formats & Storage

File formats, compression, storage layout, and open table formats for analytical workloads.

| Notebook | What you will learn |
|---|---|
| `01_format_benchmark.ipynb` | Row vs columnar formats, Parquet/ORC/Avro/CSV write+read benchmark, column pruning, predicate pushdown, compression codec comparison |
| `02_iceberg_advanced.ipynb` | ACID transactions, MERGE INTO, time travel, schema evolution, partition evolution, row-level DELETE/UPDATE, snapshot management, branching & tagging |
| `03_delta_advanced.ipynb` | Transaction log internals, OPTIMIZE, ZORDER, VACUUM, Change Data Feed, time travel, RESTORE, schema enforcement/evolution, generated columns, data skipping |

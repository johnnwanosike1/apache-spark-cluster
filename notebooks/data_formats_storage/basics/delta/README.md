# Delta Lake Basics — 10 Notebooks

Complete guide to Delta Lake from first table to production maintenance.

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_first_table.ipynb` | What Delta is (Parquet + _delta_log), three ways to create a table, transaction log internals, DESCRIBE DETAIL, Delta vs plain Parquet |
| 02 | `02_reading_writing.ipynb` | Write modes, idempotent writes (txnAppId/txnVersion), replaceWhere targeted overwrite, reading specific versions, insertInto vs writeTo vs save |
| 03 | `03_acid_transactions.ipynb` | Atomicity demo, optimistic concurrency, schema consistency enforcement, snapshot isolation, concurrent read/write safety |
| 04 | `04_updates_deletes.ipynb` | UPDATE, DELETE, MERGE INTO, CDC upsert pattern, deduplication MERGE, Deletion Vectors, DML performance tips |
| 05 | `05_time_travel.ipynb` | VERSION AS OF, TIMESTAMP AS OF, RESTORE, debugging with snapshots, ML reproducibility, audit trail |
| 06 | `06_optimize_zorder.ipynb` | OPTIMIZE for small file compaction, ZORDER BY for data clustering, Z-ordering explained, scheduling strategies |
| 07 | `07_schema_enforcement.ipynb` | Schema rejection by default, mergeSchema opt-in, ALTER TABLE ADD/RENAME columns, column mapping mode, safe type widening |
| 08 | `08_change_data_feed.ipynb` | Enable CDF, insert/update_pre/update_post/delete change types, incremental pipeline with checkpoint, downstream replication |
| 09 | `09_partitioning.ipynb` | partitionBy mechanics, partition pruning benchmark, partition-level DML/OPTIMIZE, Liquid Clustering as modern alternative |
| 10 | `10_maintenance.ipynb` | VACUUM (safe file deletion), history retention, DESCRIBE DETAIL health monitoring, complete production maintenance runbook |

# Iceberg Basics — 10 Notebooks

Complete guide to Apache Iceberg from first table to production metadata.

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_first_table.ipynb` | Iceberg architecture (metadata.json + manifests + data files), CREATE TABLE, catalog setup, Delta vs Iceberg comparison |
| 02 | `02_reading_writing.ipynb` | writeTo/append/overwritePartitions, format("iceberg"), fanout-enabled, partition pruning |
| 03 | `03_snapshots.ipynb` | Snapshot creation, .snapshots metadata, rollback_to_snapshot, expire_snapshots |
| 04 | `04_time_travel.ipynb` | VERSION AS OF, TIMESTAMP AS OF (as-of-timestamp), tags as named checkpoints, snapshot diffs |
| 05 | `05_partitioning.ipynb` | Hidden partitioning transforms (years/months/days/hours/bucket/truncate), automatic partition pruning |
| 06 | `06_schema_evolution.ipynb` | ADD/DROP/RENAME columns, type promotion, column IDs vs names, metadata-only changes |
| 07 | `07_partition_evolution.ipynb` | REPLACE PARTITION FIELD (no data rewrite), mixed-layout reads, partition spec history |
| 08 | `08_merge_upsert.ipynb` | MERGE INTO (basic + 3-way), CDC upsert, WHEN NOT MATCHED BY SOURCE, MoR vs CoW modes |
| 09 | `09_maintenance.ipynb` | expire_snapshots, rewrite_data_files (compaction), rewrite_manifests, remove_orphan_files |
| 10 | `10_metadata_tables.ipynb` | .snapshots, .files, .manifests, .history, .partitions, .refs — health dashboard |

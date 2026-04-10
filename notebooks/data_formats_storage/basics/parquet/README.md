# Parquet Basics — 10 Notebooks

Complete guide to reading, writing, and optimizing Parquet files with Apache Spark.

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_reading_parquet.ipynb` | Columnar vs row-based, spark.read.parquet, single file/directory/glob, explicit schema, mergeSchema, footer metadata and statistics |
| 02 | `02_writing_parquet.ipynb` | Write modes, compression codecs comparison, row group size tuning, coalesce vs repartition, sorted write for data skipping, repartitionByRange |
| 03 | `03_partitioning.ipynb` | partitionBy mechanics, partition pruning benchmark, cardinality rules, multi-level partitioning, dynamic partition overwrite |
| 04 | `04_predicate_pushdown.ipynb` | PushedFilters in explain(), supported vs unsupported predicates, row group skipping with statistics, filter ordering |
| 05 | `05_column_pruning.ipynb` | Column-level I/O reduction, ReadSchema in explain(), nested column pruning, select() vs drop(), cache before vs after select |
| 06 | `06_schema_evolution.ipynb` | Adding/removing columns, type promotion rules, mergeSchema, safe rename pattern, multi-version reading |
| 07 | `07_small_files.ipynb` | Causes of small file problem, performance impact benchmark, coalesce vs repartition, compaction, AQE auto-coalescing |
| 08 | `08_compression_codecs.ipynb` | snappy/zstd/gzip/lz4/none benchmark, zstd levels, compression by data type, workload-based selection guide |
| 09 | `09_nested_data.ipynb` | StructType (nested records), ArrayType (lists), MapType (key-value), explode/posexplode, dot notation, JSON→Parquet |
| 10 | `10_performance_tuning.ipynb` | Diagnosis methodology, before/after benchmark, production configuration template, complete optimization checklist |

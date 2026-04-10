# ORC Basics — 10 Notebooks

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_reading_orc.ipynb` | spark.read.orc, column pruning, predicate pushdown, stripe metadata, ORC vs Parquet first look |
| 02 | `02_writing_orc.ipynb` | Compression (zlib/snappy/lz4/zstd), stripe size, bloom filters, sorted write |
| 03 | `03_orc_internals.ipynb` | File/stripe/row-index 3-level layout, column encodings (DIRECT/DICTIONARY/DELTA/RLE_V2), statistics |
| 04 | `04_predicate_pushdown.ipynb` | Bloom filter pushdown, min/max statistics, supported predicates, explain() verification |
| 05 | `05_orc_vs_parquet.ipynb` | Head-to-head benchmark: size, write/read, schema evolution, ecosystem support, decision guide |
| 06 | `06_hive_compatibility.ipynb` | Hive-style partitioning, ACID ORC (base + delta directories), SerDe properties |
| 07 | `07_complex_types.ipynb` | StructType/ArrayType/MapType in ORC, nested column pruning, explode patterns |
| 08 | `08_stripe_tuning.ipynb` | Stripe size vs query pattern benchmark, row index stride, production config template |
| 09 | `09_orc_to_parquet.ipynb` | Migration pipeline, schema preservation, row count + checksum validation, performance after migration |
| 10 | `10_performance_tuning.ipynb` | Diagnosis, optimization checklist, before/after benchmark, complete ORC recap |

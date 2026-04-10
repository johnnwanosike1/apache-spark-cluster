# CSV Basics — 10 Notebooks

Complete guide to reading, writing, and processing CSV files with Apache Spark.

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_reading_csv.ipynb` | spark.read.csv options, header/sep/encoding, single file vs directory vs glob, explicit schema, null handling, quoted values, multiLine |
| 02 | `02_writing_csv.ipynb` | spark.write.csv options, single file (coalesce), custom sep/quote/nullValue, date/timestamp formats, save modes, partitioned write |
| 03 | `03_schema_inference.ipynb` | inferSchema cost (2x scan), samplingRatio danger, StructType vs DDL vs JSON schema, schema mismatch handling, schema evolution |
| 04 | `04_dirty_data.ipynb` | PERMISSIVE/DROPMALFORMED/FAILFAST modes, columnNameOfCorruptRecord, extra/missing columns, whitespace, production quarantine pipeline |
| 05 | `05_large_csv.ipynb` | Why CSV is slow (no column pruning/pushdown), parallelism, CSV vs Parquet benchmark, optimization tips, landing zone pipeline |
| 06 | `06_encodings.ipynb` | UTF-8 vs Latin-1 vs Windows-1252, BOM detection, chardet integration, encoding-safe ingestion pipeline |
| 07 | `07_csv_vs_tsv.ipynb` | Delimiter comparison, quoting problem, semicolon-separated (European CSV), RFC 4180, auto-detecting delimiter |
| 08 | `08_csv_transformations.ipynb` | Normalize column names, trim/case/regex, parse multiple date formats, split compound columns, complete cleaning pipeline |
| 09 | `09_csv_to_parquet.ipynb` | Migration pipeline, size/speed comparison, row count + checksum validation, incremental migration with processed log |
| 10 | `10_streaming_csv.ipynb` | Structured Streaming from CSV directory, schema enforcement, maxFilesPerTrigger, bad row handling, progress monitoring |

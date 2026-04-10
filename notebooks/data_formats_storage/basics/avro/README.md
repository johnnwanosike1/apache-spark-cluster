# Avro Basics — 10 Notebooks

Complete guide to Apache Avro for event streaming and schema evolution.

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_reading_avro.ipynb` | format("avro"), avroSchema option, ignoreMissingFiles, recursiveFileLookup, JAR verification |
| 02 | `02_writing_avro.ipynb` | Write modes, compression codecs, explicit avroSchema on write, recordName/namespace |
| 03 | `03_schema_definition.ipynb` | Primitive types, record, array, map, union, enum — Avro JSON to Spark StructType mapping |
| 04 | `04_schema_evolution.ipynb` | Backward/forward/full compatibility, add/remove with defaults, aliases for rename |
| 05 | `05_nullable_unions.ipynb` | ["null","T"] pattern, default values, complex unions, null handling in Spark |
| 06 | `06_nested_records.ipynb` | Nested records, arrays of records, maps of records, dot notation, explode, flatten patterns |
| 07 | `07_kafka_simulation.ipynb` | Confluent wire format (magic byte + schema_id), Schema Registry simulation, batch deserialization |
| 08 | `08_avro_vs_parquet.ipynb` | Storage size, read speed, column pruning comparison, when to use each format |
| 09 | `09_avro_to_parquet.ipynb` | Multi-version Avro landing zone, wide schema read, normalize, partitioned Parquet output, validate |
| 10 | `10_avro_compression.ipynb` | uncompressed/snappy/deflate/bzip2 benchmark, data type compression efficiency, Kafka vs storage recommendations |

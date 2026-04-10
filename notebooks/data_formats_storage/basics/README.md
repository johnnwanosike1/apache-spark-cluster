# Data Formats — Basics

Step-by-step notebooks for each format, from first read to production patterns.
Each format has 10 notebooks with minimum 5 detailed steps and explanations.

| Format | Folder | Focus |
|---|---|---|
| CSV | `csv/` | Reading, writing, schema, dirty data, encodings, streaming |
| Parquet | `parquet/` | Reading, writing, partitioning, predicate pushdown, column pruning, schema evolution, compression, nested data, performance tuning |
| Delta Lake | `delta/` | First table, ACID, DML, time travel, OPTIMIZE/ZORDER, schema management, CDF, partitioning, maintenance |
| Iceberg | `iceberg/` | First table, snapshots, time travel, hidden partitioning, partition evolution, schema evolution, MERGE, maintenance, metadata tables |
| Avro | `avro/` | Reading/writing, schema definition, evolution, nullable unions, nested records, Kafka simulation, Avro vs Parquet, landing zone pipeline, compression |
| ORC | `orc/` | Reading/writing, internals, predicate pushdown, Hive compat, stripe tuning, ORC vs Parquet, migration |
| JSON | `json/` | Reading/writing, schema inference, nested data, streaming, performance, REST APIs, validation, pipeline |
| Protobuf | `protobuf/` | Proto schema, serialization, Spark from_protobuf, schema evolution, Kafka, vs JSON/Avro, pipeline |

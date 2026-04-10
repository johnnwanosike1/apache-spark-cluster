# Protobuf Basics — 10 Notebooks

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_what_is_protobuf.ipynb` | Protobuf vs JSON vs Avro, wire types, gRPC use case, Spark integration overview |
| 02 | `02_proto_schema.ipynb` | proto3 syntax, scalar types, nested messages, repeated, oneof, enums, field numbers |
| 03 | `03_serialization.ipynb` | Wire format internals, Python protobuf library, serialize/deserialize, size comparison |
| 04 | `04_spark_protobuf.ipynb` | from_protobuf/to_protobuf, descriptor files, reading binary files, Spark 4.0.2 API |
| 05 | `05_schema_evolution.ipynb` | Field number rules, reserved numbers, wire-compatible type changes, Protobuf vs Avro evolution |
| 06 | `06_protobuf_kafka.ipynb` | Kafka + Protobuf architecture, Confluent SR format, deserializing Kafka messages in Spark |
| 07 | `07_protobuf_vs_json_avro.ipynb` | Size/speed benchmark, ecosystem comparison, decision guide |
| 08 | `08_nested_protobuf.ipynb` | nested messages→StructType, repeated→ArrayType, map→MapType, flatten for analytics |
| 09 | `09_protobuf_to_parquet.ipynb` | Binary landing zone, UDF deserializer, Parquet output, validation |
| 10 | `10_protobuf_best_practices.ipynb` | .proto design guidelines, descriptor management, Spark checklist, complete pipeline recap |

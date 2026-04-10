# JSON Basics — 10 Notebooks

| # | Notebook | Topics |
|---|---|---|
| 01 | `01_reading_json.ipynb` | spark.read.json, multiLine, PERMISSIVE/DROPMALFORMED/FAILFAST, corrupt records, options reference |
| 02 | `02_writing_json.ipynb` | Compression, date/timestamp formatting, single file output, write modes |
| 03 | `03_schema_inference.ipynb` | inferSchema cost, samplingRatio risk, type conflicts, primitivesAsString, explicit schema |
| 04 | `04_nested_json.ipynb` | Struct access, explode/posexplode, from_json/to_json, get_json_object, json_tuple, flatten |
| 05 | `05_json_streaming.ipynb` | File-based streaming, Kafka JSON pattern, from_json in streaming, schema enforcement |
| 06 | `06_json_performance.ipynb` | JSON vs Parquet vs Avro benchmark, why JSON is slow, convert-first pattern |
| 07 | `07_json_schema_validation.ipynb` | PERMISSIVE + corrupt capture, business rule validation, quarantine pipeline |
| 08 | `08_json_rest_apis.ipynb` | Wrapped responses, paginated APIs, unwrapping with explode, normalization |
| 09 | `09_json_to_parquet.ipynb` | Multi-day landing zone pipeline, incremental with checkpoint, validation |
| 10 | `10_json_best_practices.ipynb` | Schema management, deduplication, production checklist, common pitfalls |

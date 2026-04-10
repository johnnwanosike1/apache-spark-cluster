# Configuration Notebooks

| Notebook | Content |
|---|---|
| `01_active_configuration` | All **explicitly configured** parameters from `spark-defaults.conf` — live values from SparkSession, category, explanation |
| `02_all_parameters` | **All** Spark parameters (configured + defaults) — filter by prefix, keyword search, explicitly set vs default comparison, CSV export |

## Configured parameter categories

| Category | Parameters |
|---|---|
| Cluster | master, executor.memory, driver.memory, executor.cores |
| SQL | shuffle.partitions, ansi.enabled |
| SQL / AQE | adaptive.enabled, coalescePartitions.enabled |
| SQL / Arrow | execution.arrow.pyspark.enabled |
| Catalog | extensions, catalog.local.*, catalog.spark_catalog |
| Serialization | serializer (Kryo) |
| History | eventLog.enabled, eventLog.dir, history.* |
| Shuffle | sort.bypassMergeThreshold |
| JVM | driver/executor.extraJavaOptions (Gluten log suppression) |

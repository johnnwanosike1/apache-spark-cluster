# Gluten / Velox

Deep dives into the Gluten native execution engine and Velox backend.

| Notebook | What you will learn |
|---|---|
| `01_fallback_analysis.ipynb` | Which operators offload to Velox vs fall back to JVM, how to measure offload rate, Python UDF fallback, decision tree for writing Gluten-friendly queries |
| `02_velox_performance_deep_dive.ipynb` | Why Velox is faster (SIMD, columnar, native Parquet), benchmark framework for 18 queries across scan/filter/agg/join/sort/string, vanilla vs Gluten speedup report |
| `03_off_heap_memory.ipynb` | Three memory pools explained (on-heap/off-heap/overhead), Velox native memory pool, GC pressure comparison, Tungsten off-heap config, OOM diagnosis guide |

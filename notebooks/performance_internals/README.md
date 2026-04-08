# Performance Internals

Understanding how Spark plans and executes queries — the foundation of optimization.

| Notebook | What you will learn |
|---|---|
| `01_query_plan_deep_dive.ipynb` | Reading `explain()` output, all plan modes, physical operators, predicate pushdown into Parquet, join strategy selection, Spark UI guide |
| `02_aqe_deep_dive.ipynb` | All 3 AQE features: partition coalescing, dynamic join conversion, skew join splitting — each with hands-on benchmarks |
| `03_memory_management.ipynb` | Full executor memory model, storage vs execution memory, shuffle spill, off-heap, broadcast variables, GC tuning |
| `04_join_strategies.ipynb` | All 5 join strategies benchmarked, BroadcastHashJoin vs SortMergeJoin vs ShuffledHashJoin, join hints, skew handling with AQE and manual salting |

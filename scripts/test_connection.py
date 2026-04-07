#!/usr/bin/env python3
"""
Quick smoke test — verifies the Spark 3.5.8 master is reachable.

Usage:
    python3 scripts/test_connection.py
"""
import sys, time

def main():
    try:
        from pyspark.sql import SparkSession
    except ImportError:
        print("ERROR: pyspark not installed. Run: pip install pyspark==3.5.8")
        sys.exit(1)

    master = "spark://spark-master:7077"
    print(f"Connecting to {master} ...")

    t0 = time.time()
    spark = (
        SparkSession.builder
        .appName("smoke-test")
        .master(master)
        .config("spark.executor.memory", "1g")
        .config("spark.driver.memory", "512m")
        .getOrCreate()
    )
    spark.sparkContext.setLogLevel("WARN")
    elapsed = time.time() - t0

    print(f"Connected in {elapsed:.2f}s")
    print(f"Spark version : {spark.version}")

    count = spark.range(1_000_000).count()
    assert count == 1_000_000, f"Expected 1000000 got {count}"
    print(f"range(1_000_000).count() = {count}  OK")

    answer = spark.sql("SELECT 6 * 7 AS answer").collect()[0]["answer"]
    assert answer == 42
    print(f"SELECT 6 * 7 = {answer}  OK")

    print("\nAll checks passed.")
    spark.stop()

if __name__ == "__main__":
    main()

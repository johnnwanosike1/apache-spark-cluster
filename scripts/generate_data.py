#!/usr/bin/env python3
"""
TPC-H style benchmark data generator.

Generates Parquet files for orders, lineitem and customer tables.
Run this locally BEFORE starting the cluster:

    pip install pandas pyarrow numpy
    python3 scripts/generate_data.py --scale 1

Scale factor reference:
    1  →  ~150 MB Parquet  (fast build, sufficient for local benchmarks)
    5  →  ~750 MB Parquet  (more visible Vanilla vs Gluten difference)
    10 →  ~1.5 GB Parquet
"""

import argparse
import os
import numpy as np
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
parser = argparse.ArgumentParser(description="Generate TPC-H style Parquet data.")
parser.add_argument("--scale", type=int, default=1,
                    help="Scale factor: 1=~150MB, 5=~750MB (default: 1)")
parser.add_argument("--out", default="data",
                    help="Output directory (default: data)")
args = parser.parse_args()

SF  = args.scale
OUT = args.out
os.makedirs(OUT, exist_ok=True)

RNG = np.random.default_rng(42)

NATIONS  = ["Germany", "France", "UK", "USA", "China", "Japan", "India",
            "Brazil", "Canada", "Australia", "Czech", "Slovakia", "Poland"]
SEGMENTS = ["AUTOMOBILE", "BUILDING", "FURNITURE", "MACHINERY", "HOUSEHOLD"]
STATUS   = ["O", "F", "P"]
PRIORITY = ["1-URGENT", "2-HIGH", "3-MEDIUM", "4-NOT SPECIFIED", "5-LOW"]


def write_parquet(name: str, df: pd.DataFrame) -> None:
    path = os.path.join(OUT, f"{name}.parquet")
    table = pa.Table.from_pandas(df, preserve_index=False)
    pq.write_table(table, path, compression="snappy", row_group_size=100_000)
    mb = os.path.getsize(path) / 1024 / 1024
    print(f"  wrote {path}  ({len(df):,} rows, {mb:.1f} MB)")


def random_dates(n: int, start: str = "1992-01-01", end: str = "1998-12-31") -> list:
    ts_start = pd.Timestamp(start).value // 10**9
    ts_end   = pd.Timestamp(end).value   // 10**9
    return (
        pd.to_datetime(RNG.integers(ts_start, ts_end, n), unit="s")
          .strftime("%Y-%m-%d")
          .tolist()
    )


print(f"\nGenerating TPC-H style data — scale factor {SF} ...")

# ---------------------------------------------------------------------------
# ORDERS
# ---------------------------------------------------------------------------
n_orders = 1_500_000 * SF
print(f"\norders ({n_orders:,} rows):")
orders = pd.DataFrame({
    "o_orderkey":      np.arange(1, n_orders + 1, dtype=np.int64),
    "o_custkey":       RNG.integers(1, 150_000 * SF, n_orders),
    "o_orderstatus":   RNG.choice(STATUS, n_orders),
    "o_totalprice":    RNG.uniform(1_000, 500_000, n_orders).astype(np.float64),
    "o_orderdate":     random_dates(n_orders),
    "o_orderpriority": RNG.choice(PRIORITY, n_orders),
    "o_clerk":         [f"Clerk#{RNG.integers(1, 1000):09d}" for _ in range(n_orders)],
    "o_shippriority":  RNG.integers(0, 2, n_orders, dtype=np.int32),
    "o_comment":       [f"comment_{i}" for i in range(n_orders)],
})
write_parquet("orders", orders)

# ---------------------------------------------------------------------------
# LINEITEM
# ---------------------------------------------------------------------------
n_lines = 6_000_000 * SF
print(f"\nlineitem ({n_lines:,} rows):")
lineitem = pd.DataFrame({
    "l_orderkey":      RNG.integers(1, n_orders + 1, n_lines),
    "l_partkey":       RNG.integers(1, 200_000 * SF, n_lines),
    "l_suppkey":       RNG.integers(1, 10_000 * SF, n_lines),
    "l_linenumber":    RNG.integers(1, 8, n_lines, dtype=np.int32),
    "l_quantity":      RNG.uniform(1, 50, n_lines).astype(np.float64),
    "l_extendedprice": RNG.uniform(1_000, 100_000, n_lines).astype(np.float64),
    "l_discount":      RNG.uniform(0, 0.1, n_lines).astype(np.float64),
    "l_tax":           RNG.uniform(0, 0.08, n_lines).astype(np.float64),
    "l_returnflag":    RNG.choice(["A", "N", "R"], n_lines),
    "l_linestatus":    RNG.choice(["O", "F"], n_lines),
    "l_shipdate":      random_dates(n_lines),
    "l_commitdate":    random_dates(n_lines),
    "l_shipmode":      RNG.choice(["AIR", "MAIL", "RAIL", "REG AIR", "SHIP", "TRUCK", "FOB"], n_lines),
    "l_comment":       [f"lc_{i}" for i in range(n_lines)],
})
write_parquet("lineitem", lineitem)

# ---------------------------------------------------------------------------
# CUSTOMER
# ---------------------------------------------------------------------------
n_cust = 150_000 * SF
print(f"\ncustomer ({n_cust:,} rows):")
customer = pd.DataFrame({
    "c_custkey":    np.arange(1, n_cust + 1, dtype=np.int64),
    "c_name":       [f"Customer#{i:09d}" for i in range(n_cust)],
    "c_address":    [f"addr_{i}" for i in range(n_cust)],
    "c_nationkey":  RNG.integers(0, len(NATIONS), n_cust, dtype=np.int32),
    "c_nation":     RNG.choice(NATIONS, n_cust),
    "c_phone":      [f"00-000-{RNG.integers(100, 999)}-{RNG.integers(1000, 9999)}"
                     for _ in range(n_cust)],
    "c_acctbal":    RNG.uniform(-999, 9_999, n_cust).astype(np.float64),
    "c_mktsegment": RNG.choice(SEGMENTS, n_cust),
    "c_comment":    [f"cc_{i}" for i in range(n_cust)],
})
write_parquet("customer", customer)

print(f"\nDone. Files written to ./{OUT}/")
print("Next: docker compose up --build")

#!/usr/bin/env python3
import sys
from pathlib import Path
import pandas as pd

if len(sys.argv) != 2:
    print("Uso: python3 analyze_correlation.py /ruta/all_results.csv")
    sys.exit(1)

csv_path = Path(sys.argv[1])
df = pd.read_csv(csv_path)

df = df[df["restart_validation_passed"] == "yes"].copy()

numeric_cols = ["runtime_min_entropy", "H_r", "H_c", "H_I", "restart_min", "osr", "max_mem_code"]
for col in numeric_cols:
    df[col] = pd.to_numeric(df[col], errors="coerce")

print("\nFilas válidas:", len(df))
print("\nResumen descriptivo:")
print(df[["runtime_min_entropy", "H_r", "H_c", "H_I", "restart_min"]].describe())

print("\nCorrelaciones globales")
for target in ["H_r", "H_c"]:
    pearson = df["runtime_min_entropy"].corr(df[target], method="pearson")
    spearman = df["runtime_min_entropy"].corr(df[target], method="spearman")
    print(f"runtime_min_entropy vs {target}:")
    print(f"  Pearson : {pearson:.6f}")
    print(f"  Spearman: {spearman:.6f}")

print("\nCorrelación por memory_access")
for mem_access, sub in df.groupby("memory_access"):
    if len(sub) >= 3:
        print(f"\nmemory_access={mem_access}, n={len(sub)}")
        for target in ["H_r", "H_c"]:
            pearson = sub["runtime_min_entropy"].corr(sub[target], method="pearson")
            spearman = sub["runtime_min_entropy"].corr(sub[target], method="spearman")
            print(f"  runtime_min_entropy vs {target}: Pearson={pearson:.6f}, Spearman={spearman:.6f}")

print("\nCorrelación por all_caches")
for all_caches, sub in df.groupby("all_caches"):
    if len(sub) >= 3:
        print(f"\nall_caches={all_caches}, n={len(sub)}")
        for target in ["H_r", "H_c"]:
            pearson = sub["runtime_min_entropy"].corr(sub[target], method="pearson")
            spearman = sub["runtime_min_entropy"].corr(sub[target], method="spearman")
            print(f"  runtime_min_entropy vs {target}: Pearson={pearson:.6f}, Spearman={spearman:.6f}")

out_txt = csv_path.with_name("correlation_report.txt")
with open(out_txt, "w", encoding="utf-8") as f:
    f.write(f"Rows: {len(df)}\n")
    for target in ["H_r", "H_c"]:
        pearson = df["runtime_min_entropy"].corr(df[target], method="pearson")
        spearman = df["runtime_min_entropy"].corr(df[target], method="spearman")
        f.write(f"runtime_min_entropy vs {target}\n")
        f.write(f"  Pearson : {pearson:.6f}\n")
        f.write(f"  Spearman: {spearman:.6f}\n")

print(f"\nReporte guardado en: {out_txt}")1

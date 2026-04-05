#!/usr/bin/env bash
set -euo pipefail

gcc -O2 -Wall -Wextra -pedantic -pthread /mnt/data/jent_autotune.c -lm -o /mnt/data/jent_autotune

#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== Bootstrap (installs only Rust components through rustup when available) =="

for cmd in git rustup cargo rustc; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Missing required command: $cmd" >&2
    echo "Install Git and Rust via rustup, then rerun this script." >&2
    exit 1
  }
done

MIN_FREE_GB="${MIN_FREE_GB:-5}"
AVAILABLE_KB="$(df -Pk "$ROOT" | awk 'NR==2 {print $4}')"
REQUIRED_KB=$((MIN_FREE_GB * 1024 * 1024))
if [[ "$AVAILABLE_KB" -lt "$REQUIRED_KB" ]]; then
  echo "Only $((AVAILABLE_KB / 1024 / 1024)) GiB free; recommended minimum is ${MIN_FREE_GB} GiB." >&2
  echo "Run scripts/disk-audit.sh and review safe cleanup options. Nothing was deleted." >&2
  exit 2
fi

TOOLCHAIN="$(awk -F '"' '/channel/ {print $2; exit}' rust-toolchain.toml)"
if [[ -z "$TOOLCHAIN" ]]; then echo "Could not read toolchain from rust-toolchain.toml" >&2; exit 3; fi

rustup toolchain install "$TOOLCHAIN" --profile minimal --component rustfmt --component clippy
rustup component add rustfmt clippy --toolchain "$TOOLCHAIN"

echo "Running locked Cargo check..."
cargo + "$TOOLCHAIN" check --workspace --all-targets --locked
echo "Bootstrap checks completed. No system cleanup was performed."

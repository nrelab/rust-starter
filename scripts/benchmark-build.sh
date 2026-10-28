#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "Build timing is informational; it does not delete target/."
echo "Toolchain: $(rustc --version 2>/dev/null || echo unavailable)"
echo "sccache: $(sccache --version 2>/dev/null || echo unavailable)"
START="$(date +%s)"
cargo build --workspace --release --locked
END="$(date +%s)"
echo "Release build wall time: $((END - START)) seconds"
if command -v sccache >/dev/null 2>&1; then sccache --show-stats; fi

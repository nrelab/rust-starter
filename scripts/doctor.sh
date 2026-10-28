#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

printf '%s\n' "== Rust Starter: environment doctor =="
printf 'Project: %s\n' "$ROOT"
printf 'OS: '; uname -srm || true
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Disk: '; df -h "$ROOT" | tail -n 1 || true

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '[OK] %-14s %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '[MISSING] %s\n' "$cmd"
  fi
}

for cmd in git rustup rustc cargo make; do check_cmd "$cmd"; done
if command -v rustc >/dev/null 2>&1; then rustc --version; fi
if command -v cargo >/dev/null 2>&1; then cargo --version; fi
if command -v rustup >/dev/null 2>&1; then rustup show active-toolchain || true; fi
if command -v sccache >/dev/null 2>&1; then sccache --version; else echo "[OPTIONAL] sccache is not installed"; fi
if command -v docker >/dev/null 2>&1; then docker --version; else echo "[OPTIONAL] docker is not installed"; fi

if command -v cargo >/dev/null 2>&1; then
  echo
  echo "Cargo environment:"
  cargo metadata --no-deps --format-version 1 >/dev/null 2>&1 \
    && echo "[OK] Cargo manifest parses" || echo "[WARN] Cargo metadata failed; inspect Cargo.toml"
fi

echo
echo "Doctor is read-only. It does not install tools or delete files."

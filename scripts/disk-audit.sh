#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

human_size() {
  if command -v du >/dev/null 2>&1; then du -sh "$1" 2>/dev/null | awk '{print $1}'; else echo "unknown"; fi
}

echo "== Read-only disk audit =="
printf 'Project root: %s\n' "$ROOT"
df -h "$ROOT"
echo
echo "Largest known project-local directories (if present):"
for path in target .git .devcontainer/.cache; do
  if [[ -e "$path" ]]; then printf '  %-24s %s\n' "$path" "$(human_size "$path")"; fi
done

echo
echo "Cargo/Rust cache locations (size checks only):"
CARGO_HOME="${CARGO_HOME:-$HOME/.cargo}"
RUSTUP_HOME="${RUSTUP_HOME:-$HOME/.rustup}"
for path in "$CARGO_HOME/registry" "$CARGO_HOME/git" "$RUSTUP_HOME/toolchains" "$HOME/.cache/sccache"; do
  if [[ -e "$path" ]]; then printf '  %-42s %s\n' "$path" "$(human_size "$path")"; else printf '  %-42s %s\n' "$path" "not present"; fi
done

echo
echo "No files were changed. Review output before considering cleanup."
echo "For a safe preview: bash scripts/safe-clean.sh --preview"

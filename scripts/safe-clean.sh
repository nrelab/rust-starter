#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
MODE=""
PREVIEW=0
YES=0

usage() {
  cat <<'USAGE'
Usage:
  scripts/safe-clean.sh --preview [--target]
  scripts/safe-clean.sh --target [--yes]
  scripts/safe-clean.sh --sccache [--yes]

Options:
  --preview   Show what would be removed; never changes files.
  --target    Remove only this repository's ./target directory.
  --sccache   Clear only the current user's local sccache cache (if known).
  --yes       Skip interactive confirmation (must be explicit).
  --help      Show this help.

This script never deletes OS files, home directories, Cargo registry/git caches,
Rust toolchains, Docker resources, or arbitrary paths.
USAGE
}

while (($#)); do
  case "$1" in
    --preview) PREVIEW=1 ;;
    --target) MODE="target" ;;
    --sccache) MODE="sccache" ;;
    --yes) YES=1 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ "$PREVIEW" -eq 1 && -z "$MODE" ]]; then MODE="target"; fi
if [[ -z "$MODE" ]]; then usage >&2; exit 2; fi

case "$MODE" in
  target)
    TARGET="$ROOT/target"
    [[ "$TARGET" == "$ROOT/target" ]] || { echo "Path validation failed" >&2; exit 3; }
    if [[ ! -e "$TARGET" ]]; then echo "Nothing to clean: $TARGET"; exit 0; fi
    echo "Target selected: $TARGET"
    du -sh "$TARGET" 2>/dev/null || true
    ACTION="remove this project's target directory"
    ;;
  sccache)
    CACHE="${SCCACHE_DIR:-$HOME/.cache/sccache}"
    [[ "$CACHE" == "$HOME/.cache/sccache" || "$CACHE" == "$HOME/.cache/sccache/"* ]] || {
      echo "Refusing non-default sccache path: $CACHE" >&2; exit 3;
    }
    if [[ ! -e "$CACHE" ]]; then echo "Nothing to clean: $CACHE"; exit 0; fi
    echo "sccache selected: $CACHE"
    du -sh "$CACHE" 2>/dev/null || true
    ACTION="remove the local sccache cache only"
    ;;
esac

if [[ "$PREVIEW" -eq 1 ]]; then
  echo "PREVIEW ONLY: would $ACTION."
  exit 0
fi

if [[ "$YES" -ne 1 ]]; then
  read -r -p "Type CLEAN to $ACTION: " answer
  [[ "$answer" == "CLEAN" ]] || { echo "Cancelled."; exit 0; }
fi

case "$MODE" in
  target) rm -rf -- "$ROOT/target" ;;
  sccache)
    if command -v sccache >/dev/null 2>&1; then
      sccache --stop-server >/dev/null 2>&1 || true
    fi
    rm -rf -- "${SCCACHE_DIR:-$HOME/.cache/sccache}"
    ;;
esac
echo "Cleanup completed."

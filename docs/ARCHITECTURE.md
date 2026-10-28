# Repository architecture

```text
Developer machine
  ├── scripts/doctor.sh       read-only diagnostics
  ├── scripts/disk-audit.sh   read-only disk/cache inventory
  ├── scripts/safe-clean.sh   narrowly scoped, confirmed cleanup
  ├── scripts/bootstrap.sh    toolchain + free-space check + Cargo check
  └── make check              fmt → check → clippy → tests → release build

GitHub Actions
  ├── CI: quality gates on PRs and trusted branch pushes
  ├── Security: dependency audit and policy checks
  └── Release: verify tagged version and rerun quality gates

Build caching
  ├── Cargo registry/git cache: dependency source downloads
  ├── Cargo target directory: build artifacts (local workspace)
  └── sccache: compiler artifact cache, local or S3-compatible
```

Keep host preparation separate from project generation. Scripts should report available
space and cache sizes before any cleanup. Do not silently delete toolchains or dependency
caches because that can cause expensive downloads and break offline development.

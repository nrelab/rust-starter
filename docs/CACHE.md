# Build cache strategy

## Layers

1. **Cargo registry and Git cache** — downloaded dependency source. Usually keep this.
2. **`target/`** — workspace build artifacts. Project-local and safe to rebuild, but may be large.
3. **sccache** — caches compiler outputs. Enable with `RUSTC_WRAPPER=sccache`.
4. **Remote sccache backend** — optional shared cache for trusted CI builds.

## Local use

```bash
cargo install sccache --version 0.10.0 --locked
export RUSTC_WRAPPER=sccache
export SCCACHE_DIR="$HOME/.cache/sccache"
export SCCACHE_CACHE_SIZE=5G
cargo build --release --locked
sccache --show-stats
```

## S3-compatible backend

Configure `SCCACHE_BUCKET`, `SCCACHE_REGION`, and `SCCACHE_S3_USE_SSL=true`; configure
AWS credentials through the standard credential chain or GitHub OIDC. Verify supported
environment variables against the exact pinned sccache release before enabling it.
Do not place static AWS keys in workflow YAML or expose remote-cache write credentials to
fork pull requests. Prefer separate read/write permissions and an isolated prefix per repo
or trust domain.

`SCCACHE_S3_KEY_PREFIX` support can vary by sccache version; verify the version's upstream
configuration reference before relying on it. If the selected backend doesn't support a
prefix setting, isolate by bucket or IAM policy instead.

## Build reproducibility

- Commit `Cargo.lock` for applications and CI.
- Use `--locked` in CI.
- Keep `CARGO_INCREMENTAL=0` for predictable CI cache behavior.
- Pin Rust toolchain and sccache version.
- Benchmark cache hit rate and build wall time; cache is not a substitute for correctness.

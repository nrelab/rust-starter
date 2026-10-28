# Development workflow

## Standard loop

```bash
cargo fmt --all
cargo check --workspace --all-targets --locked
cargo clippy --workspace --all-targets --locked -- -D warnings
cargo test --workspace --locked
cargo build --workspace --release --locked
```

Or run `make check`.

## Before changing the toolchain

1. Update `rust-toolchain.toml`.
2. Update `.github/actions/setup-rust/action.yml` default.
3. Test on a clean environment.
4. Regenerate `Cargo.lock` only when required.
5. Document compatibility and performance impact.

## Disk headroom

The bootstrap default expects 5 GiB free. Override with `MIN_FREE_GB=2 bash scripts/bootstrap.sh`
only when you understand the build's disk needs. This check does not clean files.

# Rust Starter — Production Engineering Template

A reusable Rust project scaffold with pinned toolchain configuration, quality gates,
safe developer-machine diagnostics, build caching, GitHub Actions CI/CD, security checks,
and a Dev Container.

> **Safety:** disk scripts audit first. Destructive cleanup requires explicit flags and
> confirmation. No script deletes operating-system files or arbitrary paths.

## Quick start

```bash
# 1. Inspect your machine without changing it
bash scripts/disk-audit.sh
bash scripts/doctor.sh

# 2. Install/check project prerequisites and Rust components
bash scripts/bootstrap.sh

# 3. Run all local quality gates
make check
```

If `rustup` is not installed, install Rust using the official rustup instructions first.
The scaffold targets Rust `1.92.0` by default; change `rust-toolchain.toml` and the
`RUST_TOOLCHAIN` repository variable together when intentionally upgrading.

## Included

- `rust-toolchain.toml`: pinned toolchain, `rustfmt`, `clippy`
- `.cargo/config.toml`: reproducible build defaults and useful aliases
- `scripts/`: diagnostics, disk audit, safe cleanup, bootstrap, checks, build benchmark
- `.github/actions/`: reusable composite actions
- `.github/workflows/`: CI, security, and release workflows
- `.devcontainer/`: containerized development environment
- `docs/`: architecture, cache, CI, security, and maintenance notes
- `Makefile`: standard developer commands

## First-use checklist

- [ ] Review `Cargo.toml`, package name, license, and repository URLs.
- [ ] Run `bash scripts/doctor.sh` and `bash scripts/disk-audit.sh`.
- [ ] Run `bash scripts/bootstrap.sh`.
- [ ] Run `make check`.
- [ ] Configure repository Actions permissions and branch protection.
- [ ] Pin third-party GitHub Actions to reviewed full commit SHAs before production use.
- [ ] Configure cloud credentials only for trusted branches/environments.
- [ ] For S3 caching, configure bucket, region, IAM permissions, and GitHub OIDC separately.
- [ ] Review `docs/SECURITY.md` and `docs/CACHE.md`.

## Important notes

- The sample crate is intentionally small and is meant to be replaced by your application.
- `sccache` remote caching is optional. Local builds work without cloud credentials.
- `cargo audit` and `cargo deny` are installed as optional developer tools; CI handles them
  in the security workflow.
- Release publication is intentionally not automatic. Add registry credentials and a
  protected GitHub Environment only after reviewing the release process.

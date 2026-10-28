SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help doctor disk-audit bootstrap fmt fmt-check check clippy test release security cache-stats build-benchmark clean-target

help: ## Show available commands
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

doctor: ## Diagnose local tools and disk headroom
	bash scripts/doctor.sh

disk-audit: ## Read-only disk/cache audit
	bash scripts/disk-audit.sh

bootstrap: ## Check prerequisites and run a locked Cargo check
	bash scripts/bootstrap.sh

fmt: ## Format Rust files
	cargo fmt --all

fmt-check: ## Verify formatting
	cargo fmt --all -- --check

check: fmt-check ## Run local quality gates
	cargo check --workspace --all-targets --locked
	cargo clippy --workspace --all-targets --locked -- -D warnings
	cargo test --workspace --locked
	cargo build --workspace --release --locked

clippy: ## Run Clippy with warnings as errors
	cargo clippy --workspace --all-targets --locked -- -D warnings

test: ## Run tests
	cargo test --workspace --locked

release: ## Build release profile
	cargo build --workspace --release --locked

security: ## Run security tools if installed
	@command -v cargo-audit >/dev/null 2>&1 && cargo audit || echo "SKIP: cargo-audit not installed"
	@command -v cargo-deny >/dev/null 2>&1 && cargo deny check || echo "SKIP: cargo-deny not installed"

cache-stats: ## Show sccache statistics if installed
	@sccache --show-stats

build-benchmark: ## Compare clean-ish release build duration (does not delete target)
	bash scripts/benchmark-build.sh

clean-target: ## Explicitly remove this project's target directory after confirmation
	bash scripts/safe-clean.sh --target

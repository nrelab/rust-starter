# Security baseline

- Never commit `.env`, cloud credentials, tokens, signing keys, or private certificates.
- Never expose remote cache write credentials to pull requests from forks.
- Use GitHub OIDC and short-lived credentials where possible.
- Keep CI permissions minimal and use protected environments for releases.
- Pin third-party GitHub Actions to reviewed full commit SHAs before production.
- Keep Rust and dependency versions intentional; run `cargo audit` and `cargo deny`.
- Treat build scripts and proc macros as executable code from dependencies.
- Review license policy in `deny.toml` for the project's actual obligations.
- Avoid automatic system cleanup. Inspect `scripts/disk-audit.sh` output before acting.
- Do not run broad commands such as `rm -rf "$HOME/.cargo"` or prune Docker volumes
  without a separate, deliberate maintenance procedure.

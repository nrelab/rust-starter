# CI/CD operating model

## Pull requests

Run formatting, `cargo check`, Clippy with warnings as errors, tests, release build, and
dependency/security checks. Keep permissions read-only unless a job needs more.

## Trusted branch builds

Remote cache writes should happen only on protected branches or trusted release workflows.
Use GitHub OIDC for cloud credentials when supported. Keep cache credentials unavailable to
untrusted fork PRs.

## Release workflow

The included workflow verifies the tag version against Cargo metadata and reruns checks. It
does not publish packages or create a GitHub Release. Add those steps only after configuring
a protected GitHub Environment, explicit approval rules, least-privilege permissions, and
a reviewed signing/provenance policy.

## Supply-chain hardening

The sample uses action version tags for readability. Before production, pin each third-party
action to a reviewed full commit SHA and automate reviewed updates (for example, with Dependabot).
Use a least-privilege token, branch protection, and required status checks.

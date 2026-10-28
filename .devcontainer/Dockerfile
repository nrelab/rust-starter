FROM mcr.microsoft.com/devcontainers/rust:1-bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential pkg-config ca-certificates git curl make python3 \
    && rm -rf /var/lib/apt/lists/*

USER vscode
WORKDIR /workspaces/rust-starter

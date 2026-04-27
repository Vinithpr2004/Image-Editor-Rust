#!/usr/bin/env bash
set -e

# Install rustup
curl https://sh.rustup.rs -sSf | sh -s -- -y

# Add cargo to PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Install stable toolchain
rustup default stable

# Add WASM target
rustup target add wasm32-unknown-unknown

# Run your existing build from the image-lab folder
cd artifacts/image-lab
bash rust-wasm/build.sh

#!/bin/bash -e -o pipefail
################################################################################
##  File:  install-rust.sh
##  Desc:  Install Rust
##  Supply chain security: rustup-init - checksum validation
################################################################################

source ~/utils/utils.sh

echo "Installing Rustup..."
if is_Arm64; then
    arch="aarch64-apple-darwin"
else 
    arch="x86_64-apple-darwin"
fi

download_url="https://static.rust-lang.org/rustup/dist/${arch}/rustup-init"
external_hash="$(curl -fsSL ${download_url}.sha256 | awk '{print $1}')"

binary_path=$(download_with_retry $download_url)

use_checksum_comparison "$binary_path" "$external_hash"

chmod +x "$binary_path"
mv "$binary_path" /usr/local/bin/rustup-init

echo "Installing Rust language..."
rustup-init -y --no-modify-path --default-toolchain=stable --profile=minimal

echo "Initialize environment variables..."
CARGO_HOME=$HOME/.cargo

echo "Install common tools..."
rustup component add rustfmt clippy

echo "Cleanup Cargo registry cached data..."
rm -rf $CARGO_HOME/registry/*

invoke_tests "Rust"

# Tobicoin

A fungible token smart contract for the Stacks blockchain, built with Clarinet.

## Features
- Fungible token `tobi` via `define-fungible-token`
- One-time `initialize` to set the contract owner (the caller)
- Owner-only `mint` to any principal
- `transfer`, `burn`, `get-balance`, `get-total-supply`
- Name: "Tobicoin" | Symbol: "TOBI" | Decimals: 6

## Project structure
- `Clarinet.toml` — Clarinet project manifest (Clarity v2, epoch 2.1)
- `contracts/tobicoin.clar` — Clarity contract implementation

## Prerequisites
- Linux x86_64
- Rust toolchain (for Cargo-based install) or prebuilt Clarinet binary

## Install Clarinet (Linux)
- Cargo (from source):
  ```bash
  cargo install --locked --git https://github.com/stx-labs/clarinet clarinet-cli
  ```
  The binary is installed to `~/.cargo/bin/clarinet` by default.

- Prebuilt binary (alternative):
  - Download the latest release from: https://github.com/stx-labs/clarinet/releases
  - Place `clarinet` into a directory on your `PATH` (e.g., `~/.local/bin`) and `chmod +x clarinet`.

## Common commands
- Check compilation: `clarinet check`
- Open REPL console: `clarinet console`
- Format contracts: `clarinet format`

## Contract interface
- Initialize owner (call once):
  ```
  (contract-call? .tobicoin initialize)
  ```
- Mint (owner only):
  ```
  (contract-call? .tobicoin mint u1000 'ST3J2GVMMM2R07ZFBJDWTYEYAR8FZH5WKDTFJ9AHA)
  ```
- Transfer:
  ```
  (contract-call? .tobicoin transfer u250 'ST...SENDER 'ST...RECIPIENT none)
  ```
- Burn (caller burns own tokens):
  ```
  (contract-call? .tobicoin burn u50)
  ```
- Read balance:
  ```
  (contract-call? .tobicoin get-balance 'ST...WHO)
  ```
- Read total supply:
  ```
  (contract-call? .tobicoin get-total-supply)
  ```

## Notes
- This contract exposes SIP-010-like entrypoints but does not declare explicit `impl-trait`. For strict SIP-010 compliance, add the official trait and implement the exact required signatures.
- Clarinet epoch is set to `2.1` in `Clarinet.toml`, which is required for Clarity v2 contracts.

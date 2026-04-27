# Workspace

## Overview

pnpm workspace monorepo using TypeScript. Each package manages its own dependencies.

## Artifacts

- **image-lab** (`/`) — Real-time image processing web app. React + Vite frontend that
  loads a Rust → WebAssembly module for grayscale, Sobel edge detection, Gaussian
  blur, and RGB histogram operations. The WASM crate lives at
  `artifacts/image-lab/rust-wasm/` and is built into `artifacts/image-lab/src/wasm/`
  by `pnpm --filter @workspace/image-lab run wasm:build`.
- **api-server** (`/api`) — Shared Express 5 API server (currently only `/healthz`).
- **mockup-sandbox** — design canvas sandbox.

## Stack

- **Monorepo tool**: pnpm workspaces
- **Node.js version**: 24
- **Package manager**: pnpm
- **TypeScript version**: 5.9
- **API framework**: Express 5
- **Database**: PostgreSQL + Drizzle ORM
- **Validation**: Zod (`zod/v4`), `drizzle-zod`
- **API codegen**: Orval (from OpenAPI spec)
- **Build**: esbuild (CJS bundle)
- **Native code**: Rust (compiled to WebAssembly via wasm-bindgen 0.2.100)

## Building the Rust → WASM module

The Replit Nix environment ships rustc/cargo without the `wasm32-unknown-unknown`
standard library, so the build script (`artifacts/image-lab/rust-wasm/build.sh`):

1. Mirrors the read-only Nix rustc sysroot to `/tmp/rust-sysroot`.
2. Uses `rustup` to fetch a matching wasm32 std and symlinks it into the mirror.
3. Runs `cargo build --target wasm32-unknown-unknown --release` with
   `RUSTFLAGS=--sysroot=/tmp/rust-sysroot`.
4. Invokes the Nix-provided `wasm-bindgen` CLI with `--target web` to emit
   ESM glue + the `.wasm` blob into `artifacts/image-lab/src/wasm/`.

Vite picks the `.wasm` file up via the standard `?url` import pattern.

## Key Commands

- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/image-lab run wasm:build` — rebuild the Rust WASM
- `pnpm --filter @workspace/image-lab run dev` — run the image-lab frontend
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks/Zod schemas
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- `pnpm --filter @workspace/api-server run dev` — run API server locally

See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details.

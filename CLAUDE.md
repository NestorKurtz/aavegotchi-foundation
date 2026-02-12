# CLAUDE.md

## Project Overview

Aavegotchi Foundation Treasury Tracker — a lightweight Node.js/Express REST API that fetches real-time DAO and Foundation treasury balances from the Polygon blockchain. Includes Dune Analytics SQL queries for historical treasury analysis.

## Tech Stack

- **Runtime:** Node.js (18.x, 20.x, 22.x)
- **Framework:** Express.js (^4.18.0)
- **Language:** Plain JavaScript (no TypeScript, no transpilation)
- **Blockchain:** Direct JSON-RPC 2.0 calls to Polygon RPC (no Web3.js/ethers.js)
- **Balance Math:** Native JavaScript BigInt

## Repository Structure

```
├── server.js              # Express app entry point (5 REST endpoints)
├── treasury-config.js     # Wallet addresses, tracked tokens, Dune/governance refs
├── treasury-tracker.js    # Core RPC logic: token balances, native balance, snapshots
├── queries/               # Dune Analytics SQL queries
│   ├── dao-treasury-balance.sql
│   ├── foundation-treasury-balance.sql
│   ├── treasury-balance-over-time.sql
│   ├── treasury-income.sql
│   └── treasury-total-value.sql
├── package.json
└── .github/workflows/node.js.yml  # CI: Node.js matrix (18, 20, 22)
```

## Commands

```bash
npm install        # Install dependencies
npm start          # Run server (node server.js)
```

No build, test, or lint scripts are currently configured.

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PORT` | `3000` | Server listen port |
| `POLYGON_RPC_URL` | `https://polygon-rpc.com` | Polygon JSON-RPC endpoint |

## API Endpoints

| Route | Description |
|-------|-------------|
| `GET /` | Welcome message with available endpoints |
| `GET /treasury` | Live token balances from on-chain RPC |
| `GET /treasury/config` | Configured wallets and tracked tokens |
| `GET /treasury/dune` | Dune Analytics dashboard links and query descriptions |
| `GET /treasury/governance` | Related AGIP governance proposals |

## Key Architecture Decisions

- **No Web3 libraries:** RPC calls are made with native `fetch()` and raw JSON-RPC 2.0 payloads (eth_call, eth_getBalance). This keeps dependencies minimal.
- **BigInt for balances:** All token balance math uses JavaScript BigInt to avoid floating-point precision issues with 18-decimal ERC20 tokens.
- **Per-token error handling:** If one token balance fetch fails, other tokens still return successfully. Errors are reported inline per token.
- **Static config:** Wallet addresses and token lists are defined in `treasury-config.js`, not fetched dynamically.

## Treasury Wallets

1. **DAO Treasury** (`0xb208f8BB431f580CC4b216826AFfB128cd1431aB`) — Gnosis Safe multisig on Polygon
2. **Foundation Multisig** (`0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62`) — 5/9 Gnosis Safe on Polygon, created via AGIP-50

## Tracked Tokens

**Polygon:** GHST, DAI, FUD, FOMO, ALPHA, KEK, native MATIC/POL
**Ethereum:** GHST, DAI (for Foundation wallet)

## Git Conventions

- Imperative mood commit messages ("Add", "Initialize", "Fix")
- Feature branches with pull requests to `main`/`master`
- CI runs on push/PR to `main` across Node.js 18.x, 20.x, 22.x

## Code Conventions

- Plain JavaScript with CommonJS `require()`/`module.exports`
- No linting or formatting tools configured — keep code style consistent with existing files
- Error handling: return error details in response objects rather than throwing
- Token addresses and wallet addresses are checksummed (mixed-case EIP-55)

## Dune Analytics Queries

The `queries/` directory contains SQL queries designed for [Dune Analytics](https://dune.com):
- Use `tokens_polygon.balances` and `prices.usd` tables for current balances
- Use `erc20_polygon.evt_Transfer` for historical balance tracking
- Queries reference hardcoded treasury wallet addresses

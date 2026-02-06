const express = require('express');
const { TREASURY_WALLETS, TRACKED_TOKENS, DUNE_REFERENCES, GOVERNANCE } = require('./treasury-config');
const { getFullTreasurySnapshot } = require('./treasury-tracker');

const app = express();

// Default public Polygon RPC - replace with your own for production
const POLYGON_RPC = process.env.POLYGON_RPC_URL || 'https://polygon-rpc.com';

app.get('/', (req, res) => {
  res.json({
    name: 'Aavegotchi Foundation Treasury Tracker',
    description: 'Tracks DAO and Foundation treasury balances on Polygon',
    endpoints: {
      '/treasury': 'Live treasury balances (fetched from chain)',
      '/treasury/config': 'Treasury wallet addresses and tracked tokens',
      '/treasury/dune': 'Dune Analytics dashboard references and SQL queries',
      '/treasury/governance': 'Related governance proposals',
    },
    references: {
      eitriDashboard: DUNE_REFERENCES.eitriDashboard,
      officialTreasury: 'https://app.aavegotchi.com/treasury',
      polygonscanDAO: `https://polygonscan.com/address/${TREASURY_WALLETS.dao.address}`,
    },
  });
});

app.get('/treasury', async (req, res) => {
  try {
    const snapshot = await getFullTreasurySnapshot(POLYGON_RPC);
    res.json(snapshot);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/treasury/config', (req, res) => {
  res.json({
    wallets: TREASURY_WALLETS,
    tokens: TRACKED_TOKENS,
  });
});

app.get('/treasury/dune', (req, res) => {
  res.json({
    dashboards: DUNE_REFERENCES,
    note: 'SQL queries are in the /queries directory of this project. '
        + 'They can be run directly on dune.com to reproduce the eitri dashboard.',
    queries: [
      { file: 'dao-treasury-balance.sql', description: 'Current DAO Treasury token balances' },
      { file: 'foundation-treasury-balance.sql', description: 'Foundation Multisig token balances (Polygon + Ethereum)' },
      { file: 'treasury-balance-over-time.sql', description: 'Daily GHST, DAI, and Alchemica balances over time' },
      { file: 'treasury-income.sql', description: 'Monthly inflows, outflows, and net flow by token' },
      { file: 'treasury-total-value.sql', description: 'Total treasury value in USD over time' },
    ],
  });
});

app.get('/treasury/governance', (req, res) => {
  res.json(GOVERNANCE);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Treasury tracker running on port ${PORT}`));

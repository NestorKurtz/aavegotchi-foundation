// Treasury Tracker - Fetches live balances from Polygon RPC
// Replaces Dune SQL queries with direct on-chain reads
// Original dashboard reference: https://dune.com/eitri/aavegotchi-dao-treasury

const { TREASURY_WALLETS, TRACKED_TOKENS } = require('./treasury-config');

const ERC20_BALANCE_OF_ABI = '0x70a08231';

async function getTokenBalance(rpcUrl, tokenAddress, walletAddress) {
  const paddedWallet = walletAddress.toLowerCase().replace('0x', '').padStart(64, '0');
  const data = ERC20_BALANCE_OF_ABI + paddedWallet;

  const response = await fetch(rpcUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: 1,
      method: 'eth_call',
      params: [{ to: tokenAddress, data }, 'latest'],
    }),
  });

  const result = await response.json();
  if (result.error) {
    throw new Error(`RPC error: ${result.error.message}`);
  }

  return BigInt(result.result || '0x0');
}

function formatBalance(rawBalance, decimals) {
  const divisor = BigInt(10 ** decimals);
  const whole = rawBalance / divisor;
  const fraction = rawBalance % divisor;
  const fractionStr = fraction.toString().padStart(decimals, '0').slice(0, 4);
  return `${whole}.${fractionStr}`;
}

async function getTreasuryBalances(rpcUrl) {
  const results = {};

  for (const [walletKey, wallet] of Object.entries(TREASURY_WALLETS)) {
    results[walletKey] = {
      label: wallet.label,
      address: wallet.address,
      chain: wallet.chain,
      tokens: {},
    };

    const chainTokens = TRACKED_TOKENS[wallet.chain] || {};

    for (const [symbol, token] of Object.entries(chainTokens)) {
      try {
        const rawBalance = await getTokenBalance(rpcUrl, token.address, wallet.address);
        results[walletKey].tokens[symbol] = {
          address: token.address,
          rawBalance: rawBalance.toString(),
          balance: formatBalance(rawBalance, token.decimals),
          decimals: token.decimals,
        };
      } catch (err) {
        results[walletKey].tokens[symbol] = {
          address: token.address,
          error: err.message,
        };
      }
    }
  }

  return results;
}

async function getNativeBalance(rpcUrl, walletAddress) {
  const response = await fetch(rpcUrl, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      jsonrpc: '2.0',
      id: 1,
      method: 'eth_getBalance',
      params: [walletAddress, 'latest'],
    }),
  });

  const result = await response.json();
  return BigInt(result.result || '0x0');
}

async function getFullTreasurySnapshot(rpcUrl) {
  const balances = await getTreasuryBalances(rpcUrl);

  // Also fetch native MATIC/POL balances
  for (const [walletKey, wallet] of Object.entries(TREASURY_WALLETS)) {
    try {
      const nativeBalance = await getNativeBalance(rpcUrl, wallet.address);
      balances[walletKey].tokens['MATIC'] = {
        address: 'native',
        rawBalance: nativeBalance.toString(),
        balance: formatBalance(nativeBalance, 18),
        decimals: 18,
      };
    } catch (err) {
      balances[walletKey].tokens['MATIC'] = {
        address: 'native',
        error: err.message,
      };
    }
  }

  return {
    timestamp: new Date().toISOString(),
    wallets: balances,
  };
}

module.exports = {
  getTokenBalance,
  getTreasuryBalances,
  getNativeBalance,
  getFullTreasurySnapshot,
  formatBalance,
};

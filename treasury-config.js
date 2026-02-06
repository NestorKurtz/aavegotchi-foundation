// Aavegotchi DAO & Foundation Treasury Configuration
// Reconstructed from eitri's Dune dashboard: https://dune.com/eitri/aavegotchi-dao-treasury
// and public governance records (AGIP-50, AGIP-24, AGIP-76)

const TREASURY_WALLETS = {
  // Original DAO Treasury on Polygon
  // https://polygonscan.com/address/0xb208f8BB431f580CC4b216826AFfB128cd1431aB
  dao: {
    label: 'Aavegotchi DAO Treasury',
    address: '0xb208f8BB431f580CC4b216826AFfB128cd1431aB',
    chain: 'polygon',
    type: 'gnosis-safe',
  },

  // Foundation Multisig (created via AGIP-50)
  // 9 Directors, 5/9 threshold
  // https://debank.com/profile/0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
  foundation: {
    label: 'AavegotchiDAO Foundation Multisig',
    address: '0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62',
    chain: 'polygon',
    type: 'gnosis-safe',
    signers: 9,
    threshold: 5,
  },
};

// Key tokens tracked in the treasury
const TRACKED_TOKENS = {
  polygon: {
    GHST: {
      address: '0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7',
      decimals: 18,
      coingeckoId: 'aavegotchi',
    },
    DAI: {
      address: '0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063',
      decimals: 18,
      coingeckoId: 'dai',
    },
    FUD: {
      address: '0x403E967b044d4Be25170310157cB1a4Bf10bdD0f',
      decimals: 18,
      coingeckoId: 'aavegotchi-fud',
    },
    FOMO: {
      address: '0x44A6e0BE76e1D9620A7F76588e4509fE4fa8E8C8',
      decimals: 18,
      coingeckoId: 'aavegotchi-fomo',
    },
    ALPHA: {
      address: '0x6a3E7C3c6EF65Ee26975b12293cA1AAD7e1dAeD2',
      decimals: 18,
      coingeckoId: 'aavegotchi-alpha',
    },
    KEK: {
      address: '0x42E5E06EF5b90Fe15F853F59299Fc96259209c5C',
      decimals: 18,
      coingeckoId: 'aavegotchi-kek',
    },
  },
  ethereum: {
    GHST: {
      address: '0x3F382DbD960E3a9bbCeaE22651E88158d2791550',
      decimals: 18,
      coingeckoId: 'aavegotchi',
    },
    DAI: {
      address: '0x6B175474E89094C44Da98b954EedeAC495271d0F',
      decimals: 18,
      coingeckoId: 'dai',
    },
  },
};

// Dune Analytics references
// Original dashboard by eitri: https://dune.com/eitri/aavegotchi-dao-treasury
// Related dashboard by shoouunn: https://dune.com/shoouunn/aavegotchi-treasury
const DUNE_REFERENCES = {
  eitriDashboard: 'https://dune.com/eitri/aavegotchi-dao-treasury',
  shoouunnDashboard: 'https://dune.com/shoouunn/aavegotchi-treasury',
  eitriGotchis: 'https://dune.com/eitri/aavegotchi-gotchis',
  eitriXP: 'https://dune.com/eitri/aavegotchi-xp',
};

// Governance references
const GOVERNANCE = {
  agip50: {
    title: 'Create AavegotchiDAO Foundation',
    description: 'Created the Cayman Islands Foundation with 9 Directors/Multisig Signers',
    url: 'https://blog.aavegotchi.com/vote-agip-50-51-52-53-create-aavegotchidao-foundation-election-for-dao-foundations-9-directors-multisig-signers-rarity-farming-season-5-channel-alchemica-by-burning-kinship/',
  },
  agip24: {
    title: 'Treasury Staking on Aave',
    description: 'Deposit ~80% of DAO Treasury GHST (3M GHST) into Aave as collateral',
    url: 'https://blog.aavegotchi.com/vote-agip-24-25-26-27-28-treasury-staking-on-aave-realm-auction-raffle-delay-parcel-vrf-variance-reduction-alternative-trait-mapping-dao-treasury-task-force-multisig-extension/',
  },
  agip76: {
    title: 'Create a DAO Treasury Dashboard',
    description: 'Proposed by MikeyJay and Eitri to track DAO income and assets',
    url: 'https://dao.aavegotchi.com/t/create-a-dao-treasury-dashboard/4746',
  },
};

module.exports = {
  TREASURY_WALLETS,
  TRACKED_TOKENS,
  DUNE_REFERENCES,
  GOVERNANCE,
};

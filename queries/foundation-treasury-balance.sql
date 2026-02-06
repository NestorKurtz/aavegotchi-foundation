-- Aavegotchi Foundation Multisig - Current Token Balances
-- Foundation Multisig (Gnosis Safe, 5/9 signers)
-- Address: 0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
--
-- The Foundation was created via AGIP-50. Pixelcraft Studios transferred
-- DAO Treasury funds (DAI, GHST, Alchemica) to this multisig on both
-- Ethereum and Polygon.

-- ====================================================================
-- Query 1: Foundation treasury balances on Polygon
-- ====================================================================
SELECT
    b.token_address,
    t.symbol,
    t.decimals,
    b.balance / POW(10, t.decimals) AS balance,
    p.price AS price_usd,
    (b.balance / POW(10, t.decimals)) * p.price AS value_usd
FROM tokens_polygon.balances b
LEFT JOIN tokens.erc20 t
    ON t.contract_address = b.token_address
    AND t.blockchain = 'polygon'
LEFT JOIN prices.usd_latest p
    ON p.contract_address = b.token_address
    AND p.blockchain = 'polygon'
WHERE b.address = 0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
    AND b.balance > 0
ORDER BY value_usd DESC NULLS LAST;

-- ====================================================================
-- Query 2: Foundation treasury balances on Ethereum
-- ====================================================================
SELECT
    b.token_address,
    t.symbol,
    t.decimals,
    b.balance / POW(10, t.decimals) AS balance,
    p.price AS price_usd,
    (b.balance / POW(10, t.decimals)) * p.price AS value_usd
FROM tokens_ethereum.balances b
LEFT JOIN tokens.erc20 t
    ON t.contract_address = b.token_address
    AND t.blockchain = 'ethereum'
LEFT JOIN prices.usd_latest p
    ON p.contract_address = b.token_address
    AND p.blockchain = 'ethereum'
WHERE b.address = 0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
    AND b.balance > 0
ORDER BY value_usd DESC NULLS LAST;

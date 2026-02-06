-- Aavegotchi DAO Treasury - Current Token Balances
-- Reconstructed from eitri's dune.com/eitri/aavegotchi-dao-treasury dashboard
-- Tracks: DAO Treasury (0xb208f8BB431f580CC4b216826AFfB128cd1431aB)
--         Foundation Multisig (0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62)
--
-- Tables: tokens_polygon.balances_daily, prices.usd

-- ====================================================================
-- Query 1: Current token balances for DAO Treasury on Polygon
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
WHERE b.address = 0xb208f8BB431f580CC4b216826AFfB128cd1431aB
    AND b.balance > 0
ORDER BY value_usd DESC NULLS LAST;

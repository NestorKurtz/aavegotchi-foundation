-- Aavegotchi DAO Treasury - Income Tracking
-- Tracks inflows to the treasury wallets over time
-- Income sources: protocol fees, NFT sales, Aave yield, etc.

-- ====================================================================
-- Query 1: Monthly income by token (inflows only)
-- ====================================================================
WITH known_tokens AS (
    SELECT contract_address, symbol FROM (VALUES
        (0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7, 'GHST'),
        (0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, 'DAI'),
        (0x403E967b044d4Be25170310157cB1a4Bf10bdD0f, 'FUD'),
        (0x44A6e0BE76e1D9620A7F76588e4509fE4fa8E8C8, 'FOMO'),
        (0x6a3E7C3c6EF65Ee26975b12293cA1AAD7e1dAeD2, 'ALPHA'),
        (0x42E5E06EF5b90Fe15F853F59299Fc96259209c5C, 'KEK')
    ) AS t(contract_address, symbol)
)
SELECT
    date_trunc('month', e.evt_block_time) AS month,
    k.symbol,
    SUM(CAST(e.value AS DOUBLE)) / 1e18 AS inflow_amount,
    COUNT(*) AS tx_count
FROM erc20_polygon.evt_Transfer e
INNER JOIN known_tokens k ON e.contract_address = k.contract_address
WHERE e."to" IN (
    0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
    0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
)
GROUP BY 1, 2
ORDER BY 1 DESC, 2;

-- ====================================================================
-- Query 2: Monthly outflows by token
-- ====================================================================
WITH known_tokens AS (
    SELECT contract_address, symbol FROM (VALUES
        (0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7, 'GHST'),
        (0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, 'DAI'),
        (0x403E967b044d4Be25170310157cB1a4Bf10bdD0f, 'FUD'),
        (0x44A6e0BE76e1D9620A7F76588e4509fE4fa8E8C8, 'FOMO'),
        (0x6a3E7C3c6EF65Ee26975b12293cA1AAD7e1dAeD2, 'ALPHA'),
        (0x42E5E06EF5b90Fe15F853F59299Fc96259209c5C, 'KEK')
    ) AS t(contract_address, symbol)
)
SELECT
    date_trunc('month', e.evt_block_time) AS month,
    k.symbol,
    SUM(CAST(e.value AS DOUBLE)) / 1e18 AS outflow_amount,
    COUNT(*) AS tx_count
FROM erc20_polygon.evt_Transfer e
INNER JOIN known_tokens k ON e.contract_address = k.contract_address
WHERE e."from" IN (
    0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
    0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
)
GROUP BY 1, 2
ORDER BY 1 DESC, 2;

-- ====================================================================
-- Query 3: Net monthly treasury flow (income - spending)
-- ====================================================================
WITH known_tokens AS (
    SELECT contract_address, symbol FROM (VALUES
        (0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7, 'GHST'),
        (0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, 'DAI'),
        (0x403E967b044d4Be25170310157cB1a4Bf10bdD0f, 'FUD'),
        (0x44A6e0BE76e1D9620A7F76588e4509fE4fa8E8C8, 'FOMO'),
        (0x6a3E7C3c6EF65Ee26975b12293cA1AAD7e1dAeD2, 'ALPHA'),
        (0x42E5E06EF5b90Fe15F853F59299Fc96259209c5C, 'KEK')
    ) AS t(contract_address, symbol)
)
SELECT
    date_trunc('month', e.evt_block_time) AS month,
    k.symbol,
    SUM(CASE
        WHEN e."to" IN (
            0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
            0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
        ) THEN CAST(e.value AS DOUBLE) / 1e18
        WHEN e."from" IN (
            0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
            0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
        ) THEN -CAST(e.value AS DOUBLE) / 1e18
    END) AS net_flow
FROM erc20_polygon.evt_Transfer e
INNER JOIN known_tokens k ON e.contract_address = k.contract_address
WHERE e."to" IN (
    0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
    0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
)
OR e."from" IN (
    0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
    0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
)
GROUP BY 1, 2
ORDER BY 1 DESC, 2;

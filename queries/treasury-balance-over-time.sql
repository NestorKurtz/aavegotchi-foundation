-- Aavegotchi DAO + Foundation Treasury - Balance Over Time
-- Tracks daily token balances for both treasury wallets
-- Used for time-series charts showing treasury health

-- ====================================================================
-- Query 1: Daily GHST balance over time (both wallets combined)
-- ====================================================================
WITH daily_transfers AS (
    SELECT
        date_trunc('day', evt_block_time) AS day,
        SUM(CASE
            WHEN "to" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            ) THEN CAST(value AS DOUBLE)
            WHEN "from" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            ) THEN -CAST(value AS DOUBLE)
        END) / 1e18 AS net_ghst
    FROM erc20_polygon.evt_Transfer
    WHERE contract_address = 0x385Eeac5cB85A38A9a07A70c73e0a3271CfB54A7 -- GHST on Polygon
        AND (
            "to" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            )
            OR "from" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            )
        )
    GROUP BY 1
)
SELECT
    day,
    SUM(net_ghst) OVER (ORDER BY day) AS cumulative_ghst_balance
FROM daily_transfers
ORDER BY day;

-- ====================================================================
-- Query 2: Daily DAI balance over time (both wallets combined)
-- ====================================================================
WITH daily_transfers AS (
    SELECT
        date_trunc('day', evt_block_time) AS day,
        SUM(CASE
            WHEN "to" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            ) THEN CAST(value AS DOUBLE)
            WHEN "from" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            ) THEN -CAST(value AS DOUBLE)
        END) / 1e18 AS net_dai
    FROM erc20_polygon.evt_Transfer
    WHERE contract_address = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063 -- DAI on Polygon
        AND (
            "to" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            )
            OR "from" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            )
        )
    GROUP BY 1
)
SELECT
    day,
    SUM(net_dai) OVER (ORDER BY day) AS cumulative_dai_balance
FROM daily_transfers
ORDER BY day;

-- ====================================================================
-- Query 3: Daily Alchemica balances over time (FUD, FOMO, ALPHA, KEK)
-- ====================================================================
WITH alchemica_tokens AS (
    SELECT contract_address, symbol FROM (VALUES
        (0x403E967b044d4Be25170310157cB1a4Bf10bdD0f, 'FUD'),
        (0x44A6e0BE76e1D9620A7F76588e4509fE4fa8E8C8, 'FOMO'),
        (0x6a3E7C3c6EF65Ee26975b12293cA1AAD7e1dAeD2, 'ALPHA'),
        (0x42E5E06EF5b90Fe15F853F59299Fc96259209c5C, 'KEK')
    ) AS t(contract_address, symbol)
),
daily_transfers AS (
    SELECT
        date_trunc('day', e.evt_block_time) AS day,
        a.symbol,
        SUM(CASE
            WHEN e."to" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            ) THEN CAST(e.value AS DOUBLE)
            WHEN e."from" IN (
                0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
                0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
            ) THEN -CAST(e.value AS DOUBLE)
        END) / 1e18 AS net_amount
    FROM erc20_polygon.evt_Transfer e
    INNER JOIN alchemica_tokens a ON e.contract_address = a.contract_address
    WHERE (
        e."to" IN (
            0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
            0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
        )
        OR e."from" IN (
            0xb208f8BB431f580CC4b216826AFfB128cd1431aB,
            0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62
        )
    )
    GROUP BY 1, 2
)
SELECT
    day,
    symbol,
    SUM(net_amount) OVER (PARTITION BY symbol ORDER BY day) AS cumulative_balance
FROM daily_transfers
ORDER BY day, symbol;

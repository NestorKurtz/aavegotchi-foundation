-- Aavegotchi DAO + Foundation Treasury - Total Value (USD) Over Time
-- Combines all token balances with USD prices

-- ====================================================================
-- Query 1: Total treasury value in USD over time
-- ====================================================================
WITH treasury_addresses AS (
    SELECT address FROM (VALUES
        (0xb208f8BB431f580CC4b216826AFfB128cd1431aB),  -- DAO Treasury
        (0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62)   -- Foundation Multisig
    ) AS t(address)
),
daily_balances AS (
    SELECT
        b.day,
        b.token_address,
        t.symbol,
        SUM(b.balance / POW(10, COALESCE(t.decimals, 18))) AS total_balance
    FROM tokens_polygon.balances_daily b
    INNER JOIN treasury_addresses ta ON b.address = ta.address
    LEFT JOIN tokens.erc20 t
        ON t.contract_address = b.token_address
        AND t.blockchain = 'polygon'
    WHERE b.balance > 0
    GROUP BY 1, 2, 3
)
SELECT
    db.day,
    db.symbol,
    db.total_balance,
    p.price AS price_usd,
    db.total_balance * p.price AS value_usd
FROM daily_balances db
LEFT JOIN prices.usd p
    ON p.contract_address = db.token_address
    AND p.blockchain = 'polygon'
    AND p.minute = date_trunc('day', db.day)
WHERE db.total_balance > 0
ORDER BY db.day DESC, value_usd DESC NULLS LAST;

-- ====================================================================
-- Query 2: Total combined treasury value per day
-- ====================================================================
WITH treasury_addresses AS (
    SELECT address FROM (VALUES
        (0xb208f8BB431f580CC4b216826AFfB128cd1431aB),
        (0x53c3CA81EA03001a350166D2Cc0fcd9d4c1b7B62)
    ) AS t(address)
),
daily_balances AS (
    SELECT
        b.day,
        b.token_address,
        SUM(b.balance / POW(10, COALESCE(t.decimals, 18))) AS total_balance
    FROM tokens_polygon.balances_daily b
    INNER JOIN treasury_addresses ta ON b.address = ta.address
    LEFT JOIN tokens.erc20 t
        ON t.contract_address = b.token_address
        AND t.blockchain = 'polygon'
    WHERE b.balance > 0
    GROUP BY 1, 2
)
SELECT
    db.day,
    SUM(db.total_balance * p.price) AS total_treasury_value_usd
FROM daily_balances db
LEFT JOIN prices.usd p
    ON p.contract_address = db.token_address
    AND p.blockchain = 'polygon'
    AND p.minute = date_trunc('day', db.day)
GROUP BY 1
ORDER BY 1 DESC;

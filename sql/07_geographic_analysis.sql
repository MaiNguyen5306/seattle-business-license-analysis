USE seattle_business_license;

-- Compare Seattle and non-Seattle business addresses
SELECT
    is_seattle_address,
    COUNT(*) AS license_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM business_licenses_analysis),
        2
    ) AS share_of_total
FROM business_licenses_analysis
GROUP BY is_seattle_address
ORDER BY is_seattle_address DESC;
-- Results:
-- Seattle addresses: 8,805 licenses, 68.27% of all records.
-- Non-Seattle addresses: 4,092 licenses, 31.73% of all records.


-- Identify the ZIP codes with the most Seattle-based license records
SELECT
    zip_5,
    COUNT(*) AS license_count,
    ROUND(
        COUNT(*) * 100.0 /
        (
            SELECT COUNT(*)
            FROM business_licenses_analysis
            WHERE is_seattle_address = 1
        ),
        2
    ) AS share_of_seattle_records
FROM business_licenses_analysis
WHERE is_seattle_address = 1
  AND zip_5 IS NOT NULL
  AND TRIM(zip_5) <> ''
GROUP BY zip_5
ORDER BY license_count DESC
LIMIT 5;
-- Results:
-- 1. ZIP 98103: 688 licenses, 7.81% of Seattle-address records.
-- 2. ZIP 98101: 529 licenses, 6.01%.
-- 3. ZIP 98118: 513 licenses, 5.83%.
-- 4. ZIP 98109: 471 licenses, 5.35%.
-- 5. ZIP 98107: 465 licenses, 5.28%.
-- Portfolio insight:
-- Most active license records have Seattle addresses, accounting for 68.27%
-- of the dataset. ZIP 98103 has the largest concentration, with 688 licenses,
-- or 7.81% of all Seattle-address records.

-- Calculate the combined share of the top five Seattle ZIP codes
WITH zip_counts AS (
    SELECT
        zip_5,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE is_seattle_address = 1
      AND zip_5 IS NOT NULL
      AND TRIM(zip_5) <> ''
    GROUP BY zip_5
),
ranked_zips AS (
    SELECT
        zip_5,
        license_count,
        ROW_NUMBER() OVER (
            ORDER BY license_count DESC
        ) AS zip_rank
    FROM zip_counts
)
SELECT
    SUM(license_count) AS top_5_zip_license_count,
    ROUND(
        SUM(license_count) * 100.0 /
        (
            SELECT COUNT(*)
            FROM business_licenses_analysis
            WHERE is_seattle_address = 1
        ),
        2
    ) AS top_5_zip_share
FROM ranked_zips
WHERE zip_rank <= 5;
-- Results:
-- Top five Seattle ZIP codes combined: 2,666 licenses.
-- Share of Seattle-address records: 30.28%.

-- Portfolio insight:
-- The five largest Seattle ZIP-code concentrations account for 2,666 licenses,
-- or 30.28% of all Seattle-address records.
-- This suggests business-license activity is somewhat concentrated geographically,
-- although most Seattle records are still distributed across other ZIP codes.

-- Find the top industry within each of the five largest Seattle ZIP codes
WITH top_zips AS (
    SELECT
        zip_5,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE is_seattle_address = 1
      AND zip_5 IS NOT NULL
      AND TRIM(zip_5) <> ''
    GROUP BY zip_5
    ORDER BY license_count DESC
    LIMIT 5
),
industry_by_zip AS (
    SELECT
        b.zip_5,
        b.naics_description,
        COUNT(*) AS license_count
    FROM business_licenses_analysis AS b
    INNER JOIN top_zips AS z
        ON b.zip_5 = z.zip_5
    WHERE b.naics_description IS NOT NULL
      AND TRIM(b.naics_description) <> ''
    GROUP BY
        b.zip_5,
        b.naics_description
),
ranked_industries AS (
    SELECT
        zip_5,
        naics_description,
        license_count,
        ROW_NUMBER() OVER (
            PARTITION BY zip_5
            ORDER BY license_count DESC
        ) AS industry_rank
    FROM industry_by_zip
)
SELECT
    zip_5,
    naics_description,
    license_count
FROM ranked_industries
WHERE industry_rank = 1
ORDER BY zip_5;
-- Results:
-- ZIP 98101: Parking Lots and Garages, 33 licenses.
-- ZIP 98103: Lessors of Residential Buildings and Dwellings, 40 licenses.
-- ZIP 98107: Offices of Mental Health Practitioners, 35 licenses.
-- ZIP 98109: Offices of Real Estate Agents and Brokers, 32 licenses.
-- ZIP 98118: Taxi and Ridesharing Services, 32 licenses.

-- Geographic insight:
-- The leading industry differs across Seattle's highest-volume ZIP codes,
-- suggesting that business activity varies by local area rather than following
-- one citywide pattern.
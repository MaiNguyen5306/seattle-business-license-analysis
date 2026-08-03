USE seattle_business_license;

-- Count missing values in important columns
SELECT
    COUNT(*) AS total_rows,

    SUM(CASE
        WHEN `Business Legal Name` IS NULL
          OR TRIM(`Business Legal Name`) = ''
        THEN 1 ELSE 0
    END) AS missing_legal_name,

    SUM(CASE
        WHEN `Trade Name` IS NULL
          OR TRIM(`Trade Name`) = ''
        THEN 1 ELSE 0
    END) AS missing_trade_name,

    SUM(CASE
        WHEN `Ownership Type` IS NULL
          OR TRIM(`Ownership Type`) = ''
        THEN 1 ELSE 0
    END) AS missing_ownership_type,

    SUM(CASE
        WHEN `NAICS Code` IS NULL
          OR TRIM(`NAICS Code`) = ''
        THEN 1 ELSE 0
    END) AS missing_naics_code,

    SUM(CASE
        WHEN `NAICS Description` IS NULL
          OR TRIM(`NAICS Description`) = ''
        THEN 1 ELSE 0
    END) AS missing_naics_description,

    SUM(CASE
        WHEN `License Start Date` IS NULL
          OR TRIM(`License Start Date`) = ''
        THEN 1 ELSE 0
    END) AS missing_license_start_date

FROM business_licenses_raw;
-- Results:
-- Total rows: 12,897
-- Missing Business Legal Name: 0
-- Missing Trade Name: 0
-- Missing Ownership Type: 0
-- Missing NAICS Code: 0
-- Missing NAICS Description: 6
-- Missing License Start Date: 0
-- Check for duplicate City Account Numbers

SELECT
    `City Account Number`,
    COUNT(*) AS record_count
FROM business_licenses_raw
WHERE `City Account Number` IS NOT NULL
  AND TRIM(`City Account Number`) <> ''
GROUP BY `City Account Number`
HAVING COUNT(*) > 1
ORDER BY record_count DESC;
-- Result: No duplicate City Account Numbers were found.

-- Check for duplicate UBI values
SELECT
    UBI,
    COUNT(*) AS record_count
FROM business_licenses_raw
WHERE UBI IS NOT NULL
  AND TRIM(UBI) <> ''
GROUP BY UBI
HAVING COUNT(*) > 1
ORDER BY record_count DESC;
-- Result: Multiple UBI values appear more than once.
-- The highest visible counts include 47, 43, and 22 records for a single UBI.
-- These are not automatically treated as duplicate rows because one business
-- may have multiple license records associated with the same UBI.

-- Check the earliest and latest license start dates
SELECT
    MIN(`License Start Date`) AS earliest_start_date,
    MAX(`License Start Date`) AS latest_start_date
FROM business_licenses_raw;
-- Results:
-- Earliest License Start Date: 19900101
-- Latest License Start Date: 20261210

-- Review records with missing NAICS descriptions
SELECT
    `Business Legal Name`,
    `Trade Name`,
    `NAICS Code`,
    `NAICS Description`
FROM business_licenses_raw
WHERE `NAICS Description` IS NULL
   OR TRIM(`NAICS Description`) = '';
-- Results:
-- 6 records are missing NAICS descriptions.
-- 1 record has NAICS Code 454111.
-- 5 records have NAICS Code 454390.
-- The missing values will be handled in the cleaned table, not the raw table.
-- Results:
-- NAICS Code 454111 appears once, and its description is missing.
-- NAICS Code 454390 appears five times, and all descriptions are missing.
-- No completed descriptions exist elsewhere in the dataset for these codes.
-- Official NAICS descriptions will be researched and added only in the cleaned table.


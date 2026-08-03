USE seattle_business_license;

-- Remove the analysis-ready table if this script is rerun
DROP TABLE IF EXISTS business_licenses_analysis;

-- Create an analysis-ready table with derived fields
CREATE TABLE business_licenses_analysis AS
SELECT
    business_legal_name,
    trade_name,
    ownership_type,
    naics_code,
    naics_description,

    -- First two digits represent the broad NAICS sector
    LEFT(naics_code, 2) AS naics_sector,

    license_start_date,
    YEAR(license_start_date) AS license_start_year,

    -- Business age as of the dataset download date
    TIMESTAMPDIFF(
        YEAR,
        license_start_date,
        '2026-08-02'
    ) AS business_age_years,

    -- Group businesses into easier age categories
    CASE
        WHEN license_start_date > '2026-08-02'
            THEN 'Future start date'
        WHEN TIMESTAMPDIFF(
            YEAR,
            license_start_date,
            '2026-08-02'
        ) < 1
            THEN 'Less than 1 year'
        WHEN TIMESTAMPDIFF(
            YEAR,
            license_start_date,
            '2026-08-02'
        ) BETWEEN 1 AND 5
            THEN '1–5 years'
        WHEN TIMESTAMPDIFF(
            YEAR,
            license_start_date,
            '2026-08-02'
        ) BETWEEN 6 AND 10
            THEN '6–10 years'
        WHEN TIMESTAMPDIFF(
            YEAR,
            license_start_date,
            '2026-08-02'
        ) BETWEEN 11 AND 20
            THEN '11–20 years'
        ELSE 'More than 20 years'
    END AS business_age_group,

    -- Mark records dated after the dataset download date
    CASE
        WHEN license_start_date > '2026-08-02'
            THEN 1
        ELSE 0
    END AS is_future_start_date,

    street_address,
    city,
    state,
    zip_5,

    -- Identify records with a Seattle city address
    CASE
        WHEN city = 'SEATTLE'
            THEN 1
        ELSE 0
    END AS is_seattle_address,

    city_account_number,
    ubi

FROM business_licenses_clean;

-- Confirm the row count
SELECT COUNT(*) AS analysis_rows
FROM business_licenses_analysis;

-- Result:
-- Analysis row count: 12,897

-- Confirm the future-date flag
SELECT
    is_future_start_date,
    COUNT(*) AS record_count
FROM business_licenses_analysis
GROUP BY is_future_start_date;

-- Results:
-- is_future_start_date = 0: 12,876 records
-- is_future_start_date = 1: 21 records

-- Review business-age groups
SELECT
    business_age_group,
    COUNT(*) AS record_count
FROM business_licenses_analysis
GROUP BY business_age_group
ORDER BY record_count DESC;

-- Results:
-- Less than 1 year: 1054
-- 1–5 years: 3961
-- 6–10 years: 2678
-- 11–20 years: 2901
-- More than 20 years: 2282
-- Future start date: 21

-- Check Seattle versus non-Seattle addresses
SELECT
    is_seattle_address,
    COUNT(*) AS record_count
FROM business_licenses_analysis
GROUP BY is_seattle_address;

-- Results:
-- Seattle address = 1: 8805
-- Seattle address = 0: 4092

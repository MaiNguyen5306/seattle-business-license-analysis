USE seattle_business_license;

-- Remove the cleaned table if this script is rerun
DROP TABLE IF EXISTS business_licenses_clean;

-- Create a cleaned table while keeping the raw table unchanged
CREATE TABLE business_licenses_clean AS
SELECT
    TRIM(`Business Legal Name`) AS business_legal_name,
    TRIM(`Trade Name`) AS trade_name,
    TRIM(`Ownership Type`) AS ownership_type,
    TRIM(`NAICS Code`) AS naics_code,

    CASE
        WHEN TRIM(`NAICS Description`) <> ''
            THEN TRIM(`NAICS Description`)
        WHEN TRIM(`NAICS Code`) = '454111'
            THEN 'Electronic Shopping'
        WHEN TRIM(`NAICS Code`) = '454390'
            THEN 'Other Direct Selling Establishments'
        ELSE NULL
    END AS naics_description,

    STR_TO_DATE(TRIM(`License Start Date`), '%Y%m%d')
        AS license_start_date,

    TRIM(`Street Address`) AS street_address,
    UPPER(TRIM(City)) AS city,
    UPPER(TRIM(State)) AS state,

    LEFT(TRIM(ZIP), 5) AS zip_5,

    TRIM(`Business Phone`) AS business_phone,
    TRIM(`City Account Number`) AS city_account_number,
    TRIM(UBI) AS ubi

FROM business_licenses_raw;
-- Results:
-- Raw row count: 12,897
-- Cleaned row count: 12,897
-- No records were removed because no duplicate City Account Numbers were found.
-- All six missing NAICS descriptions were filled in the cleaned table.

-- Check whether any dates failed to convert
SELECT
    COUNT(*) AS total_rows,
    SUM(
        CASE
            WHEN license_start_date IS NULL
            THEN 1
            ELSE 0
        END
    ) AS invalid_or_missing_dates
FROM business_licenses_clean;
-- Result: 0 invalid or missing dates after conversion.

-- Check for license start dates after the dataset download date
SELECT
    business_legal_name,
    trade_name,
    license_start_date,
    city_account_number,
    ubi,
    city,
    state,
    zip_5
FROM business_licenses_clean
WHERE license_start_date > '2026-08-02'
ORDER BY license_start_date;
-- Result: 21 records have license start dates after the dataset download date
-- of 2026-08-02.
-- These records were retained because they may represent licenses approved
-- in advance or scheduled to begin later.
-- They should not be treated as historical active-business records before
-- their listed start dates.
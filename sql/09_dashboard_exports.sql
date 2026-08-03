USE seattle_business_license;

-- Recreate summary tables whenever this script is rerun
DROP TABLE IF EXISTS export_kpis;
DROP TABLE IF EXISTS export_yearly_trends;
DROP TABLE IF EXISTS export_industry_summary;
DROP TABLE IF EXISTS export_zip_summary;
DROP TABLE IF EXISTS export_ownership_summary;
DROP TABLE IF EXISTS export_age_groups;


-- 1. Overall KPI summary
CREATE TABLE export_kpis AS
SELECT
    COUNT(*) AS total_license_records,
    COUNT(DISTINCT ubi) AS unique_ubi_count,
    SUM(is_seattle_address) AS seattle_address_records,
    ROUND(
        SUM(is_seattle_address) * 100.0 / COUNT(*),
        2
    ) AS seattle_address_share,
    ROUND(AVG(business_age_years), 2) AS average_business_age,
    SUM(
        CASE
            WHEN business_age_years BETWEEN 0 AND 5
                 AND is_future_start_date = 0
            THEN 1
            ELSE 0
        END
    ) AS started_within_last_5_years,
    SUM(is_future_start_date) AS future_dated_records
FROM business_licenses_analysis;


-- 2. License-start trends by year
CREATE TABLE export_yearly_trends AS
SELECT
    license_start_year,
    COUNT(*) AS license_count
FROM business_licenses_analysis
WHERE is_future_start_date = 0
GROUP BY license_start_year
ORDER BY license_start_year;


-- 3. Industry summary
CREATE TABLE export_industry_summary AS
SELECT
    naics_description,
    COUNT(*) AS license_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM business_licenses_analysis),
        2
    ) AS share_of_total
FROM business_licenses_analysis
WHERE naics_description IS NOT NULL
  AND TRIM(naics_description) <> ''
GROUP BY naics_description
ORDER BY license_count DESC;


-- 4. Seattle ZIP-code summary
CREATE TABLE export_zip_summary AS
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
ORDER BY license_count DESC;


-- 5. Ownership summary
CREATE TABLE export_ownership_summary AS
SELECT
    ownership_type,
    COUNT(*) AS license_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM business_licenses_analysis),
        2
    ) AS share_of_total
FROM business_licenses_analysis
WHERE ownership_type IS NOT NULL
  AND TRIM(ownership_type) <> ''
GROUP BY ownership_type
ORDER BY license_count DESC;


-- 6. Business-age group summary
CREATE TABLE export_age_groups AS
SELECT
    business_age_group,
    COUNT(*) AS license_count
FROM business_licenses_analysis
GROUP BY business_age_group
ORDER BY license_count DESC;

SELECT * FROM export_kpis;

SELECT * FROM export_yearly_trends
ORDER BY license_start_year;

SELECT * FROM export_industry_summary
LIMIT 10;

SELECT * FROM export_zip_summary
LIMIT 10;

SELECT * FROM export_ownership_summary;

SELECT * FROM export_age_groups;

-- Result:
-- Six summary tables were created successfully for Excel and IBM Cognos.
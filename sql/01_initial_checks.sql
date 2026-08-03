USE seattle_business_license;

-- Check the total number of imported rows
SELECT COUNT(*) AS total_rows
FROM business_licenses_raw;

-- Review the table structure and data types
DESCRIBE business_licenses_raw;

-- Preview the first 10 records
SELECT *
FROM business_licenses_raw
LIMIT 10;

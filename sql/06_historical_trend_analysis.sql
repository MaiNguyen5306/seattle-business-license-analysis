USE seattle_business_license;

-- Count currently active license records by start year
SELECT
    license_start_year,
    COUNT(*) AS license_count
FROM business_licenses_analysis
WHERE is_future_start_date = 0
GROUP BY license_start_year
ORDER BY license_start_year;

-- Identify the start year with the most currently active license records
SELECT
    license_start_year,
    COUNT(*) AS license_count
FROM business_licenses_analysis
WHERE is_future_start_date = 0
GROUP BY license_start_year
ORDER BY license_count DESC
LIMIT 1;
-- Result:
-- Peak license start year: 2025
-- Currently active records with that start year: 1057 

-- Calculate year-over-year changes from 2015 onward
WITH yearly_counts AS (
    SELECT
        license_start_year,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE is_future_start_date = 0
      AND license_start_year >= 2015
    GROUP BY license_start_year
),
yearly_changes AS (
    SELECT
        license_start_year,
        license_count,
        LAG(license_count) OVER (
            ORDER BY license_start_year
        ) AS previous_year_count
    FROM yearly_counts
)
SELECT
    license_start_year,
    license_count,
    previous_year_count,
    license_count - previous_year_count AS numeric_change,
    ROUND(
        (license_count - previous_year_count) * 100.0
        / NULLIF(previous_year_count, 0),
        2
    ) AS percentage_change
FROM yearly_changes
ORDER BY license_start_year;

-- Results:
-- 2016: 456 licenses, up 5.56% from 2015.
-- 2017: 508 licenses, up 11.40%.
-- 2018: 618 licenses, up 21.65%.
-- 2019: 630 licenses, up 1.94%.
-- 2020: 455 licenses, down 27.78%.
-- 2021: 567 licenses, up 24.62%.
-- 2022: 729 licenses, up 28.57%.

-- Note:
-- The 2015 previous-year values are NULL because 2015 is the first year
-- included in this year-over-year calculation.

-- Portfolio insight:
-- License-start counts increased each year from 2015 through 2019,
-- followed by a sharp 27.78% decline in 2020.
-- Counts then rebounded strongly, increasing 24.62% in 2021
-- and another 28.57% in 2022.

-- Review the most recent start years
SELECT
    license_start_year,
    COUNT(*) AS license_count
FROM business_licenses_analysis
WHERE is_future_start_date = 0
  AND license_start_year >= 2022
GROUP BY license_start_year
ORDER BY license_start_year;
-- Results:
-- 2022: 729 licenses
-- 2023: 894 licenses
-- 2024: 951 licenses
-- 2025: 1,057 licenses
-- 2026: 695 licenses

-- Historical trend:
-- License-start counts continued increasing from 729 in 2022
-- to 1,057 in 2025, a total increase of 45.0%.
-- The 2026 count is lower because the dataset was downloaded
-- on 2026-08-02, before the end of the calendar year.

-- Portfolio insight:
-- Among currently active license records, start-year counts rose steadily
-- from 729 in 2022 to a peak of 1,057 in 2025, a 45.0% increase.
-- The lower 2026 count should not be interpreted as a full-year decline
-- because the dataset only includes records available through 2026-08-02.
USE seattle_business_license;

-- Count active license records by NAICS description
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
ORDER BY license_count DESC
LIMIT 15;

--Results:
-- 1. Lessors of Residential Buildings and Dwellings:
--    540 licenses, 4.19% of all records.
-- 2. All Other Personal Services:
--    461 licenses, 3.57%.
-- 3. Taxi and Ridesharing Services:
--    418 licenses, 3.24%.
-- 4. All Other Transit and Ground Passenger Transportation:
--    380 licenses, 2.95%.
-- 5. Offices of Mental Health Practitioners:
--    335 licenses, 2.60%.

-- Calculate the combined share of the top five industries
WITH industry_counts AS (
    SELECT
        naics_description,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE naics_description IS NOT NULL
      AND TRIM(naics_description) <> ''
    GROUP BY naics_description
),
ranked_industries AS (
    SELECT
        naics_description,
        license_count,
        ROW_NUMBER() OVER (
            ORDER BY license_count DESC
        ) AS industry_rank
    FROM industry_counts
)
SELECT
    SUM(license_count) AS top_5_license_count,
    ROUND(
        SUM(license_count) * 100.0 /
        (SELECT COUNT(*) FROM business_licenses_analysis),
        2
    ) AS top_5_share
FROM ranked_industries
WHERE industry_rank <= 5;

-- Results:
-- Top five industries combined: 2,134 licenses.
-- Share of all license records: 16.55%.
-- Insight:
-- The five largest industries account for 2,134 licenses, or 16.55% of all records.
-- This suggests Seattle's active business-license landscape is broadly distributed
-- across many industries rather than dominated by a few categories.

-- Find the top five industries within each age segment
WITH industry_by_age AS (
    SELECT
        CASE
            WHEN business_age_years BETWEEN 0 AND 5
                THEN 'Started within last 5 years'
            ELSE 'More than 5 years old'
        END AS business_age_segment,
        naics_description,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE is_future_start_date = 0
      AND naics_description IS NOT NULL
      AND TRIM(naics_description) <> ''
    GROUP BY
        business_age_segment,
        naics_description
),
ranked_industries AS (
    SELECT
        business_age_segment,
        naics_description,
        license_count,
        ROW_NUMBER() OVER (
            PARTITION BY business_age_segment
            ORDER BY license_count DESC
        ) AS industry_rank
    FROM industry_by_age
)
SELECT
    business_age_segment,
    naics_description,
    license_count,
    industry_rank
FROM ranked_industries
WHERE industry_rank <= 5
ORDER BY
    business_age_segment,
    industry_rank;

-- Results:

-- More than 5 years old:
-- 1. All Other Transit and Ground Passenger Transportation: 358 licenses
-- 2. All Other Personal Services: 353 licenses
-- 3. Taxi and Ridesharing Services: 350 licenses
-- 4. Administrative Management and General Management Consulting Services: 172 licenses
-- 5. All Other Miscellaneous Retailers: 171 licenses

-- Started within last 5 years:
-- 1. Lessors of Residential Buildings and Dwellings: 413 licenses
-- 2. All Other Traveler Accommodation: 263 licenses
-- 3. Offices of Mental Health Practitioners: 219 licenses
-- 4. Independent Artists, Writers, and Performers: 162 licenses
-- 5. Residential Remodelers: 143 licenses

-- Insight:
-- Industry composition differs between recently started and older active businesses.
-- Transportation-related industries lead among businesses more than five years old,
-- while residential lessors, traveler accommodation, and mental-health practices
-- rank highly among businesses started within the last five years.

-- Track the leading industries by license start year
WITH yearly_industry_counts AS (
    SELECT
        license_start_year,
        naics_description,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE is_future_start_date = 0
      AND naics_description IS NOT NULL
      AND TRIM(naics_description) <> ''
    GROUP BY
        license_start_year,
        naics_description
),
ranked_yearly_industries AS (
    SELECT
        license_start_year,
        naics_description,
        license_count,
        ROW_NUMBER() OVER (
            PARTITION BY license_start_year
            ORDER BY license_count DESC
        ) AS industry_rank
    FROM yearly_industry_counts
)
SELECT
    license_start_year,
    naics_description,
    license_count
FROM ranked_yearly_industries
WHERE industry_rank = 1
ORDER BY license_start_year;
-- Historical trend observation:
-- Early license-start years contain very few records, often only one license.
-- Because of the small yearly counts, the leading industry in those years is
-- not strong enough to support a meaningful trend conclusion.
-- More reliable comparisons should focus on recent years with larger record counts.

WITH yearly_industry_counts AS (
    SELECT
        license_start_year,
        naics_description,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE is_future_start_date = 0
      AND license_start_year >= 2015
      AND naics_description IS NOT NULL
      AND TRIM(naics_description) <> ''
    GROUP BY
        license_start_year,
        naics_description
),
ranked_yearly_industries AS (
    SELECT
        license_start_year,
        naics_description,
        license_count,
        ROW_NUMBER() OVER (
            PARTITION BY license_start_year
            ORDER BY license_count DESC
        ) AS industry_rank
    FROM yearly_industry_counts
)
SELECT
    license_start_year,
    naics_description,
    license_count
FROM ranked_yearly_industries
WHERE industry_rank = 1
ORDER BY license_start_year;
-- Historical trend observations:
-- From 2015 through 2019, All Other Transit and Ground Passenger Transportation
-- was the leading industry among currently active licenses started in each year.
-- Its count increased from 39 in 2015 to a peak of 89 in 2017,
-- then declined to 44 by 2019.
-- The leading category changed in 2020 to Offices of Mental Health Practitioners
-- and in 2021 to Lessors of Residential Buildings and Dwellings.
-- This suggests the industry mix of recently started active licenses shifted
-- away from transportation-related businesses after 2019.
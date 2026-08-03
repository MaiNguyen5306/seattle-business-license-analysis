USE seattle_business_license;

-- Count active license records by ownership type
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
-- Results:
-- 1. Sole proprietorship: 3,283 licenses, 25.46%.
-- 2. Corporation: 3,099 licenses, 24.03%.
-- 3. LLC - Single Member: 2,797 licenses, 21.69%.
-- 4. LLC - Multi Member: 2,622 licenses, 20.33%.
-- 5. Other: 435 licenses, 3.37%.

-- Portfolio insight:
-- Four ownership structures dominate the dataset.
-- Sole proprietorships, corporations, single-member LLCs,
-- and multi-member LLCs together account for 91.51% of all records.

-- Find the top five ownership types within each age segment
WITH ownership_by_age AS (
    SELECT
        CASE
            WHEN business_age_years BETWEEN 0 AND 5
                THEN 'Started within last 5 years'
            ELSE 'More than 5 years old'
        END AS business_age_segment,
        ownership_type,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE is_future_start_date = 0
      AND ownership_type IS NOT NULL
      AND TRIM(ownership_type) <> ''
    GROUP BY
        business_age_segment,
        ownership_type
),
ranked_ownership AS (
    SELECT
        business_age_segment,
        ownership_type,
        license_count,
        ROW_NUMBER() OVER (
            PARTITION BY business_age_segment
            ORDER BY license_count DESC
        ) AS ownership_rank
    FROM ownership_by_age
)
SELECT
    business_age_segment,
    ownership_type,
    license_count,
    ownership_rank
FROM ranked_ownership
WHERE ownership_rank <= 5
ORDER BY
    business_age_segment,
    ownership_rank;
-- Results:

-- More than 5 years old:
-- 1. Corporation: 2,514 licenses.
-- 2. Sole proprietorship: 2,252 licenses.
-- 3. LLC - Multi Member: 1,843 licenses.
-- 4. Other: 427 licenses.
-- 5. LLC - Single Member: 404 licenses.

-- Started within last 5 years:
-- 1. LLC - Single Member: 2,384 licenses.
-- 2. Sole proprietorship: 1,027 licenses.
-- 3. LLC - Multi Member: 775 licenses.
-- 4. Corporation: 582 licenses.
-- 5. Non Profit Corporation: 94 licenses.

-- Portfolio insight:
-- Ownership structure differs sharply by business age.
-- Corporations are the most common ownership type among records more than
-- five years old, while single-member LLCs rank first among records started
-- within the last five years.
-- This suggests newer active businesses are more likely to use a
-- single-member LLC structure than older active businesses.

-- Compare ownership types within the five largest industries
WITH top_industries AS (
    SELECT
        naics_description,
        COUNT(*) AS license_count
    FROM business_licenses_analysis
    WHERE naics_description IS NOT NULL
      AND TRIM(naics_description) <> ''
    GROUP BY naics_description
    ORDER BY license_count DESC
    LIMIT 5
),
ownership_by_industry AS (
    SELECT
        b.naics_description,
        b.ownership_type,
        COUNT(*) AS license_count
    FROM business_licenses_analysis AS b
    INNER JOIN top_industries AS t
        ON b.naics_description = t.naics_description
    WHERE b.ownership_type IS NOT NULL
      AND TRIM(b.ownership_type) <> ''
    GROUP BY
        b.naics_description,
        b.ownership_type
),
ranked_ownership AS (
    SELECT
        naics_description,
        ownership_type,
        license_count,
        ROW_NUMBER() OVER (
            PARTITION BY naics_description
            ORDER BY license_count DESC
        ) AS ownership_rank
    FROM ownership_by_industry
)
SELECT
    naics_description,
    ownership_type,
    license_count
FROM ranked_ownership
WHERE ownership_rank = 1
ORDER BY naics_description;
-- Results:
-- All Other Personal Services:
-- Sole proprietorship, 168 licenses.

-- All Other Transit and Ground Passenger Transportation:
-- Sole proprietorship, 353 licenses.

-- Lessors of Residential Buildings and Dwellings:
-- LLC - Single Member, 195 licenses.

-- Offices of Mental Health Practitioners:
-- LLC - Single Member, 210 licenses.

-- Taxi and Ridesharing Services:
-- Sole proprietorship, 370 licenses.

-- Portfolio insight:
-- The most common ownership structure differs by industry.
-- Sole proprietorships lead in personal services and transportation-related
-- industries, while single-member LLCs lead among residential lessors
-- and mental-health practitioners.


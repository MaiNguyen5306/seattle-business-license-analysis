# Seattle Business License Analysis

## Project Background

This project analyzes Seattle active business license data to understand the city's current business landscape, including industry composition, geographic distribution, ownership structure, and business age.

## Project Status

The SQL analysis, Excel validation, Tableau dashboard, and initial project documentation are complete.

The findings and recommendations will receive a final review to ensure that every conclusion is accurate, appropriately supported, and clearly communicated.

## Tools

- MySQL
- Excel
- Tableau Public

## Interactive Tableau Dashboard

[Open the interactive Tableau dashboard](https://public.tableau.com/views/seattle_business_license_dashboard/SeattleBusinessLicenseDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

[![Seattle Business License Dashboard](images/tableau_dashboard.png)](https://public.tableau.com/views/seattle_business_license_dashboard/SeattleBusinessLicenseDashboard?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

The dashboard is based on a City of Seattle Open Data snapshot downloaded on August 2, 2026. The 2026 license-start total is partial through that date.

## How to Explore This Project

1. Review the Executive Summary and Key Findings in this README.
2. Open the interactive Tableau dashboard for a visual overview.
3. Optional: Review the supporting analysis in the [`sql/`](sql/) folder, the Excel validation workbook in [`excel/`](excel/), and the processed CSV files in [`data/processed/`](data/processed/).

## Executive Summary

This project analyzes 12,897 active business-license records from the City of Seattle Open Data portal using MySQL, Excel, and Tableau. The analysis examines license-start trends, industry composition, ownership structure, geographic concentration, and business age.

The results show that Seattle’s active business landscape is highly diverse. No single industry dominates the dataset, and the five largest industries account for only 16.55% of all records. License starts increased substantially between 2022 and 2025, while sole proprietorships, corporations, and limited liability companies represent most ownership structures.

## Key Findings

- **Industry diversity:** No single industry dominates the active-license landscape. The five largest industries account for only 16.55% of all records.

- **License-start trend:** License starts among active records increased from 729 in 2022 to 1,057 in 2025, representing a 45% increase over the period.

- **Ownership concentration:** Sole proprietorships, corporations, single-member LLCs, and multi-member LLCs together account for 91.51% of all license records.

- **Geographic concentration:** The five leading Seattle ZIP codes contain 30.28% of Seattle-address records, with ZIP code 98103 ranking first at 688 records.

- **Business-age distribution:** The average record age is 11.31 years. About 60% of non-future-dated records fall within the first ten years, while roughly 40% are more than ten years old, showing representation from both newer and long-established license holders.

## Recommendations

- **Industry diversity suggests broad support is more appropriate than narrow targeting.** Because the five largest industries account for only 16.55% of active license records, business-support programs should remain flexible enough to serve a wide range of industries rather than concentrating resources on only a few sectors.

- **Ownership concentration supports differentiated assistance.** Sole proprietorships, corporations, and LLCs account for most license records, so outreach and support could be tailored to their different compliance, financing, and operational needs.

- **Geographic concentration can guide where outreach occurs, independent of industry focus.** The five leading Seattle ZIP codes contain 30.28% of Seattle-address records, with 98103 ranking first at 688 records. ZIP-level patterns could help prioritize outreach locations while maintaining broad support across industries.

- **Recent license-start growth should be monitored cautiously.** License starts among currently active records increased 45% from 2022 to 2025, but additional years of data are needed to determine whether this reflects a sustained pattern rather than a temporary increase.

## Limitations

- The dataset is a snapshot downloaded on August 2, 2026, so it does not update automatically. The 2026 license-start count is also partial and should not be compared directly with complete calendar years.

- A license record does not necessarily represent a unique business because one organization may have multiple accounts, locations, or records.

- Business addresses and industry classifications are imperfect proxies: addresses may not reflect where customers, employees, or activity are concentrated, while NAICS categories may be broad, outdated, self-reported, or incomplete. The dataset also included 21 future-dated records and six missing NAICS descriptions that required review.

- The analysis describes licensing patterns but does not measure revenue, employment, profitability, survival, or economic impact.

## Business Questions

This project focuses on five questions:

1. How have active license starts changed over time?
2. Which industries and ownership structures account for the largest share of active license records?
3. How are active licenses distributed across business-age groups?
4. Which Seattle ZIP codes have the highest concentration of active license records?
5. What data-quality and scope limitations affect how the results should be interpreted?

## Data Source

- Source: City of Seattle Open Data portal
- Dataset: Active Business License Tax Certificate records
- Snapshot date: August 2, 2026
- Records analyzed: 12,897
- Unique UBI numbers: 11,659
- Scope: Includes license records with both Seattle and non-Seattle addresses
- Note: 2026 license-start results are partial through August 2

## Data Preparation and Validation

- **Validated import integrity:** Confirmed record counts, reviewed City Account Numbers and UBI numbers for duplicate patterns, and standardized field names and formats.
- **Built time-based fields:** Converted license-start values into date and year fields and calculated business age and age-group categories.
- **Resolved data-quality issues:** Flagged 21 future-dated records and filled six missing NAICS descriptions after reviewing their codes.
- **Standardized geography:** Created Seattle-address indicators and standardized five-digit ZIP-code fields.
- **Cross-validated results:** Compared final SQL outputs with Excel totals before building the Tableau dashboard.

## Analysis Workflow

### MySQL

- Created calculated fields for license-start year, business age, age groups, Seattle-address status, and standardized ZIP codes.
- Ran grouped analyses across time, industry, ownership type, geography, and business age.
- Produced validated summary tables and analysis-ready exports for Excel and Tableau.

### Excel

- Cross-validated key SQL totals and reviewed data-quality results.
- Built a KPI summary, charts, and an ownership-by-age PivotTable.
- Used the workbook as a secondary validation layer before dashboard development.

### Tableau Public

Built and published an interactive dashboard highlighting:

- License-start trends
- Industry and ownership patterns
- Business-age distribution
- Seattle ZIP-code concentration

## Tools and Skills Demonstrated

- **SQL:** Data cleaning, exploratory analysis, grouped queries, CTEs, calculated fields, and data-quality validation
- **Excel:** KPI summaries, PivotTables, charts, and cross-validation of SQL results
- **Tableau:** Interactive dashboard design, geographic visualization, and data storytelling
- **Analysis & Communication:** Segmentation insights, business recommendations, methodology, and limitations

## Project Deliverables

- SQL scripts for data inspection, cleaning, analysis, and dashboard exports
- Processed datasets and summary files
- Excel validation and analysis workbook
- Published interactive Tableau dashboard and packaged workbook
- Written findings, recommendations, methodology, and limitations

## Author

Mai Nguyen — Mathematics student building data analytics and business intelligence skills through hands-on projects in SQL, Excel, and Tableau.
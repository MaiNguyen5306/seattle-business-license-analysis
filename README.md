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

1. Open the interactive Tableau dashboard for a visual overview.
2. Review the Executive Summary and Key Findings in this README.
3. Open the Excel workbook to see validation tables, charts, and the PivotTable.
4. Review the SQL scripts to follow the data-cleaning and analysis process.
5. Explore the processed CSV exports used to support the dashboard.

## Executive Summary

This project analyzes 12,897 active business-license records from the City of Seattle Open Data portal using MySQL, Excel, and Tableau. The analysis examines license-start trends, industry composition, ownership structure, geographic concentration, and business age.

The results show that Seattle’s active business landscape is highly diverse. No single industry dominates the dataset, and the five largest industries account for only 16.55% of all records. License starts increased substantially between 2022 and 2025, while sole proprietorships, corporations, and limited liability companies represent most ownership structures.

The dataset is a snapshot downloaded on August 2, 2026. Therefore, 2026 results are partial and should not be directly compared with complete calendar years.

## Key Findings

- The dataset contains 12,897 active license records representing 11,659 unique UBI numbers.
- 8,805 records, or 68.27%, have a Seattle business address.
- The average business age is 11.31 years.
- License starts increased from 729 in 2022 to 1,057 in 2025, a 45% increase.
- The five largest industries account for 2,134 records, or 16.55% of the dataset, indicating broad industry diversity.
- Sole proprietorship is the largest ownership type with 3,283 records, followed by corporations with 3,099.
- The four largest ownership categories account for 91.51% of all license records.
- ZIP code 98103 has the highest concentration of Seattle-address records with 688 licenses.
- The top five Seattle ZIP codes account for 30.28% of Seattle-address license records.
- Twenty-one future-dated records were excluded from the business-age distribution.

## Recommendations

- Continue tracking annual license starts to determine whether the growth observed from 2022 through 2025 represents a lasting trend or a temporary increase.
- Use ZIP-level patterns to identify neighborhoods with strong business activity and areas that may benefit from additional outreach, technical assistance, or small-business resources.
- Segment business-support programs by ownership structure because sole proprietorships, corporations, and LLCs may have different financing, compliance, and growth needs.
- Avoid focusing support on only the largest industries. The top five industries represent just 16.55% of records, so broad and flexible business-development programs may serve the city better than narrowly targeted initiatives.
- Review future-dated and incomplete records before using the dataset for operational decisions or automated reporting.

## Limitations

- The dataset is a snapshot downloaded on August 2, 2026 and does not update automatically.
- The 2026 license-start count is partial and should not be compared directly with complete calendar years.
- A license record does not necessarily represent a unique business because one organization may have multiple accounts or locations.
- Business address does not always indicate where customers, employees, or business activity are concentrated.
- Industry classifications may be broad, outdated, or self-reported.
- Twenty-one future-dated records were identified, and six missing NAICS descriptions required review or cleaning.
- The analysis describes patterns in active license records but does not measure business revenue, employment, survival, profitability, or economic impact.

## Business Questions

This project explores the following questions:

1. How many active business-license records are included in the dataset, and how many represent unique UBI numbers?
2. What share of active license records have a Seattle business address?
3. How have license starts changed over time?
4. Which industries account for the largest number of active license records?
5. Which ownership structures are most common?
6. How are active licenses distributed across business-age groups?
7. Which Seattle ZIP codes have the highest concentration of active license records?
8. What data-quality issues or limitations should be considered when interpreting the results?

## Data Source

The data was obtained from the City of Seattle Open Data portal and contains active Seattle Business License Tax Certificate records.

- Snapshot download date: August 2, 2026
- Records analyzed: 12,897
- Unique UBI numbers: 11,659
- Geographic scope: Businesses with both Seattle and non-Seattle addresses included in the active-license dataset
- Reporting note: License-start results for 2026 are partial through August 2, 2026

The raw source file is not stored in this repository. Processed summary files and the analysis workbook are included for reproducibility and portfolio review.

## Data Preparation and Validation

The dataset was imported into MySQL and reviewed before analysis. The preparation process included:

- Verifying the number of imported records
- Reviewing missing values across important fields
- Checking City Account Numbers and UBI numbers for duplicate patterns
- Standardizing field names and formats
- Converting license-start values into usable date and year fields
- Creating business-age calculations and age-group categories
- Identifying 21 records with future license-start dates
- Filling six missing NAICS descriptions after reviewing their NAICS codes
- Creating Seattle-address indicators and standardized five-digit ZIP-code fields
- Comparing final SQL results with Excel validation totals

The cleaned analysis table retained all 12,897 source records. Future-dated records were flagged rather than deleted so the issue remained transparent.

## Analysis Workflow

### MySQL

MySQL was used to:

- Inspect the imported data
- Identify missing and unusual values
- Clean and standardize fields
- Create calculated fields
- Perform exploratory analysis
- Calculate summary metrics
- Export analysis-ready files for Excel and Tableau

### Excel

Excel was used to:

- Validate key SQL totals
- Create a KPI summary
- Review historical, industry, ownership, geographic, and age-group results
- Build charts and a PivotTable
- Confirm that spreadsheet results matched the SQL output

### Tableau Public

Tableau Public was used to create an interactive dashboard containing:

- Total active license records
- Seattle-address records and share
- Average business age
- Annual license-start trends
- Top industries
- Ownership structures
- Business-age groups
- Seattle ZIP-code concentration

The published visualization allows users to explore the results through interactive selections and tooltips.

## Repository Structure

```text
seattle-business-license-analysis/
│
├── dashboard/
│   └── seattle_business_license_dashboard.twbx
│
├── data/
│   ├── raw/
│   │   └── Raw source file excluded from Git
│   └── processed/
│       ├── business_licenses_analysis.csv
│       ├── export_age_groups.csv
│       ├── export_industry_summary.csv
│       ├── export_kpis.csv
│       ├── export_ownership_summary.csv
│       ├── export_yearly_trends.csv
│       └── export_zip_summary.csv
│
├── excel/
│   └── seattle_business_license_analysis.xlsx
│
├── images/
│   └── tableau_dashboard.png
│
├── sql/
│   ├── 01_initial_checks.sql
│   ├── 02_data_quality.sql
│   ├── 03_cleaning.sql
│   ├── 04_exploration.sql
│   ├── 05_summary_metrics.sql
│   ├── 06_business_insights.sql
│   ├── 07_validation.sql
│   ├── 08_analysis_table.sql
│   └── 09_dashboard_exports.sql
│
├── .gitignore
└── README.md

```markdown
## Tools and Skills Demonstrated

- MySQL
- SQL data cleaning and exploratory analysis
- Aggregate functions and grouped analysis
- Common table expressions and calculated fields
- Data-quality validation
- Microsoft Excel
- PivotTables
- Tableau Public
- Interactive dashboard design
- Data visualization and storytelling
- Git and GitHub
- Business-oriented recommendations
- Technical documentation

## Project Deliverables

- SQL scripts for data inspection, cleaning, analysis, and dashboard exports
- Processed analysis datasets
- Excel validation and analysis workbook
- Published interactive Tableau dashboard
- Tableau packaged workbook
- Dashboard image for portfolio viewing
- Written findings, recommendations, methodology, and limitations

## Author

Mai Nguyen

Mathematics student developing skills in data analytics, business intelligence, SQL, Excel, and data visualization.
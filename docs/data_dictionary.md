# Data Dictionary

## Dataset Overview

**Dataset:** Active Business License Tax Certificate  
**Source:** Seattle Open Data  
**Download date:** August 2, 2026  
**Raw file:** Active_Business_License_Tax_Certificate_20260802.csv

Each row represents one active Seattle business license record.

## Columns

| Column | Simple meaning | Expected data type | Possible use |
|---|---|---|---|
| Business Legal Name | Official registered business name | Text | Identifying businesses and checking duplicates |
| Trade Name | Name the business uses publicly | Text | Business identification |
| Ownership Type | Legal ownership structure | Text | Comparing ownership types |
| NAICS Code | Industry classification code | Text | Grouping businesses by industry |
| NAICS Description | Written description of the industry | Text | Industry analysis and dashboard labels |
| License Start Date | Date the license began | Date | Business age and historical trends |
| Street Address | Business street location | Text | Location checks |
| City | Business city | Text | Seattle versus outside-Seattle analysis |
| State | Business state | Text | Geographic analysis |
| ZIP | Business ZIP code | Text | Neighborhood and geographic analysis |
| Business Phone | Business telephone number | Text | Not needed for this analysis |
| City Account Number | Seattle license account identifier | Text | Checking unique license records |
| UBI | Washington business identifier | Text | Estimating unique businesses |

## Important Notes

- The raw dataset should not be manually edited.
- Business names, addresses, and phone numbers will not be shown in the public dashboard.
- ZIP codes should be stored as text so leading zeros are not removed.
- NAICS codes should be stored as text because they are classification codes, not numbers used for calculations.
- This dataset contains currently active licenses, so it is not a complete record of businesses that have closed.
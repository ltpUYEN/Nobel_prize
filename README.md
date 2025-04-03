# Nobel Prize Data Analysis and Exploration (1901-2024)

Inspired by Nobel winner Han Kang, this project explores over a century of Nobel Prize data (1901-2024) to uncover trends among laureates. Data from multiple sources was acquired, cleaned, and merged using Python (`pandas`), then loaded into a MySQL database. This project aims to provide a comprehensive analysis of Nobel Prize laureates and awards. The analysis focuses on identifying trends, distributions, and interesting patterns, **with a specific lens on the achievements of women Nobel Prize winners**, within the data.

## Data Sources

* **Historical (1901-2023):** Harvard Dataverse - [Link to Harvard Dataset, e.g., https://doi.org/10.7910/DVN/28207] (CSV)
* **Recent (2023-2024):** Nobel Prize Official Website ([https://www.nobelprize.org/](https://www.nobelprize.org/)) - Manually compiled using Excel.
## Tech stack & Workflow

* **Tools:** Python (`pandas`), Microsoft Excel, MySQL, MySQL Workbench, VS Code.
* **Workflow Summary:** Data acquired -> Cleaned & Merged (Python) -> Loaded into MySQL DB (Workbench) -> Validated & Analyzed (mySQLn in VS code).

## Validation, Analysis & Code
Extensive data validation was performed using SQL to ensure integrity and consistency, including checks for duplicates, value ranges, unique constraints, and standardization of fields like `birth_country`.

Subsequent SQL analysis explored various aspects:
* Laureate demographics (gender, birth country distribution).
* Trends in female representation over decades.
* Prize distribution across categories.
* Identification of multiple prize winners (individuals and organizations).
* Patterns in prize sharing over time.

## Data processing:
```python
#link 1 - Data_processing

import pandas as pd
import os
print(os.getcwd())

# 1. FUNCTION DEFINITION 
def combine_data(csv_path, excel_path, concat_path):  # These are just names!
    """Combines CSV and Excel data (assumes identical columns)."""
    try:
        df_csv = pd.read_csv(csv_path)       
        df_excel = pd.read_excel(excel_path)  
        df_final = pd.concat([df_csv, df_excel], ignore_index=True)
        df_final.to_csv(concat_path, index=False) 
        print(f"Combined data saved to {concat_path}")
        return df_final
    except (FileNotFoundError, pd.errors.ParserError, pd.errors.EmptyDataError, Exception) as e:
        print(f"Error: {e}")
        return None

# 2. FUNCTION CALL 
if __name__ == "__main__":
    
    my_csv_file = "/Frommypath/Project/Nobel2024/nobel_2023.csv"
    my_excel_file = "/Frommypath/Project/Nobel2024/Nobel_prizes_2024.xlsx"
    my_output_file = "/Frommypath/Project/Nobel2024/nobel_prizes.csv"
```

## Database schema:
| Field                | Type          | Null | Key | Default | Extra |
| :------------------- | :------------ | :--- | :-- | :------ | :---- |
| `year`               | `int`         | YES  |     | NULL    |       |
| `category`           | `varchar(500)`| YES  |     | NULL    |       |
| `prize`              | `varchar(500)`| YES  |     | NULL    |       |
| `motivation`         | `varchar(500)`| YES  |     | NULL    |       |
| `prize_share`        | `varchar(500)`| YES  |     | NULL    |       |
| `laureate_type`      | `varchar(500)`| YES  |     | NULL    |       |
| `full_name`          | `varchar(500)`| YES  |     | NULL    |       |
| `birth_date`         | `varchar(500)`| YES  |     | NULL    |       |
| `birth_city`         | `varchar(500)`| YES  |     | NULL    |       |
| `birth_country`      | `varchar(500)`| YES  |     | NULL    |       |
| `sex`                | `varchar(500)`| YES  |     | NULL    |       |
| `organization_name`  | `varchar(500)`| YES  |     | NULL    |       |
| `organization_city`  | `varchar(500)`| YES  |     | NULL    |       |
| `organization_country`| `varchar(500)`| YES  |     | NULL    |       |
| `death_date`         | `varchar(500)`| YES  |     | NULL    |       |
| `death_city`         | `varchar(500)`| YES  |     | NULL    |       |
| `death_country`      | `varchar(500)`| YES  |     | NULL    |       |


## SQL scripts for data validation and exploratory analysis:
- *[`Data validation`](./data_validation.sql)*
- *[`EDA`](./eda.sql)*

![Nobel p1](https://github.com/user-attachments/assets/aa23337f-d99e-4cd9-9e24-e2db02704cd2)
## DAX scripts for Power BI calculation
```SQL
Oldest Age at Award = 
VAR MaxAge = 
    MAXX( ALL( nobelpbi ), nobelpbi[age_at_award] )
VAR CategoryForMaxAge =
    CALCULATE(
        SELECTEDVALUE( nobelpbi[Category], "Multiple Categories" ), 
        FILTER(
            nobelpbi,
            nobelpbi[age_at_award] = MaxAge
        )
    )
RETURN
    MaxAge & " (" & CategoryForMaxAge & ")"

Youngest Age at Award = 
VAR MinAge = 
    MINX( ALL( nobelpbi ), nobelpbi[age_at_award] )
VAR CategoryForMinAge =
    CALCULATE(
        SELECTEDVALUE( nobelpbi[Category], "Multiple Categories" ), 
        FILTER(
            nobelpbi,
            nobelpbi[age_at_award] = MinAge
        )
    )
RETURN
    MinAge & " (" & CategoryForMinAge & ")"
age_at_award = 
VAR AwardDateValue = nobelpbi[award_year]
VAR BirthDateValue = nobelpbi[birth_date]
VAR AwardYear = YEAR(AwardDateValue)
VAR BirthYear = YEAR(BirthDateValue)
RETURN
IF(
    NOT ISBLANK(AwardDateValue) && NOT ISBLANK(BirthDateValue),
    AwardYear - BirthYear,
    BLANK()
)
```
![Nobel p2](https://github.com/user-attachments/assets/32918cc1-ed6f-4514-87e0-6c12f9fb8532)




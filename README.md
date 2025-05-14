# SQL for Data Analysis

##  Dataset: Nashville Housing Dataset

The objective of this project was to demonstrate SQL proficiency by performing data cleaning, transformation, and exploratory analysis on a real-world housing dataset. The dataset includes property sale records from Nashville.

---

##  Tools Used

- SQL Server Management Studio (SSMS)
- Nashville Housing Dataset (Excel file, imported into a table named `N_Housing`)

---

##  Key SQL Concepts Demonstrated

### 1. Data Cleaning
- Standardized the `SaleDate` format
- Filled in missing `PropertyAddress` using self-joins on `ParcelID`
- Standardized values in the `SoldAsVacant` column (`Y/N` → `Yes/No`)
- Removed duplicate records using `ROW_NUMBER()`

### 2. Data Transformation
- Split `PropertyAddress` into separate columns: street and city
- Split `OwnerAddress` into separate columns: street, city, and state

### 3. Query Skills
- `SELECT`, `WHERE`, `ORDER BY`, `GROUP BY`, `JOIN`
- Window functions (`ROW_NUMBER()`, `OVER`)
- String manipulation (`SUBSTRING`, `PARSENAME`)
- Data type conversion
- CTEs for structured deletions

---

##  Views for Analysis

To enable simplified reporting and consistent queries, views were created for quick access to commonly used summaries:

- **`vw_YearlySalesSummary`**: Shows number of properties sold and average sale price per year.
- **`vw_SalesByOwnerState`**: Summarizes total sales and average price grouped by owner state.
- **`vw_VacantVsNonVacant`**: Compares number of sales and average prices between vacant and non-vacant properties.


- Additional views can be built upon the cleaned `N_Housing` table to support dashboarding in tools like Power BI or Tableau.

---

##  Files Included

- `sqlqueryfile.sql`: Full SQL script with comments explaining each step
- `screenshots/`: Folder containing images of query results and transformations

---

##  Outcome

This project simulates the kind of real-world data wrangling tasks data analysts perform. It reinforced my understanding of SQL for cleaning, transforming, and analyzing messy datasets while ensuring data integrity and readiness for reporting or dashboarding.

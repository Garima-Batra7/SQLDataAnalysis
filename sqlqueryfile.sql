--CREATE DATABASE Nashville_Housing_Project;
--GO
--USE Nashville_Housing_Project;


-- 1. Load entire dataset
SELECT * FROM N_Housing;

----------------------------------------------------
-- 2. Standardizing the Date Format
----------------------------------------------------
ALTER TABLE N_Housing
ADD SaleDateConverted DATE;

UPDATE N_Housing
SET SaleDateConverted = CONVERT(DATE, SaleDate);

SELECT SaleDate, SaleDateConverted FROM N_Housing;

----------------------------------------------------
-- 3. Filling Missing Property Addresses
----------------------------------------------------
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM N_Housing a
JOIN N_Housing b 
  ON a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL;

SELECT * FROM N_Housing WHERE PropertyAddress IS NULL;

----------------------------------------------------
-- 4. Splitting Property Address into Street & City
----------------------------------------------------
ALTER TABLE N_Housing
ADD PropertySplitAddress NVARCHAR(255),
    PropertySplitCity NVARCHAR(255);

UPDATE N_Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity FROM N_Housing;

----------------------------------------------------
-- 5. Splitting Owner Address into Street, City, State
----------------------------------------------------
ALTER TABLE N_Housing
ADD OwnerSplitAddress NVARCHAR(255),
    OwnerSplitCity NVARCHAR(255),
    OwnerSplitState NVARCHAR(255);

UPDATE N_Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

SELECT OwnerAddress, OwnerSplitAddress, OwnerSplitCity, OwnerSplitState FROM N_Housing;


----------------------------------------------------
-- 6. Standardizing 'SoldAsVacant' Values
----------------------------------------------------
UPDATE N_Housing
SET SoldAsVacant = CASE 
    WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
END;

SELECT DISTINCT SoldAsVacant FROM N_Housing;

----------------------------------------------------
-- 7. Removing Duplicate Rows
----------------------------------------------------
-- Check Duplicates
SELECT *,
       ROW_NUMBER() OVER (
           PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
           ORDER BY UniqueID
       ) AS row_num
FROM N_Housing;

WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
               ORDER BY UniqueID
           ) AS row_num
    FROM N_Housing
)
DELETE FROM RowNumCTE
WHERE row_num > 1;


SELECT COUNT(*) FROM N_Housing;

----------------------------------------------------
-- 8. Dropping Unused Columns
----------------------------------------------------
ALTER TABLE N_Housing
DROP COLUMN OwnerAddress, SaleDate, PropertyAddress, TaxDistrict;


SELECT * FROM N_Housing;


 -- 9. View: Cleaned and Enriched Data

CREATE VIEW vw_CleanedHousing AS
SELECT
    [UniqueID ],
    ParcelID,
    PropertySplitAddress,
    PropertySplitCity,
    OwnerName,
    OwnerSplitAddress,
    OwnerSplitCity,
    OwnerSplitState,
    SalePrice,
    SaleDateConverted AS SaleDate,
    LegalReference,
    SoldAsVacant,
    LandUse
FROM N_Housing;

SELECT * FROM vw_CleanedHousing;

-- 10.View: Yearly Sales Summary

CREATE VIEW vw_YearlySalesSummary AS
SELECT
    YEAR(SaleDateConverted) AS SaleYear,
    COUNT(*) AS TotalSales,
    AVG(SalePrice) AS AvgSalePrice
FROM N_Housing
GROUP BY YEAR(SaleDateConverted);

SELECT * FROM vw_YearlySalesSummary
ORDER BY SaleYear;

-- 11. View: Owner State Summary

CREATE VIEW vw_SalesByOwnerState AS
SELECT
    OwnerSplitState,
    COUNT(*) AS TotalSales,
    AVG(SalePrice) AS AvgPrice
FROM N_Housing
GROUP BY OwnerSplitState;


SELECT * FROM vw_SalesByOwnerState
ORDER BY TotalSales DESC;

-- 12. View: Vacant vs Non-Vacant Sales

CREATE VIEW vw_VacantVsNonVacant AS
SELECT
    SoldAsVacant,
    COUNT(*) AS TotalSales,
    AVG(SalePrice) AS AvgPrice
FROM N_Housing
GROUP BY SoldAsVacant;

SELECT * FROM vw_VacantVsNonVacant;


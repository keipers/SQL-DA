/*
Cleaning Data in SQL Queries
*/





--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format
-- Strip off the 00:00:00 from the SaleDate

Update PortfolioProject.dbo.NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate);


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data
-- Populate NULL Property Address with address where ParcelIDs are =

UPDATE a
SET 
	a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM	
	PortfolioProject.dbo.NashvilleHousing a
	JOIN
	PortfolioProject.dbo.NashvilleHousing b
	ON
	a.ParcelID = b.ParcelID
AND
	a.UniqueID <> b.UniqueID
WHERE
	a.PropertyAddress is null;

	

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State) using SUBSTRING and PARSENAME


--Property Address
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD Address NVarChar(255);
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD City NVarChar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET Address = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1);
Update PortfolioProject.dbo.NashvilleHousing
SET City = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));


--Owner Address
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OAddress NVarChar(255);
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OCity NVarChar(255);
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OState NVarChar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)

Update PortfolioProject.dbo.NashvilleHousing
SET OCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

Update PortfolioProject.dbo.NashvilleHousing
SET OState = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant =
	CASE
	WHEN
		SoldAsVacant = 'Y' THEN 'Yes'
	WHEN	
		SoldAsVacant = 'N' THEN 'No'
	ELSE
		SoldAsVacant
	END




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
SELECT *,
		ROW_NUMBER () OVER (
				PARTITION BY
						ParcelID, PropertyAddress, SaleDate, LegalReference
				ORDER BY UniqueID
				) as RowNum
FROM PortfolioProject.dbo.NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE RowNum > 1;

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

--Should rarely be used on orig./base table.  Create a view but for fun

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN PropertyAddress, OwnerAddress;    --logical canidates since we split them up in above cleaning section


















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO


















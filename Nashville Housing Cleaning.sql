/* Few Data Cleaning Procedure of Nashville Housing With SQL */

--Let's take a look at our DateSet

SELECT *
FROM NashvilleHousing

--Next, we have to start cleaning our Data.

--Standadizing Date Format (Notice our salesDate is not in the right format, to correct this, we use the following queries)

ALTER TABLE NashvilleHousing
ADD ConvertedSaleDate Date;

UPDATE NashvilleHousing
SET ConvertedSaleDate = CONVERT(date, saledate)

SELECT ConvertedSaleDate
FROM NashvilleHousing

--Cleaning the Property Address column

SELECT PropertyAddress
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

--Notice some rows are NULL, in order to correct this, we fill NULL Values by finding uniqueness with other columns.

SELECT *
FROM NashvilleHousing

--Notice there is a uniqueness between the ParcelID column and the PropertyAddress column. Most of the repeated ParcelID
--carries thesame PropertyAddress hence we replace with missing values.
--To do this, we compare correlating parcelID and PropertyAddress with distinct uniqueID by using the queries below;

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Next we replace rows having NULL with corresponding PropertyAddress
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Now lets split the PropertyAddress column into Address and city using SUBSTRING

SELECT 
	  SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
	  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--Now lets split the OwnerAddress column into Address, city and State using PARSENAME

SELECT 
	  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
	  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
	  PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Now let's Change "Y" and "N" to "Yes" and "No" in the SoldAsVacant Column
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
	   CASE WHEN SoldAsVacant = 'N' THEN 'No'
	   WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'No'
	   WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   ELSE SoldAsVacant
	   END

--Remove Duplicate Data 
WITH NumRowCTE AS 
(
Select *,
	ROW_NUMBER() OVER
	(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) AS row_num
FROM NashvilleHousing)

DELETE
FROM NumRowCTE
WHERE row_num > 1


--Delete Unused Columns
ALTER TABLE NashvilleHousing
DROP COLUMN PropertyAddress, SaleDate, OwnerAddress
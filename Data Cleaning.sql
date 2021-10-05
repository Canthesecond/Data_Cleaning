


-- Standardize the Date Format



Select SaleDate,CONVERT(Date,SaleDate) from CovidAnalysis.dbo.NashvilleHousing



Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate) 
from CovidAnalysis.dbo.NashvilleHousing

use CovidAnalysis
Alter table	NashvilleHousing 
Add SaleDateConverted Date

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate) 
from CovidAnalysis.dbo.NashvilleHousing

--Populate Property Adress data 

Select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress , ISNULL(a.PropertyAddress,b.PropertyAddress)
from CovidAnalysis.dbo.NashvilleHousing a 
JOIN CovidAnalysis.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)

from CovidAnalysis.dbo.NashvilleHousing a 
JOIN CovidAnalysis.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking Address into individual columns

SELECT	
SUBSTRING(propertyaddress,CHARINDEX(',',PROPERTYADDRESS)+1, LEN(propertyaddress)) AS ADDRESS,
SUBSTRING(propertyaddress,1,CHARINDEX(',',PROPERTYADDRESS)-1) as address
from CovidAnalysis.dbo.NashvilleHousing




use covidanalysis
Alter table	NashvilleHousing
Add PropertSplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertSplitAddress = SUBSTRING(propertyaddress,CHARINDEX(',',PROPERTYADDRESS)+1, LEN(propertyaddress))
from CovidAnalysis.dbo.NashvilleHousing

USE covidanalysis
Alter table	NashvilleHousing
Add PropertSplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertSplitCity = SUBSTRING(propertyaddress,1,CHARINDEX(',',PROPERTYADDRESS)-1)
from CovidAnalysis.dbo.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),1),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
from CovidAnalysis.dbo.NashvilleHousing




SELECT	
*
From CovidAnalysis.dbo.NashvilleHousing



SELECT	
SUBSTRING(OwnerAddress,CHARINDEX(',',OwnerAddress)+1, LEN(OwnerAddress)) AS ADDRESS,
SUBSTRING(OwnerAddress,1,CHARINDEX(',',OwnerAddress)-1) as address
From CovidAnalysis.dbo.NashvilleHousing


Use covidanalysis
Alter table	NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)
from CovidAnalysis.dbo.NashvilleHousing

USE covidanalysis
Alter table	NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)
From CovidAnalysis.dbo.NashvilleHousing

USE covidanalysis
Alter table	NashvilleHousing
Add OwnerSplitZip Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitZip = PARSENAME(REPLACE(OwnerAddress,',','.'),1)
From CovidAnalysis.dbo.NashvilleHousing
--





--Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldAsVacant),count(SoldAsVacant)
From CovidAnalysis.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select soldasvacant,
Case 
When soldasvacant = 'y' then 'Yes'
When soldasvacant = 'n' then 'No'
Else SoldAsVacant
End
From CovidAnalysis.dbo.NashvilleHousing

Use CovidAnalysis
Update NashvilleHousing
Set SoldAsVacant = case 
When soldasvacant = 'y' then 'Yes'
When soldasvacant = 'n' then 'No'
Else SoldAsVacant
End






--Remove duplicates
WITH RowNumCTE AS(
select *, 
ROW_NUMBER() Over(
Partition by    parcelid,
				propertyaddress,
				saledate,
				saleprice,
				legalreference
				order by 
				uniqueid
				)row_num


From CovidAnalysis.dbo.NashvilleHousing
)

select * From RowNumCTE
where row_num > 1
order by PropertyAddress

select * 
From CovidAnalysis.dbo.NashvilleHousing



--Delete Unused Columns

select * 
From CovidAnalysis.dbo.NashvilleHousing

alter table CovidAnalysis.dbo.NashvilleHousing
drop column owneraddress, taxdistrict,propertyaddress


alter table CovidAnalysis.dbo.NashvilleHousing
drop column saledate
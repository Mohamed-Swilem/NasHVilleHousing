--Cleaning Data in SQL Queries
select*
from PortifoilioProject.dbo.NashvilleHousing


--Standardize Date Format
select SaleDateConverted,CONVERT(Date,SaleDate)
from PortifoilioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate=CONVERT(Date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted Date;

update NashvilleHousing
set SaleDateConverted=CONVERT(Date,SaleDate)

--Populate Property Address date
select PropertyAddress
from PortifoilioProject.dbo.NashvilleHousing
--where PropertyAddress is null 
order by ParcelID

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortifoilioProject.dbo.NashvilleHousing a
join PortifoilioProject.dbo.NashvilleHousing b
     on a.ParcelID=B.ParcelID
	 and a.UniqueID<>b.UniqueID
	 where a.PropertyAddress is null 
	 

--Breaking out Address into Individual Columns (Address,City,State)
select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)AS Address
,right(PropertyAddress,LEN(PropertyAddress)-CHARINDEX(',',PropertyAddress)) AS Address
from PortifoilioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);
 
update NashvilleHousing
set PropertySplitCity=right(PropertyAddress,LEN(PropertyAddress)-CHARINDEX(',',PropertyAddress)) 

select*
from PortifoilioProject.dbo.NashvilleHousing


select
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortifoilioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);
 
update NashvilleHousing
set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);
 
update NashvilleHousing
set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

select*
from PortifoilioProject.dbo.NashvilleHousing

--change 'Y'&'N' to Yes & No in "Sold As Vacant" field
select Distinct(SoldAsVacant), count(SoldAsVacant)
from PortifoilioProject.dbo.NashvilleHousing
Group By SoldAsVacant
order by 2

select SoldAsVacant,
case when SoldAsVacant='Y' then 'Yes'
     when SoldAsVacant='N' then 'No'
	 Else SoldAsVacant
	 end
from PortifoilioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant =case when SoldAsVacant='Y' then 'Yes'
     when SoldAsVacant='N' then 'No'
	 Else SoldAsVacant
	 end

--Remove Duplicates
with RowNumCTE AS(
select *,
ROW_NUMBER() over(
       partition by ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					order by 
					     UniqueID
						 ) row_num
from PortifoilioProject.dbo.NashvilleHousing
--order by ParcelID
)
select*
from RowNumCTE
where row_num>1
order by PropertyAddress



--Delete unused Columns
select*
from PortifoilioProject.dbo.NashvilleHousing

alter table NashvilleHousing
drop column SaleDate



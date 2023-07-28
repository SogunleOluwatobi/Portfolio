Select *
From PortfolioProject..nashvillehousing

-- Standardize date format
Select Saledate, convert(Date, Saledate)
From PortfolioProject..nashvillehousing

Update Nashvillehousing
Set Saledate = convert(Date, Saledate)

Alter Table Nashvillehousing		-- Adding new column
Add SaledateConverted Date;

Update Nashvillehousing				-- Filling up new column
Set SaledateConverted = convert(Date, Saledate)

Select Saledateconverted, convert(Date, Saledate) --Showing new column
From PortfolioProject..nashvillehousing


-- Populate Propety address data
Select PropertyAddress					--Showing null values
From PortfolioProject..nashvillehousing
where PropertyAddress is null

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress, b.PropertyAddress)			--Populating null values
From PortfolioProject..nashvillehousing a
JOIN PortfolioProject..nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null


Update a
Set PropertyAddress = Isnull(a.PropertyAddress, b.PropertyAddress)		-- Updating table
From PortfolioProject..nashvillehousing a
JOIN PortfolioProject..nashvillehousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null


-- Breaking out address to individual column ( Address, city, State) with substring

Select PropertyAddress				--Showing property address	
From PortfolioProject..nashvillehousing
--where PropertyAddress is null

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) As Address,		-- Showing seperation of property address
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) As Address
From PortfolioProject..nashvillehousing

Alter Table NashvilleHousing
Add PropertySpiltAdress nvarchar(255);

Update Nashvillehousing				-- Filling up new column
Set PropertySpiltAdress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table Nashvillehousing		-- Adding new column
Add PropertySplitCity nvarchar(255);

Update Nashvillehousing				-- Filling up new column
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) 

Select *							-- Showing results with new columns
From PortfolioProject..nashvillehousing


--Breaking out address to individual column ( Address, city, State) with parsename

Select OwnerAddress				-- showing OwnerAddress						
From PortfolioProject..nashvillehousing

Select									-- Showing seperation of owner address
PARSENAME(Replace(OwnerAddress, ',','.'), 3),
PARSENAME(Replace(OwnerAddress, ',','.'), 2),
PARSENAME(Replace(OwnerAddress, ',','.'), 1)
From PortfolioProject..nashvillehousing


Alter Table Nashvillehousing		-- Adding new column
Add OwnerSplitAddress nvarchar(255);

Update Nashvillehousing				-- Filling up new column
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',','.'), 3)

Alter Table Nashvillehousing		-- Adding new column
Add OwnerSplitCity nvarchar(255);

Update Nashvillehousing				-- Filling up new column
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',','.'), 2)

Alter Table Nashvillehousing		-- Adding new column
Add OwnerSplitState nvarchar(255);

Update Nashvillehousing				-- Filling up new column
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',','.'), 1)


Select *							-- Showing results with new columns
From PortfolioProject..nashvillehousing


--Organizing SoldasvVcant column
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..nashvillehousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant,
Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 else SoldAsVacant
	 end 
From PortfolioProject..nashvillehousing

Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant = 'N' Then 'No'
	 else SoldAsVacant
	 end 


-- Removing Duplicates


With RowNumCTE AS(
Select *,
Row_Number() Over(
Partition by ParcelId,
			 PropertyAddress,
			 SalePrice,
			 Saledate,
			 LegalReference
			 Order by UniqueId
			 ) row_num
From PortfolioProject..nashvillehousing
)

Delete 
From RowNumCTE
Where row_num > 1


-- Delete Unused Columns

Select * 
From PortfolioProject..nashvillehousing

Alter Table NAshvilleHousing
Drop Column OwnerAddress, Taxdistrict, Propertyaddress

Alter Table NAshvilleHousing
Drop Column Saledate


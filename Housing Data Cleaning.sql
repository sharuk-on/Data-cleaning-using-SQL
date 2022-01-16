-- Data imported using excel.


-- Removing time from datetime
update housing
set SaleDate = CONVERT(SaleDate, DATE);


-- Filling in property address
with cte as     
	(select * from
		(select parcelid, propertyaddress,
		case 
			when parcelid = lead(parcelid) over (ORDER BY ParcelID) then lead(propertyaddress) over (order by parcelid)
			when parcelid = lag(parcelid) over (ORDER BY ParcelID) then lag(propertyaddress) over (order by parcelid) 
		end address 
		from housing) x
	where PropertyAddress is null
	order by parcelid)
update housing h, cte c
set h.propertyaddress = ifnull (h.propertyaddress, c.address)
where c.parcelid = h.parcelid;


-- Extracting address and city from property address
alter table housing
	add column address varchar(45),
	add column city varchar(25);

update housing
set address = substring_index(propertyaddress,',',1),
	city = substring_index(propertyaddress,',',-1);


-- Extracting address, city and state from owner address
alter table housing
	add column owneraddressin varchar(45),
	add column ownercity varchar(25),
	add column ownerstate varchar(10);

update housing
set owneraddressin = substring_index(owneraddress, ',',1),
	ownercity = substring_index(substring_index(owneraddress, ',', 2),',',-1),
    ownerstate = substring_index(owneraddress, ',',-1);


-- Standardising values in sold as vacant
update housing
set Soldasvacant = 
case Soldasvacant
	when 'Y' then 'Yes' 
	when 'N' then 'No'
end
WHERE soldasvacant = 'Y' or soldasvacant = 'N';


-- Removing duplicates
delete from housing
where UniqueID_ in
	(select UniqueID_ from
		(select UniqueID_, ROW_NUMBER() over (PARTITION BY parcelid,
															saleprice,
															saledate,
															legalreference 
															order by uniqueid_) i
		from housing) x
	WHERE i > 1);
    

-- Removing obsolete columns
ALTER TABLE housing
	DROP COLUMN OwnerAddress,
	DROP COLUMN PropertyAddress;


-- Reordering columns
ALTER TABLE housing 
	MODIFY COLUMN address varchar(255) AFTER LandUse,
	MODIFY COLUMN city varchar(255) AFTER address,
	MODIFY COLUMN owneraddressin varchar(255) AFTER OwnerName,
	MODIFY COLUMN ownercity varchar(25) AFTER owneraddressin,
	MODIFY COLUMN ownerstate varchar(10) AFTER ownercity;

-- Renaming columns
ALTER TABLE housing 
	CHANGE UniqueID_ Unique_ID int,
	CHANGE ParcelID	Parcel_ID varchar(25),
	CHANGE LandUse Land_Use varchar(45),
	CHANGE address Property_Address varchar(255),
	CHANGE city Property_City varchar(255),
	CHANGE saledate	Sale_Date date,
	CHANGE SalePrice Sale_Price int,
	CHANGE LegalReference Legal_Reference varchar(25),
	CHANGE SoldAsVacant Sold_As_Vacant varchar(5),
	CHANGE OwnerName Owner_Name varchar(255),
	CHANGE owneraddressin Owner_Address varchar(255),
	CHANGE ownercity Owner_City varchar(25),
	CHANGE ownerstate Owner_State varchar(10),
	CHANGE TaxDistrict Tax_District varchar(25),
	CHANGE LandValue Land_Value int,
	CHANGE BuildingValue Building_Value int,
	CHANGE TotalValue Total_Value int,
	CHANGE YearBuilt Year_Built int,
	CHANGE FullBath Full_Bath int,
	CHANGE HalfBath Half_Bath int;


SELECT*
FROM [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

--STANDARDIZE DATE FORMAT

SELECT SALESDATE2, CONVERT(DATE,SaleDate)
FROM [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

UPDATE [NASHVILLE HOUSING]
SET SaleDate = CONVERT(DATE, SALEDATE)

ALTER TABLE [NASHVILLE HOUSING]
ADD SALESDATE2 DATE;

UPDATE [NASHVILLE HOUSING]
SET SALESDATE2 = CONVERT(DATE, SALEDATE)




--POPULATE PROPERTADDDRESS DATE

SELECT*
FROM [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
--WHERE PropertyAddress IS NULL
ORDER BY ParcelID

SELECT a.parcelID, a.propertyAddress,b.parcelID, b.propertyAddress, isnull(a.propertyaddress,b.propertyAddress)
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING] a
join [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING] b
on a.ParcelID = b.ParcelID
and a.[uniqueID] <> b.[uniqueID]
WHERE a.propertyaddress is null

update a 
set propertyaddress = isnull(a.propertyaddress,b.propertyAddress)
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING] a
join [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING] b
on a.ParcelID = b.ParcelID
and a.[uniqueID] <> b.[uniqueID]
WHERE a.propertyaddress is null



--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)
select propertyaddress
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

SELECT
SUBSTRING(propertyaddress, 1, charindex(',', propertyaddress)-1) as Address 
, substring(propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress))as address 
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]


alter table  [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
add propertysplitadress nvarchar(255);

update  [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
set propertysplitadress = SUBSTRING(propertyaddress,1, charindex(',', propertyaddress)-1)

alter table  [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
add propertysplitcity nvarchar(255);

update [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
set propertysplitcity = substring(propertyaddress, charindex(',', propertyaddress) +1, len(propertyaddress))

select*
from  [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

select parsename (replace(owneraddress,',','.'),3)
,parsename(replace(owneraddress,',','.'),2)
,parsename(replace(owneraddress,',','.'),1)
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

alter table [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
add ownersplitaddress nvarchar(255);
update [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
set ownersplitaddress =parsename (replace(owneraddress,',','.'),3)

alter table [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
add ownersplitcity nvarchar(255);
update [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
set ownersplitcity = parsename(replace(owneraddress,',','.'),2)

alter table [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
add ownersplitstate nvarchar(255);
update [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
set ownersplitstate = parsename(replace(owneraddress,',','.'),1)




--CHANGE Y AND N TO YES AND NO IN 'SOLD AS VACANT' FIELD 

select distinct(soldasvacant), count(soldasvacant)
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
group by SoldAsVacant
order by 2

select soldasvacant
, case when soldasvacant = 'y' then 'yes'
    when soldasvacant = 'n' then 'no'
	else soldasvacant
	end 
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

update [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
set soldasvacant = case when soldasvacant = 'y' then 'yes'
  when soldasvacant = 'n' then 'no'
  else soldasvacant
  end 




  --REMOVE DUPLICATES

  with Rownumcte as (
  select*,
      ROW_NUMBER() OVER (
	  PARTITION BY ParcelID,
	               propertyaddress,
				   saleprice,
				   legalreference
				   ORDER BY 
				    uniqueid 
					 )row_num

from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

)
select*
from Rownumcte
where row_num > 1
--Order by PropertyAddress




--DELETE UNUSED COLUMNS 
select *
from [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]

ALTER TABLE [POTFOLIO PROJECT COVID].DBO.[NASHVILLE HOUSING]
DROP COLUMN owneraddress,taxdistrict, propertyaddress, saledate 












|

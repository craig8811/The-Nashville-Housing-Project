/*

Cleaning Nashville housing data for a SQL project

*/

SELECT *
FROM nashville_housing
LIMIT 1000


-- Standardizing the saledate format
-- Tried casting and updating, didn't work 
-- So, I altered my table and this wasy did the trick.
SELECT saledate, CAST(saledate AS DATE)
FROM nashville_housing

UPDATE nashville_housing
SET saledate = CAST(saledate AS DATE)

ALTER TABLE nashville_housing
ADD saledateconverted DATE;

UPDATE nashville_housing
SET saledateconverted = CAST(saledate AS DATE)

SELECT saledateconverted
FROM nashville_housing


-- Populating property address data


SELECT *
FROM nashville_housing
--WHERE propertyaddress IS NULL
ORDER BY parcelid


SELECT nha.parcelid,
	   nha.propertyaddress,
	   nhb.parcelid,
	   nhb.propertyaddress
FROM nashville_housing nha
JOIN nashville_housing nhb ON (nha.parcelid=nhb.parcelid) AND nha.uniqueid <> nhb.uniqueid
WHERE nha.propertyaddress IS NULL


UPDATE nashville_housing nha
SET propertyaddress = nhb.propertyaddress
FROM nashville_housing nhb
WHERE nha.parcelid = nhb.parcelid
AND nha.uniqueid <> nhb.uniqueid
AND nha.propertyaddress IS NULL



-- Breaking out address into individual columns (address, city, state)


SELECT propertyaddress
FROM nashville_housing
--WHERE propertyaddress IS NULL
--ORDER BY parcelid

SELECT propertyaddress,
	   SUBSTRING(propertyaddress,1,STRPOS(propertyaddress,',')-1) AS address,
	   SUBSTRING(propertyaddress, STRPOS(propertyaddress,',')+1 , LENGTH(propertyaddress)) AS city
FROM nashville_housing


ALTER TABLE nashville_housing
ADD propertysplitaddress text;

UPDATE nashville_housing
SET propertysplitaddress = SUBSTRING(propertyaddress,1,STRPOS(propertyaddress,',')-1)


ALTER TABLE nashville_housing
ADD propertysplitcity text;

UPDATE nashville_housing
SET propertysplitcity = SUBSTRING(propertyaddress, STRPOS(propertyaddress,',')+1 , LENGTH(propertyaddress))


SELECT owneraddress
FROM nashville_housing



SELECT SPLIT_PART(owneraddress,',',1),
	   SPLIT_PART(owneraddress,',',2),
	   SPLIT_PART(owneraddress,',',3)
FROM nashville_housing



ALTER TABLE nashville_housing
ADD ownersplitaddress text;

UPDATE nashville_housing
SET ownersplitaddress = SPLIT_PART(owneraddress,',',1)



ALTER TABLE nashville_housing
ADD ownersplitcity text;

UPDATE nashville_housing
SET ownersplitcity = SPLIT_PART(owneraddress,',',2)



ALTER TABLE nashville_housing
ADD ownersplitstate text;

UPDATE nashville_housing
SET ownersplitstate = SPLIT_PART(owneraddress,',',3)



-- Changing Y and N to Yes and No in 'Sold as Vacant' field


SELECT DISTINCT(soldasvacant),
	   COUNT(*)
FROM nashville_housing
GROUP BY 1
ORDER BY 2 DESC


SELECT soldasvacant,
	   CASE WHEN soldasvacant = 'Y' THEN 'Yes'
	   WHEN soldasvacant = 'N' THEN 'No'
	   ELSE soldasvacant
	   END

FROM nashville_housing



UPDATE nashville_housing
SET soldasvacant =  CASE WHEN soldasvacant = 'Y' THEN 'Yes'
	   WHEN soldasvacant = 'N' THEN 'No'
	   ELSE soldasvacant
	   END
	   
	   

-- Remove Duplicates


WITH row_num_cte AS (
					SELECT *,
						   ROW_NUMBER() OVER (PARTITION BY parcelid,
											  propertyaddress,
											  saleprice,
											  saledate,
											  legalreference
											 ORDER BY uniqueid) AS row_num
					FROM nashville_housing
					--ORDER BY parcelid
				  ),
		dups AS	(			    -- capturing only the duplicates
					SELECT *
					FROM row_num_cte
					WHERE row_num > 1
				)

DELETE FROM nashville_housing -- Using uniqueid instead of parcelid
WHERE uniqueid IN (SELECT uniqueid FROM dups) 



-- Delete unused columns (Only doing this for demonstration purposes)



SELECT *
FROM nashville_housing


ALTER TABLE nashville_housing
DROP COLUMN owneraddress, 
DROP COLUMN taxdistrict, 
DROP COLUMN propertyaddress, 
DROP COLUMN saledate
;



-- Saving cleaned data to a new file



SELECT *
FROM nashville_housing



COPY (SELECT * FROM nashville_housing) TO '/Users/craigschlachter/Desktop/nashville_housing_eda.csv' WITH CSV HEADER;
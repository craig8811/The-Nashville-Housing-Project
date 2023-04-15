/*

Exploring the Nashville Housing Data

*/



-- Reviewing the data columns, structure, and data types



SELECT *
FROM nash_housing_eda
ORDER BY saledateconverted ASC



-- Selecting data we are going to be using
-- Seeing null in bedroom, fullbath, halfbath is common 


SELECT propertysplitcity,
	   saledateconverted,
	   saleprice,
	   landuse,
	   bedroom,
	   fullbath,
	   halfbath
FROM nash_housing_eda
WHERE LOWER(propertysplitcity) LIKE '%nash%'
ORDER BY 1,2



-- Looking at the distribution of sale prices(#1)
-- Shows the full distribution and the sale price you're likely to pay in Nashville


SELECT saleprice,
	   COUNT(*) AS sale_count
FROM nash_housing_eda
GROUP BY 1
ORDER BY 2 DESC



-- Looking at sale prices over time(#2)
-- Shows daily average sales prices


SELECT saledateconverted,
	   ROUND(AVG(saleprice)) AS avg_sale_price
FROM nash_housing_eda
GROUP BY 1
ORDER BY 1 



-- Looking at sales over time grouped by city and date(derivative of #2)


WITH city_sales AS (
					SELECT propertysplitcity,
						   saledateconverted,
						   SUM(saleprice) AS total_sales
					FROM nash_housing_eda
					--WHERE propertysplitcity LIKE '%NASHVILLE%'
					GROUP BY 1,2
					ORDER BY 1,2
				   )
				   
SELECT *,
	   SUM(total_sales) OVER (PARTITION BY propertysplitcity 
							  ORDER BY propertysplitcity, saledateconverted) AS running_total_sales
FROM city_sales
ORDER BY propertysplitcity, saledateconverted




-- Looking at sale price by different land use(#9)
-- Cleaning landuse categories into a uniform structure


SELECT landuse, 
	   COUNT(*)
FROM nash_housing_eda
GROUP BY 1
ORDER BY 2 DESC


UPDATE nash_housing_eda
SET landuse = REPLACE(landuse,'VACANT RES LAND','VACANT RESIDENTIAL LAND')


UPDATE nash_housing_eda
SET landuse = REPLACE(landuse,'VACANT RESIENTIAL LAND','VACANT RESIDENTIAL LAND')

			   
UPDATE nash_housing_eda
SET landuse = REPLACE(landuse,'RESIDENTIAL RESIDENTIAL CONDO','RESIDENTIAL CONDO')


UPDATE nash_housing_eda
SET landuse = REPLACE(landuse,'RESIDENTIAL CONDOMINIUM OFC  OR OTHER COM','RESIDENTIAL CONDO')
WHERE landuse LIKE '%RESIDENTIAL CONDOMINIUM OFC  OR OTHER COM%'



SELECT landuse,
	   ROUND(AVG(saleprice)) AS avg_sale_price
FROM nash_housing_eda
GROUP BY 1
ORDER BY 2 DESC



-- Looking at sale prices by bedroom and bathroom counts(#10) 



SELECT bedroom,
	   fullbath,
	   halfbath,
	   COUNT(*) AS num_of_units,
	   ROUND(AVG(saleprice)) AS avg_sale_price
FROM nash_housing_eda
WHERE bedroom IS NOT NULL 
AND fullbath IS NOT NULL
AND halfbath IS NOT NULL
GROUP BY 1,2,3
ORDER BY 4 DESC



-- Looking at the distribution of properties accross different neighborhoods(#11)



SELECT propertysplitcity,
	   COUNT(*) AS num_of_properties
FROM nash_housing_eda
GROUP BY 1
ORDER BY 1,2 DESC



-- Looking at the distribution of sale dates(#14)
-- Find MAX and MIN num_of_sales for each year month(derivative of #14)


SELECT saledateconverted,
	   COUNT(*) AS num_of_sales
FROM nash_housing_eda
GROUP BY 1
ORDER BY 1,2 DESC


-- Looking at Max and Min months of 2013

SELECT CAST(DATE_PART('year',saledateconverted) as text) || '-' || CAST(DATE_PART('month',saledateconverted) as text) AS date,
	   COUNT(*) AS num_of_sales
FROM nash_housing_eda
WHERE saledateconverted BETWEEN '2013-01-01' AND '2013-12-31'
GROUP BY 1
ORDER BY 2 DESC


-- Looking at Max and Min months of 2014

SELECT CAST(DATE_PART('year',saledateconverted) as text) || '-' || CAST(DATE_PART('month',saledateconverted) as text) AS date,
	   COUNT(*) AS num_of_sales
FROM nash_housing_eda
WHERE saledateconverted BETWEEN '2014-01-01' AND '2014-12-31'
GROUP BY 1
ORDER BY 2 DESC


-- Looking at Max and Min months of 2015

SELECT CAST(DATE_PART('year',saledateconverted) as text) || '-' || CAST(DATE_PART('month',saledateconverted) as text) AS date,
	   COUNT(*) AS num_of_sales
FROM nash_housing_eda
WHERE saledateconverted BETWEEN '2015-01-01' AND '2015-12-31'
GROUP BY 1
ORDER BY 2 DESC


-- Looking at Max and Min months of 2016
-- Not a full year of results for 2016 and only 2 records thereafter in 2019

SELECT CAST(DATE_PART('year',saledateconverted) as text) || '-' || CAST(DATE_PART('month',saledateconverted) as text) AS date,
	   COUNT(*) AS num_of_sales
FROM nash_housing_eda
WHERE saledateconverted BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY 1
ORDER BY 2 DESC



-- Looking at the distribution of property types(#15)(Think about using with #9 in tableau)
-- Finding the distribution of property types segmented by city(derivative of #15)


SELECT landuse,
	   COUNT(*) AS num_of_units
FROM nash_housing_eda
GROUP BY 1
ORDER BY 2 DESC


SELECT propertysplitcity,
	   landuse,
	   COUNT(*) AS num_of_units
FROM nash_housing_eda
GROUP BY 1,2
ORDER BY 3 DESC




-- Creating views to store data for later visualization

CREATE VIEW bed_bath_price AS 
SELECT bedroom,
	   fullbath,
	   halfbath,
	   COUNT(*) AS num_of_units,
	   ROUND(AVG(saleprice)) AS avg_sale_price
FROM nash_housing_eda
WHERE bedroom IS NOT NULL 
AND fullbath IS NOT NULL
AND halfbath IS NOT NULL
GROUP BY 1,2,3
ORDER BY 4 DESC




CREATE VIEW city_sales_over_time AS
WITH city_sales AS (
					SELECT propertysplitcity,
						   saledateconverted,
						   SUM(saleprice) AS total_sales
					FROM nash_housing_eda
					--WHERE propertysplitcity LIKE '%NASHVILLE%'
					GROUP BY 1,2
					ORDER BY 1,2
				   )
				   
SELECT *,
	   SUM(total_sales) OVER (PARTITION BY propertysplitcity ORDER BY propertysplitcity, saledateconverted) AS running_total_sales
FROM city_sales
ORDER BY propertysplitcity, saledateconverted













						
					 
					 

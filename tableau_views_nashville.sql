/*

Tableau views for Nashville housing data

*/

-- 1.

SELECT saledateconverted,
	   landuse,
	   saleprice
FROM nash_housing_eda
ORDER BY 1 ASC


-- 2.

SELECT saledateconverted,
	   ROUND(AVG(saleprice)) AS avg_sale_price
FROM nash_housing_eda
GROUP BY 1
ORDER BY 1 



-- 3.

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



-- 4.

SELECT landuse,
	   ROUND(AVG(saleprice)) AS avg_sale_price
FROM nash_housing_eda
GROUP BY 1
ORDER BY 2 DESC


SELECT landuse,
	   COUNT(*)
FROM nash_housing_eda
GROUP BY 1
ORDER BY 2 DESC


-- 5.

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



-- 6.

SELECT propertysplitcity,
	   COUNT(*) AS num_of_properties
FROM nash_housing_eda
GROUP BY 1
ORDER BY 1,2 DESC



-- 7.

SELECT saledateconverted,
	   COUNT(*) AS num_of_sales
FROM nash_housing_eda
GROUP BY 1
ORDER BY 1,2 DESC



-- 8.

SELECT landuse,
	   COUNT(*) AS num_of_units
FROM nash_housing_eda
GROUP BY 1
ORDER BY 2 DESC



-- 9.

SELECT propertysplitcity,
	   TRIM(COALESCE(ownersplitstate,'TN')) AS state,
	   landuse,
	   COUNT(*) AS num_of_units
FROM nash_housing_eda
GROUP BY 1,2,3
ORDER BY 4 DESC

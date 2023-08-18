-- to get the total number of seniors grouping by Quadrants
-- first to transform data to ensure all details in quadrant column have same agreement. 
SELECT CASE 
         WHEN "Quadrant" LIKE 'SOUTH%' THEN 'SOUTH'
         WHEN "Quadrant" LIKE 'NORTH%' THEN 'NORTH'
         ELSE "Quadrant"
       END AS quadrant,
       SUM("Total_count") AS seniors
FROM seniors_in_calgary
GROUP BY quadrant
ORDER BY seniors DESC;
	


-- to get a total number of seniors in nursing homes by gender
SELECT "Gender" AS gender,
       SUM(
         "age_65_74" + "age_75_84"  + "age_85_94"+ "age_95"
       ) AS total 
from "Senior_homes_calgary"
GROUP BY gender
ORDER BY total DESC;


-- to get a total number of seniors in nursing homes by total number of homes 
SELECT "home" AS home,
       SUM(
         "age_65_74" + "age_75_84"  + "age_85_94"+ "age_95"
       ) AS total 
from "Senior_homes_calgary"
GROUP BY home
ORDER BY total DESC;


-- to get a total number of seniors in nursing homes by quadrant 
SELECT "city_quadrant" AS city_quadrant,
       SUM(
         "age_65_74" + "age_75_84"  + "age_85_94"+ "age_95"
       ) AS total 
from "Senior_homes_calgary"
GROUP BY city_quadrant
ORDER BY total DESC;


-- to get a total number of seniors by age group in nursing homes 
SELECT SUM(
         "age_65_74" 
       ) AS age_65_74_total,
	   SUM(
         "age_75_84" 
       ) AS age_75_84_total,
	    SUM(
         "age_85_94" 
       ) AS age_85_94_total,
	    SUM(
         "age_95" 
       ) AS age_95_total 
from "Senior_homes_calgary"



-- to get the average age for total number of seniors in nursing homes 
WITH age_range AS (
  SELECT SUM(
    "age_65_74" 
  ) AS age_65_74_total,
  SUM(
    "age_75_84" 
  ) AS age_75_84_total,
  SUM(
    "age_85_94" 
  ) AS age_85_94_total,
  SUM(
    "age_95" 
  ) AS age_95_total 
  from "Senior_homes_calgary"
),

weighted_age AS (
  SELECT (69.5 * t1.age_65_74_total) as weighted_65_74,
       (79.5 * t1.age_75_84_total) as weighted_75_84,
       (89.5 * t1.age_85_94_total) as weighted_85_94,
       (95 * t1.age_95_total) as weighted_95
  FROM age_range as t1
),

weighted_age_sum AS (
  SELECT SUM(
		weighted_65_74 
  		+ weighted_75_84 
  		+ weighted_85_94 
  		+ weighted_95
  ) as age_sum
  FROM weighted_age
),

everyone AS (
  SELECT SUM (
    age_65_74_total
    + age_75_84_total
    + age_85_94_total
    + age_95_total
  ) as total
  FROM age_range
) 

SELECT round(
  age_sum / (
    SELECT total FROM everyone
  ),
  0
) AS agv_age
FROM weighted_age_sum;
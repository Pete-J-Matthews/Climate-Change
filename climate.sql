-- Assessing what the table contains:
SELECT *
FROM state_climate
LIMIT 5;



-- Average temperature changes over time in each state:

SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(AVG(tempc) OVER (
    PARTITION BY state
    ORDER BY year
  ),2) AS 'running_avg_temp'
FROM state_climate
WHERE state = 'Alabama'
LIMIT 5;



-- Lowest temperature in each state:

SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(FIRST_VALUE(tempc) OVER(
    PARTITION BY state
    ORDER BY tempc
  ),2) AS lowest_temp
FROM state_climate;



-- Highest temperature in each state:

SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(LAST_VALUE(tempc) OVER(
    PARTITION BY state
    ORDER BY tempc
    RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
  ),2) AS highest_temp
FROM state_climate;



-- Temperature change each year in each state, and the largest change:

SELECT
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1,
  ROUND(LAG(tempc,1,0) OVER (
    PARTITION BY state
    ORDER BY year
  ),2) AS change_in_temp
FROM state_climate
ORDER BY change_in_temp DESC;



-- Rank of the coldest temperatures:

SELECT
  RANK() OVER (
    ORDER BY tempc
  ) AS rank,
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;



-- Rank of the warmest temperatures by state:

SELECT
  RANK() OVER (
    PARTITION BY state
    ORDER BY tempc DESC
  ) AS rank,
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;



-- Average yearly temperatures by quartile and ordered by coldest quartile:

SELECT
  NTILE(4) OVER (
    PARTITION BY state
    ORDER BY tempc
  ) AS quartile,
  state,
  year,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;



-- Average yearly temperatures by quintile and ordered by coldest quintile:

SELECT
  NTILE(5) OVER (
    ORDER BY tempc
  ) AS quintile,
  year,
  state,
  ROUND(tempf,2) AS tempf1,
  ROUND(tempc,2) AS tempc1
FROM state_climate;
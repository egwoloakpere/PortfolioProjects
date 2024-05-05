----------------------------------------------------------------------
-- Explore data in all 4 tables
----------------------------------------------------------------------
SELECT *
FROM 
	"Hospital_Data".conditions;

SELECT *
FROM 
	"Hospital_Data".encounters;

SELECT *
FROM 
	"Hospital_Data".immunizations;

SELECT *
FROM
	"Hospital_Data".patients;

----------------------------------------------------------------------
/* 
Write a query that displays the description of patients having
number greaster than 5000. Exclude Body Mass Index
*/
----------------------------------------------------------------------

SELECT 
	description,
	count(*) AS number_affected
FROM 
	"Hospital_Data".conditions
WHERE description != 'Body Mass Index 30.0-30.9, adult'
GROUP BY
	description
HAVING count(*) > 5000
ORDER BY
	number_affected DESC;

----------------------------------------------------------------------
-- write a query that displays all patients from Boston 
----------------------------------------------------------------------

SELECT *
FROM 
	"Hospital_Data".patients
WHERE
	city = 'Boston';
	
----------------------------------------------------------------------
/* write a query that displays all patients from the conditions table,
who have been dignosed with Chronic kidney disease. Use the following 
codes for disease description; 585.1, 585.2, 585.3, 585.4. */
----------------------------------------------------------------------

SELECT * 
FROM
	"Hospital_Data".conditions
WHERE code IN ('585.1', '585.2', '585.3', '585.4');

----------------------------------------------------------------------
/*
write a query that list out number of patients per city in descending
order. City must not include Boston and must have at least 100 patients
from that city. 
*/
----------------------------------------------------------------------

SELECT 
	city,
	count(*) AS number_count
FROM 
	"Hospital_Data".patients
WHERE 
	city != 'Boston'
GROUP BY
	city
HAVING count(*) >= 100
ORDER BY
	number_count DESC;

---------------------------------------------------------------------------------
/* 
Phiyo Hospital Objectives for Nova Academy.
Come up with a flu shot dashboard for 2022 that does the following
1. Total % of patients that got flu shot stratefied by;
a. Age.
b. Race.
c. County (on the Map).
d. Overall.
2. Running total of flu shot over the course of 2022.
3. Total number of flu shot given in 2022.
4. A list of patients that show whether or not they recieved the flu shots.
Requirements:
Patients must have been "Active at our hospital" and must be above 6 months old.
*/
---------------------------------------------------------------------------------
WITH active_patients AS
(
	SELECT DISTINCT
		patient
	FROM 
		"Hospital_Data".encounters AS e
	JOIN 
		"Hospital_Data".patients AS pat
	ON e.patient = pat.id
	WHERE 
		start BETWEEN '2020-01-01 00:00' AND '2022-12-31 23:59'
	AND
		pat.deathdate IS NULL
	AND 
		EXTRACT(MONTH FROM age('2022-12-31',pat.birthdate)) >= 6
),
flu_shot_2022 AS
(
	SELECT 
		patient,
		MIN(date) AS earliest_flue_shot_2022
	FROM 
		"Hospital_Data".immunizations
	WHERE
		code = '5302'
		AND
		date BETWEEN '2022-01-01 00:00' AND '2022-12-31 23:59'
	GROUP BY
		patient
)

SELECT 
	pat.id,
	pat.first,
	pat.last,
	pat.birthdate,
	EXTRACT(YEAR FROM age('2022-12-31 23:59', pat.birthdate)) AS age,
	pat.race,
	pat.county,
	flu.earliest_flue_shot_2022,
	flu.patient,
	CASE WHEN flu.patient IS NOT NULL THEN 1
	ELSE 0
	END AS flu_shot_2022_stat
FROM
	"Hospital_Data".patients AS pat
LEFT JOIN 
	flu_shot_2022 AS flu
ON pat.id = flu.patient
WHERE 
	1=1
	AND
	pat.id IN (SELECT 
			   		patient
			  FROM 
			   		active_patients);




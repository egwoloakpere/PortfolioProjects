/* In this study, we will Analyze the "Aliens in America" Dataset.*/
--This dataset contains 3 different Datasets, so we first do a detailed exploration of these data;

SELECT *
FROM Aliens

SELECT *
FROM Details

SELECT *
FROM Location


-- Next, we merge the first name and last name in the Alien Table into a single column and call it full name.

ALTER TABLE Aliens
ADD full_name Nvarchar(255);

UPDATE Aliens
SET full_name = first_name +' '+last_name


-- Next we add a new column and calculate Age of all Aliens

ALTER TABLE Aliens
ADD Age INT; 

UPDATE Aliens
SET Age = 2022  - birth_year


-- Next we Join all 3 tables to enable us access every detail in a single table

SELECT A.*, D.*, L.*
FROM Aliens AS A
FULL OUTER JOIN Details AS D
ON A.id = D.detail_id
FULL OUTER JOIN Location AS L
ON L.loc_id = D.detail_id


--Next we select data for all aggressive Aliens (We will focus on only Aggressive Aliens)
SELECT A.full_name, A.Age, A.type, A.gender, D.favorite_food, D.feeding_frequency, L.state, L.occupation
FROM Aliens AS A
FULL OUTER JOIN Details AS D
ON A.id = D.detail_id
FULL OUTER JOIN Location AS L
ON L.loc_id = D.detail_id
WHERE aggressive = 1

--Next we create view for further analysis 

CREATE VIEW AliensInAmerica AS
SELECT A.full_name, A.Age, A.type, A.gender, D.favorite_food, D.feeding_frequency, L.state, L.occupation
FROM Aliens AS A
FULL OUTER JOIN Details AS D
ON A.id = D.detail_id
FULL OUTER JOIN Location AS L
ON L.loc_id = D.detail_id
WHERE aggressive = 1

-- Check for the types of Aggressive aliens and their count

SELECT DISTINCT type, COUNT(type) AS type_count
FROM AliensInAmerica
GROUP BY type 
ORDER BY COUNT(type) DESC


-- Check for the gender of Aggressive aliens and their count

SELECT DISTINCT gender, COUNT(gender) AS gender_count
FROM AliensInAmerica
GROUP BY gender 
ORDER BY COUNT(gender) DESC


-- Check for the Feeding Frequency of Aggressive aliens and their count

SELECT DISTINCT feeding_frequency, COUNT(feeding_frequency) AS feeding_count
FROM AliensInAmerica
GROUP BY feeding_frequency 
ORDER BY COUNT(feeding_frequency) DESC


-- Check for the Occupation of Aggressive aliens and their count

SELECT TOP 7 occupation, COUNT(occupation) AS occupation_count
FROM AliensInAmerica
GROUP BY occupation 
ORDER BY COUNT(occupation) DESC


-- Check for the Age of Aggressive aliens and their count

SELECT
	CASE
	WHEN age BETWEEN 50 and 99 THEN '50-99'
	WHEN age BETWEEN 100 and 149 THEN '100-149'
	WHEN age BETWEEN 150 and 199 THEN '150-199'
	WHEN age BETWEEN 200 and 249 THEN '200-249'
	WHEN age BETWEEN 250 and 299 THEN '250-299'
	WHEN age BETWEEN 300 and 350 THEN '300-350'
	END AS age_group, COUNT(age) AS age_count
FROM AliensInAmerica
GROUP BY CASE
	WHEN age BETWEEN 50 and 99 THEN '50-99'
	WHEN age BETWEEN 100 and 149 THEN '100-149'
	WHEN age BETWEEN 150 and 199 THEN '150-199'
	WHEN age BETWEEN 200 and 249 THEN '200-249'
	WHEN age BETWEEN 250 and 299 THEN '250-299'
	WHEN age BETWEEN 300 and 350 THEN '300-350'
	END
ORDER BY CASE
	WHEN age BETWEEN 50 and 99 THEN '50-99'
	WHEN age BETWEEN 100 and 149 THEN '100-149'
	WHEN age BETWEEN 150 and 199 THEN '150-199'
	WHEN age BETWEEN 200 and 249 THEN '200-249'
	WHEN age BETWEEN 250 and 299 THEN '250-299'
	WHEN age BETWEEN 300 and 350 THEN '300-350'
	END


-- Check for the Top 5 Favorite Food of Aggressive aliens and their count

SELECT TOP 6 favorite_food, COUNT(favorite_food) AS favorite_food_count
FROM AliensInAmerica
GROUP BY favorite_food 
ORDER BY COUNT(favorite_food) DESC


-- Check for the Top 5 state of Aggressive aliens and their count

SELECT TOP 5 state, COUNT(state) AS state_count
FROM AliensInAmerica
GROUP BY state 
ORDER BY COUNT(state) DESC


-- Check for the Type of Aggressive aliens per State  and their count

SELECT state, type, COUNT(type) AS type_count
FROM AliensInAmerica
WHERE state IN ('Texas', 'California', 'Florida', 'New York', 'Ohio')
GROUP BY state, type 
ORDER BY (CASE state 
		  WHEN 'Texas' THEN 1
		  WHEN 'California' THEN 2
		  WHEN 'Florida' THEN 3
		  WHEN 'New York' THEN 4
		  WHEN 'Ohio' THEN 5
		  END)


-- Check for the Top 3 Gender of Aggressive aliens per State 

SELECT state, gender, COUNT(gender) AS gender_count
FROM AliensInAmerica
WHERE gender IN ('female', 'male', 'Non-binary')
AND state IN ('Texas', 'California', 'Florida', 'New York', 'Ohio')
GROUP BY state, gender 
ORDER BY (CASE state 
		  WHEN 'Texas' THEN 1
		  WHEN 'California' THEN 2
		  WHEN 'Florida' THEN 3
		  WHEN 'New York' THEN 4
		  WHEN 'Ohio' THEN 5
		  END), gender 


-- Check for the Feeding Frequency of Aggressive aliens per State 

SELECT state, feeding_frequency, COUNT(feeding_frequency) AS feeding_frequency_count
FROM AliensInAmerica
WHERE state IN ('Texas', 'California', 'Florida', 'New York', 'Ohio')
GROUP BY state, feeding_frequency
ORDER BY (CASE state 
		  WHEN 'Texas' THEN 1
		  WHEN 'California' THEN 2
		  WHEN 'Florida' THEN 3
		  WHEN 'New York' THEN 4
		  WHEN 'Ohio' THEN 5
		  END), 
		  (CASE feeding_frequency
		  WHEN 'Never' THEN 1
		  WHEN 'Once' THEN 2
		  WHEN 'Yearly' THEN 3
		  WHEN 'Seldom' THEN 4
		  WHEN 'Monthly' THEN 5
		  WHEN 'Often' THEN 6
		  WHEN 'Weekly' THEN 7
		  WHEN 'Daily' THEN 8
		  END)


-- Check for the Age Group of Aggressive aliens per State 

SELECT state,
	CASE
	WHEN age BETWEEN 50 and 99 THEN '50-99'
	WHEN age BETWEEN 100 and 149 THEN '100-149'
	WHEN age BETWEEN 150 and 199 THEN '150-199'
	WHEN age BETWEEN 200 and 249 THEN '200-249'
	WHEN age BETWEEN 250 and 299 THEN '250-299'
	WHEN age BETWEEN 300 and 350 THEN '300-350'
	END AS age_group, COUNT(age) AS age_count
FROM AliensInAmerica
WHERE state IN ('Texas', 'California', 'Florida', 'New York', 'Ohio')
GROUP BY state, CASE
	WHEN age BETWEEN 50 and 99 THEN '50-99'
	WHEN age BETWEEN 100 and 149 THEN '100-149'
	WHEN age BETWEEN 150 and 199 THEN '150-199'
	WHEN age BETWEEN 200 and 249 THEN '200-249'
	WHEN age BETWEEN 250 and 299 THEN '250-299'
	WHEN age BETWEEN 300 and 350 THEN '300-350'
	END
ORDER BY (CASE state 
		  WHEN 'Texas' THEN 1
		  WHEN 'California' THEN 2
		  WHEN 'Florida' THEN 3
		  WHEN 'New York' THEN 4
		  WHEN 'Ohio' THEN 5
		  END),
		  (CASE
		   WHEN age BETWEEN 50 and 99 THEN '50-99'
	       WHEN age BETWEEN 100 and 149 THEN '100-149'
	       WHEN age BETWEEN 150 and 199 THEN '150-199'
	       WHEN age BETWEEN 200 and 249 THEN '200-249'
	       WHEN age BETWEEN 250 and 299 THEN '250-299'
	       WHEN age BETWEEN 300 and 350 THEN '300-350'
	       END)

-- Check for the Top Favorite Food of Aggressive aliens per State 

SELECT state, favorite_food, COUNT(favorite_food) AS favorite_food_count
FROM AliensInAmerica
WHERE state IN ('Texas', 'California', 'Florida', 'New York', 'Ohio')
GROUP BY state, favorite_food
ORDER BY (CASE state 
		  WHEN 'Texas' THEN 1
		  WHEN 'California' THEN 2
		  WHEN 'Florida' THEN 3
		  WHEN 'New York' THEN 4
		  WHEN 'Ohio' THEN 5
		  END), COUNT(favorite_food) DESC

		  











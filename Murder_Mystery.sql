# PART ONE
# Let us start by retrieving the corresponding crime scene report from the police department’s database.
# Query1 (Generate crime report)
SELECT 
	Date,
	Type,
	Description,
	city
FROM
	crime_scene_report
WHERE
	type = 'murder'
	AND
	date = 20180115
   	 AND
	city = 'SQL City';

# Query 2 (First Witness Details)
SELECT 
	Id,	
	Name,
	license_id,
	address_number,
	address_street_name,
	ssn
FROM
	person
WHERE
	address_street_name = 'Northwestern Dr'
 ORDER BY
 	address_number DESC
LIMIT 1;

# Query 3 (Second Witness Details)
SELECT 
	Id,	
	Name,
	license_id,
	address_number,
	address_street_name,
	ssn
FROM
	person
WHERE
	name LIKE 'Annabel%'
	AND
	address_street_name = 'Franklin Ave';

# Query 4 (Witnesses Interview)
SELECT
	person_id,
	transcript
FROM
	interview
WHERE
	person_id IN (14887,16371);

# Query 5 (Revealing the Murderer)
SELECT
	p.id, 
	gfm.name, 
	gfm.id,
	gfm.membership_status, 
	dl.plate_number
FROM
	person AS p
JOIN
	get_fit_now_member AS gfm
	ON
	p.id = gfm.person_id
JOIN
	drivers_license AS dl
	ON
	p.license_id = dl.id
WHERE
	gfm.membership_status = 'gold'
	AND 
	gfm.id LIKE '48Z%'
	AND 
	dl.plate_number LIKE '%H42W%';

# Query 6 (Confirming Murderer)
SELECT 
	membership_id,
	check_in_date,
	check_in_time,
	check_out_time
FROM
	get_fit_now_check_in
WHERE
	membership_id = '48Z55';

# Query 7 (Check Solution)
INSERT INTO 
	solution 
VALUES 
	(1, 'Jeremy Bowers');
SELECT 
	value 
FROM 
	solution;
    

# PART TWO
# Query 1 (Murderer Interview)
SELECT
	person_id,
	transcript
FROM
	interview
WHERE
	person_id = 67318;
    
/*For this part, we will be exploring two different approaches. JOINS and CTEs*/

# Query 2 (Finding the real villain) Using JOINS
SELECT 
	p.id,
	p.name,
	p.address_number,
	p.address_street_name,
	p.ssn,
	dl.age,
	dl.height,
	dl.gender,
	dl.plate_number,
	dl.car_make,
	dl.car_model
FROM 
	person AS p
JOIN
	drivers_license AS dl
	ON
	p.license_id = dl.id
JOIN 
	facebook_event_checkin AS fbe
	ON 
	p.id = fbe.person_id
WHERE
	dl.gender = 'female'
	AND
	dl.height BETWEEN 65 AND 67
	AND
	dl.hair_color = 'red'
	AND
	dl.car_make = 'Tesla'
	AND
	dl.car_model = 'Model S'
GROUP BY
	fbe.person_id
HAVING
	COUNT(fbe.person_id) = 3;

#Query 3 (Finding the real villain) Using CTEs
WITH info1 AS
(
  SELECT 
	  p.id,
	  p.name,
	  p.address_number,
	  p.address_street_name,
	  p.ssn,
	  dl.age,
	  dl.height,
	  dl.gender,
	  dl.plate_number,
	  dl.car_make,
	  dl.car_model
  FROM 
	  person AS p
  JOIN
	  drivers_license AS dl
	  ON
	  p.license_id = dl.id
  WHERE
	  dl.gender = 'female'
	  AND
	  dl.height BETWEEN 65 AND 67
	  AND
	  dl.hair_color = 'red'
	  AND
	  dl.car_make = 'Tesla'
	  AND
	  dl.car_model = 'Model S'
),

info2 AS
(
  SELECT
	  p.id,
	  p.name
  FROM 
	  person AS p
  JOIN 
	  facebook_event_checkin AS fbe
	  ON 
	  p.id = fbe.person_id

  GROUP BY
	  fbe.person_id
  HAVING
	  COUNT(fbe.person_id) = 3
)

SELECT 
	i1.id,
	i1.name,
	i1.address_number,
	i1.address_street_name,
	i1.ssn,
	i1.age,
	i1.height,
	i1.gender,
	i1.plate_number,
	i1.car_make,
	i1.car_model
FROM
	info1 AS i1
JOIN
	info2 AS i2
	ON
	i1.id = i2.id
WHERE
	i1.id = i2.id;

# Query 4 (Check Solution)
INSERT INTO 
	solution 
VALUES
	(1, 'Miranda Priestly');
SELECT 
	value 
FROM
	solution;




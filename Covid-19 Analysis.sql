/* COVID-19 ANALYSIS FROM FEB 2020 - AUGUST 2022*/
-- Lets check the contents of our DB Tables
--SELECT *
--FROM covid_deaths
--WHERE continent IS NOT NULL
--ORDER BY location, date;

--SELECT *
--FROM covid_vacinnations
--WHERE continent IS NOT NULL
--ORDER BY location, date;



--Lets do some basic queries
SELECT location,
	   date, 
	   new_cases, 
	   total_cases,
	   total_deaths,
	   population
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY location, 
	     date;



-- Lets analyze Total Deaths Vs Total Cases
-- This analysis shows likelihood of dying if you contract Covid-19 in your country

SELECT location,
	   date, 
	   total_cases,
	   total_deaths,
	   (total_deaths/total_cases)*100 AS death_percentage
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
ORDER BY location,
		 date;



-- Lets analyze Total Cases Vs Population
-- This analysis shows the percentage of population who have contracted covid in your country

SELECT location, 
	   date, 
	   population,
	   total_cases, 
	   (total_cases/population)*100 AS population_percentage
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
ORDER BY location,
		 date;



--Lets analyze continents with highest infection rate

SELECT continent,
	   MAX(CAST(total_cases AS INT)) AS highest_infection
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY continent
ORDER BY highest_infection DESC;



--Lets analyze countries with highest infection rate Vs  population

SELECT location,
	   population,
	   MAX(CAST(total_cases AS INT)) AS highest_infection
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY location,
		 population
ORDER BY highest_infection DESC;



--Lets analyze continents with highest death rate
SELECT continent,
	   MAX(CAST(total_deaths AS INT)) AS highest_death
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY continent
ORDER BY highest_death DESC;



--Lets analyze countries with highest death rate Vs population
SELECT location,
	   population,
	   MAX(CAST(total_deaths AS INT)) AS highest_death, continent
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY location,
		 population, continent
ORDER BY highest_death DESC;



--Lets analyze global statistics 
-- Total new cases, total new deaths, and total death percentage per day
SELECT date, SUM(new_cases) AS total_new_cases, 
			 SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
			 SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS total_death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY date
ORDER BY date;



-- Total new cases, total new deaths, and total death percentage
SELECT SUM(new_cases) AS total_new_cases, 
	   SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
	   SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS total_death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
-- AND location like '%Nigeria%' -- You can specify your country here


-- Lets join our covid deaths and covid vacinnation table

SELECT *
FROM covid_deaths AS dea
JOIN covid_vacinnation AS vac
	 ON dea.location = vac.location 
	 AND dea.date = vac.date 

--Lets look at Total Population Vs vacinnation
SELECT dea.continent,
	   dea.location,
	   dea.date,
	   dea.population,
	   vac.new_vaccinations,
	   SUM(CAST(vac.new_vaccinations AS BIGINT)) 
	   OVER 
	   (PARTITION BY dea.location
	   ORDER BY dea.location, dea.date) AS roling_new_vacinnation
FROM   covid_deaths AS dea
JOIN   covid_vacinnation AS vac
	ON dea.location = vac.location 
   AND dea.date = vac.date 
WHERE  dea.continent IS NOT NULL
ORDER BY  dea.continent,
		  dea.location;


-- Using CTE for execution

WITH PopVsVac (continent, location, date, population, new_vacination, roling_new_vacinnation)
AS
(
SELECT dea.continent,
	   dea.location,
	   dea.date,
	   dea.population,
	   vac.new_vaccinations,
	   SUM(CAST(vac.new_vaccinations AS BIGINT)) 
	   OVER 
	   (PARTITION BY dea.location
	   ORDER BY dea.location, dea.date) AS roling_new_vacinnation
FROM   covid_deaths AS dea
JOIN   covid_vacinnation AS vac
	ON dea.location = vac.location 
   AND dea.date = vac.date 
WHERE  dea.continent IS NOT NULL
)
SELECT *, 
	   (roling_new_vacinnation/population)*100 AS percent_population_vacinnated
FROM PopVsVac
ORDER BY  continent,
		  location;


--Lets create some view for visialization.
--Lets view continents with highest infection rate

CREATE VIEW ContinentHighestInfection AS
SELECT continent,
	   MAX(CAST(total_cases AS INT)) AS highest_infection
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY continent;

--Lets view countries with highest infection rate Vs  population

CREATE VIEW CountrytHighestInfection AS
SELECT location,
	   population,
	   MAX(CAST(total_cases AS INT)) AS highest_infection
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY location,
		 population; 

--Lets view continents with highest death rate
CREATE VIEW ContinentHighestDeath AS
SELECT continent,
	   MAX(CAST(total_deaths AS INT)) AS highest_death
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY continent;



--Lets view countries with highest death rate Vs population
CREATE VIEW CountrytHighestDeath AS
SELECT location,
	   population,
	   MAX(CAST(total_deaths AS INT)) AS highest_death, continent
FROM covid_deaths 
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY location,
		 population, continent;

-- Lets view Total new cases, total new deaths, and total death percentage per day
CREATE VIEW GlobalStatisticsDay AS
SELECT date, SUM(new_cases) AS total_new_cases, 
			 SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
			 SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS total_death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
   -- AND location like '%Nigeria%' -- You can specify your country here
GROUP BY date;



-- Lets View Total new cases, total new deaths, and total death percentage
CREATE VIEW GlobalStatisticsTotal AS
SELECT SUM(new_cases) AS total_new_cases, 
	   SUM(CAST(new_deaths AS INT)) AS total_new_deaths,
	   SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS total_death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
-- AND location like '%Nigeria%' -- You can specify your country here



---Lets view Total Population Vs Vacinnation
CREATE VIEW PercentPopulationVacinnated AS
WITH PopVsVac (continent, location, date, population, new_vacination, roling_new_vacinnation)
AS
(
SELECT dea.continent,
	   dea.location,
	   dea.date,
	   dea.population,
	   vac.new_vaccinations,
	   SUM(CAST(vac.new_vaccinations AS BIGINT)) 
	   OVER 
	   (PARTITION BY dea.location
	   ORDER BY dea.location, dea.date) AS roling_new_vacinnation
FROM   covid_deaths AS dea
JOIN   covid_vacinnation AS vac
	ON dea.location = vac.location 
   AND dea.date = vac.date 
WHERE  dea.continent IS NOT NULL
)
SELECT *, 
	   (roling_new_vacinnation/population)*100 AS percent_population_vacinnated
FROM PopVsVac;

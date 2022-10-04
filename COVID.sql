SELECT * FROM CovidDeaths
SELECT * FROM CovidVaccinations

SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM CovidDeaths
ORDER BY 1,2

--Total cases vs total deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as Death_Percentage 
FROM CovidDeaths
WHERE location LIKE '%INDIA%'
ORDER BY 2

--TOTAL CASES VS POPULATION
SELECT location, date, total_cases, population,  (total_cases/population) * 100 as Case_Percentage 
FROM CovidDeaths
WHERE location LIKE '%INDIA%'
ORDER BY 2

--COUNTRIES WITH HIGHEST INFECTION RATE
SELECT location, MAX(total_cases) as Total_cases, population,  MAX((total_cases/population)) * 100 as Case_Percentage 
FROM CovidDeaths
GROUP BY location, population
ORDER BY 4 DESC

--COUNTRIES WITH HIGHEST DEATHS
SELECT location, MAX(total_cases) AS TOTAL_CASES, MAX(CAST(total_deaths AS INT)) AS TOTAL_DEATHS, MAX((total_deaths/total_cases)) * 100 AS DEATH_PERCENTAGE FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 3 DESC

--CONTINENTS WITH HIGHEST DEATHS
SELECT location AS CONTINENT, MAX(total_cases) AS TOTAL_CASES, MAX(CAST(total_deaths AS INT)) AS TOTAL_DEATHS, MAX((total_deaths/total_cases)) * 100 AS DEATH_PERCENTAGE FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY 3 DESC

--GLOBAL DEATH PERCENTAGE BY DATE
SELECT date, SUM(new_cases) AS NEW_CASES, SUM(CAST(new_deaths AS INT)) AS NEW_DEATHS, 
SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DEATH_PERCENTAGE 
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1

--TOTAL POPULATION VS TOTAL VACINNATION

WITH POPVSVAC ( continent, location, date, population, new_vaccinations,Roll) AS (
SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, 
SUM(CONVERT(INT, CV.new_vaccinations)) OVER(PARTITION BY CD.location ORDER BY CD.location,	CD.	date) AS Roll
FROM CovidDeaths CD JOIN CovidVaccinations CV ON CD.location = CV.location AND CD.date=CV.date
WHERE CD.continent IS NOT NULL
)
SELECT continent, location, date, population, Roll AS TOTAL_VACCINATIONS, 
(Roll/population) * 100 AS VACCINATION_PERCENTAGE 
FROM POPVSVAC


SELECT CD.continent, CD.location, CD.date, CD.population, CV.new_vaccinations, 
SUM(CONVERT(INT, CV.new_vaccinations)) OVER(PARTITION BY CD.continent) AS Roll
FROM CovidDeaths CD JOIN CovidVaccinations CV ON CD.location = CV.location AND CD.date=CV.date
WHERE CD.continent IS NOT NULL
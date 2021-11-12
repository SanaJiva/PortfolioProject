/* COVID-19 Data Exploration Project. Use data from our world in data.
Skills used: Joins, Creating Views, Converting Data Types, Aggregate Functions
*/

-- COVID Deaths
SELECT *
FROM [dbo].[CovidDeaths];

SELECT *
FROM [dbo].[CovidDeaths]
WHERE continent is not null
ORDER By 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, Population
FROM [dbo].[CovidDeaths]
WHERE continent is not null


-- Total Cases vs Total Deaths in United States
-- Shows likelihood of dying if you contract COVID in United States
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [dbo].[CovidDeaths]
WHERE Location = 'United States'
ORDER BY 1,2;

-- Total Cases vs Population 
-- Shows what percentage of population infected with COVID in United States
SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM [dbo].[CovidDeaths]
--WHERE Location = 'United States'
ORDER BY 1,2;

-- Countries with Highest Infection Rate compared to Population
SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM [dbo].[CovidDeaths]
WHERE continent is not null
GROUP BY Location, Population
ORDER BY PercentPopulationInfected Desc;

-- Countries with Highest Death Count per Population
SELECT Location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM [dbo].[CovidDeaths]
WHERE continent is not null
GROUP by Location
ORDER BY TotalDeathCount Desc;

-- Breaking down by Continent
-- Continent with Highest Death Count per Population
SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM [dbo].[CovidDeaths]
WHERE continent is not null
GROUP By continent
ORDER BY TotalDeathCount Desc;

-- Global Numbers of total cases, total death and death percentage
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as integer)) AS total_deaths, SUM(cast(new_deaths as integer))/SUM(new_cases)*100 as DeathPercentage
FROM [dbo].[CovidDeaths]
WHERE continent is not null 
ORDER BY 1,2;

--COVID Vaccinations
SELECT *
FROM [dbo].[CovidVaccinations]

-- Total population VS Vaccination Globally
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [dbo].[CovidDeaths] dea
JOIN [dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER by 1,2,3

-- COVID-19 vaccine doses administered by continent
SELECT continent, MAX(CAST(new_vaccinations as int)) AS TotalVaccinations
FROM [dbo].[CovidVaccinations]
WHERE continent is not null
GROUP By continent
ORDER BY TotalVaccinations Desc;

-- Total population VS Vaccination in United States
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [dbo].[CovidDeaths] dea
JOIN [dbo].[CovidVaccinations] vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null and dea.location = 'United States'
ORDER by 1,2,3;


-- Total test per location globally
SELECT location, MAX(total_tests) as HighestTestDone
FROM [dbo].[CovidVaccinations]
Where continent is not null
GROUP By location
ORDER BY HighestTestDone Desc;

--Total test per continent


--Creating View HighestDeathCount

CREATE VIEW HighestDeathCount AS
SELECT Location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
FROM [dbo].[CovidDeaths]
WHERE continent is not null
GROUP by Location;

-- Creating view to HighestInfectionRate
CREATE VIEW HighestInfectionRate AS
SELECT Location, population, MAX(total_cases) AS HighestInfectionCount, MAX(total_cases/population)*100 AS PercentPopulationInfected
FROM [dbo].[CovidDeaths]
WHERE continent is not null
GROUP BY Location, Population

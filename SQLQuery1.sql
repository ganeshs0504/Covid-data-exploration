--SELECT *
--FROM PortfolioProject..CovidDeaths
--ORDER BY location, date

SELECT location, date, total_cases, total_deaths, population, (1.0*total_deaths/total_cases)*100 AS death_percent
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%king%'
ORDER BY location, date

-- Percent infected for each countries
SELECT location, population, MAX(total_cases) AS max_infected, MAX((1.0*total_cases/ population))*100 AS infected_percent
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%United Kingdom%'
GROUP BY location, population
ORDER BY infected_percent DESC

-- Total death counts for each countries
SELECT location, MAX(total_deaths) as death_counts
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_counts DESC

-- Percent death count against population for each countries
SELECT location, population, MAX(total_deaths) AS max_deaths, MAX((1.0*total_deaths/ population))*100 AS death_percent
FROM PortfolioProject..CovidDeaths
--WHERE location LIKE '%United Kingdom%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY death_percent DESC

-- continent analysis
--Total covid cases and percent affected against population by continent
SELECT continent, MAX(population) AS total_population, MAX(total_cases) AS total_cases, ((1.0*MAX(total_cases))/ MAX(population))*100 AS infected_percent
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY infected_percent DESC

--Total covid deaths and death percent against population by continent
SELECT continent, MAX(population) AS total_population, MAX(total_deaths) AS total_deaths, ((1.0*MAX(total_deaths))/ MAX(population))*100 AS percent_deaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY percent_deaths DESC

--Total covid deaths and death percent against total cases by continent
SELECT continent, MAX(population) AS total_population, MAX(total_deaths) AS total_deaths, ((1.0*MAX(total_deaths))/ MAX(total_cases))*100 AS percent_deaths_per_casees
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY percent_deaths_per_casees DESC

-- Total Population Vs Vaccinations
WITH popVaccinated
AS(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS total_vac,
	vac.total_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL --AND dea.location='Algeria'
--ORDER BY dea.location, dea.date
)

SELECT *, (total_vac/population)*100 AS popVac FROM popVaccinated
ORDER BY location, date

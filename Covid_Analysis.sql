SELECT * FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$] ORDER BY 3,4;
--SELECT * FROM [Portfolio_Project_Covid].[dbo].[covid_Vaccinations$]ORDER BY 3,4

--Select data that we are going to be using

select location,date,total_cases,new_cases,total_deaths,population 
FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$]
ORDER BY 1,2;

--Looking at the total cases vs Total Deaths

select location,date,population,total_cases,(total_deaths/total_cases)*100 as PercentPopulationInfected
FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$]
--where location like '%states%'
ORDER BY 1,2;
--Looking at countries with highest infection rate compared to population 

select location,population,max(total_cases) as HighestInfectionCount, max((total_deaths/total_cases))*100 as PercentPopulationInfected
FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$]
--where location like '%states%'
group by location,population
ORDER BY PercentPopulationInfected desc;


--Shows what percentage of populatio got covid

select location,date,total_cases,population,(total_cases/population)*100 as DeathPercentage
FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$]
where location like '%states%'
ORDER BY 1,2;

--showing countries with the highest death count per population

select location, max(cast(Total_Deaths as int)) as TotalDeathCount
FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$]
--where location like '%states%'
group by location
ORDER BY TotalDeathCount desc;

--LET'S BREAK THINGS DOWN BY CONTINENT

--showing continents with the highest death count per population

select continent, max(cast(Total_Deaths as int)) as TotalDeathCount
FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$]
--where location like '%states%'
where continent is not null
Group by continent
ORDER BY TotalDeathCount desc;

--GLOBAL NUMBERS

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
FROM [Portfolio_Project_Covid].[dbo].[Covid_Deaths$]
--where location like '%states%'
where continent is not null
--Group by date
ORDER BY 1,2;


select * from Portfolio_Project_Covid..covid_Vaccinations$;

select deaths.continent, deaths.location,deaths.date, deaths.population , vaccinations.new_vaccinations,
sum(convert(int,vaccinations.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) 
as rollingpeopleVaccinated
from Portfolio_Project_Covid..covid_deaths$ deaths
join Portfolio_Project_Covid..covid_Vaccinations$ vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date
where deaths.continent is not null
order by 2,3;


with populationVsVaccination (continent,location,date,population,new_vaccinations,rollingpeopleVaccinated)
as
(
select deaths.continent, deaths.location,deaths.date, deaths.population , vaccinations.new_vaccinations,
sum(convert(int,vaccinations.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) 
as rollingpeopleVaccinated
from Portfolio_Project_Covid..covid_deaths$ deaths
join Portfolio_Project_Covid..covid_Vaccinations$ vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date
where deaths.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/Population)*100
From populationVsVaccination;

--creating view to store data for later visualizations

create view PercentPopulationVaccinated as 
select deaths.continent, deaths.location,deaths.date, deaths.population , vaccinations.new_vaccinations,
sum(convert(int,vaccinations.new_vaccinations)) over (partition by deaths.location order by deaths.location, deaths.date) 
as rollingpeopleVaccinated
from Portfolio_Project_Covid..covid_deaths$ deaths
join Portfolio_Project_Covid..covid_Vaccinations$ vaccinations
on deaths.location=vaccinations.location
and deaths.date=vaccinations.date
where deaths.continent is not null
--order by 2,3



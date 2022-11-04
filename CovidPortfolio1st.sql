
select*
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--find duplicated
select continent,location,date,population,COUNT(*)
from PortfolioProject..CovidDeaths
where continent is not null
group by continent,location,date,population
having COUNT(*)>1

--Delete duplicate value
select distinct * into neha_table from PortfolioProject..CovidDeaths
delete from PortfolioProject..CovidDeaths
insert into PortfolioProject..CovidDeaths select * from neha_table
drop table neha_table

--showing the table
select*
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4



select*
from PortfolioProject..CovidVaccinations
order by 3,4


--Select the data that we are using

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--looking at total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)
from PortfolioProject..CovidDeaths
order by 1,2

--Naming the  column

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
order by 1,2

--Filter only Unites states

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--Filter only india

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2


--Looking at total cases vs population
select location,date,total_cases,population,(total_cases/population)*100 as PercentPopulationInfected
from PortfolioProject..CovidDeaths
where location like '%india%'
order by 1,2

--Looking at country with highest infection rate compared to population
select location,population,MAX(total_cases) as HighestInfectedCount,MAX((total_cases/population))*100 as HigestPercentPopulationInfected
from PortfolioProject..CovidDeaths
group by location,population
order by HigestPercentPopulationInfected desc


--Showing country highest death count per population
select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc



--LET'S BREAK THINGS DOWN BY CONTINENT
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is  null
group by location
order by TotalDeathCount desc


--showing continet with the higest death count per population
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--Global numbers
select SUM(new_cases) as TotalCase,SUM(cast(new_deaths as int)) as TotalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--Join the two table

select*
from PortfolioProject..CovidDeaths dea
     join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
order by 1,2,3,4


--Looking at Total Population vs vaccination
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 1,2,3



select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


--use CTE
with PopvsVac (Continent,Location,Date,Population,new_vaccination,RollingPeopleVaccination)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location=vac.location
	 and dea.date=vac.date
where dea.continent is not null

)

select *,(RollingPeopleVaccination/Population)*100
from PopvsVac



--Temp Table

drop table if exists #PercentPopulationVaccinated

create table #PercentPopulationVaccinated
(Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric)



insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3


select *,(RollingPeopleVaccinated/Population)*100 
from #PercentPopulationVaccinated

--Creating view to store data for later visualization
create view PercentPopulationVaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccination
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null

select * 
from PercentPopulationVaccinated




Select Location, date, total_cases, new_cases, total_deaths, population
From covidDeathReport
Where continent is not null 
order by 1,2

--total cases vs total deaths

select total_cases,total_deaths,location, (Cast (total_deaths as float)/cast (total_cases as float))*100 death_percentage from covidDeathReport where  (Cast (total_deaths as float)/cast (total_cases as float))*100 is not null order by location;


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select total_cases,population,location, (Cast (total_cases as float)/cast (population as float))*100 infection_percantage from covidDeathReport where  (Cast (total_cases as float)/cast (population as float))*100 is not null order by location;

--top 4 Countries with Highest Infection Rate compared to Population

select top 4 location,population,
MAX(total_cases) maximum_totalcase, 
max((Cast (total_cases as float)/cast (population as float))*100) maximum_infection_rate 
from covidDeathReport
group by location,population
order by 4 desc;

--top 4 Countries Countries with Highest Death Count per Population
select top 4 location,population,
MAX(total_deaths) maximum_totaldeath, 
max((Cast (total_deaths as float)/cast (population as float))*100) maximum_death_rate 
from covidDeathReport
group by location,population
order by 4 desc;


-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From covidDeathReport
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine



with getvaccnination(location,total_vaccine_country,population) as (select cvr.location,cdr.population,sum(cast(cvr.new_vaccinations as float)) over(partition by cvr.location  order by population) total_vaccine_country from covidDeathReport cdr join covidVaccineReport cvr on cdr.location=cvr.location where cvr.location is not null)
select *,total_vaccine_country/population *100 get_total from getvaccnination;


--create view
DROP VIEW leftVaccination;
create view leftVaccination as select cdr.location,cast(cdr.population as float) - sum(cast(cvr.new_vaccinations as float)) people_left from covidDeathReport cdr join covidVaccineReport cvr on cdr.location=cvr.location where cvr.location is not null group by cdr.location,cdr.population ;

select * from leftVaccination;
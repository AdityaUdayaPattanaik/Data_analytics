select *
from deaths
order by 3,4

--select *
--from vaccine
--order by 3,4

-- total cases vs total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from deaths
where location = 'India'
order by 1,2

--total cases vs population

select location,date,population,total_deaths,(total_deaths/population)*100 as deaths
from deaths
--where location = 'India'
order by 1,2

--looking at the countries with highest cases compared to population
select location,population,max(total_deaths) as highestcount,max((total_deaths/population))*100 as death_percentage
from deaths
--where location = 'India'
group by location, population
order by death_percentage desc

--total death counts
select location,max(cast(total_deaths as int)) as deaths
from deaths
where continent is not null
--where location = 'India'
group by location
order by deaths desc

--LETS DO THE DATA ANALYSIS ON CONTINENT

select location,max(cast(total_deaths as int)) as deaths
from deaths
where continent is  null
--where location = 'India'
group by location

order by deaths desc

--display of the coninents with highest death count per population
--GLOBAL NUMBER
select sum(population) as total_world_population,sum(new_cases) as case_count, sum(cast(new_deaths as float))as death_count, sum(cast(new_deaths as float))/sum(new_cases)*100 as death_percentage_globally--total_cases,total_deaths,(total_deaths/total_cases)*100 as deathspercentage
from deaths
where continent is not null 
--where location = 'India'
--group by date
order by 1,2

--data exploration using vaccination data 
select * from vaccines
-- joining of two data tables i.e death and vaccine
select * 
from deaths d
join vaccines v
     on d.location = v.location
	 and d.date = v.date


--total no. of people got vaccinated / the total world population
with popvsvac (continent, location, date, population,new_vaccinations, peoplevaccinated)
as
(
select d.continent,d.location,d.date,d.population,v.new_vaccinations
, sum(convert(int, v.new_vaccinations)) over (partition by d.location order by d.location, 
d.date) as peoplevaccinated
from deaths d
join vaccines v
     on d.location = v.location
	 and d.date = v.date
where d.continent is not null 
--(just for checking purpose) 
--and d.location = 'Albania'
--and v.new_vaccinations is not null 

--order by 2,3
)
select * ,(peoplevaccinated/population)*100 as percentage_of_vaccination
from popvsvac


--- creating a temp table for my data analysis
drop table  if exists percentage_people_vaccinated  --used to drop the table if it is created earlier 
create table percentage_people_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
date  datetime,
population numeric,
new_vaccincations numeric,
peoplevaccinated numeric
)

insert into percentage_people_vaccinated
select d.continent,d.location,d.date,d.population,v.new_vaccinations
, sum(convert(int, v.new_vaccinations)) over (partition by d.location order by d.location, 
d.date) as peoplevaccinated
from deaths d
join vaccines v
     on d.location = v.location
	 and d.date = v.date
where d.continent is not null 
--(just for checking purpose) 
--and d.location = 'Albania'
--and v.new_vaccinations is not null 

--order by 2,3

select * ,(peoplevaccinated/population)*100 as percentage_of_people
from percentage_people_vaccinated


--CREATING VIEW

CREATE view people_vaccinated as 
select d.continent,d.location,d.date,d.population,v.new_vaccinations
, sum(convert(int, v.new_vaccinations)) over (partition by d.location order by d.location, 
d.date) as peoplevaccinated
from deaths d
join vaccines v
     on d.location = v.location
	 and d.date = v.date
where d.continent is not null 
--(just for checking purpose) 
--and d.location = 'Albania'
--and v.new_vaccinations is not null 

--order by 2,3'
select * from people_vaccinated
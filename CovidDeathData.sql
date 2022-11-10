/****** Script for SelectTopNRows command from SSMS  ******/
/*Select all the coloumn */
SELECT [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[total_deaths]
      ,[new_deaths]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
  FROM [PortfolioProject].[dbo].[CovidDeathData]


/* Inserting row data from coviddeath to coviddeathta*/

  INSERT INTO CovidDeathData ([iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[total_deaths]
      ,[new_deaths]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million])
  SELECT [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[total_deaths]
      ,[new_deaths]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
	  FROM CovidDeaths

SELECT *
FROM CovidDeathData

/* Creating stored procedure */

CREATE PROCEDURE SelectAllCovidData
AS
SELECT [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[total_deaths]
      ,[new_deaths]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
  FROM [PortfolioProject].[dbo].[CovidDeathData]

EXEC SelectAllCovidData

UPDATE CovidDeathData
SET total_deaths = ISNULL(total_deaths,0)

UPDATE CovidDeathData
SET new_deaths = ISNULL(new_deaths,0)

UPDATE CovidDeathData
SET new_deaths_per_million = ISNULL(new_deaths_per_million,0)

UPDATE CovidDeathData
SET total_deaths_per_million = ISNULL(total_deaths_per_million,0)

ALTER TABLE CovidDeathData
DROP COLUMN new_cases_smoothed_per_million

DELETE FROM CovidDeathData
WHERE total_cases is null

DELETE FROM CovidDeathData
WHERE continent is null

ALTER TABLE CovidDeathData
ALTER COLUMN date Date


SELECT *,YEAR(Date) as Year, LEFT(DATENAME(Month,date),3) as Month
FROM CovidDeathData


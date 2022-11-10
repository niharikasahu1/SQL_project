/****** Script for SelectTopNRows command from SSMS  ******/
SELECT [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[new_tests]
      ,[total_tests]
      ,[total_tests_per_thousand]
      ,[new_tests_per_thousand]
      --,[new_tests_smoothed]
      --,[new_tests_smoothed_per_thousand]
      ,[positive_rate]
      ,[tests_per_case]
      --,[tests_units]
      ,[total_vaccinations]
      ,[people_vaccinated]
      ,[people_fully_vaccinated]
      --,[new_vaccinations]
      --,[new_vaccinations_smoothed]
      --,[total_vaccinations_per_hundred]
      --,[people_vaccinated_per_hundred]
      --,[people_fully_vaccinated_per_hundred]
      --,[new_vaccinations_smoothed_per_million]
      --,[stringency_index]
      --,[population_density]
      ,[median_age]
      ,[aged_65_older]
      ,[aged_70_older]
      ,[gdp_per_capita] into CovidVaccinatedData
      --,[extreme_poverty]
      --,[cardiovasc_death_rate]
      --,[diabetes_prevalence]
      --,[female_smokers]
      --,[male_smokers]
      --,[handwashing_facilities]
      --,[hospital_beds_per_thousand]
      --,[life_expectancy]
      --,[human_development_index]
  FROM [PortfolioProject].[dbo].[CovidVaccinations]

  select *
  from CovidVaccinatedData

  DELETE FROM CovidVaccinatedData
  WHERE new_tests is null

  select *
  from CovidVaccinatedData
  where total_vaccinations is not null
create database afford_db;
use afford_db;

select * from old_ahpro;

-- Make a duplicate table for cleaning.
select * from housing_import;

-- There are a lot of rows that null values. It probably won't do us any good. So we will select all rows that have empty/null values and delete them. 
-- Don't worry, we still have our old table.
select `PROJECT ID` from housing_import;
select `PROJECT Name` from housing_import;
select `PROJECT Start Date` from housing_import; -- All dates are good and standardized already.

select * from housing_import
where `PROJECT Completion Date` = '';  -- BUILDINGS weren't completed yet. Which are valuably information. So we WON't Delete that.



-- For now, what we are going to do is answer this question 
-- Which borough actually saw the most New Construction in 2023? 
-- Include the total count; and ratio of New Construction vs. Preservation for each borough.

select Borough, `Reporting Construction Type` as RPT, count(*) as cnt from housing_import
group by Borough, RPT
order by RPT desc;
-- In 2023, Brooklyn had the most New Construction (202 buildings in the Brooklyn.)
-- The Bronx has the 2nd highest most new Construction (152 buildings in the Bronx)
-- Queens has 83 buildings New Construction Buildings.
-- Manhattan has 17 new Construction Buildings.


-- Brooklyn has the most preservation (116 buildings)
-- Manhattan has 69 preservation buildings
-- Bronx has 59 preservation buildings 
-- Queens has only 1 preservation building.
-- Staten Island has None.



-- Next topic is this:
-- There’s a lot of noise that we’re only building for 'Middle Income' folks. 
-- Give me breakdown of Extremely Low Income (ELI) and Very Low Income (VLI) units 
-- as a percentage of the total units counted in 2023. 
-- Are we actually hitting the populations that need it most?



-- Sum up every single unit in the Extreme Low Income Units column.
-- Sum up every single unit in the Very Low Income Units column.
-- Add those two sums together (Total Deeply Affordable Units).
-- Divide that number by the sum of the All Counted Units column.

select sum(`Extremely Low Income Units`) from housing_import
where not (`Extremely Low Income Units` = '');
-- A total of Extreme Low Income 5655 units (without the empty rows).

select sum(`Very Low Income Units`) from housing_import
where not (`Very Low Income Units` = '');
-- A total of Very Low Income 5826 units (without the empty rows).
-- Total Deeply Affordable Units --> 5655 + 5826 = 11481 Total Deeply Affordable Units


select sum(`All Counted Units`) from housing_import;
-- The sum of All Count Units 27755. 

-- 

-- The percentage of people you're hitting is  about 41 %  It's somewhat close to half the people, so there is major room for improvement. 



-- NEXT
-- We’re hearing complaints that everything being built is just studios for single professionals. 
-- Calculate the percentage of 3-BR+ units across the city. 
-- Which borough is doing the best job providing for actual families?




select sum(`3-BR Units`) from housing_import;
-- Citywide Percentage. 


-- Add up all the 3-BR, 4-BR, 5-BR and 6-BR+ Units. 
select sum(`3-BR Units`), sum(`4-BR Units`), sum(`5-BR Units`), sum(`6-BR+ Units`), sum(`3-BR Units`) + sum(`4-BR Units`) + sum(`5-BR Units`) + sum(`6-BR+ Units`) as tot  from housing_import;
-- Family Sized Units = 2458.
select sum(`All Counted Units`) from housing_import;
-- 2458 / 27755
-- 8.85% (9% rounded) of all units built across NYC were family sized (3 bedrooms or larger.)


-- For the borough of Bronx
select sum(`3-BR Units`), sum(`4-BR Units`), sum(`5-BR Units`), sum(`6-BR+ Units`), sum(`3-BR Units`) + sum(`4-BR Units`) + sum(`5-BR Units`) + sum(`6-BR+ Units`) 
as Family_Sized_Units 
from housing_import
group by Borough
having Borough = 'Bronx';
-- Total Family Units for the Bronx = 613.
select sum(`All Counted Units`) from housing_import
where Borough = 'Bronx';
-- All Counted Units for Bonx = 8942.
-- 613 / 8942
-- 6.8% (7% rounded) of all units in the Bronx are familed sized (3 bedrooms of more)

-- For the borough of Manhattan
select sum(`3-BR Units`), sum(`4-BR Units`), sum(`5-BR Units`), sum(`6-BR+ Units`),
sum(`3-BR Units`) + sum(`4-BR Units`) + sum(`5-BR Units`) + sum(`6-BR+ Units`) 
as Family_Sized_Units from housing_import
group by Borough
having Borough = 'Manhattan';
-- Total Family Units for the Manhattan = 519.
select sum(`All Counted Units`) from housing_import
where Borough = 'Manhattan';
-- All Counted Units for Manhattan = 4968.
-- 519 / 4968
-- 10% of all units in Manhattan are family sized (3 bedrooms of more)


-- For the borough of Queens
select sum(`3-BR Units`), sum(`4-BR Units`), sum(`5-BR Units`), sum(`6-BR+ Units`),
sum(`3-BR Units`) + sum(`4-BR Units`) + sum(`5-BR Units`) + sum(`6-BR+ Units`) 
as Family_Sized_Units from housing_import
group by Borough
having Borough = 'Queens';
-- Total Family Units for Queens = 155.
select sum(`All Counted Units`) from housing_import
where Borough = 'Queens';
-- All Counted Units for Queens = 3487.
-- 155 / 3487
-- 4% of all units in Queens are family sized (3 bedrooms of more)



-- For the borough of Brooklyn
select sum(`3-BR Units`), sum(`4-BR Units`), sum(`5-BR Units`), sum(`6-BR+ Units`),
sum(`3-BR Units`) + sum(`4-BR Units`) + sum(`5-BR Units`) + sum(`6-BR+ Units`) 
as Family_Sized_Units from housing_import
group by Borough
having Borough = 'Brooklyn';
-- Total Family Units for Queens = 1171.
select sum(`All Counted Units`) from housing_import
where Borough = 'Brooklyn';
-- All Counted Units for Queens = 10331.
-- 1171 / 10331
-- 11% of all units in Brooklyn are family sized (3 bedrooms of more)


-- For the borough of Staten Island
select sum(`3-BR Units`), sum(`4-BR Units`), sum(`5-BR Units`), sum(`6-BR+ Units`),
sum(`3-BR Units`) + sum(`4-BR Units`) + sum(`5-BR Units`) + sum(`6-BR+ Units`) 
as Family_Sized_Units from housing_import
group by Borough
having Borough = 'Staten Island';
-- Total Family Units for Staten Island = 0.
select sum(`All Counted Units`) from housing_import
where Borough = 'Staten Island';
-- All Counted Units for Staten Island = 27

-- There is no percent/ratio of family units to all counted units for the borough of Staten Island.

-- So for family gap: In 2023, 8.85% (9% rounded) of all units built across NYC were family sized (3 bedrooms or larger.)
-- 6.8% (7% rounded) of all units in the Bronx are familed sized (3 bedrooms of more)
-- 10% of all units in Manhattan are family sized (3 bedrooms of more)
-- 4% of all units in Queens are family sized (3 bedrooms of more)
-- 11% of all units in Brooklyn are family sized (3 bedrooms of more)

-- So in 2023, the borough of Brooklyn provided the most family units in NYC. And Queens provided the least family units in NYC.


-- NEXT
-- How much time did it take to finish a building in 2023.
-- Timer Start: Start Date, Timer Stop: Building Completion Timer. 


SELECT `Project Start Date`, `Building Completion Date`,  
avg(TIMESTAMPDIFF(MONTH, STR_TO_DATE(`Project Start Date`, '%m/%d/%Y'), STR_TO_DATE(`Building Completion Date`, '%m/%d/%Y')
)) AS 'wait_time (in months)'
FROM housing_import
WHERE `Building Completion Date` <> ''
  AND `Project Start Date` <> ''
  group by `Project Start Date`, `Building Completion Date`;
  
-- Finding average months to finish a building in 2023.
SELECT AVG(
  TIMESTAMPDIFF(
    MONTH,
    STR_TO_DATE(`Project Start Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Building Completion Date`, '%m/%d/%Y')
  )
) AS avg_months
FROM housing_import
WHERE `Building Completion Date` <> ''
  AND `Project Start Date` <> '';
-- On average, it took about 6-7  months to finish a building in 2023 (7 months rounded)


-- Finding the maximum  wait time
SELECT max(
  TIMESTAMPDIFF(
    MONTH,
    STR_TO_DATE(`Project Start Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Building Completion Date`, '%m/%d/%Y')
  )
) AS `max_wait_time (months)`
FROM housing_import
WHERE `Building Completion Date` <> ''
  AND `Project Start Date` <> '';
-- The maximum wait time was A year and 11 months (23 months)  
  
-- Finding the minimum  wait time
SELECT min(
  TIMESTAMPDIFF(
    MONTH,
    STR_TO_DATE(`Project Start Date`, '%m/%d/%Y'),
    STR_TO_DATE(`Building Completion Date`, '%m/%d/%Y')
  )
) AS `max_wait_time (months)`, `Building ID`, Borough
FROM new_ahpro
WHERE `Building Completion Date` <> ''
  AND `Project Start Date` <> ''
  group by `Building ID`, Borough
  having `max_wait_time (months)` = 0;
-- The minimum wait time was under a month.


select `Project Name`, `Project Start Date`, `Project Completion Date`, `Borough` from new_ahpro
where `Building ID` in  (12851, 804646, 37598, 4168, 803888, 805985, 805986, 805989, 805990);
  
-- The slowest project took about 23 months (a year and 11 months)
-- According to the data, the fastest project took less than a month (0 months)

select * from housing_import;

-- Summary: In 2023, the average time to completion for affordable housing projects was 7 months. The fastest project took less than a month.
-- The slowest project took 23 months (a year and 11 months). Majority of projects who took 0 months to complete were done in Manhattan.



-- Have new apartments been built, or where they were just renewing the leases on old ones?
-- Count how many units are new construction, vs how many are preservation. 
-- Find the percentage of each. If 90% is preservation, the city's housing supply isn't increasing. (Pie Chart)

select count(`Reporting Construction Type`) from housing_import;

select `Reporting Construction Type`, count(*) from housing_import
group by `Reporting Construction Type`;
-- There are a total of 701 units. Of which, 456 units are New Construction and 245 units are preservation. 
-- 65% of units are new construction, and 34-35% units are preservation.
-- Summary: The city's housing supply was increasing in 2023. 




-- NEXT
-- Compare Counted Rental units column vs Counted Homeownership Units Column. 
-- What percentage of 2023 were for homeownership
 
select sum(`Counted Rental Units`), sum(`Counted Homeownership Units`) as hn, sum(`All Counted Units`),  Borough from housing_import
group by Borough
order by hn;
-- There are 26971 Rental Units, while there are 764 Counted Homeownship units. So more rented units back in 2023, than owned homes. 
-- 2% of all counted units were Homeownshiper units, while 97% of all counted units were Rental Units.
-- Brooklyn had the most homeownshiper units, while also having the most rental units.


-- NEXT 
-- Find Top 5 Neighborhood with the most units in 2023.

select sum(`Total Units`) as tot, Borough from housing_import;


select `NTA - Neighborhood Tabulation Area` as neigh, sum(`Total Units`) as total_units from housing_import
group by neigh
order by total_units desc
limit 5;
-- (BK1702) --> East Flatbush and Farragut has the most units (2703)
-- (BK0601) --> Caroll Gardens, Cobble Hill, Red Hook, & Gowanus come in second (2615 units)
-- (BK0101) --> Greenpoint, comes in third (1654 units)
-- (BK202) --> Downtown Brooklyn, Dumbo, Boerum Hill comes in fourth (1246 units)
-- (MN1203) --> Inwood, with 1061 units, coming in 5th place.

select sum(`Total Units`) as tot, Borough from housing_import
group by Borough
order by tot desc;
-- The borough with the most units in 2023 is the Brooklyn. So the neighboordhood somewhere in Brooklyn.


-- Question 8: The 'Middle Income' Reality Check
-- Sum all the middle income units and divided by all counted Units. 
-- Then find the percentage of our 2023 units were for Middle Income households.

select sum(`Middle Income Units`), sum(`All Counted Units`), (sum(`Middle Income Units`) / sum(`All Counted Units`)) * 100 from housing_import;
-- 18-19% (19 rounded) of 2023 units were for Middle Income Households
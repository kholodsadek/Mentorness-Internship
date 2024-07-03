
-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values
SELECT
	*
FROM
	CoronaVirusDataset
WHERE
	Province IS NULL
	OR Country_or_Region IS NULL
	OR Latitude IS NULL
	OR Longitude IS NULL
	OR date IS NULL
	OR Confirmed IS NULL
	OR Deaths IS NULL
	OR Recovered IS NULL;

-- Q2. If NULL values are present, update them with zeros for all columns. 
	/* THERE IS NOT NULL VALUES IN THE DATASET */

-- Q3. check total number of rows
SELECT
	count(*) AS count_rows
FROM
	CoronaVirusDataset;

-- Q4. Check what is start_date and end_date
SELECT
	MIN(date) AS start_date,
	MAX(date) As end_date
FROM 
	CoronaVirusDataset;

-- Q5. Number of month present in dataset
SELECT
    COUNT(DISTINCT strftime('%Y-%m', 
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4) || '-' || substr(date, 4, 2) || '-' || substr(date, 1, 2)
            WHEN date LIKE '%/%/%' THEN substr(date, 5, 4) || '-' || substr(date, 3, 1) || '-' || substr(date, 1, 1)
        END
    )) AS num_of_months
FROM
    CoronaVirusDataset;

-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT
    Year,
    Month,
    AVG(Confirmed) AS AvgConfirmed,
    AVG(Deaths) AS AvgDeaths,
    AVG(Recovered) AS AvgRecovered
FROM
    (
    SELECT
        -- Extract and format the year
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4)
            WHEN date LIKE '%/%/%' THEN substr(date, length(date) - 3, 4)
        END AS Year,
        -- Extract and format the month
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 4, 2)
            WHEN date LIKE '%/%/%' THEN
                printf('%02d', cast(substr(date, 1, instr(date, '/') - 1) as integer))
        END AS Month,
        Confirmed,
        Deaths,
        Recovered
    FROM
        CoronaVirusDataset
    ) AS subquery
GROUP BY
    Year,
    Month;


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT
    Year,
    Month,
    MAX(Confirmed) AS MostFrequentConfirmed,
    MAX(Deaths) AS MostFrequentDeaths,
    MAX(Recovered) AS MostFrequentRecovered
FROM
    (
    SELECT
        -- Extract and format the year
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4)
            WHEN date LIKE '%/%/%' THEN substr(date, length(date) - 3, 4)
        END AS Year,
        -- Extract and format the month
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 4, 2)
            WHEN date LIKE '%/%/%' THEN
                printf('%02d', cast(substr(date, 1, instr(date, '/') - 1) as integer))
        END AS Month,
        Confirmed,
        Deaths,
        Recovered
    FROM
        CoronaVirusDataset
    ) AS subquery
GROUP BY
    Year,
    Month;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT
    Year,
    MIN(Confirmed) AS MinConfirmed,
    MIN(Deaths) AS MinDeaths,
    MIN(Recovered) AS MinRecovered
FROM
    (
    SELECT
        -- Extract and format the year
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4)
            WHEN date LIKE '%/%/%' THEN substr(date, length(date) - 3, 4)
        END AS Year,
        Confirmed,
        Deaths,
        Recovered
    FROM
        CoronaVirusDataset
    ) AS subquery
GROUP BY
    Year;

-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT
    Year,
    MAX(Confirmed) AS MaxConfirmed,
    MAX(Deaths) AS MaxDeaths,
    MAX(Recovered) AS MaxRecovered
FROM
    (
    SELECT
        -- Extract and format the year
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4)
            WHEN date LIKE '%/%/%' THEN substr(date, length(date) - 3, 4)
        END AS Year,
        Confirmed,
        Deaths,
        Recovered
    FROM
        CoronaVirusDataset
    ) AS subquery
GROUP BY
    Year;

-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT
    Year,
    Month,
    SUM(Confirmed) AS TotalConfirmed,
    SUM(Deaths) AS TotalDeaths,
    SUM(Recovered) AS TotalRecovered
FROM
    (
    SELECT
        -- Extract and format the year
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4)
            WHEN date LIKE '%/%/%' THEN substr(date, length(date) - 3, 4)
        END AS Year,
        -- Extract and format the month
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 4, 2)
            WHEN date LIKE '%/%/%' THEN
                printf('%02d', cast(substr(date, 1, instr(date, '/') - 1) as integer))
        END AS Month,
        Confirmed,
        Deaths,
        Recovered
    FROM
        CoronaVirusDataset
    ) AS subquery
GROUP BY
    Year,
    Month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV ) 
-- Calculate total confirmed cases and average confirmed cases
SELECT
    SUM(Confirmed) AS TotalConfirmedCases,
	 AVG(Confirmed) AS AverageConfirmedCases
FROM
    CoronaVirusDataset;
	
-- Calculate variance of confirmed cases manually
SELECT
    AVG((Confirmed - MeanConfirmed) * (Confirmed - MeanConfirmed)) AS ConfirmedCasesVariance
FROM
    (
    SELECT
        AVG(Confirmed) AS MeanConfirmed
    FROM
        CoronaVirusDataset
    ) AS subquery,
    CoronaVirusDataset;

-- Calculate the Standard variance (STDEV)
/* EXP(0.5 * LOG(ConfirmedCasesVariance)) = 
    EXP(0.5 * LOG(157288925.07798)) = 12541.49 */

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
-- Calculate total Deaths cases and their average per month
SELECT
	Year,
	Month,
    SUM(Deaths) AS TotalDeathsCasesPerMonth,
	AVG(Deaths) As AverageDeathsCasesPerMonth
FROM
    (
    SELECT
        -- Extract and format the year
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4)
            WHEN date LIKE '%/%/%' THEN substr(date, length(date) - 3, 4)
        END AS Year,
        -- Extract and format the month
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 4, 2)
            WHEN date LIKE '%/%/%' THEN
                printf('%02d', cast(substr(date, 1, instr(date, '/') - 1) as integer))
        END AS Month,
        Deaths
    FROM
        CoronaVirusDataset
    ) AS subquery
GROUP BY
    Year,
    Month;
-- Calculate variance of confirmed cases per month
SELECT
	Year,
	Month,
    AVG((Deaths - MeanDeaths) * (Deaths - MeanDeaths)) AS DeathsCasesVariancePerMonth
FROM
    (
    SELECT
        AVG(Deaths) AS MeanDeaths
    FROM
        CoronaVirusDataset
    ) AS subquery,
    (
    SELECT
        -- Extract and format the year
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 7, 4)
            WHEN date LIKE '%/%/%' THEN substr(date, length(date) - 3, 4)
        END AS Year,
        -- Extract and format the month
        CASE 
            WHEN date LIKE '%-%-%' THEN substr(date, 4, 2)
            WHEN date LIKE '%/%/%' THEN
                printf('%02d', cast(substr(date, 1, instr(date, '/') - 1) as integer))
        END AS Month,
        Deaths
    FROM
        CoronaVirusDataset
    ) AS subquery
GROUP BY
    Year,
    Month;
	
-- Calculate the Standard variance (STDEV)
/* EXP(0.5 * LOG(DeathsCasesVariancePerMonth)) */
	
-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
-- Calculate total Recovered cases and average Recovered cases
SELECT
    SUM(Recovered) AS TotalRecoveredCases,
	 AVG(Recovered) AS AverageRecoveredCases
FROM
    CoronaVirusDataset;
	
-- Calculate variance of confirmed cases manually
SELECT
    AVG((Recovered - MeanRecovered) * (Recovered - MeanRecovered)) AS RecoveredCasesVariance
FROM
    (
    SELECT
        AVG(Recovered) AS MeanRecovered
    FROM
        CoronaVirusDataset
    ) AS subquery,
    CoronaVirusDataset;

-- Calculate the Standard variance (STDEV)
/* EXP(0.5 * LOG(RecoveredCasesVariance)) = 
    EXP(0.5 * LOG(107029523.262276)) = 10345.51 */

-- Q14. Find Country having highest number of the Confirmed case
SELECT
	Country_or_Region,
	MAX(Confirmed) AS max_confirmed
FROM 
	CoronaVirusDataset;

-- Q15. Find Country having lowest number of the death case
SELECT
	Country_or_Region,
	MIN(Deaths) AS min_deaths
FROM 
	CoronaVirusDataset;

-- Q16. Find top 5 countries having highest recovered case
SELECT
	Country_or_Region,
	Recovered
FROM 
	CoronaVirusDataset
ORDER BY
	Recovered DESC
LIMIT 5;

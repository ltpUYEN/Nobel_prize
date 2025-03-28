-- Each of following SQL queries were generated to answer key questions about the Nobel Prize dataset

-- Explore the dataset
USE Nobel;


-- 1. Find the top gender and top country
WITH GenderCounts AS (
    SELECT sex, COUNT(*) AS gender_count
    FROM nobel_prizes
    WHERE sex IS NOT NULL  -- Handle potential NULLs
    GROUP BY sex
    ORDER BY gender_count DESC
    LIMIT 1  -- Get only the top gender
), CountryCounts AS (
    SELECT birth_country, COUNT(*) AS country_count
    FROM nobel_prizes
    WHERE birth_country IS NOT NULL
    GROUP BY birth_country
    ORDER BY country_count DESC
    LIMIT 1
)
SELECT
    (SELECT sex FROM GenderCounts) AS top_gender,
    (SELECT birth_country FROM CountryCounts) AS top_country;

-- 2. Find top countries order by the number of Nobel Prizes
SELECT DISTINCT
    birth_country
FROM
    nobel_prizes
WHERE
    birth_country IS NOT NULL AND TRIM(birth_country) <> ''
ORDER BY
    (SELECT COUNT(*) FROM nobel_prizes AS np2 WHERE np2.birth_country = nobel_prizes.birth_country) DESC;
LIMIT 3; 

-- 3. Find number of women won the Nobel prize
SELECT count(DISTINCT full_name)
FROM nobel_prizes
WHERE sex = 'female';

-- 4. Women in nobel
SELECT 
        full_name, 
        category, 
        year 
FROM nobel_prizes
WHERE sex = 'female'
ORDER BY year 

-- 5. Find laureates with multiple prizes
SELECT
    full_name,
    COUNT(*) AS prize_count,
    GROUP_CONCAT(category) AS categories,
    GROUP_CONCAT(year) AS years
FROM
    nobel_prizes
GROUP BY
    full_name
HAVING
    COUNT(*) > 1
ORDER BY
    prize_count DESC;

-- 6. For each category, how many prizes has been awarded for women
SELECT
    all_categories.category,
    COALESCE(prize_counts.prize_count, 0) AS prize_count,
    COALESCE(prize_counts.years, 'None') AS years
FROM
    (SELECT DISTINCT category FROM nobel_prizes) AS all_categories  -- Get all unique categories
LEFT JOIN
    (
        SELECT
            category,
            COUNT(*) AS prize_count,
            GROUP_CONCAT(CAST(year AS CHAR) ORDER BY year SEPARATOR ', ') AS years
        FROM
            nobel_prizes
        WHERE
            sex = 'female'
        GROUP BY
            category
    ) AS prize_counts ON all_categories.category = prize_counts.category
ORDER BY
    prize_count DESC;

-- 7. The overall proportion of female Nobel laureates 
WITH DecadeData AS (
    SELECT
        FLOOR(year / 10) * 10 AS decade,
        CASE
            WHEN sex = 'Female' THEN 1
            ELSE 0
        END AS female_winner
    FROM
        nobel_prizes
    WHERE
        sex IS NOT NULL
), DecadeProportions AS (
    SELECT
        decade,
        AVG(female_winner) * 100 AS proportion_female,
        SUM(female_winner) AS female_count
    FROM
        DecadeData
    GROUP BY
        decade
)
SELECT
    decade,
    proportion_female,
    female_count
FROM
    DecadeProportions
ORDER BY
    decade;

-- 8. Organizations wining Nobel
SELECT
    full_name,
    category,
    year
FROM
    nobel_prizes
WHERE
    sex IS NULL or sex = ''
ORDER BY
    year,
    category;

-- 9. Number of prizes per category
SELECT
    category,
    COUNT(*) AS prize_count
FROM
    nobel_prizes
GROUP BY
    category
ORDER BY
    prize_count DESC;

-- 10. Prize share analysis per decade
WITH DecadeData AS (
    SELECT
        FLOOR(year / 10) * 10 AS decade,
        year,
        category,
        prize_share
    FROM
        nobel_prizes
    WHERE year IS NOT NULL
), DecadeSummary AS (  
    SELECT
        decade,
        GROUP_CONCAT(DISTINCT category ORDER BY category SEPARATOR ', ') AS categories,
        COUNT(*) AS total_prizes,
        SUM(CASE WHEN prize_share = '1/1' THEN 1 ELSE 0 END) AS full_prizes,
        SUM(CASE WHEN prize_share = '1/2' THEN 1 ELSE 0 END) AS half_prizes,
        SUM(CASE WHEN prize_share = '1/3' THEN 1 ELSE 0 END) AS third_prizes,
        SUM(CASE WHEN prize_share = '1/4' THEN 1 ELSE 0 END) AS quarter_prizes
    FROM
        DecadeData
    GROUP BY
        decade
)
SELECT *
FROM DecadeSummary  -- And here
ORDER BY
    decade;

-- Laureate age at award time
 SELECT
    full_name,
    category,
    year,
    birth_date,
    CAST(year AS UNSIGNED) - CAST(SUBSTRING(birth_date, 1, 4) AS UNSIGNED)  AS age_at_award  
FROM
    nobel_prizes
WHERE
    birth_date IS NOT NULL AND year IS NOT NULL AND birth_date <> '' AND full_name IS NOT NULL
ORDER BY
    age_at_award;

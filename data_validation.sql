USE Nobel;

SELECT *
FROM nobel_prizes;

-- 1.Check the structure of the table
SHOW columns FROM nobel_prizes;

ALTER TABLE nobel_prizes
DROP COLUMN `death_country 1`; 

-- 1. Check for Duplicate Rows
SELECT *, COUNT(*) AS row_count
FROM nobel_prizes
GROUP BY year, category, prize, prize_share, motivation, laureate_type, full_name, birth_date, birth_city, birth_country, sex, organization_name, organization_city, organization_country, death_date, death_city, death_country
HAVING COUNT(*) > 1;

-- 2. Check for Duplicate Prize Winners in the Same Year and Category (Partial Duplicates)

SELECT year, category, full_name, COUNT(*) AS prize_count
FROM nobel_prizes
GROUP BY year, category, prize, prize_share, full_name
HAVING COUNT(*) > 1;

-- 3. Check birth_country
SELECT DISTINCT birth_country
FROM nobel_prizes
WHERE birth_country IS NOT NULL 
ORDER BY birth_country;

-- 4. Create the mapping table
CREATE TABLE country_mapping (
    original_name VARCHAR(255) NOT NULL PRIMARY KEY,
    standardized_name VARCHAR(255) NOT NULL
);

-- Insert the mappings
INSERT INTO country_mapping (original_name, standardized_name) VALUES
('United Kindom', 'United Kingdom'),
('United States', 'USA'),
('United States of America', 'USA'),
('W & uuml ; rttemberg ( Germany )', 'Kingdom of Württemberg (Germany)');

UPDATE nobel_prizes
SET birth_country = (
    SELECT standardized_name
    FROM country_mapping
    WHERE original_name = nobel_prizes.birth_country
)
WHERE EXISTS (
    SELECT 1
    FROM country_mapping
    WHERE original_name = nobel_prizes.birth_country
);

-- 5. Check for Unique Values in 'sex'
SELECT DISTINCT sex
FROM nobel_prizes
order by sex;

-- 6. Check Year Range
SELECT MIN(year) AS min_year, MAX(year) AS max_year
FROM nobel_prizes;

-- 7. Check for inconsistent string
SELECT full_name
FROM nobel_prizes
WHERE full_name LIKE '%  %' OR full_name LIKE '%	%';

-- 8. Check the number of rows
SELECT COUNT(*) FROM nobel_prizes;

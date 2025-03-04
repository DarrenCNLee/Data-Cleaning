-- Data Cleaning

SELECT 
    *
FROM
    layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns or rows that are unnecessary

CREATE TABLE layoffs_staging LIKE layoffs;

INSERT layoffs_staging
SELECT *
FROM layoffs;

SELECT 
    *
FROM
    layoffs_staging;

SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

SELECT 
    *
FROM
    layoffs_staging
WHERE
    company = 'Casper';
  
-- Doesn't work in MySQL
WITH duplicate_cte AS 
(
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
WHERE row_num > 1;


CREATE TABLE `layoffs_staging2` (
    `company` TEXT,
    `location` TEXT,
    `industry` TEXT,
    `total_laid_off` INT DEFAULT NULL,
    `percentage_laid_off` TEXT,
    `date` TEXT,
    `stage` TEXT,
    `country` TEXT,
    `funds_raised_millions` INT DEFAULT NULL,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;

SELECT 
    *
FROM
    layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, 
country, funds_raised_millions) AS row_num
FROM layoffs_staging;

DELETE FROM layoffs_staging2 
WHERE
    row_num > 1;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    row_num > 1;


-- Standardizing data 

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company LIKE ' %';
    
SELECT DISTINCT
    TRIM(company)
FROM
    layoffs_staging2;


UPDATE layoffs_staging2 
SET 
    company = TRIM(company);
    
SELECT DISTINCT
    industry
FROM
    layoffs_staging2
ORDER BY industry;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry LIKE ' %';
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry LIKE '% ';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry LIKE '%Crypto%';

UPDATE layoffs_staging2 
SET 
    industry = 'Crypto'
WHERE
    industry LIKE '%Crypto%';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    location LIKE ' %';
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    location LIKE '% ';

SELECT DISTINCT
    country
FROM
    layoffs_staging2
ORDER BY 1;

SELECT DISTINCT
    country
FROM
    layoffs_staging2
WHERE
    country LIKE '%.';
    
SELECT DISTINCT
    country, TRIM(TRAILING '.' FROM country)
FROM
    layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2 
SET 
    country = TRIM(TRAILING '.' FROM country)
WHERE
    country LIKE '%.';
    
SELECT 
    `date`
FROM
    layoffs_staging2;

SELECT 
    `date`
FROM
    layoffs_staging2
WHERE
    `date` IS NULL;
    
SELECT 
    `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM
    layoffs_staging2;
    
UPDATE layoffs_staging2 
SET 
    `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
    
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT 
    *
FROM
    layoffs_staging2;
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry IS NULL OR industry = '';
    
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company LIKE '%Bally%';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    company LIKE '%Airbnb%';

SELECT 
    *
FROM
    layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
        AND t1.location = t2.location
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;
    
SELECT 
    t1.industry, t2.industry
FROM
    layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
        AND t1.location = t2.location
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry = '';

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    industry IS NULL;

UPDATE layoffs_staging2 
SET 
    industry = NULL
WHERE
    industry = '';

UPDATE layoffs_staging2 t1
        JOIN
    layoffs_staging2 t2 ON t1.company = t2.company
        AND t1.location = t2.location 
SET 
    t1.industry = t2.industry
WHERE
    (t1.industry IS NULL OR t1.industry = '')
        AND t2.industry IS NOT NULL;
        
        
-- Delete unnecessary rows and columns
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    total_laid_off IS NULL
        AND percentage_laid_off IS NULL;
    
DELETE FROM layoffs_staging2 
WHERE
    total_laid_off IS NULL
    AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;
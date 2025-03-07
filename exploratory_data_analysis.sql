-- Exploratory Data Analysis

SELECT 
    *
FROM
    layoffs_staging2;
    
SELECT 
    MAX(total_laid_off), MAX(percentage_laid_off)
FROM
    layoffs_staging2;

SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Companies that laid off 100 percent of employees
SELECT 
    *
FROM
    layoffs_staging2
WHERE
    percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

-- Total layoffs by company
SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    MIN(`date`), MAX(`date`)
FROM
    layoffs_staging2;
    
-- Total layoffs by industry
SELECT 
    industry, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Total layoffs by country
SELECT 
    *
FROM
    layoffs_staging;

SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Total layoffs by date
SELECT 
    `date`, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

-- Total layoffs by year
SELECT 
    YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 1 DESC;

-- Total layoffs by stage (e.g. Post-IPO)
SELECT 
    stage, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- Total layoffs by company
SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    SUBSTRING(`date`, 1, 7) AS MONTH, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 DESC;

-- Rolling total of layoffs by month
WITH Rolling_Total AS 
(
SELECT 
    SUBSTRING(`date`, 1, 7) AS MONTH, SUM(total_laid_off) AS total_off
FROM
    layoffs_staging2
WHERE
    SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 DESC
)
SELECT `MONTH`, total_off, SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_total;

SELECT 
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY company ASC;

SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)
ORDER BY 3 DESC;

-- Ranking of companies by total layoffs 
WITH Company_Year (company, years, total_laid_off) AS
(
SELECT 
    company, YEAR(`date`), SUM(total_laid_off)
FROM
    layoffs_staging2
GROUP BY company , YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
ORDER BY RANKING;
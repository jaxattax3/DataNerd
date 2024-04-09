/* This query will filter for the only jobs that we would be interested in applying to
as I am fine relocating anywhere in the US or working remotely and I want them to show their salary on their page*/
SELECT 
    job_id, 
    job_title AS title,
    company_dim.name AS company_name,
    job_location AS location,
    salary_year_avg AS salary,
    job_posted_date AS date_posted

--All columns of information we want from our query

FROM job_postings_fact
INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

--Joining the company table to our job posting table in order to get the company names

WHERE 
    job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL AND
    (job_location LIKE '%,%' OR
    job_location = 'Anywhere')

ORDER BY salary_year_avg DESC


--Filtering for jobs with the title of data analyst that have a shown salary and are either in the US or remote
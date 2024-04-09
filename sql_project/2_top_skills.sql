/* Let's find what skills will be necessary for our job by grouping by the skill names
This way we can find out what is the most necessary for the criteria I have*/
WITH relevant_jobs AS (SELECT 
    job_id AS id, 
    job_title AS title,
    company_dim.name AS company_name,
    job_location AS location,
    salary_year_avg AS salary,
    job_posted_date AS date_posted

FROM job_postings_fact
INNER JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id

WHERE 
    job_title_short = 'Data Analyst' AND 
    salary_year_avg IS NOT NULL AND
    (job_location LIKE '%,%' OR
    job_location = 'Anywhere'))
--First we get the new dataset of relevant jobs that we made before so we can query the jobs that we care about

--Let's find what skills will be necessary in our job search
SELECT
    COUNT(job_id) AS skill_count,
    skills
FROM relevant_jobs
LEFT JOIN skills_job_dim ON relevant_jobs.id = skills_job_dim.job_id
LEFT JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
--Joining the tables so we can get all the relevant data
GROUP BY skills
ORDER BY skill_count DESC
/* Good thing I learned SQL and python as my first two skills as it seams those are the most important, especially sql!*/
/* I wonder how much the skills you need would changed depending on if you need a degree?*/
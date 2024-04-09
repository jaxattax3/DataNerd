/*Since I dont have a college degree let's only take a look at the top paying skills for no degree necessary jobs*/
WITH relevant_jobs AS(
    SELECT 
    job_id, 
    job_title AS title,
    company_dim.name AS company_name,
    job_location AS location,
    salary_year_avg AS salary,
    job_posted_date AS date_posted,
    job_no_degree_mention

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

)


SELECT
    ROUND(AVG(salary)) AS avg_salary,
    sd.skills
FROM relevant_jobs AS rj
LEFT JOIN skills_job_dim AS sjd ON rj.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_no_degree_mention IS TRUE
GROUP BY skills
ORDER BY avg_salary DESC
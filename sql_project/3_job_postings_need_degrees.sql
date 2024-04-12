WITH relevant_jobs AS (
    SELECT 
        job_id,
        company_dim.name AS company_name,
        job_location AS location,
        salary_year_avg AS salary,
        job_posted_date AS date_posted,
        job_no_degree_mention
    FROM job_postings_fact AS jp
    INNER JOIN company_dim ON jp.company_id = company_dim.company_id
    WHERE 
        job_title_short = 'Data Analyst' AND 
        salary_year_avg IS NOT NULL AND
        (job_location LIKE '%,%' OR
        job_location = 'Anywhere')
)

SELECT
    ROUND(CAST((COUNT(job_id)  FILTER(WHERE job_no_degree_mention = FALSE)) AS DECIMAL) * 100.0 / COUNT(job_id),3) AS percent_require_degree,
    ROUND(CAST((COUNT(job_id)  FILTER(WHERE job_no_degree_mention = TRUE)) AS DECIMAL) * 100.0 / COUNT(job_id),3) AS percent_no_degree_required
FROM relevant_jobs;
/* As you can see about 77.5% of jobs require a degree for what I want. I actually expected it to be higher than this so I can definetley find a succesful career without getting a degree */
/*So now it's time to combine what I have done in order to find what skill works best for me to learn.
The only things I really care about are the average salary of the skill and how often I will need to have the skill in order to apply for a job.
Because of part 5 I have determined it is not a neccesity for me to get a degree and will continue my search for only jobs that do not require a degree, now lets write some sql */
WITH relevant_jobs AS (
    SELECT 
        job_id, 
        job_title AS title,
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
        job_location = 'Anywhere')),

total_jobs_no_degree AS (
    SELECT 
        COUNT(job_id) AS total_degree
    FROM relevant_jobs
    WHERE job_no_degree_mention IS TRUE),

skill_frequency AS(
    SELECT
        ROUND((((CAST(COUNT(*) AS DECIMAL))/(SELECT total_degree FROM total_jobs_no_degree)) * 100),3) AS skill_percent,
        COALESCE(sd.skills, 'No Skill Listed') AS skill_name --Sets null values to no skill listed
    FROM relevant_jobs AS rj
    LEFT JOIN skills_job_dim AS sjd ON rj.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE job_no_degree_mention IS TRUE
    GROUP BY skill_name),

skill_salary AS (
    SELECT
        ROUND(AVG(salary)) AS avg_salary,
        COALESCE(sd.skills, 'No Skill Listed') AS skill_name
    FROM relevant_jobs AS rj
    LEFT JOIN skills_job_dim AS sjd ON rj.job_id = sjd.job_id
    LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
    WHERE job_no_degree_mention IS TRUE
    GROUP BY skill_name
    ORDER BY avg_salary DESC
)

/*Now that our previous code is in I will need to think of a metric to tell how worthwhile it is to learn a skill.
 This unit called the Bradbury(My last name and my famous author relative's last name) will be as simple as the square root of the % the skill is present multiplied by the average salary*/

SELECT 
    skill_frequency.skill_name,
    ROUND((SQRT(skill_percent) * avg_salary)) AS bradbury
FROM skill_frequency
LEFT JOIN skill_salary ON skill_frequency.skill_name = skill_salary.skill_name
ORDER BY bradbury DESC 
/*Next up on my journey for Data Mastery is Tableau I guess
Hopefully after that I can give you some better visuals on my project*/
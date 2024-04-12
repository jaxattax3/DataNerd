# Introduction
This project dives into the vast world of Data Analytics, focusing on analyzing job postings to identify valuable skills in the industry. Leveraging SQL and a dataset of job postings from various websites, I embarked on a journey to understand the landscape of Data Analytics roles, particularly those not requiring a degree.

To check out the code results click [here](/sql_project/)

# Background
The motivation behind this project was to streamline my learning path in Data Analytics. With an abundance of skills and technologies available, I aimed to use data-driven insights to prioritize which skills would be most beneficial to learn next.

This data was gathered through multiple job sites and gives many data points on what job listings for data driven jobs might need. Data points include, job title, job posting date, salary, skills required, company etc.

### Questions I want to answer
These are the questions I wanted to answer when I started this project

    1. What data will be relevant to my needs and what will be irrelevant
    2. What skills are most prevelant in my relevant data
    3. How does having a degree effect what skills you need to know 
    4. How does knowing certain skills affect your likely pay
    5. What skill should I learn next

# Tools Used
**PostgreSQL**:  Used for querying and analyzing the dataset.PostgreSQL: At the core of this project was PostgreSQL, an open-source relational database that offered more than just data storage. It provided a versatile platform for executing complex SQL queries, making it indispensable for analyzing and extracting meaningful insights from our dataset.

**Visual Studio Code (VS Code)**: VS Code served as the primary text editor, offering a straightforward yet powerful environment for writing SQL. Its user-friendly interface and extension support enhanced productivity, making the process of coding and debugging more efficient and less cumbersome.

**Git and GitHub**: Git provided reliable version control, allowing for smooth transitions between different phases of the project and safe experimentation. GitHub complemented this by hosting the project online, facilitating easy access to the project's history and enabling potential collaboration.

These tools were essential in navigating the project's challenges, supporting a structured approach to data analysis while encouraging best practices in code management and collaboration.

# Analysis

#### What data will be relevant to my needs and what will be irrelevant

```sql
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

```
What we can see here from the results is the data that we will use for the rest of our searches. This is the only data that is relevant to me, the stakeholder in the situation

#### What skills will be prevelant as a data analyst with these new relevant data points

```sql
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
```

## 1. Do I need a degree in order to get a data analysis job? 
```sql
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
```
## 2. What skills would I need if I had a degree
```sql
/* Let's import what we already have and decide how it changes based on if you need a degree*/
--The relevant data for the jobs I care about
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


--Total number of jobs for degree

total_jobs_degree AS (
    SELECT 
        COUNT(job_id) AS total_degree
    FROM relevant_jobs
    WHERE job_no_degree_mention IS FALSE)

--The percent of times a job posting needs a certain skill
SELECT
    ROUND((((CAST(COUNT(*) AS DECIMAL))/(SELECT total_degree FROM total_jobs_degree)) * 100),3) AS skill_count,
    sd.skills
FROM relevant_jobs AS rj
LEFT JOIN skills_job_dim AS sjd ON rj.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_no_degree_mention IS FALSE
GROUP BY skills
ORDER BY skill_count DESC
```
## 3. What skills would I need if I  dont have a degree
```sql
/* Let's import what we already have and decide how it changes based on if you need a degree*/
--The relevant data for the jobs I care about
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


--Total number of jobs for no degree

total_jobs_no_degree AS (
    SELECT 
        COUNT(job_id) AS total_degree
    FROM relevant_jobs
    WHERE job_no_degree_mention IS TRUE)

--The percent of times a job posting needs a certain skill
SELECT
    ROUND((((CAST(COUNT(*) AS DECIMAL))/(SELECT total_degree FROM total_jobs_no_degree)) * 100),3) AS skill_count,
    sd.skills
FROM relevant_jobs AS rj
LEFT JOIN skills_job_dim AS sjd ON rj.job_id = sjd.job_id
LEFT JOIN skills_dim AS sd ON sjd.skill_id = sd.skill_id
WHERE job_no_degree_mention IS TRUE
GROUP BY skills
ORDER BY skill_count DESC
```
## 4. How does knowing certain skills affect my estimated pay?
```sql
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
```
## 5. What skill should I learn next?
```sql
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
```
As I have clearly not yet mastered Tableau here is a visualization of my results
![Final Results](Assets\Final_data.png)


### Key Takeaways

- **SQL Dominates:** SQL emerges as the top skill in the Bradbury score, indicating that it's highly valued and commonly required for Data Analyst roles that do not demand a degree. This highlights the importance of mastering SQL for data manipulation and querying.

- **Programming and Data Visualization:** Python and Tableau also rank highly, underscoring the need for both programming skills and data visualization capabilities in the analytics field. These skills are essential for performing complex data analysis and effectively communicating results.

- **General vs. Specialized Skills:** General skills like Excel appear alongside more specialized tools like Power BI and Azure, suggesting a balanced demand for both foundational and advanced technical abilities in the job market.

# Conclusion
Through this project, I've significantly enhanced my SQL skills to an intermediate level, gaining a practical understanding of complex queries, data type considerations, and function usage in PostgreSQL. I learned how to efficiently analyze job market data to determine valuable skills for my career as a Data Analyst, focusing on roles that do not require a degree.

Looking ahead, I plan to continue refining my SQL skills and start learning Tableau, as it's one of the top skills identified. My journey in SQL has taught me not only about data manipulation but also about structured problem solving and perseverance. These insights have been instrumental in shaping my approach to learning and professional development. By tackling real-world data challenges, I've developed a deeper understanding of the data analytics field and my own capabilities within it. This experience has been empowering, giving me the confidence and tools to forge ahead in my data analytics career. ​
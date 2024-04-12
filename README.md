# Introduction
This project dives into the vast world of Data Analytics, focusing on analyzing job postings to identify valuable skills in the industry. Leveraging SQL and a dataset of job postings from various websites, I embarked on a journey to understand the landscape of Data Analytics roles, particularly those not requiring a degree.

To check out the code results click [here](/sql_project/)

# Background
The motivation behind this project was to streamline my learning path in Data Analytics. With an abundance of skills and technologies available, I aimed to use data-driven insights to prioritize which skills would be most beneficial to learn next.

This data was gathered through multiple job sites and gives many data points on what job listings for data driven jobs might need. Data points include, job title, job posting date, salary, skills required, company etc.

### Questions I want to answer
These are the questions I wanted to answer when I started this project

    1. What data will be relevant to my needs and what will be irrelevant
    2. What skills are most prevelant in
    3. How does knowing certain skills affect your likely pay
    4. How does having a degree effect what skills you need to know
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

#### Do I need a degree in order to get a data analysis job and how does having a degree effect what skills you need to know
```sql

```
```sql

```
```sql

```
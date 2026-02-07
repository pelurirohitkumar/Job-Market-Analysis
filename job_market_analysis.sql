CREATE DATABASE future_jobs_analysis;
USE future_jobs_analysis;
SELECT * FROM future_jobs_dataset;
/* Future Jobs & Skills Analysis
1. Data Understanding
How many total job records are in the dataset?
What columns exist, and what are their data types?
Which columns contain NULL or missing values?
Are there duplicate job records? If yes, how many?
What are the distinct job categories/industries available? */

select count(*) from future_jobs_dataset;
select count(*)  as column_count from information_schema.columns where table_name = 'future_jobs_dataset';
describe future_jobs_dataset;
select * from future_jobs_dataset;
select a.job_id, a.job_title, a.industry, a.location, a.salary_usd,
       a.skills_required, a.remote_option, a.company_size, a.posting_date
from future_jobs_dataset a
union
select b.job_id, b.job_title, b.industry, b.location, b.salary_usd,
       b.skills_required, b.remote_option, b.company_size, b.posting_date
from future_jobs_dataset b;

select distinct job_title,industry from future_jobs_dataset;
/*
2.Job Market Overview
How many jobs exist per industry?
Which job roles appear most frequently?
Which locations/regions have the highest number of future jobs?
What percentage of jobs are remote vs on-site (if available)?
*/
select count(job_title),industry  from future_jobs_dataset  group by industry;
select job_title ,count(*) as job_count from future_jobs_dataset group by job_title order by job_count desc;
select location ,count(job_title) as job_count from future_jobs_dataset group by location order by job_count desc;
select remote_option,round(avg(job_id),2) as avg_of_jobs from future_jobs_dataset group by remote_option order by avg_of_jobs desc;

/*
3.Salary & Compensation Analysis
What is the average, minimum, and maximum salary overall?
Which job roles have the highest average salary?
Which industries pay the most on average?
Identify the top 10 highest-paying future jobs.
*/
select avg(salary_usd) as average_salary,min(salary_usd) as minimum_salary,max(salary_usd) as maximum_salary from future_jobs_dataset;
select job_title as roles_with_high_avg_salary ,avg(salary_usd) as average_salary from future_jobs_dataset  group by roles_with_high_avg_salary order by  average_salary desc;
select industry as industry_with_high_avg_salary ,avg(salary_usd) as average_salary from future_jobs_dataset group by industry_with_high_avg_salary order by average_salary desc;
select job_title as top_10_highest_paying_jobs ,max(salary_usd) as high_salary from future_jobs_dataset group by top_10_highest_paying_jobs order by high_salary limit 10; 

/*
4.Skills Demand Analysis
What are the most frequently required skills?
Which skills are associated with the highest salaries?
Which skills appear most in high-growth jobs?
How many skills are required per job on average?
Identify skill combinations that lead to better pay.
*/
select skills_required , count(*) as skill_count from future_jobs_dataset group by skills_required order by skill_count desc ;
select skills_required , max(salary_usd) as high_salary from future_jobs_dataset group by skills_required order by high_salary desc;
select round(avg(length(skills_required) - length(replace(skills_required, ',', '')) + 1 ), 2) as avg_skills_per_job
from  future_jobs_dataset
where skills_required is not null;
select skills_required,round(avg(salary_usd), 2) as  avg_salary,count(*) as job_count
from future_jobs_dataset
group by skills_required
having count(*) >= 3
order by avg_salary desc;
/*
5.Demand & Growth Trends
Which job roles are expected to grow the fastest?
What industries show the highest future demand?
Which regions show the strongest job growth?
*/
select  posting_date, str_to_date(posting_date, '%Y-%m-%d') as converted_date from future_jobs_dataset;

select * from future_jobs_dataset;
SELECT job_title, year(posting_date) as year,count(*) as job_count
from future_jobs_dataset
group by  job_title, year(posting_date)
order by job_count desc, year;

SELECT industry, year(posting_date) as year,count(*) as job_count
from future_jobs_dataset
group by  industry, year(posting_date)
order by job_count desc, year;

select location, year(posting_date) as year,COUNT(*) as job_count
from future_jobs_dataset
group by  location, year(posting_date)
order by job_count desc, year;
 



#Creating job_data table
create database jobs;
create table job_data (
    ds date,
    job_id int not null,
    actor_id int not null,
    event varchar(50) not null,
    language varchar(50) not null,
    time_spent int not null,
    org char(5)
);
insert into job_data (ds, job_id, actor_id, event, language, time_spent, org)
values ('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
     ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
     ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
     ('2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
     ('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
     ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
     ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
     ('2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');     
select * from job_data;

#Task-1: Jobs reviewed over time
select ds, round((count(job_id)/sum(time_spent))*3600) as num_of_Jobs_Reviewed_per_hour
from job_data
group by ds
order by ds;

#Task-2: Throughout analysis
select round(count(event)/sum(time_spent),2) as 7day_throughput
from job_data;

select ds, round(count(event)/sum(time_spent),2) as daily_throughput
from job_data
group by ds
order by ds;

#Task-4: Duplicate rows detection
select actor_id, count(*) as duplicates
from job_data
group by actor_id
having duplicates>1;

use jobs;
select * from job_data;

#Task-3: Language share analysis
select language, count(language) as language_count,
(count(language) / (select count(*) from job_data)) * 100 as percentage
from job_data
group by language
order by language DESC;
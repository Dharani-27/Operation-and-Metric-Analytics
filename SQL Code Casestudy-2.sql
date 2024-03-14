create database caseStudy2;
use caseStudy2;
show databases;

#Table-1: Users
create table users(
user_id int	not null,
created_at varchar(100),
company_id int not null,
language varchar(50),
activated_at varchar(100),
state varchar(50));

show variables like 'secure_file_priv';

select * from users;

alter table users add column temp_created_at datetime;
update users set temp_created_at=str_to_date(created_at, '%d-%m-%Y %H:%i');
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;

#Table2-events

use caseStudy2;
drop table events;

create table events(
user_id	int not null,
occurred_at	varchar(100),
event_type	varchar(50),
event_name	varchar(100),
location varchar(50),
device varchar(50),
user_type int not null
);

SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv'
INTO TABLE events
FIELDS TERMINATED BY ',' 
ENCLOSED BY "'"
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from events;

alter table events add column temp_occurred_at datetime;
update events set temp_occurred_at=str_to_date(occurred_at, '%d-%m-%Y %H:%i');
alter table events drop column occurred_at;
alter table events change column temp_occurred_at occurred_at datetime;

#Table3-email_events
select * from email_events;


use caseStudy2;
#Task-1: Weekly User Engagemnet
select week(occurred_at) as Week, count(distinct user_id) as Weekly_Active_Users
from events ​
where event_type = "engagement"
group by week(occurred_at);

#Task-2: User Growth Analysis
select months, total_users, round(((total_users/Lag(total_users, 1) over (order by months) - 1)*100),2) as Growth_inc
from(
select extract(month from created_at) as months, count(distinct user_id) as total_users
from users
group by months
order by months) sub;
    
#Task-4: Weekly engagement per device
select * from events;
select extract(week from occurred_at) as week, device, count(distinct user_id) as total_active_users,
count(*) as total_activities
from events
group by week, device
order by week, device;
    
#Task-5: Email engagemnet analysis
select * from email_events;
select action, count(distinct user_id) as distinct_users, count(*) as total_actions
from email_events
group by action
order by action;

#Task-3: Weekly rentention analysis
use caseStudy2;
with users_start as (
select user_id, extract(week from created_at) as start_week
from users
),
user_activity as (
select user_id, extract(week from occurred_at) as activity_week
from events
)
select users_start.start_week as cohort_week,
    user_activity.activity_week as retention_week,
    count(distinct user_activity.user_id) as total_users
from users_start
left join user_activity
on users_start.user_id = user_activity.user_id and user_activity.activity_week >= users_start.start_week
group by users_start.start_week, user_activity.activity_week
order by users_start.start_week, user_activity.activity_week;

With twt_min_max_value as (
SELECT Q1 – 1.5*IQR as min_value, Q3 + 1.5*IQR as max_value from (
Select 
percentile_cont(0.25) within group (order by users) as Q1,
percentile_cont(0.75) within group (order by users) as Q3,
percentile_cont(0.75) within group (order by users) - percentile_cont(0.25) within group (order by users) as IQR from user_data) as a)
select * from user_data 
where users < (select min_value from twt_min_max_value) or users > (select max_value from twt_min_max_value)

With cte as (
Select data_date, users, 
(Select avg (users)
From user_data) as avg,
(Select stddev (users)
From user_data) as stddev 
From user_data
 ),
twt_outlier as (
Select data_date, users, (users – avg)/stddev as z_score
From cte where abs ((users – avg)/stddev) > 2)
UPDATE users_data
SET users = (Select avg (users)
From user_data) 
Where users in (select users from twt_outlier)

Delete from users_data
Where users in (select users from twt_outlier)

Select * from (
Select *,
row_number () over (partition by address order by last_update desc) as stt
 from public.address) a
where stt > 1


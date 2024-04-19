select
case
	when length < 60 then 'short'
	when length between 60 and 120 then 'medium'
	when length >120 then 'long' --- else 'long'
end category,
count (*) as so_luong 
from film 
group by category

select film_id, 
case 
	when rating in ('PG','G') then 1
	else '0'
end TAG 
from film 

select film_id, 
case 
when rating in ('PG','PG-13') OR LENGTH > 210 THEN 'Tier 1'
when description like '%Drama%' and length > 90 then 'tier 2'
when description like '%Drama%' and length <= 90 then 'tier 3'
when rental_rate < 1 then 'tỉer 4'
end as category 

from film
where case when rating in ('PG','PG-13') OR LENGTH > 210 THEN 'Tier 1'
when description like '%Drama%' and length > 90 then 'tier 2'
when description like '%Drama%' and length <= 90 then 'tier 3'
when rental_rate < 1 then 'tỉer 4'
end  is not null 
------------------------
select customer_id,
sum (case 
	when amount > 10 then amount 
	else 0
	end) as hight,
sum (case 
	when amount between 5 and 10 then amount 
	else 0
	end) as medium,
sum (case 
	when amount < 5 then amount 
	else 0
	end) as low
from payment 
group by customer_id
order by  customer_id
---challenge
select 
case when length > 120 then 'long'
when length between 60 and 120 then 'medium'
else 'short'
end as category,
sum (case when rating = 'R' then 1
else 0
end) as r,
sum (case when rating = 'PG' then 1
else 0
end) as pg ,
sum (case when rating = 'PG-13' then 1
else 0
end) as pg_13
from film 
group by category 


--- challenge 
select 
case
	when amount < 20000 then 'low price ticket'
	when amount between 20000 and 150000 then 'mid price ticket'
	else 'high price ticket'
end category, 
count (*) as so_luong 
from bookings.ticket_flights
group by category

select 
case
	when extract (month from scheduled_departure) in (2,3,4) then 'mùa xuân'
	when extract (month from scheduled_departure) in (5,6,7) then 'mùa hè'
	when extract (month from scheduled_departure) in (8,9,10) then 'mùa thu'
	else 'mùa đông'
end category, 
count (*) as so_luong 
from bookings.flights
group by category
--- coalesce, cast
--- string/number/datetime 
select scheduled_arrival, actual_arrival,
coalesce (actual_arrival, '2020-01-01'),
coalesce (actual_arrival, scheduled_arrival),
coalesce (cast (actual_arrival - scheduled_arrival as varchar), 'not arrived')
from flights 

select *, cast (ticket_no as bigint),
cast (amount as varchar)
from bookings. ticket_flights

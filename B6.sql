--- lower, upper, length
select email,
lower (email) as lower_email,
upper (email) as upper_email,
length (email) as length_email
from customer
where length (email) >30
--- challenge
select lower (first_name) as first_name, 
lower (last_name) as last_name
from customer
where length (first_name)>10 or length (last_name) > 10
--- left (), right ()
select first_name, 
right(left (first_name,3),1) from customer
--- challenge
select email,
left(right (email,4),1)
from customer 
--- nối chuỗi
select customer_id, 
first_name,
last_name,
first_name ||' '||last_name as full_name,
concat (first_name,' ',last_name) as full_name 
from customer
--- challenge
select email,
left (email,3) || '***' || right (email,20) as email_n
from customer
--- replace
select email,
replace (email, 'org','com') as email_n
from customer
--- ex3
select ceiling (avg(salary) - avg (replace (salary, '0','')))
from employees
--- position
select email,
position ('@' in email),
left (email,position('@' in email) - 1)
from customer
--- substring
--- lấy ký tự từ 2 đến 4 của first_name
select right(left(first_name,4),3),
substring (first_name from 2 for 3)
from customer 
--- lấy ra thông tin họ của khách hàng qua từ email
select email, last_name,
substring (email from 1 
		   for position('.' in email) - 1) || ',' || last_name
from customer
--- extract
select 
extract (month from rental_date), 
extract (year from rental_date)
from rental
--- 2020 có bao nhiêu đơn hàng cho thuê trong mỗi tháng
select 
extract (month from rental_date), count (*) 
from rental 
where extract (year from rental_date) = 2020
group by extract (month from rental_date)

/* Tháng nào có tổng số tiền thanh toán cao nhất
Ngày nào trong tuần có tổng số tiền thanh toán cao nhất
Số tiền cao nhất mà 1 khách hàng đã chi tiêu trong 1 tuần là bao nhiêu */
select extract (month from payment_date) as month_of_year,
sum (amount) as total_amount 
from payment 
group by extract (month from payment_date)
order by sum (amount) desc 

select extract (DOW from payment_date) as day_of_week,
sum (amount) as total_amount 
from payment 
group by extract (DOW from payment_date)
order by sum (amount) desc 

select customer_id, extract (week from payment_date),
sum (amount) as total_amount 
from payment 
group by customer_id, extract (week from payment_date)
order by sum (amount) desc 
--- to_char
select payment_date, 
extract (day from payment_date),
to_char (payment_date, 'dd-mm-yyyy hh:mm:ss'),
to_char (payment_date, 'month')
from payment
--- interval
select current_date, current_timestamp, customer_id,
extract (day from return_date - rental_date) * 24 + 
extract (hour from return_date - rental_date) || ' giờ'
from rental
--- challenge
select return_date, rental_date, customer_id,
return_date - rental_date
from rental

select customer_id,
avg (return_date - rental_date) as avg
from rental 
group by customer_id
order by avg (return_date - rental_date) desc

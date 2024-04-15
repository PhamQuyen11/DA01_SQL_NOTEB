---GROUP BY
--- tính toán, tổng hợp câu lệnh trên 1 hay nhiều trường ttin sau khi đã đc gom nhóm 
select * from payment;

select customer_id, staff_id, 
sum (amount) as total_amount,
count (*) as count_rental --- có bn đơn hàng trên mỗi khách hàng
from payment 
group by customer_id, staff_id
order by customer_id
--- cú pháp: gom nhóm theo col nào thì tối đa select 1,2 col ấy
select col1, col2,
sum(),
avg(),
min(),
max(),
from table_nm
group by col1, col2;
---challenge1
select film_id,
max (replacement_cost) as max_cost,
min (replacement_cost) as min_cost,
round (avg (replacement_cost),2) as avg_cost, --- làm tròn 2 số thập phân 
sum (replacement_cost) as sum_cost
from film group by film_id order by film_id 

---HAVING
--- khách hàng nào đã trả > 10 trong t1/2020
select * from payment; 

select customer_id,
sum (amount) as total_amt
from payment 
where payment_date between '2020-01-01' and '2020-02-01'
group by customer_id 
having sum(amount) > 10
---Having: lọc trên trường thông tin tổng hợp, sau group by
---Where: lọc trên trường thông tin có sẵn, sau from 

--- challenge2
select customer_id, date(payment_date),
avg (amount) as avg_amt,
count (payment_id)
from payment 
where date(payment_date) in ('2020-04-28','2020-04-29','2020-04-30')
group by customer_id, date(payment_date) 
having count (payment_id) > 1
order by avg (amount) desc

---MATHEMATIC OPERATORS & FUNCTIONS 
--- Cộng: +, Trừ: -, Nhân: *, Chia: /, Số dư: %, luỹ thừa ^
--- giá trị tuyệt đối: ABS(), làm tròn: ROUND(), số nguyên cận dưới:FLOOR(), số nguyên cận trên:CEILING()

select rental_rate, 
film_id, 
rental_rate + 1 as new_rental_rate,
ceiling (rental_rate + 1) as new_rental_rate1
from film

--- challenge 3
select film_id, rental_rate, replacement_cost,
round((rental_rate/replacement_cost)*100,2) as percentage
from film
where round((rental_rate/replacement_cost)*100,2)< 4
--- Tổng kết thứ tự thực hiện câu lệnh
select customer_id,
count (*) as total_record
from payment 
where payment_date >= '2020-01-30'
group by customer_id 
having count (*) <= 15
order by total_record desc 
limit 5

==> select - from - where - group by - having - order by - limit

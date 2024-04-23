---subqueries 
--- nếu trả 1 kết quả dùng =, nếu trả >1 kết quả dùng in
---in where 
select * from payment
where amount > (select avg(amount) from payment)

select * from payment
where customer_id in (select customer_id from customer 
					  where first_name = 'ADAM')
					  
---challenge 
select film_id, title from film
where length > (select avg(length) from film )

select film_id, title from film
where film_id in (select film_id from public.inventory 
group by film_id
having count(*) >=3)

select customer_id, first_name, last_name, email from customer
where customer_id in (select customer_id from payment 
group by customer_id
having sum(amount)>100)

---in from 
select customer.first_name, new_table.so_luong from 
(select customer_id, count (payment_id) as so_luong
from payment
group by customer_id) as new_table 
join customer on new_table.customer_id = customer.customer_id
where so_luong >30 

---in select, lệnh chỉ được trả ra 1 giá trị
select *,
(select avg (amount) from payment),
(select avg (amount) from payment) - amount 
from payment 

---challenge
select payment_id, amount,
(select max(amount) from payment) as max_amount,
(select max(amount) from payment) - amount as diff 
from payment

---correlated subqueries 
---muốn dùng dấu = khi trong subqueries có where 
---in where 

select * from customer as a
where customer_id = ---where exists - chỉ sử dụng trong CS 
(select customer_id
from payment as b
					  where b.customer_id=a.customer_id 
group by customer_id
having sum (amount) > 100)

---in select
select a.customer_id, a.first_name || ' ' || a.last_name,
b.payment_id,
(select max(amount) from payment 
 where customer_id = a.customer_id
group by customer_id)
from customer as a
join payment as b
on a.customer_id = b.customer_id
group by a.customer_id, a.first_name || ' ' || a.last_name,
b.payment_id
order by customer_id 

---where: phải lọc điều kiện, select: hiển thị
/* liệt kê các khoản thanh toán với tổng số hóa đơn và 
tổng số tiền mỗi KH phải trả */
select a.*, b.count_payments,b.sum_amount from payment a 
join (select customer_id,
count (*)  as count_payments,
sum (amount) as sum_amount
from payment
group by customer_id) b 
on a.customer_id = b.customer_id

select a.*, 
(select count (*)
from payment b
 where a.customer_id = b.customer_id
group by customer_id) as count_payments,
(select sum (amount)
from payment b
 where a.customer_id = b.customer_id
group by customer_id) as sum_amount from payment a 

/* Lấy ra ds film có chi phí thay thế lớn nhât trong 
mỗi loại rating + hiển thị cptt trung bình của mỗi loại rating */
select film_id, title, rating, replacement_cost,
(select avg(replacement_cost) from film a
 where a.rating = b.rating
group by rating)
from film as b where replacement_cost = (select max (replacement_cost)
from film c where c.rating = b.rating 
										 group by rating)
										 
---CTE
/* Tìm KH có nhiều hơn 30 hóa đơn
Gồm mã kh, tên kh, số lượng hóa đơn, tổng số tiền, thời gian thuê tb */
with twt_total_payment as (
select customer_id, count (payment_id) as so_luong,
sum (amount) as so_tien from payment
group by customer_id),
twt_avg_rental_time as
(select customer_id, avg (return_date - rental_date) as rental_time
 from rental
 group by customer_id)
 select a.customer_id, a.first_name, b.so_luong, b.so_tien, c.rental_time 
  from customer as a
 join twt_total_payment as b on a.customer_id = b.customer_id
 join twt_avg_rental_time as c on c.customer_id = a.customer_id
 where so_luong > 30 
 
 /* tìm những hóa đơn có số tiền cao hơn tb của KH đó chi tiêu trên mỗi hóa đơn
 Gồm: mã KH, tên KH, số lượng hóa đơn, số tiền, số tiền tb */
 with twt_so_luong as (
 select customer_id, count (payment_id) as so_luong
 from payment group by customer_id ),
 twt_avg_amount as (
 select customer_id, avg (amount) as avg_amount
 from payment group by customer_id )
 select a.customer_id, a.first_name, b.so_luong, d.amount,c.avg_amount
 from customer as a
 join twt_so_luong as b on a.customer_id=b.customer_id
 join twt_avg_amount as c on a.customer_id=c.customer_id
 join payment as d on a.customer_id=d.customer_id 
 where d.amount > c.avg_amount

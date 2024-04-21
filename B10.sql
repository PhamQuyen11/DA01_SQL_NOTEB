--- inner join 
--- cú pháp (table1 inner join table2)
select t1.*, t2.*
from table1 as t1
inner join table2 as t2
on t1.key1=t2.key2;

select a.payment_id, a.customer_id, b. first_name, b.last_name
from payment as a
inner join customer as b
on a.customer_id=b.customer_id;

---challenge
select b.fare_conditions, 
count (flight_id) as soluong
from boarding_passes as a
inner join seats as b
on a.seat_no = b.seat_no 
group by b.fare_cconditions

--- cú pháp
select t1.*, t2.*
from table1 as t1
left/right join table2 as t2
on t1.key1=t2.key2;

--- B1: xác định bảng
--- B2: xác định key join -> aircraft_code 
--- B3: Chọn phương thức
select a.aircraft_code, b.flight_no from bookings.aircrafts_data as a
left join bookings.flights as b
on a.aircraft_code = b.aircraft_code 
where b.flight_no is null --- nếu là right join thì đổi vị trí 2 bảng 
---challenge
select a.seat_no, 
count (flight_id) as so_luong from seats as a
left join boarding_passes as b
on a.seat_no = b.seat_no 
group by a.seat_no
order by count (flight_id) desc 

select a.seat_no from seats as a
left join boarding_passes as b
on a.seat_no = b.seat_no 
where b.seat_no is null 

select right (a.seat_no,1) as line , 
count (flight_id) as so_luong from seats as a
left join boarding_passes as b
on a.seat_no = b.seat_no 
group by right (a.seat_no,1)
order by count (flight_id) desc

select count (*) from boarding_passes as a
full join tickets as b
on a.ticket_no = b.ticket_no
where b.ticket_no is null 
  
--- join nhiều điều kiện 
--- B1: Xác định input, output - số ghế, giá trung bình

select a.seat_no,
avg (b.amount) as avgamt
from boarding_passes as a
left join ticket_flights as b
on a.ticket_no = b.ticket_no
and a.flight_id = b.flight_id 
group by a.seat_no
order by avg (b.amount) desc 

--- join nhiều bảng 
select a.ticket_no, a.passenger_name, b.amount, c.scheduled_departure, c.scheduled_arrival
from tickets as a
inner join ticket_flights as b
on a.ticket_no = b.ticket_no
inner join flights as c on b.flight_id=c.flight_id 
---challenge
select a.first_name, a.last_name, a.email, d.country 
from customer as a
join address as b on a.address_id = b.address_id 
join city as c on c.city_id = b.city_id 
join country as d on d.country_id=c.country_id 
where d.country = 'Brazil'
--- self join
select emp.employee_id, emp.name as emp_name, emp.manager_id,mng.name as mng_name  
from employee as emp
left join employee as mng
on emp.manager_id = mng.employee_id 
---challenge
select f1.title as title1, f2.title as title2, f1.length from film as f1
join film as f2 on f1.length = f2.length 
where f1.title <> f2.title 
---union
select col1, col2,...coln
from table1
union/union all
select col1,col2,...coln
from table2
union/union all
select col1,col2,...coln
from table3 

select first_name, 'actor' as source from actor 
union all 
select first_name, 'customer' as source from customer
order by first_name 

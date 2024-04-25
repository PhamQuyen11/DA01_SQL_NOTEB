---WINDOW FUNCTION with SUM(), COUNT(), AVG()
SELECT payment_date,customer_id,amount,
SUM(amount) OVER(PARTITION BY customer_id ORDER BY payment_date)  AS total_amount
FROM payment
SELECT payment_date,customer_id,amount,
SUM(amount) OVER(PARTITION BY customer_id)  AS total_amount
FROM payment
/* cú pháp
select col1, col2,...
AGG(cole) over(partition by col1, col2 order by col3 --lũy kế) 
from table_name */
SELECT a.film_id,a.title,a.length, c.name as category,
AVG(a.length) OVER(PARTITION BY c.name)
FROM film a
JOIN public.film_category b on a.film_id=b.film_id
join public.category c on c.category_id=b.category_id

SELECT *,
COUNT(*) OVER(PARTITION BY customer_id,amount) as sd
FROM payment
order by payment_id

SELECT A.film_id, C.name as category, a.length,
RANK() OVER(PARTITION BY C.name ORDER BY a.length DESC) AS rank1,
DENSE_RANK() OVER(PARTITION BY C.name ORDER BY a.length DESC) as rank2,
ROW_NUMBER() OVER(PARTITION BY C.name ORDER BY a.length DESC, a.film_id) as rank3
FROM film a 
JOIN film_category B ON A.film_id=B.film_id
JOIN category C ON C.category_id =b.category_id 

SELECT * FROM
(
select a.first_name|| ' '||a.last_name AS full_name,
d.country,
count(*) as so_luong,
sum(e.amount) as amount,
RANK() OVER(PARTITION BY d.country ORDER BY sum(e.amount) DESC) AS stt
from customer a
JOIN address b on a.address_id=b.address_id
JOIN city c on c.city_id=b.city_id
JOIN country d on d.country_id=c.country_id
JOIN payment e on e.customer_id=a.customer_id
GROUP BY a.first_name|| ' '||a.last_name,
d.country) T
WHERE T.stt<= 3  

SELECT * FROM
(SELECT 
customer_id,payment_date,amount,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY payment_date DESC) AS stt
FROM payment) AS a
WHERE stt=1;

SELECT 
customer_id,payment_date,amount,
FIRST_VALUE(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) AS stt,
FIRST_VALUE(amount) OVER(PARTITION BY customer_id ORDER BY payment_date desc ) AS stt_1
FROM payment 

-- WINDOW FUNCTION with LEAD(), LAG()
-- tìm chênh lệch số tiền giữa các lần thanh toán của từng khách hàng
select 
customer_id,
payment_date,
amount,
LEAD (amount,3) OVER(PARTITION BY customer_id ORDER BY payment_date) as next_amount,
LEAD(payment_date,3) OVER(PARTITION BY customer_id ORDER BY payment_date) as next_payment_date,
amount-LEAD(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) as diff
from payment;
select 
customer_id,
payment_date,
amount,
LAG (amount) OVER(PARTITION BY customer_id ORDER BY payment_date) as previous_amount,
LAG(payment_date) OVER(PARTITION BY customer_id ORDER BY payment_date) as previous_payment_date,
amount-LAG(amount) OVER(PARTITION BY customer_id ORDER BY payment_date) as diff
from payment

/*Viết truy vấn trả về doanh thu trong ngày và doanh thu 
của ngày ngày hôm trước
Sau đó tính toán phần trăm tăng trưởng so với ngày hôm trước.*/
with twt_main_payment as
(
SELECT 
date(payment_date) as payment_date,
SUM(amount) as amount
FROM payment
GROUP BY date(payment_date)
)

SELECT payment_date,
amount ,
LAG(payment_date) OVER(ORDER BY payment_date) as previous_payment_date,
LAG(amount) OVER(ORDER BY payment_date) as previous_amount,
ROUND(((amount-LAG(amount) OVER(ORDER BY payment_date) )
 /LAG(amount) OVER(ORDER BY payment_date))*100,2) as percent_diff
FROM twt_main_payment

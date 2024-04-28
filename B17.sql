/* DDL: ảnh hưởng tới cấu trúc đối tượng: create, alter, drop
DML: thao tác trực tiếp trên đối tượng (table): insert, update, delete 
Tables - Views - Functions - Procedures (Tạo báo cáo) */
--- DDL: CREATE - DROP - ALTER
CREATE TABLE manager 
( 
	manager_id INT PRIMARY KEY ,
	user_name VARCHAR(20) UNIQUE, ---với dạng text cần giới hạn ký tự
	first_name VARCHAR (50) ,
	last_name VARCHAR (50) DEFAULT 'no info',
	date_of_birth DATE,
	address_id INT
)
DROP TABLE manager 
---truy vấn dữ liệu lấy ra ds khách hàng và địa chỉ tương ứng 
---sau đó lưu thông tin đo vào bảng đặt tên là customer_info
CREATE GLOBAL TEMP TABLE tmp_customer_info as
(
select customer_id, first_name || ' ' || last_name as full_name,
email,
b.address 
from customer as a
join address as b on a.address_id = b.address_id 
)

select * from tmp_customer_info 
---mang tính chất lưu trữ tạm thời, global temp thì nhiều người truy cập được
---nếu dữ liệu được bổ sung thì bảng vật lý không được update 
CREATE OR REPLACE VIEW view_customer_info as
(
select customer_id, first_name || ' ' || last_name as full_name,
email,
b.address,
a.active 
from customer as a
join address as b on a.address_id = b.address_id 
)
select * from view_customer_info ---cập nhật theo giá trị mới nhất

DROP VIEW view_customer_info
 
---challenge
CREATE OR REPLACE VIEW movies_category as 
(
select a.title, a.length, c.name as category_name   from film a
join public.film_category b on a.film_id = b.film_id 
join public.category c on c.category_id = b.category_id 
)
select * from movies_category
where category_name in ('Action', 'Comedy')

---DDL: ALTER TABLE 
---ADD, DELETE COL
ALTER TABLE manager
DROP first_name

ALTER TABLE manager
ADD column first_name VARCHAR (50)

---RENAME COL
ALTER TABLE manager
RENAME COLUMN first_name TO ten_kh

---ALTER data types
ALTER TABLE manager
ALTER COLUMN ten_kh TYPE text 

---DML: INSERT, UPDATE, DELETE, TRUNCATE 
select * from city;

INSERT INTO city
VALUES (1000, 'A',44,'2020-01-01 16:40:20'),
(1001,'B',33,2020-01-01 16:50:20),...

INSERT INTO city (city, country_id)
VALUES ( 'C',44),
('B',33),...

UPDATE city
SET country_id = 101 where city_id =3

---challenge
UPDATE film 
SET rental_rate = 1.99
where rental_rate = 0.99

ALTER TABLE customer
ADD COLUMN initials VARCHAR(10)

UPDATE customer 
Set initials = left(first_name,1) ||'.'|| left(last_name,1)

select * from customer

---DELETE, TRUNCATE
delete from manager --nếu chạy dòng này=>xóa hết các dòng thông tin
where manager_id = 1

TRUNCATE TABLE manager --xóa hết

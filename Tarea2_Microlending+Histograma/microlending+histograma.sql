-- 1. Cuál es el promedio, en formato human-readable, de tiempo entre cada pago por cliente de la BD Sakila?

create view p1_promedio_payment as
select c.first_name, c.last_name, p.customer_id, avg(age(t.payment_date,t.pago_anterior)) as duration
from customer c join payment p on c.customer_id = p.customer_id 
join(
	select customer_id , payment_id, payment_date, lag(payment_date) 
	over(partition by customer_id
	order by payment_date) as pago_anterior
	from payment p) t on p.customer_id = t.customer_id and p.payment_date = t.payment_date 
where t.pago_anterior is not null
group by c.first_name, c.last_name, p.customer_id
order by p.customer_id ;

--2. ¿Es una distribución normal?
--No hay una distribución normal ya que la moda, mediana y media no son iguales
--Los datos están sesgados a la derecha
select * from histogram('(select c.first_name, c.last_name, p.customer_id, 
extract(epoch from (avg(age(t.payment_date,t.pago_anterior))))/86400 as duration
from customer c join payment p on c.customer_id = p.customer_id 
join(
	select customer_id , payment_id, payment_date, lag(payment_date) 
	over(partition by customer_id
	order by payment_date) as pago_anterior
	from payment p) t on p.customer_id = t.customer_id and p.payment_date = t.payment_date 
group by c.first_name, c.last_name, p.customer_id
order by p.customer_id) as t ' , 'duration'); 



--3.  Análisis de Rental
create view p3_promedio_rental as	
select r.customer_id, avg(age(t.rental_date,t.renta_anterior)) as duration_rental
from rental r 
join(
	select customer_id, rental_id, rental_date, lag(rental_date)
	over(partition by customer_id
	order by rental_date) as renta_anterior
	from rental r) t on r.customer_id = t.customer_id
where t.renta_anterior is not null	
group by r.customer_id
order by r.customer_id ;

select * from histogram('(select r.customer_id, 
extract(epoch from (avg(age(t.rental_date,t.renta_anterior))))/86400 as duration_rental
from rental r 
join(
	select customer_id, rental_id, rental_date, lag(rental_date)
	over(partition by customer_id
	order by rental_date) as renta_anterior
	from rental r) t on r.customer_id = t.customer_id
where t.renta_anterior is not null	
group by r.customer_id
order by r.customer_id) as t','duration_rental');

--Observamos que no es una distribución normal y que también está sesgada a la derecha

--Resta de Promedios:
--Ambos promedios son parecidos ya que casi todos los resultados en la columna diferencia equivalen a 0
create view diferencia as	
select p1.customer_id, p1.first_name , p1.last_name, (p1.duration - p3.duration_rental) as diferencia 
from p1_promedio_payment p1 join p3_promedio_rental p3 on p1.customer_id = p3.customer_id 
order by p1.customer_id ;


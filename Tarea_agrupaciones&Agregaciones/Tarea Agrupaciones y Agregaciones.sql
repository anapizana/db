 --Tarea Agrupaciones y Agregaciones
 
 --1.-C�mo obtenemos todos los nombres y correos de nuestros clientes canadienses para una campa�a

select c.first_name ,c.last_name ,c.email from sakila.customer c join sakila.address a using(address_id) 
join sakila.city ci using(city_id) join sakila.country co using (country_id)
where co.country ='Canada';

--2.-Qu� cliente ha rentado m�s de nuestra secci�n de adultos?

select c.first_name, c.last_name ,f.rating , count(customer_id) as Rentas
from sakila.customer c join sakila.rental r using (customer_id)
join sakila.inventory i using (inventory_id) join sakila.film f using(film_id) 
where f.rating ='NC-17'
group by c.customer_id , f.rating 
order by Rentas desc limit 1;

--3.-Qu� pel�culas son las m�s rentadas en todas nuestras stores?

select distinct on(store_id) f.film_id ,f.title, i.store_id, count(f.film_id) as Rentas 
from sakila.rental r
join sakila.inventory i using(inventory_id) 
join sakila.film f using(film_id)
group by f.film_id ,i.store_id 
order by i.store_id ,Rentas desc;

--4.-Cu�l es nuestro revenue por store?

select s.store_id ,sum(p.amount) as revenue from sakila.payment p 
join sakila.staff s using (staff_id)
group by store_id ;
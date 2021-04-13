/*
Cilindro Mecánico
Se nos ha encargado:
Formular la medida de cilindros donde quepan todas las copias de los Blu-Rays de cada uno de nuestros stores. 

1.Analizamos numero de películas:
Vemos que hay dos tiendas, una con 2,270 películas y otra con 2,311 películas

2.Analizamos peso:
Por el peso sabemos que cada cilindo puede almacenar hasta 100 películas
50kg = 50,000 g => Si 1 pelicula pesa 500 g entonces caben 100  películas por cilindro

3.Analizamos número de cilindros requeridos:
Vemos que requerimos 23 cilindros para la tienda 1 y 24 para la tienda 2

*/

with total_peliculas as(
select i.store_id, count(i.inventory_id) as inventario
from inventory i group by i.store_id)
select tp.store_id, ceiling((tp.inventario::float/100)) as numero_cilindros
from total_peliculas tp
group by tp.store_id, tp.inventario;

/*
4.Eficientamos espacio de los cilindros:
Consideramos que cada espacio por caja mide 30 de altura, 25 de base y 8cm de ancho
Si eficientamos el espacio, se podrían acomodar 10 películas en cada nivel del cilindro con las siguientes características:

Como cada caja mide de ancho 8 cm, imaginamos un decágono con lados de 8cm y calculamos su circunradio:
Así, el círculo interno de cada cilindro tendrá un rádio de: 12.9443cm

Otras características:
Decágono	n = 10 sides
Largo de los lados	a = 8 cm
Radio interno	r = 12.3107 cm
Circunradio	R = 12.9443 cm
Area	A = 492.429 cm2
Perimetro	P = 80 cm
Angulo interior	x = 144 °
Angulo exterior	y = 36 °

Radio del cilindro:
Como cada caja mide 21cm de largo + 12.9443 cm = 33.9443 será el radio del cilindro
*/

with circumradius as(
select 33.9443* (1/(cos(pi()/10))) as circumradius)
select pi()*((c.circumradius)^2)*30 as volumen, c.circumradius*2 as diametro, c.circumradius as circunradio, (2*c.circumradius * sin(pi()/10)) as largo_lados, 
(10*(c.circumradius)^2 * tan(pi()/10)) as area, degrees( ((10-2)*pi()/10)) as angulo_interior,
degrees((2*pi()/10)) as angulo_exterior
from circumradius c;

/*

El cilindro completo tendrá:
Decágono	n = 10 sides
Largo de los lados = 22.0583 cm
radio interno	r = 33.9443 cm
Circunradio		R = 35.6911 cm
Area	A = 4139.01 cm2
Perimetro	P = 246.577 cm
Angulo interior	x = 144 °
Angulo exterior	y = 36 °
Volumen = 120,058.30 cm

Volumen:
Como tenemos 10 niveles, si consideramos un espacio de 2cm entre nivel y 2cm hasta el final del cilindro, 
tendremos un volumen final de: 128,862.2204 cm^3 *10 = 1'288,622
*/

select pi()*(35.6911^2)*32.2 as volumen, 32.2*10 as altura_cm;

/*
 Estos resultados se podrían eficientizar, ya que si las cajas no fueran tan grandes, 
 y tomando en cuenta que cada película mide 20cm*13.5cm*1.5cm
 el cilindro podría tener un radio interno de 2.427 cm y por lo tanto
 un radio completo de 2.427+13.5 = 15.927:
 */

with circumradius_opt as(
select 15.927 * (1/(cos(pi()/10))) as circumradius)
select pi()*(c.circumradius)^2*30 as volumen, c.circumradius*2 as diametro, c.circumradius as circunradio, (2*c.circumradius * sin(pi()/10)) as largo, 
(10*(c.circumradius)^2 * tan(pi()/10)) as area, degrees( ((10-2)*pi()/10)) as angulo_interior,
degrees((2*pi()/10)) as angulo_exterior
from circumradius_opt c;

/*
 Así el circunradio sería de = 16.7466
 El volumen por nivel podría ser de: 26431.7815 cm^3
 Y consideranod los 10 niveles el volumen sería de: 28,369.9805*10 =283,699
 */

select pi()*(16.7466^2)*32.2 as volumen, 32.2*10 as altura_cm;

/*
El volumen desperdicado es de: 1004923 cm^3
 */

select ceil (1288622.204 - 283699.805) as volumen_desperdiciado;






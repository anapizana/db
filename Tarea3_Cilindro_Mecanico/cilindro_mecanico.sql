/*
Cilindro Mec�nico
Se nos ha encargado:
Formular la medida de dichos cilindros de manera tal que quepan todas las copias de los Blu-Rays de cada uno de nuestros stores. 
1.Analizamos numero de pel�culas:
Vemos que hay dos tiendas, una con 2,270 pel�culas y otra con 2,311 pel�culas
2.Analizamos peso:
Por el peso sabemos que cada cilindo puede almacenar hasta 100 pel�culas
50kg = 50,000 g => Si 1 pelicula pesa 500 g entonces caben 100  pel�culas por cilindro
3.Analizamos n�mero de cilindros requeridos:
Vemos que requerimos 23 cilindros para la tienda 1 y 24 para la tienda 2
Consideramos que cada espacio por caja mide 30 de altura, 25 de base y 8cm de ancho
*/

with total_peliculas as(
select i.store_id, count(i.inventory_id) as inventario
from inventory i group by i.store_id)
select tp.store_id, ceiling((tp.inventario::float/100)) as numero_cilindros
from total_peliculas tp
group by tp.store_id, tp.inventario;

/*
4.Eficientamos espacio de los cilindros:
Si eficientamos el espacio, se podr�an acomodar 10 pel�culas en cada nivel del cilindro con las siguientes caracter�sticas:

Como cada caja mide de ancho 8 cm, imaginamos un dec�gono con lados de 8cm y calculamos su Circunradio:
El c�rculo interno del cilindro tendr� un r�dio de: 12.9443cm
Otras caracter�sticas:
Dec�gono	n = 10 sides
Largo de los lados	a = 8 cm
Radio interno	r = 12.3107 cm
Circunradio	R = 12.9443 cm
Area	A = 492.429 cm2
Perimetro	P = 80 cm
Angulo interior	x = 144 �
Angulo exterior	y = 36 �


Como cada caja mide 21cm de largo + 12.9443 cm = 33.9443 ser� el radio del cilindro
*/

with circumradius as(
select 33.9443* (1/(cos(pi()/10))) as circumradius)
select pi()*((c.circumradius)^2)*30 as volumen, c.circumradius*2 as diametro, c.circumradius as circunradio, (2*c.circumradius * sin(pi()/10)) as largo_lados, 
(10*(c.circumradius)^2 * tan(pi()/10)) as area, degrees( ((10-2)*pi()/10)) as angulo_interior,
degrees((2*pi()/10)) as angulo_exterior
from circumradius c;

/*

El cilindro completo tendr�:
Dec�gono	n = 10 sides
Largo de los lados = 22.0583 cm
radio interno	r = 33.9443 cm
Circunradio		R = 35.6911 cm
Area	A = 4139.01 cm2
Perimetro	P = 246.577 cm
Angulo interior	x = 144 �
Angulo exterior	y = 36 �
Volumen = 120,058.30 cm

Como tenemos 10 niveles, sin consideramos un espacio de 2cm entre nivel y 2cm hasta el final del cilindro, 
tendremos un volumen final de: 128,862.2204 cm^3
*/

select pi()*(35.6911^2)*32.2 as volumen, 32.2*10 as altura_cm;

/*
 Estos resultados se podr�an eficientizar, ya que si las cajas no fueran tan grandes, 
 y tomando en cuenta que cada pel�cula mide 20cm*13.5cm*1.5cm
 el cilindro podr�a tener un radio interno de 2.427 cm y por lo tanto
 un radio completo de 2.427+13.5 = 15.927:
 */

with circumradius_opt as(
select 15.927 * (1/(cos(pi()/10))) as circumradius)
select pi()*(c.circumradius)^2*30 as volumen, c.circumradius*2 as diametro, c.circumradius as circunradio, (2*c.circumradius * sin(pi()/10)) as largo, 
(10*(c.circumradius)^2 * tan(pi()/10)) as area, degrees( ((10-2)*pi()/10)) as angulo_interior,
degrees((2*pi()/10)) as angulo_exterior
from circumradius_opt c;

/*
 As� el circunradio ser�a de = 16.7466
 Y el volumen por nivel podr�a ser de: 26431.7815 cm^3
 Y consideranod los 10 niveles el volumen ser�a de: 28,369.9805
 */

select pi()*(16.7466^2)*32.2 as volumen, 32.2*10 as altura_cm;

/*
El volumen desperdicado es de: 100,493 cm^3
 */

select ceil (128862.2204 - 28369.9805) as volumen_desperdiciado;






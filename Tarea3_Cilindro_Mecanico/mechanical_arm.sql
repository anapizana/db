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
Ahora, obtenemos el n�mero de pel�culas por tienda y el n�mero de cilindros necesarios por tienda:
Vemos que requerimos 23 cilindros para la tienda 1 y 24 para la tienda 2
Cada espacio por caja mide 30 de altura, 25 de base y 8cm de ancho
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

A continuaci�n tomo como par�metro el hecho de que la base de las cajas son de 25 cm
Bajo el supuesto de que el centro del c�rculo de un dec�gono de 2 cm de alto, considerar�:
25+(2/1)= 26 cm de radio interno
Con este par�metro, ya puedo calcular lo dem�s: 	 
*/

with circumradius as(
select 26* (1/(cos(pi()/10))) as circumradius)
select pi()*c.circumradius*30 as volumen, c.circumradius*2 as diametro, c.circumradius as circunradio, (2*c.circumradius * sin(pi()/10)) as largo, 
(10*(c.circumradius)^2 * tan(pi()/10)) as area, degrees( ((10-2)*pi()/10)) as angulo_interior,
degrees((2*pi()/10)) as angulo_exterior
from circumradius c;

/*
RESULTADOS:
Decagono	n = 10 sides
largo de los lados	a = 16.895824204111 cm
inradius	r = 26 cm
circunradio	R = 27.338017830195 cm
area	A = 2196.4571465345 cm2
perimetro	P = 168.95824204111 cm
angulo interior	x = 144 *
angulo exterior	y = 36 *
Volumen = 2576.5474793714166
*/
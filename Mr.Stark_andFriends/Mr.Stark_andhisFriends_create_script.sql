create table Marvel (
id_marvel numeric(4) constraint pk_marvel primary key,
nombre varchar(100) not null, 
apellido varchar(100),
correo varchar(100)not null 
);
CREATE SEQUENCE pk_marvel_seq START 1 INCREMENT 1 ;
ALTER TABLE marvel ALTER COLUMN id_marvel SET DEFAULT nextval('pk_marvel_seq');
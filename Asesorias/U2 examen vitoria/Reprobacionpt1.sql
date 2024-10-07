create database EnviosExamen

go

use EnviosExamen

go

create table categorias(

catid int not null,

nombre varchar( 50) not null )

go

create table tamaños(

tamid int not null,

nombre varchar( 50) not null )

go

create table productos(

prodid int not null,

nombre varchar( 50) not null,

precio numeric(12,2) not null,

catid int not null,

tamid int not null )

create table municipios(

munid int not null,

nombre varchar( 50) not null )

go

create table clientes(

cliid int not null,

nombre varchar( 50) not null ,

apellidos varchar( 50 ) not null, 

munid int )

go

create table envios(

folio int not null,

fecha datetime not null,

cliid int not null )

go

create table detalle(

folio int not null,

prodid int not null,

cantidad numeric(12,2) not null,

precio numeric(12,2) not null,

pesounitario numeric(12,2) not null )

go

alter table categorias add constraint pk_categorias  primary key ( catid )

alter table productos add constraint pk_productos  primary key ( prodid )

alter table tamaños add constraint pk_tamaños  primary key ( tamid )

alter table municipios add constraint pk_municipios  primary key ( munid )

alter table clientes add constraint pk_clientes  primary key ( cliid )

alter table envios add constraint pk_envios  primary key ( folio )

alter table detalle add constraint pk_detalle primary key ( folio, prodid )

go

alter table productos add 

constraint fk_products_categorias foreign key ( catid) references categorias( catid ),

constraint fk_products_tamaños foreign key ( tamid ) references tamaños( tamid )

go

alter table clientes add 

constraint fk_clientes_municipios foreign key ( munid ) references municipios( munid ) 

go

alter table envios add 

constraint fk_envios_clientes foreign key ( cliid ) references clientes( cliid ) 

go

alter table detalle  add 

constraint fk_detalles_productos  foreign key ( prodid ) references productos( prodid ),

constraint fk_detalles_envios foreign key ( folio ) references envios( folio )

go

go

insert municipios values( 1 , 'Sinaloa' ) 

insert municipios values( 2 , 'Sonora' ) 

insert municipios values( 3 , 'Jalisco' ) 

go

insert clientes values ( 1, 'Carlos', 'Prez', 1)

insert clientes values ( 2, 'Ana', 'Lara', 2)

insert clientes values ( 3, 'Luis', 'Luna', 1)

insert clientes values ( 4, 'Pedro', 'Soto', 3)

insert clientes values ( 5, 'Juan', 'Prez', 3)

go

insert tamaños values( 1, 'Chico' ) 

insert tamaños values( 2, 'Mediano' ) 

insert tamaños values( 3, 'Grande' ) 

go

insert categorias values( 1, 'Ferretera' )

insert categorias values( 2, 'Carpintera' )

go

insert productos values( 1 , 'Martillo' , 122.23 , 2 , 1 )

insert productos values( 2 , 'Cerrucho' , 422.43 , 2 , 3 )

insert productos values( 3 , 'Taladro' , 765.23 , 1 , 1 )

insert productos values( 4 , 'Manguera' , 321.23 , 1 , 2 )

insert productos values( 5 , 'Pala' , 565.23 , 1 , 3 )

go

insert envios values( 1, '1-1-2021', 1 ) 

insert envios values( 2, '1-1-2021', 2 ) 

insert envios values( 3, '2-1-2021', 3 ) 

insert envios values( 4, '2-1-2021', 2 ) 

insert envios values( 5, '3-1-2021', 3 ) 

go

insert detalle values( 1, 1 , 2 , 122.32 , 12.23 ) 

insert detalle values( 1, 3 , 3 , 345.32 , 2.23 ) 

insert detalle values( 2, 4 , 2 , 123.32 , 3.23 ) 

insert detalle values( 2, 5 , 3 , 564.32 , 5.23 ) 

insert detalle values( 4, 4 , 5 , 455.32 , 2.23 ) 

insert detalle values( 4, 1 , 2 , 321.32 , 1.23 ) 

insert detalle values( 5, 2 , 2 , 122.32 , 12.23 ) 

insert detalle values( 5, 5 , 3 , 345.32 , 2.23 ) 
GO
CREATE VIEW vw_clientes AS
select
C.CLIID,CLINOMBRE=C.NOMBRE,CLIAPELLIDOS=C.APELLIDOS,
M.MUNID,MUNICIPIO=M.NOMBRE
FROM CLIENTES C
INNER JOIN MUNICIPIOS M ON M.MUNID=C.MUNID
GO
CREATE VIEW vw_envios AS
SELECT
E.FOLIO,E.FECHA, VWC.*
FROM ENVIOS E
INNER JOIN vw_clientes VWC ON (VWC.CLIID=E.CLIID)
GO
CREATE VIEW vw_productos AS
SELECT
P.PRODID,NOMBREPRODUCTO=P.NOMBRE, PRECIOPRODUCTO=P.PRECIO,
T.TAMID,NOMBRETAMAO=T.NOMBRE,A.CATID,CATEGORIA=A.NOMBRE
FROM PRODUCTOS P
INNER JOIN CATEGORIAS A ON A.CATID=P.CATID
INNER JOIN TAMAñOS T ON T.TAMID=P.TAMID
GO
CREATE VIEW vw_detalle AS
SELECT
D.CANTIDAD,PRECIODETALLE=D.PRECIO,D.PESOUNITARIO, VWE.*, VWP.*
FROM DETALLE D
INNER JOIN VW_ENVIOS VWE ON (VWE.FOLIO=D.FOLIO)
INNER JOIN VW_PRODUCTOS VWP ON (VWP.PRODID=D.PRODID)
GO
SELECT * FROM vw_clientes
SELECT * FROM vw_envios
SELECT * FROM vw_productos
SELECT * FROM vw_detalle
GO
--CONSULTA CON EL NOMBRE DEL TAMAO DEL PRODUCTO
--Y TOTAL DE PIEZAS QUE CONTIENE.
SELECT NOMBRETAMAÑO, CANTIDAD
FROM vw_detalle
--3.- CONSULTA CON EL NOMBRE DEL CLIENTE, TOTAL ENVIOS REALIZADOS EN 2020, 2021 Y 2022. CADA AO EN UNA COLUMNA
SELECT
CLIENTE = (CLINOMBRE + ' ' + CLIAPELLIDOS), 
'2020' = sum(CASE WHEN YEAR(FECHA) = 2020 THEN 1 ELSE 0 END),
'2021' = sum(CASE WHEN YEAR(FECHA) = 2021 THEN 1 ELSE 0 END),
'2022' = sum(CASE WHEN YEAR(FECHA) = 2022 THEN 1 ELSE 0 END)
FROM  vw_envios
GROUP BY CLINOMBRE, CLIAPELLIDOS
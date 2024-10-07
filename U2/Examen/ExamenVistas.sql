create database RentasExamen

go

use RentasExamen

go

create table paises(
paisid int not null,
nombre varchar( 50) not null )

go

create table estados(
paisid int not null,
edoid int not null,
nombre varchar( 50) not null ,
area int not null)

go

create table clientes(
cliid int not null,
nombre varchar( 50) not null ,
apellidos varchar( 50 ) not null, 
domicilio varchar( 50 ) not null, 
rfc char(13) , 
paisid int not null,
edoid int not null )

go

create table radios(
radid int not null,
nombre varchar( 50) not null ,
descripcion varchar( 200 ) not null,
preciorenta numeric(12,2) not null )

go

create table sucursales(
sucid int not null,
nombre varchar( 50) not null )

go

create table rentas(
sucid int not null,
folio int not null,
fecha datetime not null,
cliid int not null ,
radid int not null ,
importe numeric(12,2) not null  )

go

alter table paises add constraint pk_paises  primary key ( paisid )
alter table estados add constraint pk_estados  primary key ( paisid , edoid )
alter table clientes add constraint pk_clientes  primary key ( cliid )
alter table radios add constraint pk_radios  primary key ( radid )
alter table sucursales add constraint pk_sucursales  primary key ( sucid )
alter table rentas add constraint pk_rentas  primary key ( sucid, folio )

go

alter table estados add 
constraint fk_estados_paises foreign key ( paisid ) references paises( paisid ) 

go

alter table clientes add 
constraint fk_clientes_estados foreign key ( paisid, edoid ) references estados ( paisid,edoid ) 

go

alter table rentas add 
constraint fk_rentas_clientes foreign key ( cliid ) references clientes( cliid ),
constraint fk_rentas_radios foreign key ( radid ) references radios( radid ),
constraint fk_rentas_sucursales foreign key ( sucid ) references sucursales ( sucid )

go

insert paises values( 1,'México')
insert paises values( 2,'USA')
insert paises values( 3,'Colombia')
insert paises values( 4,'Brasil')
insert paises values( 5,'Nicaragua')

go

insert estados values( 1,1 , 'Sinaloa' , 500 )
insert estados values( 1,2 , 'Sonora' , 600)
insert estados values( 1,3 , 'Jalisco' , 1400 )
insert estados values( 2,1 , 'Arizona' ,2000 )
insert estados values( 2,2 , 'Texas' , 3200 )

go

insert clientes values( 1 , 'Pedro', 'Castro', 'Av zapata 23', 'casd670104', 1,1)
insert clientes values( 2 , 'Ana', 'Lara', 'Av Obregón 233', 'vfsd600104', 1,1)
insert clientes values( 3 , 'Luis', 'Soto', 'Av Juárez 12', 'essd900104', 1,2)
insert clientes values( 4 , 'Carlos', 'López', 'Av Castro 67', 'tesd800104', 1,3)
insert clientes values( 5 , 'José', 'Payán', 'Av zapata 87', 'vqsd500104', 1,3)

go

insert sucursales values( 1, 'Centro' ) 
insert sucursales values( 2, 'Plaza Grande' ) 

go

insert radios values ( 1, 'Motorola G20' , 'Radio grande' , 451.26  )
insert radios values ( 2, 'Motorola F10' , 'Radio Mediano' , 342.26  )
insert radios values ( 3, 'Motorola Z' , 'Radio Chico' , 654.26  )

go

insert rentas values( 1 , 1 , '1-1-2021' , 1 , 1 , 456.43 ) 
insert rentas values( 1 , 2 , '2-1-2021' , 2 , 2 , 564.43 ) 
insert rentas values( 1 , 3 , '3-1-2021' , 3 , 1 , 654.43 ) 
insert rentas values( 2 , 1 , '1-1-2021' , 1 , 2 , 456.43 ) 
insert rentas values( 2 , 2 , '2-1-2021' , 2 , 1 , 234.43 ) 
insert rentas values( 2 , 3 , '3-1-2021' , 3 , 3 , 765.43 ) 

-- CREACION DE VISTAS
--* Secuencia de creación de vistas
--! nombre                  tablas utilizadas
--*------------------------------------------------------------------------
--? vw_estados          (estados, paises)
--? vw_clientes         (clientes, vw_estados)
--? vw_rentas           (rentas, radios, sucursales, vw_clientes)
--*------------------------------------------------------------------------
GO
CREATE VIEW vw_estados AS
SELECT 
e.edoid, estado = e.nombre, edoarea = e.area,
p.paisid, pais = p.nombre
FROM estados e 
INNER JOIN paises p ON p.paisid = e.paisid
GO

CREATE VIEW vw_clientes AS
SELECT 
c.cliid, clinombre = c.nombre, cliapellidos = c.apellidos, c.domicilio, c.rfc,
vwe.*
FROM clientes c 
INNER JOIN vw_estados vwe ON (vwe.edoid = c.edoid ) and (vwe.paisid = c.paisid)
GO

CREATE VIEW vw_rentas AS
SELECT
re.folio, re.fecha, re.importe,
vwc.*,
s.sucid, sucursal = s.nombre,
ra.radid, radio = ra.nombre, ra.descripcion, ra.preciorenta
FROM rentas re
INNER JOIN vw_clientes vwc ON vwc.cliid = re.cliid
INNER JOIN radios ra ON ra.radid = re.radid
INNER JOIN sucursales s ON s.sucid = re.sucid
GO

SELECT * FROM vw_estados
SELECT * FROM vw_clientes
SELECT * FROM vw_rentas

--* 2.- NOMBRE DEL PAIS, TOTAL DE ESTADOS QUE CONTIENE Y AREA TOTAL DEL PAIS.
SELECT 
pais, 'total de estados' = count(edoid), 'area total' = SUM(edoarea)
FROM vw_estados
GROUP BY pais

--* 3.- NOMBRE DEL ESTADO Y TOTAL DE CLIENTES QUE CONTIENEN. MOSTRAR SOLO LOS ESTADOS QUE TIENEN ENTRE 5 Y 10 CLIENTES.
SELECT
estado, 'total de clientes' = count(cliid)
FROM vw_clientes
GROUP BY estado
HAVING COUNT(cliid) BETWEEN 5 AND 10

--* 4.- NOMBRE DE LA SUCURSAL, TOTAL DE RENTAS REALIZADOS E IMPORTE TOTAL DE RENTAS.
SELECT
sucursal, 'total de rentas' = count(folio), 'importe total de rentas' = sum(importe)
FROM vw_rentas
GROUP BY sucursal

--* 5.- NOMBRE DEL CLIENTE, TOTAL DE RENTAS REALIZADOS E IMPORTE TOTAL DE LA RENTA. MOSTRAR SOLO LOS CLIENTES QUE SU NOMBRE TENGA 20 LETRAS Y QUE EL IMPORTE TOTAL DE LA RENTA SEA MAYOR A 1000 PESOS.
SELECT
cliente = clinombre + ' ' + cliapellidos, 'total de rentas' = count(folio), 'importe total' = sum(importe)
FROM vw_rentas
WHERE (LEN(clinombre)+LEN(cliapellidos)) = 20
GROUP BY clinombre, cliapellidos
HAVING sum(importe)>1000
--* 6.- CONSULTA CON EL AÑO E IMPORTE TOTAL DE LA RENTA. MOSTRAR SOLO EL PRIMER SEMESTRE DE LOS AÑOS Y QUE EL IMPORTE SEA MAYOR A 500 PESOS.
SELECT
año = YEAR(fecha), 'importe total' = SUM(importe)
FROM vw_rentas
WHERE MONTH(fecha) <= 6
GROUP BY YEAR(fecha)
HAVING SUM(importe) > 500
--* 7.- CONSULTA CON EL DIA DE LA SEMANA EL TOTAL DE RENTAS REALIZADAS EN EL 2020, TOTAL DE RENTAS REALIZADAS EN 2021 Y TOTAL DE RENTAS REALIZADAS EN 2022.
SELECT
'dia de la semana' = DATENAME(DW, fecha), 
'2020' = case when year(fecha) = 2020 then COUNT(folio) else 0 end,
'2021' = case when year(fecha) = 2021 then COUNT(folio) else 0 end,
'2022' = case when year(fecha) = 2022 then COUNT(folio) else 0 end
FROM vw_rentas
GROUP BY DATENAME(DW, fecha)

--* 8.- CONSULTA CON EL AÑO, IMPORTE DE RENTAS EN MEXICO, USA, COLOMBIA, BRASIL Y NICARAGUA, CADA IMPORTE EN UNA SOLA COLUMNA.
SELECT
YEAR(fecha), 
Mexico = sum(case when paisid = 1 then importe else 0 end),
USA = sum(case when paisid = 2 then importe else 0 end),
Colombia = sum(case when paisid = 3 then importe else 0 end),
Brasil = sum(case when paisid = 4 then importe else 0 end),
Nicaragua = sum(case when paisid = 5 then importe else 0 end)
FROM vw_rentas
GROUP BY YEAR(fecha)
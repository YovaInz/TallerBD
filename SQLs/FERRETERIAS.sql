CREATE DATABASE FERRETERIAS
go
USE FERRETERIAS
go
CREATE TABLE ZONAS(
ZONAID INT NOT NULL,
ZONANOMBRE NVARCHAR(50) NOT NULL,
ZONADESCRIPCION NVARCHAR(200) NULL)
GO
SELECT * FROM ZONAS
<<<<<<< HEAD
GO 
CREATE TABLE MUNICIPIOS(
=======
GO CREATE TABLE MUNICIPIOS(
>>>>>>> 779ab5f (CONGRESO.SQL CREATED)
MUNID INT NOT NULL,
MUNNOMBRE NVARCHAR(50)NOT NULL,
LADA NCHAR(3) NULL)
GO
CREATE TABLE COLONIAS(
COLID INT NOT NULL, 
COLNOMBRE NVARCHAR(50) NOT NULL,
COLCP NCHAR(5) NULL,
MUNID INT NOT NULL)
GO
CREATE TABLE FAMILIAS(
FAMID INT NOT NULL,
<<<<<<< HEAD
FAMNOMBRE NVARCHAR(20) NOT NULL,
FAMDESCRIPCION NVARCHAR(200) NOT NULL)
=======
)
>>>>>>> 779ab5f (CONGRESO.SQL CREATED)
GO
CREATE TABLE FERRETERIAS(
FERRID INT NOT NULL,
FERRNOMBRE NVARCHAR(20) NOT NULL,
FERRDOMICILIO NVARCHAR(50) NOT NULL,
FERRTELEFONO NCHAR(10) NOT NULL)
GO
CREATE TABLE EMPLEADOS(
EMPID INT NOT NULL,
EMPNOMBRE NVARCHAR(50) NOT NULL,
EMPAPEPAT NVARCHAR(50) NOT NULL,
EMPAPEMAT NVARCHAR(50) NULL,
EMPDOMICILIO NVARCHAR(50) NOT NULL,
EMPTELEFONO NCHAR(10) NULL,
EMPCELULAR NCHAR(10) NULL,
EMPRFC NCHAR(13) NULL,
EMPCURP NCHAR(18) NULL,
EMPFECHAINGRESO DATETIME NOT NULL,
EMPFECHANACIMIENTO DATETIME NOT NULL,
ZONAID INT NOT NULL,
JEFEID INT NULL)
GO
CREATE TABLE CLIENTES(
CTEID INT NOT NULL, 
CTENOMBRE NVARCHAR(50) NOT NULL,
CTEAPEPAT NVARCHAR(50) NOT NULL,
CTEAPEMAT NVARCHAR(50) NULL,
CTEDOMICILIO NVARCHAR(50) NOT NULL,
CTETELEFONO NCHAR(10) NULL,
CTECELULAR NCHAR(10) NULL,
CTERFC NCHAR(13) NULL,
CTECURP NCHAR(18) NULL,
CTEFECHANACIMIENTO DATETIME NOT NULL,
CTESEXO NCHAR(1) NOT NULL,
COLID INT NOT NULL)
GO
CREATE TABLE ARTICULOS(
ARTID INT NOT NULL,
ARTNOMBRE NVARCHAR(20) NOT NULL,
ARTDESCRIPCION NVARCHAR(200)NOT NULL,
ARTPRECIO NUMERIC(10,2)NOT NULL,
FAMID INT NOT NULL)
GO
CREATE TABLE VENTAS(
FOLIO INT NOT NULL,
FECHA DATETIME NOT NULL,
FERRID INT NOT NULL,
CTEIT INT NOT NULL,
EMPID INT NOT NULL)
GO
CREATE TABLE DETALLE(
FOLIO INT NOT NULL,
ARTID INT NOT NULL,
CANTIDAD NUMERIC(7,2) NOT NULL, ---->-+99,999.99
PRECIO NUMERIC(10,2) NOT NULL) ---->-+99,999,999.99
GO
<<<<<<< HEAD
-- creamos la llave primaria de zonas
alter table zonas add constraint pk_zonas primary key(zonaid)
-- eliminamos los registros de zonas
delete zonas
-- se insertan nuevamente las zonas
insert zonas values (1, 'Norte', 'Zona Norte')
insert zonas values (2, 'Sur', 'Zona Sur')
insert zonas values (3, 'Este', 'Zona Este')
insert zonas values (4, 'Oeste', 'Zona Oeste')
insert zonas values (5, 'Suereste', 'Zona Sureste')

-- verificar los datos en la tabla zonas
select * from ZONAS

-- LLAVE PRIMARIA
alter table detalle add constraint pk_detalle primary key(folio, artid)

alter table municipios add constraint pk_municipios primary key(munid)
alter table colonias add constraint pk_colonias primary key(colid)
alter table empleados add constraint pk_empleados primary key(empid)
alter table clientes add constraint pk_clientes primary key(cteid)
alter table articulos add constraint pk_articulos primary key(artid)
alter table familias add constraint pk_familias primary key(famid)
alter table ventas add constraint pk_ventas primary key(folio)
alter table ferreterias add constraint pk_ferreterias primary key(ferrid)
go

-- IDENTITY
create database prueba
go 
use prueba
go
create table empresas(
clave int not null identity(100,2),
nombre varchar(100) not null,
domicilio varchar(100)null)

-- es necesario omitir el valor identidad en la insercion
insert empresas values ('tiendas lopez', 'av obregon 43')
insert empresas values ('tiendas LEY', 'av obregon 345')
insert empresas values ('tiendas DEL CENTRO', 'av obregon 37')
select * from empresas
-- no se puede actualizar el valor identidad 
update empresas set clave = 101 where clave = 100

--al eliminar un registro, el contador del identity conntinua, no se reinicia
delete empresas
--el valor continua con 106
insert empresas values ('tiendas lopez', 'av obregon 43')
select * from empresas
-- variable de sistema para mostrar el ultimo valor identity
select @@IDENTITY

-- con truncate table se reinicia el valor identidad
truncate table empresas
-- se reinicia el 100 el valor identity

insert empresas values('tiendas lopez', 'av obregon 43')
select * from empresas

-- CON ESTE PROFESOR NUNCA USES IDENTITY (AUTO INCREMENT)
Create Table ESTADOS(
edoid int not null,
edoNombre VarChar(50) not null)
GO
Create Table MUNICIPIOS(
munid int not null,
munNombre VarChar(50) not null,
edoid int not null)
GO
alter table Estados add CONSTRAINT pk_Estados PRIMARY KEY(edoid)
alter table Municipios add CONSTRAINT FK_Municipios_Estados
FOREIGN KEY (edoid) REFERENCES ESTADOS (edoid)

insert estados values (1, 'Sinaloa')
insert estados values (2, 'Jalisco')
insert estados values (3, 'Colima')

-- SE DEBEN INSERTAR MUNICIPIOS CON UN ESTADO DADO DE ALTA
insert municipios values (100, 'ahome', 1)
insert municipios values (200, 'Guadalajara',2 )

-- MARCA ERROR PORQUE NO EXISTE EL ESTADO 4
insert municipios values (300, 'Hermosillo', 4)

-- no permite eliminar un estado con hijos
delete estados where edoid = 1

-- si permite eliminar un estado sin hijos
delete estados where edoid = 3

-- no permite actualizar un estado que no exista
update municipios set edoid = 4 where munid = 100

delete MUNICIPIOS

-- LLAVES EXTERNAS
USE FERRETERIAS 
GO 
ALTER TABLE ARTICULOS ADD
CONSTRAINT FK_ARTICULOS_FAMILIAS FOREIGN KEY (FAMID) REFERENCES FAMILIAS (FAMID)
GO
ALTER TABLE COLONIAS ADD
CONSTRAINT FK_COLONIAS_MUN FOREIGN KEY (MUNID) REFERENCES MUNICIOS (MUNID)
GO
ALTER TABLE CLIENTES ADD
CONSTRAINT FK_CLIENTES_COL FOREIGN KEY (COLID) REFERENCES COLONIAS (COLID)
GO
ALTER TABLE EMPLEADOS ADD
CONSTRAINT FK_EMP_ZONAS FOREIGN KEY (ZONAID) REFERENCES COLONIAS (ZONAID)
GO
ALTER TABLE VENTAS ADD
CONSTRAINT FK_VENTAS_FERR FOREIGN KEY (FERRID) REFERENCES FERRETERIAS (FERRID),
CONSTRAINT FK_VENTAS_CTE FOREIGN KEY (CTEID) REFERENCES CLIENTES (CTEID),
CONSTRAINT FK_VENTAS_EMP FOREIGN KEY (EMPID) REFERENCES EMPLEADOS (EMPID)
GO
ALTER TABLE DETALLE ADD
CONSTRAINT FK_DETALLE_ARTIC FOREIGN KEY (ARTID) REFERENCES ARTICULOS (ARTID),
CONSTRAINT FK_DETALLE_VENTAS FOREIGN KEY (FOLIO) REFERENCES VENTAS (FOLIO)
GO
-- ASOCIACION UNARIA -->> UN EMPLEADO TIENE A SU CARGO MUCHOS EMPLEADOS
ALTER TABLE EMPLEADOS ADD
CONSTRAINT FK_EMP_EMP FOREIGN KEY (JEFEID) REFERENCES EMPLEADOS (EMPID)
GO

-- LLAVE EXTERNA APUNTANDO HACIA UNA LLAVE UNICA Y NO A UNA LLAVE PRIMARIA
USE PRUEBA
create table envios(
folio int not null,
fecha datetime not null,
clirfc char(13) null)
go
create table clientes(
cliid int not null,
clinombre varchar(50) not null,
clirfc char(13) null)
go
-- creamos las llaves primarias
alter table envios add constraint pk_envios primary key (folio)
alter table clientes add constraint pk_clientes primary key (cliid)

-- creamos el rfc como llave unica
alter table clientes add constraint uc_clientes_rfc unique (clirfc)

-- creamos la llave externa de envios apuntando a una llave unica
alter table envios add constraint fk_envios_clientes foreign key (clirfc) references clientes(clirfc)

-- se insertan valores en las dos tablas
insert clientes values (1, 'Carlos Lopez', 'locm800108r5t')
insert clientes values (2, 'Ana Lara', null)
-- marca error, solo acepta un valor nulo
insert clientes values (3, 'Pedro Castro', null)

-- MARCA ERROR EL RFC NO EXISTE EN CLIENTES
insert envios values (1000, '1-1-2021', 'XXXX800108r5t')
-- INSERCION CORRECTA
insert envios values (1000, '1-1-2021', 'locm800108r5t')
insert envios values (2000, '1-1-2021', null)
insert envios values (3000, '1-1-2021', null)

-- unique constraint
-- Unique constraint
USE FERRETERIAS 
GO
alter table clientes add 
constraint uc_clientes_rfc unique( cterfc ) ,
constraint uc_clientes_curp unique( ctecurp )
go
alter table empleados add 
constraint uc_empleados_rfc unique( emprfc ),
constraint uc_empleados_curp unique( empcurp ) 
go

-- check constraint 
-- check constraint 
alter table clientes add 
constraint cc_clientes_sexo check( ctesexo in ( 'F', 'M') ),
constraint cc_Clientes_rfc_curp check ( cterfc < ctecurp ), 
constraint cc_Clientes_rfc_len check ( len( cterfc ) =13)
go 
alter table empleados add 
constraint cc_emp_rfc_curp check(emprfc < empcurp)
go
alter table detalle add 
constraint cc_detalle_precio check ( precio>0),
constraint cc_detalle_cantidad check ( cantidad > 0 )
go
alter table articulos add 
constraint cc_articulos_precio check ( artprecio > 0)
go 
alter table ventas add 
constraint cc_ventas_fecha check ( fecha > '1-1-2018')

-- default constraint 
-- default constraint
alter table empleados add
constraint dc_empleados_domicilio default ('Sin Domicilio') for empdomicilio,
constraint dc_empleados_telefono default ('Sin telefono') for emptelefon
go
alter table clientes add
constraint dc_clientes_domicilio default ('Sin Domicilio') for ctedomicilio,
constraint dc_clientes_telefono default ('Sin telefono') for ctetelefono
go
alter table colonias add constraint dc_colonias_cp default('00000') for colCP
go

-- se necesita utilizar la palabra reservada DEFAULT u omitir el valor del cp en la tabla calonias
insert MUNICIPIOS values (1,'Culiacán')

insert colonias values (1, 'Col. Obregón', DEFAULT, 1)
insert colonias(colid, colnombre, munid) values (8, 'Col. Lomas', 1)

-- expresamente se guarda NULL en CP
insert colonias values (9, 'Col.Zapata', NULL, 1)

select * from colonias


=======
>>>>>>> 779ab5f (CONGRESO.SQL CREATED)

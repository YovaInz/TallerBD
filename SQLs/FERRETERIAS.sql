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
GO 
CREATE TABLE MUNICIPIOS(
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
FAMNOMBRE NVARCHAR(20) NOT NULL,
FAMDESCRIPCION NVARCHAR(200) NOT NULL)
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
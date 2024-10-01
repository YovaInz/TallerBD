CREATE DATABASE HOSPITALES
GO
USE HOSPITALES
GO
CREATE TABLE ZONAS (
    ZONAID INT NOT NULL,
    NOMBRE NVARCHAR(50) NOT NULL)
GO
CREATE TABLE HOSPITALES (
    ZONAID INT NOT NULL,
    HOSPID INT NOT NULL,
    NOMBRE NVARCHAR(50) NOT NULL)
GO
CREATE TABLE CONSULTORIOS (
    CONID INT NOT NULL,
    NOMBRE NVARCHAR(50) NOT NULL,
    ZONAID INT NOT NULL,
    HOSPID INT NOT NULL)
GO
CREATE TABLE CITAS (
    CONID INT NOT NULL,
    FOLIO INT NOT NULL,
    FECHA DATE NOT NULL,
    PESO INT NULL,
    ALTURA INT NULL,
    PRESION INT NULL,
    OBSERVACIONES NVARCHAR(200) NULL)
GO
--* PRIMARY KEY
ALTER TABLE ZONAS ADD CONSTRAINT pkZonas PRIMARY KEY (ZONAID)
GO
ALTER TABLE HOSPITALES ADD CONSTRAINT pkHospitales PRIMARY KEY (ZONAID, HOSPID)
GO
ALTER TABLE CONSULTORIOS ADD CONSTRAINT pkConsultorios PRIMARY KEY (CONID)
GO
ALTER TABLE CITAS ADD CONSTRAINT pkCitas PRIMARY KEY (CONID, FOLIO)
GO
--* FOREIGN KEY
ALTER TABLE HOSPITALES ADD 
CONSTRAINT fkHospitalesZonas FOREIGN KEY (ZONAID) REFERENCES ZONAS (ZONAID)
GO
ALTER TABLE CONSULTORIOS ADD
CONSTRAINT fkConsultoriosHospital FOREIGN KEY (ZONAID, HOSPID) REFERENCES HOSPITALES (ZONAID, HOSPID)
GO
ALTER TABLE CITAS ADD
CONSTRAINT fkCitasConsultorios FOREIGN KEY (CONID) REFERENCES CONSULTORIOS (CONID)
GO
--* ASIGNACIONES DEFAULT
ALTER TABLE CITAS ADD
CONSTRAINT dcCitasFecha DEFAULT GETDATE() FOR FECHA,
CONSTRAINT dcCitasPeso DEFAULT 0.00 FOR PESO,
CONSTRAINT dcCitasAltura DEFAULT 0.00 FOR ALTURA,
CONSTRAINT dcCitasPresion DEFAULT 'NO SE MIDIO' FOR PRESION
GO
--* ASIGNACIONES CHECK
ALTER TABLE CITAS ADD
CONSTRAINT ccCitasPeso CHECK (PESO >= 0),
CONSTRAINT ccCitasAltura CHECK (ALTURA >= 0)
GO
--* INSERTAR 5 VALORES POR TABLA. SOLO 3 EN ZONAS
insert zonas values( 1, 'Centro')
insert zonas values( 2, 'Norte')
insert zonas values( 3, 'Sur')
go 
insert hospitales values( 1,1 , 'Dr Castro' ) 
insert hospitales values( 1,2 , 'Dr Lopez' ) 
insert hospitales values( 2,1 , 'Dr Casas' ) 
insert hospitales values( 2,2 , 'Dr Lazaro' ) 
insert hospitales values( 2,3 , 'Dr Valle' ) 
go
insert consultorios values(  1, 'Consultorio 1' , 1,1 )
insert consultorios values(  2, 'Consultorio 2' , 1,1 )
insert consultorios values(  3, 'Consultorio 3' , 1,2 )
insert consultorios values(  4, 'Consultorio 4' , 1,2)
insert consultorios values(  5, 'Consultorio 5' , 2,1 )
insert consultorios values(  6, 'Consultorio 6' , 2,1 )
insert consultorios values(  7, 'Consultorio 7' , 2,2 )
go
insert citas values( 1, 1, '1-1-2024', 66, 160, 56, 'Tiene fiebre' ) 
insert citas values( 1, 2, '1-1-2024', 77, 170, 56, 'Tiene fiebre' ) 
insert citas values( 1, 3, '1-1-2024', 88, 150, 56, 'Tiene fiebre' ) 
insert citas values( 1, 4, '2-2-2024', 67, 165, 56, 'Tiene fiebre' ) 

insert citas values( 2, 1, '1-13-2024', 70, 160, 56, 'Tiene fiebre' ) 
insert citas values( 2, 2, '1-14-2024', 60, 170, 56, 'Tiene fiebre' ) 
insert citas values( 2, 3, '1-15-2024', 80, 150, 56, 'Tiene fiebre' ) 
insert citas values( 2, 4, '3-2-2024', 67, 165, 56, 'Tiene fiebre' ) 

insert citas values( 3, 1, '1-13-2024', 88, 160, 56, 'Tiene fiebre' ) 
insert citas values( 3, 2, '1-14-2024', 66, 170, 56, 'Tiene fiebre' ) 
insert citas values( 3, 3, '1-15-2024', 99, 150, 56, 'Tiene fiebre' ) 
insert citas values( 3, 4, '2-2-2024', 67, 165, 56, 'Tiene fiebre' ) 

insert citas values( 4, 1, '3-13-2024', 99, 160, 56, 'Tiene fiebre' ) 
insert citas values( 4, 2, '3-14-2024', 66, 170, 56, 'Tiene fiebre' ) 
insert citas values( 4, 3, '3-15-2024', 88, 150, 56, 'Tiene fiebre' ) 
insert citas values( 4, 4, '3-21-2024', 88, 150, 56, 'Tiene fiebre' ) 

insert citas values( 5, 1, '5-21-2024', 77, 160, 56, 'Tiene fiebre' ) 
insert citas values( 5, 2, '5-22-2024', 60, 170, 56, 'Tiene fiebre' ) 
insert citas values( 5, 3, '5-23-2024', 77, 150, 56, 'Tiene fiebre' ) 
insert citas values( 5, 4, '5-21-2024', 88, 150, 56, 'Tiene fiebre' ) 

insert citas values( 6, 1, '5-21-2024', 99, 170, 56, 'Tiene fiebre' ) 
insert citas values( 6, 2, '5-22-2024', 78, 180, 52, 'Tiene fiebre' ) 
insert citas values( 6, 3, '5-23-2024', 60, 160, 53, 'Tiene fiebre' ) 
insert citas values( 6, 4, '5-18-2024', 60, 160, 53, 'Tiene fiebre' ) 
go
-- CREACION DE FAMILIA DE VISTAS
--* Secuencia de creación de vistas
--! nombre                  tablas utilizadas
--*------------------------------------------------------------------------
--? vw_hospitales           (hospitales, zona)
--? vw_consultorios         (consultorios, vw_hospitales)
--? vw_citas                (citas, vw_consultorios)
--*------------------------------------------------------------------------
-- vw_hospitales (hospitales, zona)
CREATE or alter VIEW vw_hospitales AS
SELECT 
H.HOSPID, HOSPITAL = H.NOMBRE,
Z.ZONAID, ZONA = Z.NOMBRE
FROM HOSPITALES H
INNER JOIN ZONAS Z ON Z.ZONAID = H.ZONAID
GO
-- vw_consultorios (consultorios, vw_hospitales)
CREATE or alter VIEW vw_consultorios AS
SELECT
C.CONID, CONSULTORIO = C.NOMBRE, VWH.*
FROM CONSULTORIOS C
INNER JOIN vw_hospitales VWH on (VWH.HOSPID = C.HOSPID) and (VWH.ZONAID = C.ZONAID)

GO
-- vw_citas (citas, vw_consultorios)
CREATE or alter VIEW vw_citas AS
SELECT
C.FOLIO, C.FECHA, C.PESO, C.ALTURA, C.PRESION, C.OBSERVACIONES, VWC.*
FROM CITAS C
INNER JOIN vw_consultorios VWC ON VWC.CONID = C.CONID
GO
SELECT * FROM vw_hospitales
SELECT * FROM vw_consultorios
SELECT * FROM vw_CITAS 

--* 10 CONSULTAS
--? 1.- NOMBRE DE LA ZONA Y TOTAL DE HOSPITALES DE LA ZONA.
SELECT ZONANOMBRE = Z.NOMBRE, 'HOSPITALES' = COUNT(distinct HOSPID)
FROM ZONAS Z LEFT OUTER JOIN vw_hospitales VWH ON VWH.ZONAID = Z.ZONAID
GROUP BY Z.NOMBRE
GO

--? 2.- NOMBRE DEL CONSULTORIO Y TOTAL DE CITAS REALIZADAS.
SELECT CONOMBRE = C.NOMBRE, 'CITAS' = COUNT(VWC.CONID)
FROM CONSULTORIOS C LEFT OUTER JOIN vw_citas VWC on VWC.CONID = C.CONID
GROUP BY C.NOMBRE
GO

--? 3.- AÑO Y TOTAL DE CITAS REALIZADAS.
SELECT 'AÑO' = YEAR(FECHA), 'TOTAL DE CITAS' = COUNT(*)
FROM vw_citas
GROUP BY YEAR(FECHA)
GO

--? 4.- MES Y TOTAL DE CITAS REALIZADAS. MOSTRAR TODOS LOS MESES, SI NO TIENE CITAS, MOSTAR EN CERO.

--? 5.- NOMBRE DEL HOSPITAL Y TOTAL DE CONSULTORIOS QUE CONTIENE.
SELECT HOSPNOMBRE = H.NOMBRE, CONSULTORIOS = COUNT(CONID)
FROM HOSPITALES H LEFT OUTER JOIN vw_consultorios VWC ON (VWC.HOSPID = H.HOSPID) and (VWC.ZONAID = H.ZONAID)
GROUP BY H.NOMBRE
GO

--? 6.- NOMBRE DEL CONSULTORIO Y PESO TOTAL DE LOS PACIENTES ATENDIDOS EN LAS CITAS.
SELECT CONNOMBRE = C.NOMBRE, 
PESO = SUM(case when PESO IS NOT NULL THEN PESO ELSE 0 END)
FROM CONSULTORIOS C LEFT OUTER JOIN vw_citas VWC ON VWC.CONID = C.CONID
GROUP BY C.NOMBRE
GO

--? 7.- NOMBRE DEL HOSPITAL Y TOTAL DE CITAS REALIZADAS POR MES DEL AÑO 2020.
SELECT HOSPNOMBRE = H.NOMBRE, 
TOTAL = SUM(CASE WHEN YEAR(VWC.FECHA) = 2024 THEN 1 ELSE 0 END),
ENE = SUM(CASE WHEN MONTH(VWC.FECHA) = 1 THEN 1 ELSE 0 END),
FEB = SUM(CASE WHEN MONTH(VWC.FECHA) = 2 THEN 1 ELSE 0 END),
MAR = SUM(CASE WHEN MONTH(VWC.FECHA) = 3 THEN 1 ELSE 0 END),
ABL = SUM(CASE WHEN MONTH(VWC.FECHA) = 4 THEN 1 ELSE 0 END),
MAY = SUM(CASE WHEN MONTH(VWC.FECHA) = 5 THEN 1 ELSE 0 END),
JUN = SUM(CASE WHEN MONTH(VWC.FECHA) = 6 THEN 1 ELSE 0 END),
JUL = SUM(CASE WHEN MONTH(VWC.FECHA) = 7 THEN 1 ELSE 0 END),
AGO = SUM(CASE WHEN MONTH(VWC.FECHA) = 8 THEN 1 ELSE 0 END),
SEP = SUM(CASE WHEN MONTH(VWC.FECHA) = 9 THEN 1 ELSE 0 END),
OCT = SUM(CASE WHEN MONTH(VWC.FECHA) = 10 THEN 1 ELSE 0 END),
NOV = SUM(CASE WHEN MONTH(VWC.FECHA) = 11 THEN 1 ELSE 0 END),
DIC = SUM(CASE WHEN MONTH(VWC.FECHA) = 12 THEN 1 ELSE 0 END)
FROM HOSPITALES H LEFT OUTER JOIN vw_citas VWC ON (VWC.HOSPID = H.HOSPID) and (VWC.ZONAID = H.ZONAID)
WHERE YEAR(VWC.FECHA) = 2024
GROUP BY H.NOMBRE
GO
--? 8.- AÑO, Y TOTAL DE CITAS REALIZADAS POR DIA DE LA SEMANA.
SELECT AÑO = YEAR(FECHA),
TOTAL = SUM(CASE WHEN YEAR(FECHA) = 2024 THEN 1 ELSE 0 END),
DOMINGO = SUM(CASE WHEN DATEPART(DW, FECHA) = 1 THEN 1 ELSE 0 END),
LUNES = SUM(CASE WHEN DATEPART(DW, FECHA) = 2 THEN 1 ELSE 0 END),
MARTES = SUM(CASE WHEN DATEPART(DW, FECHA) = 3 THEN 1 ELSE 0 END),
MIERCOLES = SUM(CASE WHEN DATEPART(DW, FECHA) = 4 THEN 1 ELSE 0 END),
JUEVES = SUM(CASE WHEN DATEPART(DW, FECHA) = 5 THEN 1 ELSE 0 END),
VIERNES = SUM(CASE WHEN DATEPART(DW, FECHA) = 6 THEN 1 ELSE 0 END),
SABADO = SUM(CASE WHEN DATEPART(DW, FECHA) = 7 THEN 1 ELSE 0 END)
FROM vw_citas
GROUP BY YEAR(FECHA)
GO
--? 9.- AÑO Y TOTAL DE CITAS POR ZONA.
SELECT AÑO = YEAR(FECHA), 
TOTAL = SUM(CASE WHEN YEAR(FECHA) = 2024 THEN 1 ELSE 0 END),
CENTRO = SUM(CASE WHEN ZONAID = 1 THEN 1 ELSE 0 END),
NORTE = SUM(CASE WHEN ZONAID = 2 THEN 1 ELSE 0 END),
SUR = SUM(CASE WHEN ZONAID = 3 THEN 1 ELSE 0 END)
FROM vw_citas
GROUP BY YEAR(FECHA)
GO

--? 10.- NOMBRE DE LA ZONA, TOTAL DE HOSPITALES QUE EXISTEN, TOTAL DE CONSULTORIOS QUE EXISTEN EN LA ZONA.
SELECT ZONA, CITAS = COUNT(*), HOSPITALES = COUNT(DISTINCT HOSPID), CONSULTORIOS = COUNT(DISTINCT CONID)
FROM vw_citas
GROUP BY ZONA
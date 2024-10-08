-- CREATE DATABASE BODEGAS
-- GO
-- USE BODEGAS
-- GO
-- CREATE TABLE TIPOS (
--     TIPOID INT NOT NULL,
--     TIPONOMBRE NVARCHAR(50) NOT NULL)
-- GO
-- CREATE TABLE BODEGAS (
--     BODID INT NOT NULL,
--     BODNOMBRE NVARCHAR(50) NOT NULL,
--     BODDOMICILIO NVARCHAR(50) NOT NULL,
--     TIPOID INT NOT NULL)
-- GO
-- CREATE TABLE ARTICULOS (
--     ARTID INT NOT NULL,
--     ARTNOMBRE NVARCHAR(50) NOT NULL,
--     ARTPRECIO NUMERIC(10,2) NOT NULL,
--     ARTPAQUETE INT NULL   -- ARTPAQUETE = ARTID
-- )
-- GO
-- CREATE TABLE ENVIOS (
--     BODID INT NOT NULL,
--     FOLIO INT NOT NULL,
--     FECHA DATE NOT NULL,
--     ARTID INT NOT NULL,
--     CANTIDAD NUMERIC(7,2) NOT NULL,
--     PRECIO NUMERIC(10,2) NOT NULL
-- )
-- GO
-- -- PRIMARY KEYS
-- ALTER TABLE TIPOS ADD CONSTRAINT pkTipos PRIMARY KEY (TIPOID)
-- GO
-- ALTER TABLE BODEGAS ADD CONSTRAINT pkBodegas PRIMARY KEY (BODID)
-- GO
-- ALTER TABLE ENVIOS ADD CONSTRAINT pkEnvios PRIMARY KEY (BODID, FOLIO)
-- GO
-- ALTER TABLE ARTICULOS ADD CONSTRAINT pkArticulos PRIMARY KEY (ARTID)
-- GO
-- -- FOREIGN KEY
-- ALTER TABLE BODEGAS ADD 
-- CONSTRAINT fkBodegasTipos FOREIGN KEY (TIPOID) REFERENCES TIPOS(TIPOID)
-- GO
-- ALTER TABLE ENVIOS ADD
-- CONSTRAINT fkEnviosBodegas FOREIGN KEY (BODID) REFERENCES BODEGAS(BODID),
-- CONSTRAINT fkEnviosArticulos FOREIGN KEY (ARTID) REFERENCES ARTICULOS (ARTID)
-- GO
-- ALTER TABLE ARTICULOS ADD
-- CONSTRAINT fkArticulosPaquete FOREIGN KEY (ARTPAQUETE) REFERENCES ARTICULOS(ARTID)
-- GO

-- -- RESTRICCION UNICA
-- ALTER TABLE BODEGAS ADD CONSTRAINT ucBodegasTipoid UNIQUE (TIPOID)

-- -- RESTRICCION POR DEFECTO
-- ALTER TABLE BODEGAS ADD 
-- CONSTRAINT dcBodegasDomicilio DEFAULT ('SIN DOMICILIO') FOR BODDOMICILIO

-- -- RESTRICCION DE VERIFICACION
-- ALTER TABLE ARTICULOS ADD
-- CONSTRAINT ccArticulosPrecio CHECK (ARTPRECIO >=0)
-- GO
-- ALTER TABLE ENVIOS ADD
-- CONSTRAINT ccEnviosPrecio CHECK (PRECIO >= 0)

--* PREGUNTA 2
USE FERRETERIAS

SELECT 'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT, Z.ZONANOMBRE
FROM EMPLEADOS E
INNER JOIN ZONAS Z ON Z.ZONAID = E.ZONAID
WHERE LEFT(Z.ZONANOMBRE, 1) = RIGHT(Z.ZONANOMBRE,1)
GO

--* PREGUNTA 3
SELECT V.FOLIO, V.FECHA, 'MESES DESDE LA VENTA' = DATEDIFF(MM, V.FECHA, GETDATE()), 
'CLIENTE' = C.CTENOMBRE + ' '+ C.CTEAPEPAT + ' ' + C.CTEAPEMAT, F.FERRNOMBRE
FROM VENTAS V
INNER JOIN CLIENTES C ON C.CTEID = V.CTEID
INNER JOIN FERRETERIAS F ON F.FERRID = V.FERRID
WHERE C.CTETELEFONO LIKE '667%' AND F.FERRTELEFONO LIKE '667%'
GO

--* PREGUNTA 4
SELECT 'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT,'JEFE' = J.EMPNOMBRE + ' ' + J.EMPAPEPAT + ' ' + J.EMPAPEMAT
FROM EMPLEADOS E
INNER JOIN EMPLEADOS J ON J.EMPID = E.JEFEID
WHERE E.ZONAID = J.ZONAID
GO

--* PREGUNTA 5.- Consulta con el nombre del empleado, nombre de su jefe, edad del empleado cuando entro a trabajar, edad del jefe cuando entro a trabajar. Mostrar solo los empleados que no tengan RFC.
SELECT 'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT,
'JEFE' = J.EMPNOMBRE + ' ' + J.EMPAPEPAT + ' ' + J.EMPAPEMAT,
'EDAD DEL EMPLEADO AL INGRESAR' = DATEDIFF(YY, E.EMPFECHANACIMIENTO, E.EMPFECHAINGRESO),
'EDAD DEL JEFE AL INGRESAR' = DATEDIFF(YY, E.EMPFECHANACIMIENTO, E.EMPFECHAINGRESO)
FROM EMPLEADOS E
INNER JOIN EMPLEADOS J ON J.EMPID = E.JEFEID
WHERE E.EMPRFC IS NULL
GO

--* PREGUNTA 6
SELECT D.FOLIO, A.ARTNOMBRE, A.ARTPRECIO, D.CANTIDAD
FROM DETALLE D 
INNER JOIN ARTICULOS A ON A.ARTID = D.ARTID
WHERE A.ARTPRECIO BETWEEN 50 AND 100
GO

--* PREGUNTA 7
SELECT M.MUNNOMBRE, C.COLNOMBRE
FROM COLONIAS C
INNER JOIN MUNICIPIOS M ON M.MUNID = C.MUNID
WHERE C.COLNOMBRE LIKE '%[AEIOU][AEIOU]%'
AND C.COLNOMBRE NOT LIKE '%[AEIOU][AEIOU][AEIOU]%'
GO


-- Realizar la familia de vistas de la base de datos de Ferreterias y Congreso de Estudiantes.

-- * FERRETERIAS
use Ferreterias
--* Secuencia de creación de vistas
--! nombre                  tablas utilizadas
--*------------------------------------------------------------------------
--? vw_colonias             colonias, municipios
--? vw_articulos            articulos, familias
--? vw_empleados            empleados, zonas
--? vw_clientes             clientes, vw_colonias
--? vw_ventas               ventas, ferreterias, vw_empleados, vw_clientes
--? vw_detalle              detalle, vw_articulos, vw_ventas
--*------------------------------------------------------------------------
GO
-- vw_colonias (colonias, municipios)
CREATE VIEW vw_colonias AS
SELECT
C.COLID, C.COLNOMBRE, C.COLCP,
M.MUNID, M.MUNNOMBRE, M.LADA
FROM COLONIAS C
INNER JOIN MUNICIPIOS M ON M.MUNID = C.MUNID
GO

-- vw_articulos (articulos, familias)
CREATE VIEW vw_articulos AS
SELECT
A.ARTID, A.ARTNOMBRE, A.ARTDESCRIPCION, A.ARTPRECIO,
F.FAMID, F.FAMNOMBRE, F.FAMDESCRIPCION
FROM ARTICULOS A 
INNER JOIN FAMILIAS F ON F.FAMID = A.FAMID
GO

-- vw_empleados (empleados, zonas)
CREATE VIEW vw_empleados AS
SELECT 
E.EMPID, E.EMPNOMBRE, E.EMPAPEPAT, E.EMPAPEMAT, E.EMPDOMICILIO, E.EMPTELEFONO,
E.EMPCELULAR, E.EMPRFC, E.EMPCURP, E.EMPFECHAINGRESO, E.EMPFECHANACIMIENTO, E.JEFEID,
Z.ZONAID, Z.ZONANOMBRE, Z.ZONADESCRIPCION
FROM EMPLEADOS E
INNER JOIN ZONAS Z ON Z.ZONAID = E.ZONAID
GO

-- vw_clientes (clientes, vw_colinas)
CREATE VIEW vw_clientes AS
SELECT 
C.CTEID, C.CTENOMBRE, C.CTEAPEPAT, C.CTEAPEMAT, C.CTEDOMICILIO, C.CTETELEFONO, 
C.CTECELULAR, C.CTERFC, C.CTECURP, C.CTEFECHANACIMIENTO, C.CTESEXO, 
VWC.*
FROM CLIENTES C
INNER JOIN vw_colonias VWC ON VWC.COLID = C.COLID
GO

-- vw_ventas (ventas, ferreterias, vw_empleados, vw_clientes)
CREATE VIEW vw_ventas AS
SELECT
V.FOLIO, V.FECHA,
VWE.*, VWC.*,
F.FERRID, F.FERRNOMBRE, F.FERRDOMICILIO, F.FERRTELEFONO
FROM VENTAS V
INNER JOIN vw_empleados VWE ON VWE.EMPID = V.EMPID
INNER JOIN vw_clientes VWC ON VWC.CTEID = V.CTEID
INNER JOIN FERRETERIAS F ON F.FERRID = V.FERRID
GO

-- vw_detalle (detalle, vw_articulos, vw_ventas)
CREATE VIEW vw_detalle AS
SELECT 
D.CANTIDAD, D.PRECIO, VWA.*, VWV.*
FROM DETALLE D
INNER JOIN vw_articulos VWA ON VWA.ARTID = D.ARTID
INNER JOIN vw_ventas VWV ON VWV.FOLIO = D.FOLIO
GO

SELECT * FROM vw_colonias
SELECT * FROM vw_articulos
SELECT * FROM vw_empleados
SELECT * FROM vw_clientes
SELECT * FROM vw_ventas

SELECT * FROM vw_detalle

-- * CONGREOS DE ESTUDIANTES
use CONGRESOS
--* Secuencia de creación de vistas
--! nombre                  tablas utilizadas
--*------------------------------------------------------------------------
--? vw_escuelas             (escuelas, municipios)
--? vw_estudiantes          (estudiantes, vw_escuelas)
--? vw_eventos              (eventos, expositores)
--? vw_registro             (registro, congresos, vw_estudiantes)
--? vw_registroxeventos     (registroxeventos, vw_eventos, vw_registro)
--*------------------------------------------------------------------------
GO
-- vw_escuelas (escuelas, municipios)
CREATE VIEW vw_escuelas AS
SELECT
E.ESCID, E.ESCNOMBRE, E.ESCDOMICILIO, M.*
FROM ESCUELAS E 
INNER JOIN MUNICIPIOS M ON M.MUNID = E.MUNID
GO

-- vw_estudiantes (estudiantes, vw_escuelas)
CREATE VIEW vw_estudiantes AS
SELECT
E.ESTID, E.ESTNOMBRE, E.ESTAPEPAT, E.ESTAPEMAT, E.ESTDOMICILIO, E.ESTCORREO, E.ESTCELULAR, VWE.*
FROM ESTUDIANTES E
INNER JOIN vw_escuelas VWE ON VWE.ESCID = E.ESCID
GO

-- vw_eventos (eventos, expositores)
CREATE VIEW vw_eventos AS
SELECT
E.EVEID, E.EVENOMBRE, E.EVEDESCRIPCION, E.EVEFECHA, E.EVELUGAR, E.EVECOSTO, EX.*
FROM EVENTOS E
INNER JOIN EXPOSITORES EX ON EX.EXPID = E.EXPID
GO

-- vw_registro (registro, congresos, vw_estudiantes)
CREATE VIEW vw_registro AS
SELECT
R.FOLIO, R.FECHA, C.*, VWE.*
FROM REGISTRO R
INNER JOIN CONGRESOS C ON C.CONID = R.CONID
INNER JOIN vw_estudiantes VWE ON VWE.ESTID = R.ESTID
GO

-- vw_registroxeventos (registroxeventos, vw_eventos, vw_registro)
CREATE VIEW vw_registroxeventos AS
SELECT
RE.COSTO, VWE.*, VWR.*
FROM REGISTROXEVENTOS RE
INNER JOIN vw_eventos VWE ON VWE.EVEID = RE.EVEID
INNER JOIN vw_registro VWR ON (VWR.FOLIO = RE.FOLIO) AND (VWR.CONID = RE.CONID)
GO

SELECT * FROM vw_escuelas
SELECT * FROM vw_estudiantes
SELECT * FROM vw_eventos
SELECT * FROM vw_registro

SELECT * FROM vw_registroxeventos
use ferreterias
GO
-- !Nota: escribir el Select, From y Where al inicio del renglón.

--? 1.- Consulta con el folio, fecha de la venta, nombre de la ferretería, mostrar los registros cuyo año sea multiplo de 3 y el mes contenga la letra r.
SELECT V.FOLIO, V.FECHA, F.FERRNOMBRE
FROM VENTAS V 
INNER JOIN FERRETERIAS F ON F.FERRID = V.FERRID
WHERE YEAR(V.FECHA) % 3 = 0 AND DATENAME(MM, V.FECHA) LIKE '%r%'
GO

--? 2.- Consulta con el folio de la venta, fecha de la venta, meses que han pasado desde que se hizo la venta, nombre del cliente y nombre de la ferretería.      
--?     Mostrar solo las ventas de los clientes y ferreterías que sus teléfonos empiece con 667.
SELECT V.FOLIO, V.FECHA, 'MESES DESDE LA VENTA' = DATEDIFF(MM, V.FECHA, GETDATE()), 
'CLIENTE' = C.CTENOMBRE + ' '+ C.CTEAPEPAT + ' ' + C.CTEAPEMAT, F.FERRNOMBRE
FROM VENTAS V
INNER JOIN CLIENTES C ON C.CTEID = V.CTEID
INNER JOIN FERRETERIAS F ON F.FERRID = V.FERRID
WHERE C.CTETELEFONO LIKE '667%' AND F.FERRTELEFONO LIKE '667%'
GO

--? 3.- Consulta con el folio de la venta, nombre del artículo, cantidad de piezas vendidas, precio e importe total. 
--?     Mostrar solo los artículos de las familias que su nombre empieza con las letras Q, R, T, G.
SELECT V.FOLIO, A.ARTNOMBRE, D.CANTIDAD, A.ARTPRECIO, 'IMPORTE TOTAL' = D.PRECIO*D.CANTIDAD
FROM DETALLE D
INNER JOIN VENTAS V ON V.FOLIO = D.FOLIO
INNER JOIN ARTICULOS A ON A.ARTID = D.ARTID
INNER JOIN FAMILIAS F ON F.FAMID = A.FAMID
WHERE F.FAMNOMBRE LIKE '[QRTG]%'
GO

--? 4.- Consulta con el nombre completo del cliente, nombre de la colonia y nombre del municipio. 
--?     Mostrar solo los clientes que el nombre del municipio y nombre la colonia contenga la cadena ‘ASA’.
SELECT 'CLIENTE'=CL.CTENOMBRE + ' ' + CL.CTEAPEPAT + ' ' + CL.CTEAPEMAT, 'COLONIA' = CO.COLNOMBRE, 'MUNICIPIO' = M.MUNNOMBRE
FROM CLIENTES CL
INNER JOIN COLONIAS CO ON CO.COLID = CL.COLID
INNER JOIN MUNICIPIOS M ON M.MUNID = CO.MUNID
WHERE M.MUNNOMBRE LIKE '%ASA%' AND CO.COLNOMBRE LIKE '%ASA%'
GO

--? 5.- Consulta con el folio de la venta, fecha, nombre del empleado y cliente. Mostrar solo los empleados que no tengan RFC y los clientes que no tengan CURP.
SELECT V.FOLIO, V.FECHA, 'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT, 'CLIENTE' = C.CTENOMBRE + ' ' + C.CTEAPEPAT + ' ' + C.CTEAPEMAT
FROM VENTAS V
INNER JOIN EMPLEADOS E ON E.EMPID = V.EMPID
INNER JOIN CLIENTES C ON C.CTEID = V.CTEID
WHERE E.EMPRFC IS NULL AND C.CTECURP IS NULL
GO

--? 6.- Consulta con el nombre del articulo y nombre de la familia. Mostrar solo las familias que su tercera letra sea T, S, B, M.
SELECT A.ARTNOMBRE, F.FAMNOMBRE
FROM ARTICULOS A
INNER JOIN FAMILIAS F ON F.FAMID = A.FAMID
WHERE F.FAMNOMBRE LIKE '__[TSBM]%'
GO

--? 7.- Consulta con el folio de la venta, fecha, nombre del empleado, cliente y ferretería. Mostrar solo las ventas del segundo semestre de 2020.
SELECT V.FOLIO, V.FECHA, 'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT, 'CLIENTE' = C.CTENOMBRE + ' ' + C.CTEAPEPAT + ' ' + C.CTEAPEMAT, F.FERRNOMBRE
FROM VENTAS V
INNER JOIN EMPLEADOS E ON E.EMPID = V.EMPID
INNER JOIN CLIENTES C ON C.CTEID = V.CTEID
INNER JOIN FERRETERIAS F ON F.FERRID = V.FERRID
WHERE MONTH(V.FECHA) > 6 AND YEAR(V.FECHA) = 2020
GO

--? 8.- Consulta con el nombre del empleado, nombre de su jefe. Mostrar solo los empleados y jefes que vivan en la misma zona.
SELECT 'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT, 'JEFE' = J.EMPNOMBRE + ' ' + J.EMPAPEPAT + ' ' + J.EMPAPEMAT
FROM EMPLEADOS E
INNER JOIN EMPLEADOS J ON J.EMPID = E.JEFEID
WHERE E.ZONAID = J.ZONAID
GO

--? 9.- Consulta con el nombre del empleado, nombre de la zona que atiende. Mostrar solo los empleados que la zona en su segunda letra sea la letra o.
SELECT 'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT, Z.ZONANOMBRE
FROM EMPLEADOS E
INNER JOIN ZONAS Z ON Z.ZONAID = E.ZONAID
WHERE Z.ZONANOMBRE LIKE '_O%'
GO

--? 10.- Consulta con el folio de la venta, fecha de la venta, nombre del empleado, edad que tenía el empleado cuando hizo la venta.
SELECT V.FOLIO, V.FECHA,
'EMPLEADO' = E.EMPNOMBRE + ' ' + E.EMPAPEPAT + ' ' + E.EMPAPEMAT, 
'EDAD AL VENDER' = DATEDIFF(YY, E.EMPFECHANACIMIENTO, V.FECHA)
FROM VENTAS V
INNER JOIN EMPLEADOS E ON E.EMPID = V.EMPID
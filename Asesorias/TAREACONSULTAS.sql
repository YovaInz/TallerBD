USE FERRETERIAS
GO
--? 1. Consulta con los 5 artículos más baratos de la familia que empiecen con vocal. 
SELECT TOP 5 *
FROM ARTICULOS A
INNER JOIN FAMILIAS F ON F.FAMID = A.FAMID
ORDER BY A.ARTPRECIO ASC
GO

--? 2. Consulta con el folio de venta, fecha de venta y nombre del cliente. 
--?    Mostrar solo las ventas realizadas los días lunes de los clientes que viven en los municipios que su nombre termine con las letras s,n y vocales. 
SELECT V.FOLIO, V.FECHA,'CLIENTE' = CL.CTENOMBRE + ' ' + CL.CTEAPEPAT + ' ' + CL.CTEAPEMAT
FROM VENTAS V 
INNER JOIN CLIENTES CL ON CL.CTEID = V.CTEID
INNER JOIN COLONIAS CO ON CO.COLID = CL.COLID
INNER JOIN MUNICIPIOS M ON M.MUNID = CO.MUNID
WHERE DATENAME(WEEKDAY, V.FECHA) = 'Lunes' AND M.MUNNOMBRE LIKE '%[AEIOUSN]'
GO

--? 3. Consulta con el folio de la venta, fecha de la venta, domicilio del cliente, del empleado y de la ferreteria, mostrar solo los clientes y empleados que vivan en una avenida. 
SELECT V.FOLIO, V.FECHA, C.CTEDOMICILIO, E.EMPDOMICILIO, F.FERRDOMICILIO
FROM VENTAS V
INNER JOIN CLIENTES C ON C.CTEID = V.CTEID
INNER JOIN EMPLEADOS E ON E.EMPID = V.EMPID
INNER JOIN FERRETERIAS F ON F.FERRID = V.FERRID
WHERE C.CTEDOMICILIO LIKE 'Avenida%' AND E.EMPDOMICILIO LIKE 'Avenida%'
GO

--? 4. Consulta con el folio de venta, nombre del producto, precio, cantidad, mostrar los productos que tengan un precio entre 50 y 100 
SELECT D.FOLIO, A.ARTNOMBRE, A.ARTPRECIO, D.CANTIDAD
FROM DETALLE D
INNER JOIN ARTICULOS A ON A.ARTID = D.ARTID
WHERE A.ARTPRECIO BETWEEN 50 AND 100
GO

--? 5. Consulta con el folio de la venta, fecha de la venta, meses que han pasado desde que se hizo la venta, nombre del cliente y nombre de la ferreteria. 
--?    Mostrar solo las ventas de los clientes y ferreterias que sus telefonos empiecen con 667. 
SELECT V.FOLIO, V.FECHA, 'MESES DESDE LA VENTA' = DATEDIFF(MM, V.FECHA, GETDATE()), 
'CLIENTE' = C.CTENOMBRE + ' ' + C.CTEAPEPAT + ' ' + C.CTEAPEMAT, F.FERRNOMBRE
FROM VENTAS V
INNER JOIN CLIENTES C ON C.CTEID = V.CTEID
INNER JOIN FERRETERIAS F ON F.FERRID = V.FERRID
WHERE C.CTETELEFONO LIKE '667%' AND F.FERRTELEFONO LIKE '667%'
GO
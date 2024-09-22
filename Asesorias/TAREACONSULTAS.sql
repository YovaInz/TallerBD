USE FERRETERIAS
GO
--? 1. Consulta con los 5 artículos más baratos de la familia que empiecen con vocal. 
SELECT TOP 5 *
FROM ARTICULOS A
INNER JOIN FAMILIAS F ON F.FAMID = A.FAMID
ORDER BY A.ARTPRECIO ASC
GO

--? 2. Consulta con el folio de venta, fecha de venta y nombre del cliente. Mostrar solo las ventas 
SELECT V.FOLIO, V.FECHA,'CLIENTE' = C.CTENOMBRE + ' ' + C.CTEAPEPAT + ' ' + C.CTEAPEMAT
FROM VENTAS V LEFT OUTER JOIN CLIENTES C ON C.CTEID = V.CTEID

--? realizadas los días lunes de los clientes que viven en los municipios que su nombre termine con las letras s,n y vocales.  


--? 3. Consulta con el folio de la venta, fecha de la venta, domicilio del cliente, del empleado y de la ferreteria, mostrar solo los clientes y empleados que vivan en una avenida. 


--? 4. Consulta con el folio de venta, nombre del producto, precio, cantidad, mostrar los productos que tengan un precio entre 50 y 100 


--? 5. Consulta con el folio de la venta, fecha de la venta, meses que han pasado desde que se hizo la venta, nombre del cliente y nombre de la ferreteria. 
--?    Mostrar solo las ventas de los clientes y ferreterias que sus telefonos empiecen con 667. 


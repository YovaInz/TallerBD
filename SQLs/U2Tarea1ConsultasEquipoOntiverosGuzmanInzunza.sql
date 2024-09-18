--! Nota: escribir el Select, From y Where al inicio del renglón.
use northwind
GO

SET LANGUAGE Spanish; --* cambia el lenguaje para que datos como las fechas en la consulta 3 no esten en ingles
GO
--? 1.- mostrar el nombre completo del empleado imprimiendo el nombre en un renglon y el apellido en otro
SELECT firstname, lastname
FROM Employees
GO

--? 2.- mostrar los empleados que entraron a trabajar cuando tenían entre 30 y 50 años.
SELECT Firstname, BirthDate, HireDate, 'Edad cuando entró a trabajar' = datediff(yy, BirthDate, HireDate)
FROM Employees
GO

--? 3.- consulta con el nombre del empleado un texto de la siguiente forma cada
--? empleado:
--? 'JOSE PEREZ ENTRO A TRABAJAR UN MARTES 03 DE JUNIO DE 2000 CON UNA EDAD DE 35 AÑOS'
SELECT UPPER(FirstName) + ' ' + UPPER(LastName) + ' ENTRO A TRABAJAR UN ' + UPPER(DATENAME(WEEKDAY, HireDate)) + ' ' + 
DATENAME(DAY, hiredate) + ' DE ' + UPPER(DATENAME(MONTH, HireDate)) + ' DEL ' + 
DATENAME(yy, hiredate) + ' CON UNA EDAD DE ' + 
CAST(DATEDIFF(YY, BirthDate, HireDate) as varchar) + ' AÑOS'
FROM Employees;
GO

--? 4.- consulta con la clave y fecha de la orden que se hayan realizado los días lunes del primer semestre de todos los años.
select OrderID, OrderDate
from orders
where DATENAME(WEEKDAY, OrderDate) = 'Lunes' AND MONTH(OrderDate) <= 6 
GO

--? 5.- Consulta con las claves de la orden y fecha de la orden. mostrar solamente las ordenes que se hayan realizadas los días viernes por los empleados 1,3 y 5.
select OrderID, OrderDate, EmployeeID
from orders
where DATENAME(WEEKDAY, OrderDate) = 'viernes' AND (EmployeeID = 1 or EmployeeID = 3 or EmployeeID = 5)
GO

--? 6.- mostrar en una sola columna la siguiente información de cada orden:
--? 'la orden 1 fue realizada por el cliente ANTON y atendida por el empleado 1’
select 'La orden '+ CONVERT(varchar(10), OrderID) +' fue realizada por el cliente '+ CONVERT(varchar(50), CustomerID) +' y atendida por el empleado '+ CONVERT(varchar(10), EmployeeID)
from orders
GO

--? 7.- consulta con los clientes cuyo nombre empiece con consonante y sea mayor a 10 caracteres.
select *
from Customers
where ContactName like '[^aeiou]%' and len(ContactName) > 10
GO

--? 8.- consulta con los productos que su nombre con empiece  con A, B, N y termine con N
select *
from Products
where ProductName LIKE '[ABN]%N'
GO

--? 9.- consulta con los empleados que su nombre y apellido termine con una letra mayúscula. Modificar la tabla con el siguiente código para que muestre un resultado:
-- update employees set lastname = 'FulleR', FirstName = 'AndreW' where EmployeeID = 2
-- update employees set lastname = 'BuchanaN', FirstName = 'SteveN' where EmployeeID = 5
SELECT *
FROM Employees
WHERE ASCII(RIGHT(FirstName, 1)) BETWEEN 65 AND 90
AND ASCII(RIGHT(LastName, 1)) BETWEEN 65 AND 90;
GO

--? 10.- consulta con todas las ordenes que se hayan realizado en los meses que inicial con vocal.
SELECT * 
FROM Orders
WHERE DATENAME(MONTH, OrderDate) LIKE '[aeiou]%'
GO

--? 11.- consulta con los nombres de producto que tengan solamente 2 vocales juntas.
SELECT ProductName
FROM Products
WHERE ProductName LIKE '%[aeiou][aeiou]%' 
AND ProductName NOT LIKE '%[aeiou][aeiou][aeiou]%' 
GO

--? 12.- consulta con las fechas de las ordenes cuyo año sea múltiplo de 3.
SELECT OrderID, OrderDate
FROM Orders
WHERE YEAR(OrderDate) % 3 = 0
GO

--? 13.- consulta con las ordenes que se hayan realizado en sábado y domingo, y que hayan sido realizadas por los empleados 1,2 y 5.
SELECT EmployeeID, 'Dia' = DATENAME(dw,OrderDate)
FROM Orders
WHERE DATENAME(DW, OrderDate) IN ('Sabado', 'Domingo') AND (EmployeeID = 1 or EmployeeID = 2 or EmployeeID = 5)
GO 

--? 14.- consulta con las ordenes que NO tengan compañía de envío o que se hayan realizado en el mes de enero.
SELECT OrderID, OrderDate, ShipVIA
FROM Orders
WHERE ShipVia = null or MONTH(OrderDate) = 1
GO

--? 15.- consulta con las 10 últimas ordenes de 1997.
SELECT TOP 10 *
FROM Orders
WHERE YEAR(OrderDate) = 1997
ORDER BY OrderDate DESC
GO

--? 16.- consulta con los 10 productos más caros del proveedor 1, 2 y 5.
SELECT TOP 10 *
FROM Products
WHERE SupplierID = 1 or SupplierID = 2 or SupplierID = 5
ORDER BY UnitPrice DESC
GO

--? 17.- consulta con los 4 empleados con mas antigüedad.
SELECT TOP 4 *, 'Antiguedad' = DATEDIFF(yy, HireDate, GETDATE())
FROM Employees
ORDER BY Antiguedad DESC
GO

--? 18.- consulta con empleado con una antigüedad de 10,20 o 30 años y con una edad mayor a 30, o con los empleados que vivan en un blvd y no tengan una región asignada.
SELECT *, 'Antiguedad' = DATEDIFF(yy, HireDate, GETDATE())
FROM Employees
WHERE (DATEDIFF(yy, HireDate, GETDATE()) IN (10,20,30) AND DATEDIFF(yy, BirthDate, GETDATE()) > 30) OR (Address LIKE 'blvd%' AND Region IS null)
GO

--? 19.- consulta con las ordenes el código postal de envío tenga solamente letras.
SELECT OrderID, ShipPostalCode
FROM Orders
WHERE ShipPostalCode NOT LIKE '%[^A-z]%'
GO

--? 20.- consulta con las ordenes que se hayan realizado en 1996 y en los meses que contengan la letra R.
SELECT OrderID, OrderDate, 'Mes' = DATENAME(mm, OrderDate)
FROM Orders
WHERE YEAR(OrderDate) = 1996 AND DATENAME(mm, OrderDate) LIKE '%R%'
GO
use northwind
-- consulta con todos los datos de todos los empleados
select * from employees

-- consulta con el nombre del cliente y su direccion
select companyname, address from customers

--consultacon clave y el nombredel empleado


-- CONCATENAR TEXTO A UN CAMPO DE TEXTO
select nombre = 'el nombre es' + firstname from employees

-- mostra el precio de los productos aumentando 10%, 20%, y 30%
select productname,
'Original' = unitprice,
'10%' = unitprice * 1.1,
'20%' = unitprice * 1.2,
'30%' = unitprice * 1.3
from products

-- imprimir el aumento simulado de 20 pesos a todos los productos
select productname, unitprice,
'aumento 20 pesos' = unitprice + 20
from products

-- FUNCIONES MATEMATICAS
select abs(-21)
select floor(3.9)
select ceiling(3.1)

select round(12.23656,2)
select sign(12.3)
select sign(-12.3)

use Northwind
select rand()
select power(3,4)

-- elevar al cuadrado el precio de los productos
select productname, 'cuadrado' = power(unitprice, 2) from products

-- imprimir la raiz cuadrada del precio de los productos
select productname, unitprice, 'raiz cuadrada' = sqrt(unitprice) from products

--!-----------------------CLASE 2 (11/09/2024)---------------------------
use Northwind
--* concatenacion 
-- mostrar el nombre completo de empleado
select firstname + char(32) + '' + space(1) + lastname from employees

-- mostrar el nombre del empleado como J.Perez
select substring(firstname,1,1) + '.' + space(1) + lastname from employees

-- mostra en mayusculas el nombre completo del empleado
select upper(firstname +  '' + lastname) from employees

-- mostrar la ultima letra del apellido del empleado
select lastname,
apellido = right(lastname, 1),
apellido = substring(lastname, Len(lastname), 1)
from employees

-- no se puede concatenar una cadena de texto con un campo numerico de manera directa
select 'el precio es' + unitprice from products

-- se necesita utilizar la funcion STR para realizar este proceso
select 'el precio es' + LTRIM( STR(unitprice,50,2)) from products

-- se necesita utilizar la función CONVERT para realizar este proceso
select 'el precio es' + CONVERT(varchar(100), unitprice) from products
select 'el precio es' + CAST(unitprice as varchar(10)) from products

-- CONVERT se utiliza para los campos tipo fecha
-- Concatenar el texto 'la fecha de la orden es' a la fecha de la orden
select 'la fecha de la orden es' + CONVERT(varchar(11), orderdate) from orders


-- * Fechas
use Northwind
-- FUNCION QUE REGRESA LA FECHA DEL SERVIDOR
select getdate()

-- Consulta con los años vividos por los empleados (edad)
select employeeid, firstname,  birthdate,
datediff(yy, birthdate, getdate()) ,
year(getdate()) - year(birthdate)
from employees
--*   DATEDIFF(unidad de tiempo, fecha inicial, fecha final) 

-- consulta con el nombre y la antiguedad de los empleados
select firstname, hiredate, Antiguedad = datediff(yy, hiredate, getdate())
from employees

-- consulta con la edad del empleado cuando entró a trabajar
select firstname, birthdate, hiredate, 'Edad cuando entró a trabajar' = datediff(yy, birthdate, hiredate)
from employees

--*
use Northwind
-- consulta con los productos con precio menor a 30
select * from products 
where unitprice <30

-- consulta con los empleados que nacieron antes de 1960
select * from Employees
where year(BirthDate) <1960

-- consulta con los productos con precio entre 20 y 50
select * from products where unitprice between 20 and 50

select * from products where unitprice >= 20 and UnitPrice <= 50

-- consulta con las ordenes del primer semestre de 1998
select * from orders where orderdate  between '1-1-1998' and '6-30-1998'

-- productos que valtan 10, 20 o 31
select * from products where unitprice in (10,20,31)

--!-----------------------CLASE 3 (12/09/2024)---------------------------
use northwind
--mostrar los productos con precio de 18, 25 o 30
select productid, productname, unitprice
from products
where
unitprice = 18
or unitprice = 25
or unitprice = 30

-- mostrar los productos con un precio entre 20 y 30 pesos
select productid, productname, unitprice
from products
where
unitprice >= 20
and unitprice <= 30

--mostrar los empleados que hayan nacido en marzo, agosto o noviembre
select employeeid, firstname, mes = month(BirthDate)
from employees
where
month(BirthDate) = 3
or month(BirthDate) = 8
or month(BirthDate) = 11;


-- mostrar las ordenes realizadas el primer semestre de 1998
select orderdate, mes = month(orderdate), año = year(orderdate)
from orders
where
month(orderdate) between 1 and 6
and year(orderdate) = 1998;

--? consultar por elementos dentro de un texto
--? manejo de cadena de caracteres
USE Northwind
-- consulta con los productos donde su nombre sea ikura
select * from products where productname like 'ikura'

-- consulta con los productos que empiecen con el texto "queso"
select * from products where productname like 'queso%'

-- consulta con los productos que terminen con la cadena "es"
select * from products where productname like '%ES'

-- consulta con los productos que contenga la cadena "as"
select * from products where productname like '%as%'

-- consulta con los productos que empiecen con la letra G y terminen con la letra A
select * from products where productname like 'g%a'

-- consulta con los productos que empiecen con M, G o R
select * from products where productname like '[mgr]%'

select * from products
where ProductName like 'm%' or productname like 'g%' or ProductName like 'r%'

select * from Products
where substring(productname,1,1) in ('m','g','r')

-- consulta con los productos que terminen con consonantes
select * from products where productname like '%[^aeiou]'

select * from products where productname not like '%[aeiou]'

-- consulta con los productos que tengan 5 caracteres
select * from products where productname like '_____' -- son 5 guines bajos( _ )

select * from products where len(productname) = 5

-- consulta con los productos que en la tercera posicion tenga una VOCAL
select * from products where productname like '__[aeiou]%'

-- productos que su primera palabra tenga 5 caracteres
select * from products where productname like '_____ %'-- 5 guines bajos, un espacio en blanco y el porciento

--? Valores desconocidos
-- consulta con los empleados que no tienen asignada una region
select firstname, region from Employees where Region is NULL
-- esto es un error
select * from Employees where Region = null

-- consulta con los clientes que si tienen asignado un fax
select customerid, CompanyName, fax from Customers
where fax is not null

--? Ordenamiento
-- consulta con los nombres de los empleados por apellido 
select Employeeid, lastname, firstname from Employees
order by lastname asc -- asc se usa para ordenar de menor a mayor

-- consulta con los productos ordenados de mayor a menor precio
select productid, productname, unitprice from Products
order by unitprice desc -- desc se usa para ordenar de mayor a menor

select productid, productname, unitprice from Products
order by 3 DESC -- el 3 significa la tercer columna de la consulta en este caso es unitprice

--? Ordenamiento / sentencia TOP
-- consulta con los 5 productos mas caros
select TOP 5 productid, productname, unitprice from Products
order by unitprice DESC

-- consulta con los 2 empleados mas jovenes
select TOP 2 Employeeid, firstname, birthdate
from Employees
order by BirthDate desc

-- consulta con las ultimas 5 ordenes de 1996 del empleado 2
select orderid, orderdate, employeeid
from Orders
where employeeid = 2 and year(orderdate) = 1996
order by orderdate desc

-- consulta con los 2 productos mas baratos del proveedor 2
select top 2 productid, productname, unitprice, supplierid 
from products
where supplierid = 2
order by unitprice asc

--!-----------------------CLASE 5 (18/09/2024)---------------------------
use northwind
-- ? croos join, combinaciones cruzadas
-- 10 columnas, 77 renglones
select * from products 
-- 4 columnas, 8 renglones
select * from categories

select * from products cross join categories
select * from products, categories
-- columnas: 10 + 4 = 14
-- renglones: 77 * 8 = 616

-- columnas 12, renglones 29
select * from suppliers

select * from products cross join categories cross join suppliers
-- columnas: 10 + 4 + 12 = 26
-- renglones: 77 * 8 * 29 = 17,864

-- ? consulta con el nombre del producto y nombre de la categoria
-- ANSI
select products.productname, categories.categoryname
from products
inner join categories on categories.categoryid = products.categoryid

select P.productname , C.categoryname, p.categoryid , c.categoryid
from Products P
inner join Categories C on C.categoryid = P.categoryid

-- con transact-SQL
select p.productname, c.categoryname
from products p, categories c
where c.CategoryID = p.CategoryID

-- consulta con el nombre del producto, nombre del proovedor y nombre de la categoria
select p.ProductName, s.CompanyName, c.CategoryName
from products p
inner join suppliers s on s.SupplierID = p.SupplierID
inner join categories c on c.CategoryID = p.CategoryID

-- consulta con la clave y fecha de la orden, nombre del empleado y nombre del cliente,
-- mostrar solamente las ordenes realizadas en 1996
select o.OrderID, o.OrderDate, 'Empleado' = (e.FirstName + ' '+ e.LastName), c.CompanyName
from orders o
inner join Employees e on o.EmployeeID = e.EmployeeID
inner join customers c on o.CustomerID = c.CustomerID
where YEAR(o.OrderDate) = 1996

-- consulta con l aclave de la orden, nombre del producto, cantidad, precio y total de la venta.
-- mostrar solo las ordenes realizadas los dias lunes
select o.orderid, p.ProductName, d.Quantity, d.UnitPrice, total = d.Quantity * d.UnitPrice
from Orders o
inner join [order details] d on d.OrderID = o.OrderID
inner join products p on p.ProductID = d.ProductID
where DATEPART(dw, o.OrderDate) = 2
-- *Nota: los corchetes cuadrados se usan cuando hay un espacio en el nombre de la tabla
select * from [Order Details]

--!-----------------------CLASE 6 (19/09/2024)---------------------------
use northwind
-- consulta con el nombre del empleado y nombre del territorio que atiende
select e.firstname + ' '+e.lastname, t.TerritoryDescription
from employees e
inner join employeeterritories X on x.employeeid = e.employeeid 
inner join Territories t on t.TerritoryID = x.TerritoryID

select * from employeeterritories

-- mostrar solo los empleados y clientes que su nombre empiece con vocal
select o.OrderID, e.FirstName + ' ' + e.LastName, c.CompanyName
from orders o
inner join employees e on e.EmployeeID = o.EmployeeID
inner join customers c on c.CustomerID = o.CustomerID
WHERE
e.FirstName like '[aeiou]%'
AND c.CompanyName like '[aeiou]%'

-- ?SELF JOIN, AUTOCOMBINACIONES
-- consulta con el nombre del empleado y nombre de su jefe
select empleados = e.firstname + ' ' +e.lastname, jefe = j.firstname + ' ' + j.LastName
from employees e
inner join Employees j on e.ReportsTo = j.EmployeeID

select * from Employees

-- mediante una combinacion externa, s epuede mostrar todos los empleados que no tengan jefe
select
ClaveEmp = e.employeeid, empleado = E.firstname + ' ' + E.lastname,
ClaveJefe = e.ReportsTo, Jefe = J.firstname + ' ' + j.lastname
FROM employees e left outer join employees j on e.reportsto = j.EmployeeID

select
ClaveEmp = e.employeeid, empleado = E.firstname + ' ' + E.lastname,
ClaveJefe = e.ReportsTo, Jefe = J.firstname + ' ' + j.lastname
FROM employees e right outer join employees j on e.reportsto = j.EmployeeID
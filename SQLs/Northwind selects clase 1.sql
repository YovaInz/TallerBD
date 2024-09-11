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

-------------------------CLASE 2 (11/09/2024)---------------------------
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
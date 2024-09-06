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


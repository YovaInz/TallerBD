/* TIPOS DE FUNCIONES DEFINIDAS POR LOS USUARIOS
SQL utiliza tres tipos de funciones:
1.- las funciones escalares, 
2.- tabla en linea,
3.- funciones de tabla de multi sentencias.

Los tres tipos de funciones aceptan parámetros de cualquier tipo excepo el rowversion.
Las funciones escalares devueklven un solo valor, tabla en linea y Multisentencias devuelven
un tipo de dato tabla.

Limitaciones
Las funciones definidas por el usuario tienen algunas restricciones. No todas las sentencias SQL son
válidas dentro de una función.

Inválidas:
- Sentencias de modificación o actualización de tablas o vistas sobre tablas de usuario 
(opdate, delete, insert)
- Operaciones CURSOR FETCH que devuelven datos del cliente.
- No se pueden utilizar procedimientos almacenados dentro de la función
- No se puede utilizar tablas temporales.

Válido:
- Las sentencias de asignación.
- Las sentencias de Control de Flujo while, if.
- Sentencias SELECT y modifcación de variables locales.
- Operaciones de cursores sobre variables locales.
- Sentencias INSERT; UPDATE; DELETE con variables Locales tipo Tabla.

1.- Funciones Escalares
Las funciones escalares devuelve u tipo de los datos tal como int, money, varchar, real, etc.
Puede ser utilizadas en cualquier lugar incluso incorporada dentro de sentencias SQL.

La snitaxis para una función excalar es la siguiente:

CREATE FUNCTION [NombrePropietario.]NombreFuncion
(@nombreParametro TipoDato [=default], ... )
RETURNS TipoDatoRetorno
AS BEGIN
	CuerpoFuncion

	RETURN ValorRetorno
END
*/
--* Funcion que calcula el cubo de un numero
CREATE FUNCTION dbo.Cubo(@num numeric(12,2))
RETURNS numeric(12,2)
AS
BEGIN
	RETURN( @num * @num * @num)
END
GO
-- Ejecucion
select dbo.Cubo(3)

declare @R numeric(12,2)
select @R = dbo.cubo(3)
select @R

-- nombre y precio del producto al cubo
select productname, 'precio cubo' = dbo.cubo(unitprice) from products 

-- funcion que reciba la fecha de nacimiento y regrese la edad exacta
go
create function dbo.fn_edad(@fecha datetime)
returns int
as
begin
	declare @edad int
	select @edad = datediff(yy, @fecha, getdate())

	select @fecha = dateadd(yy, @edad, @fecha)

	if @fecha > getdate()
		select @edad = @edad - 1
	
	return @edad
end
go

-- Ejecucion
select firstname, birthdate, 'edad exacta' = dbo.fn_edad(birthdate)
from employees
where dbo.fn_edad(birthdate) > 70
go

-- Funcion que reciba la clave de la orden y regrese el importe total de la orden
create function dbo.fn_total(@clave int)
returns numeric(12,2)
as
begin
	declare @total numeric(12,2)
	select @total = sum(quantity* unitprice ) from [Order Details] where orderid = @clave
	
	return @total
end
go
-- Ejecucion
select dbo.fn_total(10248)
go

-- consulta con la clave y fecha de la orden, y el importe total de la orden
-- seejecutan 830 select de la función mas 1 select de orders
select orderid, orderdate, importe = dbo.fn_total(orderid) from orders

-- se ejecuta una sola consulta
select o.orderid, orderdate, importe = sum(quantity * unitprice)
from orders o
inner join [Order Details] d on d.OrderID = o.OrderID
group by o.orderid, orderdate

-- Factorial recursivo:
--? 5! = 1*2*3*4*5 = 5*4*3*2*1
go
create or alter function dbo.Factorial (@numero int)
returns int
as
begin
	declare @i int

	IF @numero <= 1
		set @i = @numero
	else 
		set @i = @numero * dbo.Factorial(@numero - 1)

	return @i
end
go
-- Ejecucion
select dbo.factorial(5)

select employeeid, reportsto from employees
go
-- FUNCION JEFE SUERIOR: LA FUNCION RECIBE LA CLAVE DE UN EMPLEADO Y REGRESA
-- EL JEFE SUPERIOR
create or alter function dbo.jefe (@emp int)
returns varchar(10)
as
begin
	declare @jefe int, @r int

	select @jefe = ReportsTo FROM employees WHERE EmployeeID = @emp

	if @jefe is not null
		select @r = dbo.jefe(@jefe)
	else
		select @r = @emp

	return @r
end
go
-- Ejecucion
select dbo.jefe(9)
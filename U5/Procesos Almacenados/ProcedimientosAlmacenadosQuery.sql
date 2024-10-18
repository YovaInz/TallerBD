--!---------------------- clase 10/10/2024 ----------------------
use Northwind

select 'Nombre' = firstname + ' ' + lastname, 'dias trabajados' = (datediff(dd, hiredate, getdate())/7)*5
from Employees

DECLARE @fecha DATE
DECLARE @conta INT
DECLARE @dia INT

SELECT @fecha = '1-1-2020'
SELECT @conta = 0

WHILE @fecha <= GETDATE()
BEGIN
	SELECT @DIA = DATEPART(DW, @fecha)

	IF @DIA NOT IN (1,7)
	BEGIN
		SELECT @conta += 1
	END
	SELECT @fecha = DATEADD(dd,1,@fecha)
END
SELECT @conta 

-- SE PUEDE USAR "SELECT" O "SET" PARA ASIGNAR VALORES A UNA VARIABLE @
GO
CREATE TABLE #T(employeeid, dias)
@min = min(employeeid) from employees
WHERE @min is not null
BEGIN
	@fecha = hiredate from employees
	where employeeid = @min
	WHILE @fecha <= GETDATE()
	BEGIN
		SELECT @dia = DATEPART(DW, @fecha)
		IF @dia NOT IN (1,7)
		BEGIN
			SELECT @conta += 1
		END
		SELECT @fecha = DATEADD(dd,1,@fecha)
	END
	INSERT #T(@min, @conta)
	@min = MIN(employeeid) from employees
	WHERE employeeid > @min
END
SELECT * FROM #T
GO

--!---------------------- clase 14/10/2024 ----------------------

DECLARE @fecha date
DECLARE @edad int

select @fecha = '1-12-2000'
select @edad = datediff(yy, @fecha, getdate())
select @edad
select @fecha = dateadd(yy, @edad, @fecha)

IF @fecha > getdate()
BEGIN
	select @edad = @edad - 1
END

select @edad

-- ejemplo 
insert products values ('casa', 3)

if @@error <> 0
	raiserror ('Error al insertar en la tabla products', 16, 1)

-- BEGIN TRY
BEGIN TRY
 DECLARE @Valor1 Numeric(9,2), @Valor2 Numeric(9,2), @Division Numeric(9,2)
 SET @Valor1 = 100
 SET @Valor2 = 0
 Set @Division = @Valor1 / @Valor2
 PRINT 'La división no reporta error'
END TRY
BEGIN CATCH
 select @@error AS 'Error', ERROR_NUMBER() AS 'N° de Error', ERROR_SEVERITY() As 'Severidad',
 ERROR_STATE() As 'Estado', ERROR_PROCEDURE() As 'Procedimiento',
 ERROR_LINE() As 'N° línea',
 ERROR_MESSAGE() As 'Mensaje'
END CATCH

--!---------------------- clase 15/10/2024 ----------------------
-- concatenar todas las ordenes que pertenece al producto 8
Select orderid from [Order Details] where productid = 8
--
declare @min int, @folio int, @ordenes varchar(2000)

select @folio = min(orderid) from [Order Details] where productid = 8
select @ordenes = ''
while @folio is not null
begin 
	select @ordenes = @ordenes + convert(varchar(6), @folio) + ','

	select @folio = min(orderid) from [Order Details]
	where productid = 8 and OrderID > @folio
end
select @ordenes

go
-- en un solo paso

declare @ordenes varchar(2000)
 
select @ordenes = ''

select @ordenes = @ordenes + convert(varchar(6), orderid) + ','
from [Order Details] where ProductID = 8

select @ordenes
go
-- con string_agg
declare @ordenes varchar(2000)

select @ordenes = ''

select @ordenes = string_agg(orderid, ',')
from [Order Details] where productid = 8

select @ordenes
go
--* TIPOS DE PROCEDIMIENTOS ALMACENADOS (stored procedures, sp):
--1.- PROC ALM QUE REGRESAN UNA CONSULTA
--2.- SIN PARAMETROS
--3.- CON PARAMETROS DE ENTRADA
--4.- CON PARAMETROS DE SALIDA
--5.- POR VALOR POR RETORNO
--6.- CON VALORES PREDEFINIDOS

--*1.- PROCEDIMIENTOS ALMACENADOS QUE REGRESA UNA CONSULTA

-- SP QUE RECIBA LA CLAVE DE UN EMPLEADOS Y REGRESE LAS ORDENES REALIZADAS
CREATE PROC SP_REGRESO @EMP INT AS

SELECT ORDERID, ORDERDATE FROM ORDERS WHERE EMPLOYEEID = @EMP
GO
-- EJECUCION
exec SP_REGRESO 3 --  el número 3 representa el valor que se pasa al parámetro @EMP en tu procedimiento almacenado SP_REGRESO. 
				  --  Así que está obteniendo los pedidos del empleado con la ID 3.

-- CREAMOS UNA TABLA TEMPORAL PARA INSERTAR EL RESULTADO DE UN PROC ALM QUE
-- REGRESE UNA TABLA
CREATE TABLE #RES (FOLIO INT, FECHA DATETIME)

-- EJECUTAMOS EL PROC Y SE INSERTA AUTOMATICAMENTE EN LA TABLA #RES
INSERT #RES
EXEC SP_REGRESO 2

-- VERIFICAMOS EL CONTENIDO DE LA TABLA
SELECT * FROM #RES
go
--*2.- SIN PARAMETROS
-- procedimiento que actualice el precio de todos los productos y aumente el 10%
create proc SP_aumento as
update products set UnitPrice = UnitPrice * 1.1
go
-- ejecucion
exec SP_aumento
-- validar el producto 1
select productid, unitprice from Products where ProductID = 1
GO
--*3.- SP CON PARAMETROS DE ENTRADA
-- SP QUE RECIBA 4 CALIFICACIONES IMPRIMIR EL PROMEDIO
CREATE PROC SP_CALIFICACIONES
@CAL1 INT, @CAL2 INT, @CAL3 INT, @CAL4 INT AS
DECLARE @PROM NUMERIC(12,2)

SELECT @PROM = (@CAL1 + @CAL2 + @CAL3 + @CAL4)/4
SELECT @PROM
GO
-- EJECUCION
EXEC SP_CALIFICACIONES 34,56,79,80

-- se puede cambiar el orden de los parametros indicando el nombre antes del valor
EXEC SP_CALIFICACIONES @cal2 = 56, @cal3 = 79, @cal4 = 80, @cal1 = 34

--!---------------------- clase 16/10/2024 ----------------------

--*4.- CON PARAMETROS DE SALIDA
GO
-- SP QUE RECIBA 4 CALIFICAICONES Y REGRESE COMO PARAMETRO DE SALIDA EL PRMOEDIO Y
-- SI FUE APROBADO
CREATE PROC SP_CALIFICACIONES_SAL
@CAL1 INT, @CAL2 INT, @CAL3 INT, @CAL4 INT,
@PROM NUMERIC(12,3) OUTPUT, @TIPO CHAR(20) OUTPUT AS

SELECT @PROM = (@CAL1 + @CAL2 + @CAL3 + @CAL4)/4.0

IF @PROM >= 70 
	SELECT @TIPO = 'APROBADO'
ELSE
	SELECT @TIPO = 'REPROBADO'
GO
-- EJECUTARLO
DECLARE @A NUMERIC(12,3), @B CHAR(20)
SELECT @A, @B
EXEC SP_CALIFICACIONES_SAL 70,80,60,70, @A OUTPUT, @B OUTPUT
SELECT calificacion = @A, resultado = @B
GO
--* 5.- POR VALOR POR RETORNO

-- VALOR POR RETORNO UTILIZA LA PALABRA RESERADA RETURN Y
-- REGRESA SOL VALORES ENTEROS
CREATE PROC SP_CALIFICAIONESReturn
@CAL1 INT, @CAL2 INT, @CAL3 INT, @CAL4 INT AS

DECLARE @PROM INT
SELECT @PROM = (@CAL1 + @CAL2 + @CAL3 + @CAL4) / 4.0

RETURN @PROM
GO
-- EJECUCION 
DECLARE @A integer
SELECT @A
EXEC @A = SP_CALIFICAIONESReturn 60, 80, 98, 70
SELECT @A
GO

--* 6.- CON VALORES PREDEFINIDOS

-- PROCEDIMIENTO QUE RECIBE PARAMETROS Y TIENEN VALORES PREDEFINIDOS

-- DECLARACION 
CREATE PROC SP_RECIBIR_DEFAULT
@VAL1 INT, @VAL2 INT, 
@VAL3 INT = 20, @VAL4 INT = 30 AS

DECLARE @TOTAL INT
SELECT @TOTAL = @VAL1 + @VAL2 + @VAL3 + @VAL4
SELECT @TOTAL
GO
-- EJECUCION
EXEC SP_RECIBIR_DEFAULT 2,4,5,6
-- SE PUEDE OMITIR LOS 2 ULTIMOS VALORES
EXEC SP_RECIBIR_DEFAULT 2,4

EXEC SP_RECIBIR_DEFAULT 2,4, @VAL4 = 6

--* Acitivdadsita c: de chill 
USE Northwind
GO
CREATE PROC SP_JEFESUPERIOR @emp INT, @nivel INT output, @jefesup INT output AS
 declare @aux int, @jefe int
 select @nivel = 0
 select @jefe = reportsto from employees where employeeid = @emp
 
 while @jefe is not null
 begin 
	select @aux = @jefesup
	select @nivel = @nivel + 1
	
	select @jefe = reportsto from employees where employeeid = @jefe
 end
 select @jefesup = @aux
go
-- ejecucion
declare @a int, @b int
exec SP_JEFESUPERIOR 9, @a output, @b output
select sup = @a, nivel = @b
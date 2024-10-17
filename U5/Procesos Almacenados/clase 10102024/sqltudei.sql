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
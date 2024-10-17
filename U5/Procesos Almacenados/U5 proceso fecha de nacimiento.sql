USE Northwind

DECLARE @fecha date
DECLARE @edad int
DECLARE @min int

CREATE TABLE #Tabla(emp int, edad int)
SELECT @min = min(employeeid) 
FROM  employees
WHILE @min is not null
BEGIN
	select @fecha = BirthDate from employees
	where employeeid = @min

	select @edad = datediff(yy, @fecha, getdate())
	select @fecha = dateadd(yy, @edad, @fecha)

	IF @fecha > getdate() 
	BEGIN 
		SELECT @edad = @edad - 1
	END
	insert #Tabla values (@min, @edad)

	SELECT @min = min(employeeid) from employees
	where EmployeeID > @min
END

SELECT e.FirstName + ' ' + e.LastName, e.BirthDate,
t.edad, datediff(yy, e.BirthDate, GETDATE())
FROM #Tabla t
inner join employees e on e.EmployeeID = t.emp
-- clase 14/10/2024

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
----------------------
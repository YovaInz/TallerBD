

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
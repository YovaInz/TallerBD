--!------------------clase 17/10/2024-----------------
Diccionario de datos
Es la referencia con la que cuenta el servidor para guardar la estrucuta de las 
tablas, vistas y sp. Esta información contenida en tablas de sistema, las cuales
guardan la información de las tablas de usuario.
-- Tablas de sistema

--Tabla SYSOBJECTS:
--Contiene toda la información referente a tablas, vistas, sp, funciones y demás objetos de la BD.
select * from sysobjects
select * from information_schema.tables
xtype:
u: tablas
p: sp
v: vistas
fn,tf: funciones

-- tablas de usuario de la base de datos
select id, name, xtype
from sysobjects where xtype = 'u'
order by id

funciones utilizadas:
object_id('Nombre Tabla'):
funcion que recibe el nombre de un objeto y regresa el identificador de dicho objeto.
select object_id('categories')

object_name(Identificador):
Fucnión que recibe el identificador de un objeto y regresa el nombre de dicho objeto.
select object_name(21575115)

-- TablaSYSCOLUMNS:
-- Contiene el nombre de columnas de tablas y vistas, tambien el nombre de los parametros de los
-- procedimientos almacenados.
select id, colid, colorder, name, xtype, length, prec, scale, isnullable
from syscolumns where object_id('products') = id

select * from information_schema.columns where table_name like 'products'

-- Tabla SYSTYPES:
-- Contiene los tipos de datos asociados a columnas de tablas y vistas,
-- tambien incluye los tipos de datos asociados a los parametros de los proc alm.
select XTYPE, NAME from systypes

-- consulta el nombre de las columnas y tipo de datos
select c.id, c.colid, c.colorder, c.name, tipo = t.name, c.prec, c.scale, isnullable
from syscolumns c
inner join systypes t on c.xtype = t.xtype
where c.id = object_id('categories') and t.name not like 'sysname'
order by c.colorder
go
--*1.- proc alm que reciba el nombre de una tabla y regrese el select 
--	   completo de el nombre de todos los campos, utilizar alias
create proc sp_columnas @tabla nvarchar(100) as
declare @texto nvarchar(2000), @alias varchar(2), @min int, @columna varchar(50)
select @alias = substring(@tabla,1,1)
select @texto = 'Select '

select @min = min(colid) from syscolumns where id = object_id(@tabla)
while @min is not null
begin
	select @columna = name from syscolumns where id = object_id(@tabla) and @min = colid
	select @texto = @texto + @alias + '.' + @columna + ', '

	select @min = min(colid) from syscolumns where id = object_id(@tabla) and colid > @min
end
select @texto = substring(@texto, 1, len(@texto)-1) -- QUITAR LA ULTIMA COMA
select @texto += ' from ' + @tabla + ' ' + @alias
select @texto
go
-- ejercicio
EXEC sp_columnas 'SUPPLIERS'
EXEC sp_columnas 'products'

-- Tabla SYSFOREIGHNKEY:
-- Contiene información referente a las llaves externas de las tablas,
-- contenido información de las tablas que participan.
constid: clave de la restricción
rkeyid: clave de la tabla padre
fkeyid: clave de la tabla hijo
fkey: clave de la columna que interviene en la llave externa

select nombreFK = constid, TablaPadre = rkeyid, TablaHijo = fkeyid, columna = fkey
from sysforeignkeys

select 
nombreFK = OBJECT_NAME(constid),
TablaPadre = OBJECT_NAME(rkeyid), 
TablaHijo = OBJECT_NAME(fkeyid), 
columna = fkey
from sysforeignkeys

--? hacer un procedimiento que limpie las tablas (delete) tarea para el lunes

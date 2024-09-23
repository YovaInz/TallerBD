use Northwind
go

-- vista con la clave, el nombre y el precio del producto
create view vw_productos as
select productid, productname, unitprice from products
go 
--utilizar la vista
select * from vw_productos

-- con una combinacion
select *
from vw_productos p
inner join [Order Details] d on d.ProductID = p.ProductID

-- para la modificacion de un registro
update vw_productos set UnitPrice = UnitPrice + 1 where ProductID = 1

-- Se consulta los datos sobre la tabla
select productname, UnitPrice from products where ProductID = 1
go

-- con este procedimiento almacenado se ve el contenido de la vista si no esta encriptada.
sp_helptext vw_productos

-- eliminación de una vista
drop view vw_productos
go
-- ahora la vista creada y encriptada
create view vw_productos with encryption as
select ProductID, productname, unitprice, costo = UnitPrice * 0.2 from products
go
-- no se puede mostrar el contenido de la vista
sp_helptext vw_productos

select * from vw_productos
go
-- vista con la clave y nombre de la categoria
-- incluir las categorias que empiecen con la letra C.
create view vw_categorias as
select categoryid, categoryname
from categories
where categoryname like 'c%'
GO

select * from vw_categorias
go
-- RESTRICCIONES DE VISTAS

--1.- Debe especificar en una vista los nombre de todas las columnas derivadas,
--    ademas los nombres de las columnas no se deben repetir.

create view vw_productoprecio as
select productname, precio= unitprice*1.4 from products
go

--2.- Las instrucciones CREATE VIEW no pueden combinarse con ninguna otra
--    instruccion de SQL en un lote. Un lote es un conjunto de instrucciones separadas por la palabra GO
create view vw_productos2 AS
select * from products
go
create view vw_productos3 AS
select * from products
go

--3.- Todos los objetos de BD a los que se haga referencia en la vista, se verifican al momento de crearla

--!    marca error, el campo gasto no existe en la tabla productos
--?    create view vw_productos4 as
--?    select gasto from products
--?    go

--4.- No se pueden incluir las clausulas ORDER BY en la insercion select dentro de una vista
create view vw_productos6 as
select * from products
order by productname
go
-- se ordena hasta que se ejecuta la vista
select * from vw_productos6
order by ProductName
go

--5.- Si se eliminan objetos a los que se hace referencia dentro de una vista, la vista permanece,
--    la siguiente vez que intente usar esa vista recibirá un mensaje de error.
create view vw_productos7 as
select * from vw_productos6
go
drop view vw_productos6

-- la vista 7 ya no se ejecuta, la vista 6 fue eliminada previamente
select * from vw_productos7 order by ProductID
go

--6.- No se puede hacer refernecia a las tablas temporales en la vista
--    Tampoco puede utilizar la clausula SELECT INTO dentro de una vista

--? tabla temporal local
create table #Local(col1 int, col2 int)
--? tabla temporal global
create table ##Global(col1 int, col2 int)

select * from #local
select * from ##global -- se puede ver desde cualquier conexión 
go
--! marca error
create view vw_productos5 as
select * from #local
go

--* SELECT INTO, COPIA LA ESTRUCTURA DE LA TABLA Y LA LLENA DE DATOS
select * 
INTO #COPIAPROD
from products
go
select * from #COPIAPROD
go

--! marca error
--? create view vw_productos5 as
--? select * 
--? into tabla4
--? from products
--? go

--7.- Si la vista emplea el asterisco * en la instruccion SELECT y 
--    la tabla base a la que hace referencia se le agregan nuevas columnas
--    estas no se mostrarán en la vista.
create table tabla1(col1 int, col2 int)
GO
create view vw_tablaA as
select * from tabla1
go
alter table tabla1 add col3 int
go
select * from VW_tablaA
go
--* es necesario utilizar el comando ALTER VIEW para actualizar los campos en la vista
alter view vw_tablaA as
select * from tabla1
go
--* al eliminar una columna de tabla1, la vista marcará error al ejecutarse
alter table tabla1 drop column col1
--! marca error
select * from vw_tablaA
go
-- se corrige ejecutando alter view

--8.- Si crea una vista hija con base en una vista padre, debe tomar presente lo
--    que esta haciendo la vista padre

--9.- Los datos de las vistas no se almacenan por separado, si cambia un dato en
--    una vista, está modificando el dato en la tabla base
create view vw_productos9 AS
select * from products
go
update vw_productos9 set unitprice = unitprice + 10 where productid = 4

select * from products where productid = 4

--10.- En una vista no puede hacer referencia a mas de 1024 columnas.

--11.- En una vista no puede crear indices ni desencadenadores (triggers).
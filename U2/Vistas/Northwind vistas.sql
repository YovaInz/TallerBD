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
create view vw_categories as
select categoryid, categoryname
from categories
where categoryname like 'c%'
GO

select * from vw_categories
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


--!--------------- CLASE 25/09/2024 -------------------
-- Modificacion de datos mediante vistas
-- para modificar datos desde vistas creadas, es necesario tomar en cuenta las siguientes reglas:

--* Regla 1:
-- Las modificaciones no pueden afectar a mas de una tabla subyacente.
-- Si una vista une información de dos o mas tablas, solo se puede modificar datos en una de las tablas base
use Northwind
go
create view vw_productos_cat as
select p.ProductID, p.ProductName, p.UnitPrice, c.categoryid, c.categoryname
from products p
inner join Categories c on p.CategoryID = c.CategoryID
go
--! no se puede actualizar el nombre del producto y de la categoria en el mismo update
update vw_productos_cat 
set productname = 'Leche descremada', CategoryName = 'Lacteos'
where ProductID = 1

--? se tienen que hacer 2 update por separado
update vw_productos_cat set CategoryName = 'Lacteos' where ProductID = 1
update vw_productos_cat set ProductName = 'Leche descremada' where productid = 1

-- actualizar el precio de los productos en un 20% donde su precio sea mayor a $50,
-- ademas agregarr un guión al final del nombre de la categoria.

-- no se pueden modificar directamente las dos tablas en el mismo update
update vw_productos_cat
set unitprice = unitprice * 1.2, categoryname = categoryname + '-'
where unitprice >= 50

-- es necesario hacerlo por separado
update vw_productos_cat set unitprice = unitprice * 1.2
where UnitPrice >= 50

update vw_productos_cat set CategoryName = RTRIM(CategoryName) + '-'
where UnitPrice >= 50

-- insertar un registro en la tabla productos con la vista vw_productos_cat
insert vw_productos_cat (ProductName) values ('Leche descremada')

insert vw_productos_cat (CategoryName) VALUES ('Abarrotes')

select * from Categories
select * from Products
-- la eliminacion no es posible porque afecta a dos tablas
delete vw_productos_cat where ProductID in (78)

-- se tiene que hacer directo co la tabla
delete products where ProductID in (78)
--* Regla 2
-- Solo se pueden modificar datos de columnas directas en una tabla base, así que no es posible alterar
-- columnas calculadas, columnas con funciones de agrado y columnas con funciones de cadena, fecha
-- o aritméticas.
go
create view vw_detalle as
select orderid, productid, unitprice, quantity, total = unitprice * quantity
from [order details]
go

--! no se puede actualizar el campo total
update vw_detalle set total = total * 1.3 where productid = 1

--? si se puede actualizar cualquier otro campo directo
update vw_detalle set UnitPrice = unitprice * 1.3, Quantity = 4 where ProductID = 1

--* Regla 3
-- Las columnas co la propiedad "not null" defendidas en la tabla base, pero no forman parte de la vista,
-- deben tener asignados valores predeterminados para cuando se insertan
-- nuevas filas por medio de la vista

-- el campo TIPO no acepta valores nulos
create table grupos (clave int primary key, nombre char(10) not null, tipo int not null)

-- una vista sobre la tabla grupos y no se incluye el campo tipo
go
create view vw_grupos as
select clave, nombre from grupos
go

--! no se puede insertar datos desde la vista
insert vw_grupos (clave, nombre) values (1, 'casa')

-- crear un valor predeterminado sobre el campo tipo para que
-- inserte el valor 5 en el campo TIPO, ya es posible insertar utilizando la vista
alter table grupos add constraint dc_grupos_tipo default (5) for tipo

select * from grupos
--* Regla 4
-- Al crear una vista con la opción WITH CHECK OPTION, todos los datos
-- que se deseen insertar o actualizar deberan apegarse a la condición
-- incluida en la instrucción select de la vista
--? SOLAMENTE SE PUEDEN MODIFICAR O INSERTAR DATOS QUE EMPIEZAN CON M
go
create view vw_prod AS
select * from products
where productname like 'm%'
WITH CHECK OPTION
go
--! marca error
insert vw_prod (productname) values ('Desarmador')
--? si se puede insertar
insert vw_prod (productname) values ('Madera')

--* FAMILIAS DE VISTAS

-- Plan para generar la familia de vistas en la base de datos northwind:

-- Se debe ir generando las vistas de afuera hacia adentro e ir reutilizando las 
-- vistas creadas previamente con todas las columnas

--* Secuencia de creación de vistas
--! nombre                  tablas utilizadas
--*------------------------------------------------------------------------
--? vw_products                 products, categorias, suppliers
--? vw_orders                   orders, employees, shippers, customers
--? vw_orderdetails             [order details], vw_orders, vw_products

--* suplementarias
--? vw_territories              territories, region
--? vw_employeeterritories      employeeterritories, vw_territories, employees
--*------------------------------------------------------------------------
go
-- vista products
create view vw_products as
select 
p.productid, p.ProductName, p.QuantityPerUnit, produnitprice = p.unitprice,
p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel, p.Discontinued,

s.SupplierID, s.CompanyName, s.ContactName, s.ContactTitle, s.Address,
s.City, s.Region, s.PostalCode, s.Country, s.Phone, s.Fax, s.HomePage,

c.CategoryID, c.CategoryName, c.[Description],c.Picture

from products p
inner join suppliers s on s.SupplierID = p.SupplierID
inner join Categories c on c.CategoryID = p.CategoryID
go
-- ejecución de la vista productos
select * from vw_products
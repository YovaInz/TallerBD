-- unique constraint
-- Unique constraint
USE FERRETERIAS 
GO
alter table clientes add 
constraint uc_clientes_rfc unique( cterfc ) ,
constraint uc_clientes_curp unique( ctecurp )
go
alter table empleados add 
constraint uc_empleados_rfc unique( emprfc ),
constraint uc_empleados_curp unique( empcurp ) 
go

-- check constraint 
-- check constraint 
alter table clientes add 
constraint cc_clientes_sexo check( ctesexo in ( 'F', 'M') ),
constraint cc_Clientes_rfc_curp check ( cterfc < ctecurp ), 
constraint cc_Clientes_rfc_len check ( len( cterfc ) =13)
go 
alter table empleados add 
constraint cc_emp_rfc_curp check(emprfc < empcurp)
go
alter table detalle add 
constraint cc_detalle_precio check ( precio>0),
constraint cc_detalle_cantidad check ( cantidad > 0 )
go
alter table articulos add 
constraint cc_articulos_precio check ( artprecio > 0)
go 
alter table ventas add 
constraint cc_ventas_fecha check ( fecha > '1-1-2018')

-- default constraint 
-- default constraint
alter table empleados add
constraint dc_empleados_domicilio default ('Sin Domicilio') for empdomicilio,
constraint dc_empleados_telefono default ('Sin telefono') for emptelefon
go
alter table clientes add
constraint dc_clientes_domicilio default ('Sin Domicilio') for ctedomicilio,
constraint dc_clientes_telefono default ('Sin telefono') for ctetelefono
go
alter table colonias add constraint dc_colonias_cp default('00000') for colCP
go

-- se necesita utilizar la palabra reservada DEFAULT u omitir el valor del cp en la tabla calonias
insert MUNICIPIOS values (1,'Culiacán')

insert colonias values (1, 'Col. Obregón', DEFAULT, 1)
insert colonias(colid, colnombre, munid) values (8, 'Col. Lomas', 1)

-- expresamente se guarda NULL en CP
insert colonias values (9, 'Col.Zapata', NULL, 1)

select * from colonias



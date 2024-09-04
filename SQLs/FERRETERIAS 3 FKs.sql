-- LLAVES EXTERNAS
USE FERRETERIAS 
GO 
ALTER TABLE ARTICULOS ADD
CONSTRAINT FK_ARTICULOS_FAMILIAS FOREIGN KEY (FAMID) REFERENCES FAMILIAS (FAMID)
GO
ALTER TABLE COLONIAS ADD
CONSTRAINT FK_COLONIAS_MUN FOREIGN KEY (MUNID) REFERENCES MUNICIOS (MUNID)
GO
ALTER TABLE CLIENTES ADD
CONSTRAINT FK_CLIENTES_COL FOREIGN KEY (COLID) REFERENCES COLONIAS (COLID)
GO
ALTER TABLE EMPLEADOS ADD
CONSTRAINT FK_EMP_ZONAS FOREIGN KEY (ZONAID) REFERENCES COLONIAS (ZONAID)
GO
ALTER TABLE VENTAS ADD
CONSTRAINT FK_VENTAS_FERR FOREIGN KEY (FERRID) REFERENCES FERRETERIAS (FERRID),
CONSTRAINT FK_VENTAS_CTE FOREIGN KEY (CTEID) REFERENCES CLIENTES (CTEID),
CONSTRAINT FK_VENTAS_EMP FOREIGN KEY (EMPID) REFERENCES EMPLEADOS (EMPID)
GO
ALTER TABLE DETALLE ADD
CONSTRAINT FK_DETALLE_ARTIC FOREIGN KEY (ARTID) REFERENCES ARTICULOS (ARTID),
CONSTRAINT FK_DETALLE_VENTAS FOREIGN KEY (FOLIO) REFERENCES VENTAS (FOLIO)
GO
-- ASOCIACION UNARIA -->> UN EMPLEADO TIENE A SU CARGO MUCHOS EMPLEADOS
ALTER TABLE EMPLEADOS ADD
CONSTRAINT FK_EMP_EMP FOREIGN KEY (JEFEID) REFERENCES EMPLEADOS (EMPID)
GO

-- LLAVE EXTERNA APUNTANDO HACIA UNA LLAVE UNICA Y NO A UNA LLAVE PRIMARIA
USE PRUEBA
create table envios(
folio int not null,
fecha datetime not null,
clirfc char(13) null)
go
create table clientes(
cliid int not null,
clinombre varchar(50) not null,
clirfc char(13) null)
go
-- creamos las llaves primarias
alter table envios add constraint pk_envios primary key (folio)
alter table clientes add constraint pk_clientes primary key (cliid)

-- creamos el rfc como llave unica
alter table clientes add constraint uc_clientes_rfc unique (clirfc)

-- creamos la llave externa de envios apuntando a una llave unica
alter table envios add constraint fk_envios_clientes foreign key (clirfc) references clientes(clirfc)

-- se insertan valores en las dos tablas
insert clientes values (1, 'Carlos Lopez', 'locm800108r5t')
insert clientes values (2, 'Ana Lara', null)
-- marca error, solo acepta un valor nulo
insert clientes values (3, 'Pedro Castro', null)

-- MARCA ERROR EL RFC NO EXISTE EN CLIENTES
insert envios values (1000, '1-1-2021', 'XXXX800108r5t')
-- INSERCION CORRECTA
insert envios values (1000, '1-1-2021', 'locm800108r5t')
insert envios values (2000, '1-1-2021', null)
insert envios values (3000, '1-1-2021', null)
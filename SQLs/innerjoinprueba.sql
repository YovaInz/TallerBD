use prueba
-- create table estados(
-- edoID int not null,
-- edonombre varchar(100))
-- go
-- alter table estados add constraint pk_edos primary key (edoID)
-- go
-- create table municipios(
-- munID int not null,
-- munnombre varchar(100),
-- edoid int)
-- go
-- alter table municipios add constraint pk_mun primary key (munid),
-- constraint fk_edo_mun foreign key (edoid) references estados (edoid)
-- go
-- insert estados values (1, 'sinaloa')
-- insert estados values (2, 'sonora')
-- insert estados values (3, 'colima')
-- insert estados values (4, 'Jalisco')
-- insert municipios values (100, 'culiacán', 1)
-- insert municipios values (101, 'obregon', 2)
-- insert municipios values (102, 'toluca', null)
-- insert municipios values (103, 'tepic', null)

--!-----------------------CLASE 4 (17/09/2024)---------------------------

select * from estados -- 2 columnas y 4 renglones
select * from municipios -- 3 columnas y 4 renglones 
-- *cross join
select * from municipios cross join estados
--columnas 2 + 3 = 5 columnas
--renglones

-- *inner join
-- combinacion interna
-- muestras los registros que existen en las 2 tablas
select m.munnombre, m.edoid, e.edoID, e.edonombre
from municipios m
inner join estados e on e.edoid = m.edoid

select m.munnombre, m.edoid, e.edoID, e.edonombre
from municipios m, estados e
where e.edoid = m.edoid

--!-----------------------CLASE 6 (19/09/2024)---------------------------
-- ? INNER JOIN
-- ?combinacion interna
use prueba
select * from estados
select * from municipios
-- muestra los registros que existen en las 2 tablas
select m.munnombre, m.edoid, e.edoid, e.edonombre
from municipios m
inner join estados e on e.edoid = m.edoid

--? combinación externa
-- muestra todos los municipios aunque no tengan asignado un estado
select m.munnombre, m.edoid, e.edoid, e.edonombre
from municipios m left outer join estados e on e.edoid = m.edoid

select m.munnombre, m.edoid, e.edoID, e.edonombre
from estados e right outer join municipios m on e.edoID = m.edoid

--? combinación externa
-- muestra todos los estados aunque no tengan asignado un municipio
select m.munnombre, m.edoid, e.edoid, e.edonombre
from municipios m right outer join estados e on e.edoid = m.edoid

select m.munnombre, m.edoid, e.edoID, e.edonombre
from estados e left outer join municipios m on e.edoID = m.edoid

--? combinacion externa
-- muestra todos los estados aunque no tengan asignado un municipio
select m.munnombre, m.edoid, e.edoid, e.edonombre
from municipios m right outer join estados e on e.edoid = m.edoid

select m.munnombre, m.edoid, e.edoid, e.edonombre
from estados e left outer join municipios m on e.edoid = m.edoid

--* full outer join
select m.munnombre, m.edoid, e.edoid, e.edonombre
from municipios m full outer join estados e on e.edoid = m.edoid

--CONSULTA CON LOS ESTADOS QUE NO TIENEN ASIGNADO UN MUNICIPIO
select m.munID, m.munnombre, m.edoid, e.edoid, e.edonombre
from estados e left outer join municipios m on e.edoid = m.edoid
where m.munid is null

select m.munid, m.munnombre, m.edoid, e.edoid, e.edonombre
from estados e left outer join municipios m on e.edoid = m.edoid
where M.munnombre is null

-- consulta con los municipios que no tienen asgnado un estado
select m.munid, m.munnombre, m.edoid, e.edoid, e.edonombre
from estados e right outer join municipios m on e.edoid = m.edoid
where e.edonombre is null

select m.munid, m.munnombre, m.edoid, e.edoid, e.edonombre
from estados e right outer join municipios m on e.edoid = m.edoid
where e.edonombre is null

select m.munid, m.munnombre, m.edoid, e.edoid, e.edonombre
from estados e right outer join municipios m on e.edoid = m.edoid
where e.edonombre is null
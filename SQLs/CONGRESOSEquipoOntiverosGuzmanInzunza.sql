-- *CREACIÓN DE LA BASE DE DATOS
CREATE DATABASE CONGRESOS
GO

-- *USAR LA BASE DE DATOS
USE CONGRESOS
GO

-- *CREACIÓN DE TABLAS
CREATE TABLE CONGRESOS(
    CONID INT NOT NULL,
    CONNOMBRE NVARCHAR(50) NOT NULL,
    CONDESCRIPCION NVARCHAR(200) NULL,
    CONFECHAINI DATE NOT NULL,
    CONFECHAFIN DATE NOT NULL,
    CONLUGAR NVARCHAR(50) NOT NULL)
GO
CREATE TABLE EXPOSITORES(
    EXPID INT NOT NULL,
    EXPNOMBRE NVARCHAR(50) NOT NULL,
    EXPAPEPAT NVARCHAR(50) NOT NULL,
    EXPAPEMAT NVARCHAR(50) NULL,
    EXPCORREO NVARCHAR(50) NULL,
    EXPCELULAR NCHAR(10) NULL)
GO
CREATE TABLE EVENTOS(
    EVEID INT NOT NULL,
    EVENOMBRE NVARCHAR(50) NOT NULL,
    EVEDESCRIPCION NVARCHAR(200) NULL,
    EVEFECHA DATE NOT NULL,
    EVELUGAR NVARCHAR(50) NOT NULL,
    EVECOSTO NUMERIC(10,2) NOT NULL,
    EXPID INT NOT NULL)
GO
CREATE TABLE MUNICIPIOS(
    MUNID INT NOT NULL,
    MUNNOMBRE NVARCHAR(50) NOT NULL)
GO
CREATE TABLE ESCUELAS (
    ESCID INT NOT NULL,
    ESCNOMBRE NVARCHAR(50) NOT NULL,
    ESCDOMICILIO NVARCHAR(50) NOT NULL,
    MUNID INT NOT NULL)
GO
CREATE TABLE ESTUDIANTES(
    ESTID INT NOT NULL,
    ESTNOMBRE NVARCHAR(50) NOT NULL,
    ESTAPEPAT NVARCHAR(50) NOT NULL,
    ESTAPEMAT NVARCHAR(50) NULL,
    ESTDOMICILIO NVARCHAR(50) NOT NULL,
    ESTCORREO NVARCHAR(50) NULL,
    ESTCELULAR NCHAR(10) NULL,
    ESCID INT NOT NULL)
GO
CREATE TABLE REGISTRO (
    FOLIO INT NOT NULL,
    FECHA DATE NOT NULL,
    CONID INT NOT NULL,
    ESTID INT NOT NULL)
GO
CREATE TABLE REGISTROXEVENTOS(
    FOLIO INT NOT NULL,
    EVEID INT NOT NULL)
GO

-- *CREACION DE LLAVES PRIMARIAS
ALTER TABLE CONGRESOS ADD CONSTRAINT pkCongresos PRIMARY KEY (CONID)
GO
ALTER TABLE REGISTRO ADD CONSTRAINT pkRegistro PRIMARY KEY (FOLIO)
GO
ALTER TABLE EXPOSITORES ADD CONSTRAINT pkExpositores PRIMARY KEY (EXPID)
GO
ALTER TABLE EVENTOS ADD CONSTRAINT pkEventos PRIMARY KEY (EVEID)
GO
ALTER TABLE ESTUDIANTES ADD CONSTRAINT pkEstudiantes PRIMARY KEY (ESTID)
GO
ALTER TABLE ESCUELAS ADD CONSTRAINT pkEscuelas PRIMARY KEY (ESCID)
GO 
ALTER TABLE MUNICIPIOS ADD CONSTRAINT pkMunicipios PRIMARY KEY (MUNID)
GO
ALTER TABLE REGISTROXEVENTOS ADD 
CONSTRAINT pkUnionRegistro PRIMARY KEY (FOLIO),
CONSTRAINT pkUnionEventos PRIMARY KEY (EVEID)
GO

-- *CREACION DE LLAVES FORANEAS
ALTER TABLE REGISTRO ADD
CONSTRAINT fkRegistroCongresos FOREIGN KEY (CONID) REFERENCES CONGRESOS(CONID),
CONSTRAINT fkRegistroEstudiantes FOREIGN KEY (ESTID) REFERENCES ESTUDIANTES(ESTID)
GO
ALTER TABLE ESTUDIANTES ADD
CONSTRAINT fkEstudiantesEscuelas FOREIGN KEY (ESCID) REFERENCES ESCUELAS (ESCID)
GO
ALTER TABLE ESCUELAS ADD
CONSTRAINT fkEscuelasMunicipios FOREIGN KEY (MUNID) REFERENCES MUNICIPIOS (MUNID)
GO
ALTER TABLE EVENTOS ADD
CONSTRAINT fkEventosExpositores FOREIGN KEY (EXPID) REFERENCES EXPOSITORES (EXPID)
GO
ALTER TABLE REGISTROXEVENTOS ADD
CONSTRAINT fkUnionRegistro FOREIGN KEY (FOLIO) REFERENCES REGISTRO (FOLIO),
CONSTRAINT fkUnionEventos FOREIGN KEY (EVEID) REFERENCES EVENTOS (EVEID)
GO

-- *CREACION DE LLAVES UNICAS
ALTER TABLE EXPOSITORES ADD 
CONSTRAINT ucExpositoresCelular UNIQUE (EXPCELULAR)
GO
ALTER TABLE ESTUDIANTES ADD 
CONSTRAINT ucEstudiantesCelular UNIQUE (ESTCELULAR)
GO

-- *ASIGNACION DE VALORES POR DEFAULT
ALTER TABLE EXPOSITORES ADD
CONSTRAINT dfExpositoresCorreo DEFAULT 'sin@correo.com' FOR EXPCORREO
GO
ALTER TABLE ESTUDIANTES ADD
CONSTRAINT dfEstudiantesCorreo DEFAULT 'sin@correo.com' FOR ESTCORREO,
CONSTRAINT dfEstudiantesDomicilio DEFAULT 'Sin Domicilio' FOR ESTDOMICILIO
GO
ALTER TABLE EVENTOS ADD
CONSTRAINT dfEventosCosto DEFAULT 0.00 FOR EVECOSTO
GO
ALTER TABLE REGISTRO ADD
CONSTRAINT dfRegistroFecha DEFAULT GETDATE() FOR FECHA
GO

-- *ASIGNACION DE VALORES DE COMPROBACION
ALTER TABLE CONGRESOS ADD
CONSTRAINT chkCongresoFechas CHECK (CONFEHCAINI <= CONFECHAFIN)
GO
ALTER TABLE EVENTOS ADD
CONSTRAINT chkCostoPositivo CHECK (EVECOSTO >= 0)
GO
ALTER TABLE EXPOSITORES ADD
CONSTRAINT chkExpositoresCorreo CHECK (EXPCORREO LIKE '%_@__%.__%')
GO
ALTER TABLE ESTUDIANTES ADD
CONSTRAINT chkEstudiantesCorreo CHECK (ESTCORREO LIKE '%_@__%.__%')
GO

-- *5 INSERCIONES POR CADA TABLA
INSERT INTO MUNICIPIOS (MUNID, MUNNOMBRE) VALUES 
(1, 'Culiacan'),
(2, 'Mazatlan'),
(3, 'Navolato'),
(4, 'Guasave'),
(5, 'Ahome')
GO
INSERT INTO ESCUELAS (ESCID, ESCNOMBRE, ESCDOMICILIO, MUNID) VALUES
(1, 'Instituto Tecnológico de Culiacán', 'Juan de Dios Bátiz 310', 1),
(2, 'Unidad Autonoma de Occidente', 'Av. del Mar 1200, Fraccionamiento Tellerías', 2),
(3, 'Universidad Autonoma de Sinaloa', 'Carranza 222 Pte, Los Mochis', 5),
(4,'Universidad Autonoma de Durango','Villa Delrio 2900',1),
(5,'UAS Facultad de Derecho','A Villamoros SN-I SINOMEX, Solidaridad',3)
GO
INSERT INTO ESTUDIANTES (ESTID, ESTNOMBRE, ESTAPEPAT, ESTAPEMAT, ESTDOMICILIO, ESTCORREO, ESTCELULAR, ESCID) VALUES
(1, 'Fatima Judith', 'Perea', 'Ortega', 'Del Jardin 310', 'fattimi@gmail.com', '2794542905', 4),
(2, 'Cesar Yovanni', 'Inzunza', 'Aguilar', 'Catalunya 3241', 'yovanniinzunza@gmail.com', '6674585417', 1),
(3, 'Victoria Adahi', 'Ontiveros', 'Ramos', 'Villas del rey 321', 'vixdiosa@gmail.com', '6677955810', 3),
(4, 'Oliver Alejandro', 'Guzmán', 'Silva', 'Villas del rio 3412', 'Oliveratom@outlook.com', '6672083822', 2),
(5, 'Maria Clara', 'Aguilar', 'Fuentes', 'Vld. valle alto 3110', 'maryclerck71@gmail.com', '6674123456',5)
GO
INSERT INTO CONGRESOS (CONID, CONNOMBRE, CONDESCRIPCION, CONFECHAINI, CONFECHAFIN, CONLUGAR) VALUES
(1, 'Congreso de Tecnología', 'Congreso sobre las últimas innovaciones en tecnología.', '2024-10-01', '2024-10-03', 'Centro de Convenciones, Culiacán'),
(2, 'Congreso de Salud', 'Evento de actualización en temas de salud y bienestar.', '2024-11-05', '2024-11-07', 'Auditorio Municipal, Mazatlán'),
(3, 'Congreso de Educación', 'Congreso enfocado en nuevas metodologías educativas.', '2024-12-10', '2024-12-12', 'Hotel Plaza, Los Mochis'),
(4, 'Congreso de Medio Ambiente', 'Congreso dedicado a la sostenibilidad y protección del medio ambiente.', '2024-09-15', '2024-09-17', 'Centro Cultural, Guasave'),
(5, 'Congreso de Ciencia', 'Evento para presentar investigaciones y avances científicos.', '2024-11-20', '2024-11-22', 'Centro de Eventos, Ahome')
GO
INSERT INTO REGISTRO (FOLIO, FECHA, CONID, ESTID) VALUES
(1, '2024-09-01', 1, 2),
(2, '2024-09-02', 2, 5),
(3, '2024-09-03', 3, 1),
(4, '2024-09-04', 4, 4),
(5, '2024-09-05', 5, 3)
GO
INSERT INTO EXPOSITORES (EXPID, EXPNOMBRE, EXPAPEPAT, EXPAPEMAT, EXPCORREO, EXPCELULAR) VALUES
(1, 'Juan Carlos', 'Mendoza', 'García', 'carlosmendoza1@gmail.com', '6671234567'),
(2, 'Ana María', 'López', 'González', 'anaLopezz@gmail.com', '6672345678'),
(3, 'Luis Fernando', 'Fernández', 'Martínez', 'luis_Fernandez@outlook.com', '6673456789'),
(4, 'María José', 'García', 'Moreno', 'maria.garcia@hotmail.com', '6674567890'),
(5, 'Jorge Romeo', 'Romero', 'Pérez', 'romeroJorge@hotmail.com', '6675678901')
GO
INSERT INTO EVENTOS (EVEID, EVENOMBRE, EVEDESCRIPCION, EVEFECHA, EVELUGAR, EVECOSTO, EXPID) VALUES
(1, 'Taller de Innovación Tecnológica', 'Taller práctico sobre las últimas tecnologías emergentes.', '2024-10-02', 'Sala 1, Centro de Convenciones, Culiacán', 150.00, 1),
(2, 'Seminario de Bienestar', 'Seminario sobre técnicas de bienestar y salud mental.', '2024-11-06', 'Auditorio Principal, Mazatlán', 100.00, 2),
(3, 'Conferencia Educativa', 'Conferencia sobre métodos educativos modernos.', '2024-12-11', 'Salón de Conferencias, Hotel Plaza, Los Mochis', 75.00, 3),
(4, 'Panel sobre Medio Ambiente', 'Panel de discusión sobre el impacto ambiental y sostenibilidad.', '2024-09-16', 'Sala Verde, Centro Cultural, Guasave', 120.00, 4),
(5, 'Simposio de Avances Científicos', 'Simposio sobre los últimos avances en ciencia y tecnología.', '2024-11-21', 'Gran Salón, Centro de Eventos, Ahome', 200.00, 5)
GO
INSERT INTO REGISTROXEVENTOS (FOLIO, EVEID) VALUES
(1,5),
(2,4),
(3,3),
(4,2),
(5,1)
GO

SELECT * FROM MUNICIPIOS
SELECT * FROM ESCUELAS
SELECT * FROM ESTUDIANTES
SELECT * FROM EXPOSITORES
SELECT * FROM EVENTOS
SELECT * FROM CONGRESOS
SELECT * FROM REGISTRO
SELECT * FROM REGISTROXEVENTOS
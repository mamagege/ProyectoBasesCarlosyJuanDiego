--Restricción de Atributos

ALTER TABLE USUARIOSFRECUENTES ADD CONSTRAINT ck_Tcorreo
CHECK (correo LIKE '%@%.%');

ALTER TABLE DEALERS ADD CONSTRAINT ck_Tespecialidad
CHECK (especialidad IN ('Blackjack','Poker','Ruleta','Baccarat'));

ALTER TABLE APUESTAS ADD CONSTRAINT ck_TestadoApuesta
CHECK (estado IN ('En proceso','Perdida','Ganada'));

ALTER TABLE MESAS ADD CONSTRAINT ck_TestadoMesa
CHECK (estado IN ('Abierta','Cerrada','En mantenimiento'));

ALTER TABLE CambioFichas ADD CONSTRAINT ck_TrecibeDinero
CHECK (cajaRecibe IN ('Dinero','Fichas'));

ALTER TABLE EMPLEADOS ADD CONSTRAINT ck_Tturno
CHECK (turno IN ('Manana','Tarde','Noche'));

--Ciclo 2

ALTER TABLE Torneos ADD CONSTRAINT ck_TestadoTorneo
CHECK (estado IN ('Activo', 'Finalizado', 'Cancelado'));

ALTER TABLE Premios ADD CONSTRAINT ck_TestadoPremio
CHECK (estado IN ('Asignado', 'Entregado'));

ALTER TABLE Torneos ADD CONSTRAINT ck_FechaTorneo
CHECK (fecha_inicio < fecha_fin);
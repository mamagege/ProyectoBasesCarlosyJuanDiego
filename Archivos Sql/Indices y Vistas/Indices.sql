--Índices

-- índice para consultar el historial de apuestas de un usuario específico.
--Es relevante pues los usuarios constantemente están revisando su historial.

CREATE INDEX idx_apuesta_usuario
ON APUESTA (usuario);

--Se usa para que los cajeros puedan revisar con más velocidad el historial de sus transacciones.
CREATE INDEX idx_cambiofichas_cajero
ON CAMBIOFICHAS (cajero);

--Cuando dealer quiere consultar su mesa y juego asociado con más velocidad.
CREATE INDEX idx_dealer_mesa
ON MESAS (dealer);

--Cuando el dealer necesita registrar las apuestas de la mesa
CREATE INDEX idx_apuesta_mesa
ON APUESTAS (mesa);

--Cuando el cajero registra visitas o cambios de fichas de usuarios
CREATE INDEX idx_cambiofichas_usuario
ON CAMBIOFICHAS (usuario);

--Para que los dealers verifiquen el juego correspondiente a la mesa
CREATE INDEX idx_mesa_juego
ON MESAS (juego);

--Para que el cajero verifique rapidamente las transacciones de su turno y que dinero o fichas recibió
CREATE INDEX idx_cambiofichas_caja
ON CAMBIOFICHAS (cajarecibe);


--CICLO 2

-- Índice para consultar torneos por estado
CREATE INDEX idx_torneos_estado 
ON Torneos(estado);

-- Índice para consultar mesas por torneo
CREATE INDEX idx_mesas_torneo 
ON Mesas(torneo);

-- Índice para consultar mesas por estado
CREATE INDEX idx_mesas_estado 
ON Mesas(estado);


-- Índice para consultar participantes por torneo
CREATE INDEX idx_participantes_torneo 
ON Participantes(torneo);

-- Índice para consultar participantes por usuario
CREATE INDEX idx_participantes_usuario 
ON Participantes(usuario);

CREATE INDEX idx_Usuarios_Premios_usuario
ON Usuarios_Premios(usuario);

CREATE INDEX idx_Usuarios_Premios_premio
ON Usuarios_Premios(premio);    


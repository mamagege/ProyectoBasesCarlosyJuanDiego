--Eliminación de Indices:

ALTER TABLE Apuestas DROP CONSTRAINT FK_Apuestas_Usuario; --Para idx_apuesta_usuario
ALTER TABLE CambioFichas DROP CONSTRAINT FK_CambioFichas_Cajero; --Para idx_cambiofichas_cajero
ALTER TABLE Mesas DROP CONSTRAINT FK_Mesas_Dealer; --Para idx_dealer_mesa
ALTER TABLE Apuestas DROP CONSTRAINT FK_Apuestas_Mesa; --Para idx_apuesta_mesa
ALTER TABLE CambioFichas DROP CONSTRAINT FK_CambioFichas_Usuario; --Para idx_cambiofichas_usuario
ALTER TABLE UsuariosFrecuentes DROP CONSTRAINT UQ_UsuariosFrecuentes_Correo; --Para idx_usuariofrecuente_correo
ALTER TABLE Mesas DROP CONSTRAINT FK_Mesas_Juego; --Para idx_mesa_juego
DROP INDEX idx_cambiofichas_caja;

--Eliminación de Vistas:

DROP VIEW V_UsuariosCompleto;
DROP VIEW V_CambioFichas_Detalle;
DROP VIEW V_Mesas_Detalle;
DROP VIEW V_Apuestas_Detalle;
DROP VIEW V_Empleados_Roles;
DROP VIEW V_Usuario_ResumenFinanciero;


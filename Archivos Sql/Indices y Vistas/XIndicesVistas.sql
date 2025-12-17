--Eliminación de Indices:

DROP INDEX idx_apuesta_usuario;
DROP INDEX idx_cambiofichas_cajero;
DROP INDEX idx_dealer_mesa;
DROP INDEX idx_apuesta_mesa;
DROP INDEX idx_cambiofichas_usuario;
DROP INDEX idx_usuariofrecuente_correo;
DROP INDEX idx_mesa_juego;
DROP INDEX idx_cambiofichas_caja;

--CICLO 2
DROP INDEX idx_torneos_estado;
DROP INDEX idx_mesas_torneo;
DROP INDEX idx_mesas_estado;
DROP INDEX idx_participantes_torneo;
DROP INDEX idx_participantes_usuario;



--Eliminación de Vistas:

DROP VIEW V_UsuariosCompleto;
DROP VIEW V_CambioFichas_Detalle;
DROP VIEW V_Mesas_Detalle;
DROP VIEW V_Apuestas_Detalle;
DROP VIEW V_Empleados_Roles;
DROP VIEW V_Usuario_ResumenFinanciero;

--CICLO 2




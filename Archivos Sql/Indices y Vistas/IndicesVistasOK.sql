--Indices y Vistas Ok

--Consulta: Obtener todos los cambios de fichas hechos hoy.
--Usa: idx_cambiofichas_cajero y Vista V_CambioFichas_Detalle

SELECT *
FROM V_CambioFichas_Detalle
WHERE TRUNC(fechaHora) = TRUNC(SYSDATE);


--Consulta: Buscar cambios de fichas por usuario
--Usa: idx_cambiofichas_usuario y Vista V_CambioFichas_Detalle

SELECT *
FROM V_CambioFichas_Detalle
WHERE usuario_id = 15;


--Consulta: Consultar total de fichas entregadas por cada cajero
--Usa: idx_cambiofichas_cajero y Vista V_CambioFichas_Detalle

SELECT cajero_nombre, SUM(monto) AS total_monto
FROM V_CambioFichas_Detalle
GROUP BY cajero_nombre
ORDER BY total_monto DESC;

--Consulta: Buscar cambios hechos por un empleado específico
--Usa: idx_cambiofichas_cajero

SELECT cf.*
FROM CambioFichas cf
JOIN Cajeros c ON cf.cajero = c.id
JOIN Empleados e ON c.id = e.id
WHERE e.nombre = 'Juan Perez';

--Consulta: Contar cuántas transacciones hizo cada usuario
--Usa: idx_cambiofichas_usuario

SELECT u.nombre, COUNT(*) AS total_transacciones
FROM CambioFichas cf
JOIN Usuarios u ON cf.usuario = u.id
GROUP BY u.nombre
ORDER BY total_transacciones DESC;

--CICLO 2


-- Consulta: Obtener todos los torneos activos
-- Usa: idx_torneos_estado y Vista V_Torneos_Activos

SELECT *
FROM V_Torneos_Activos;

-- Consulta: Obtener todos los participantes de un torneo
-- Usa: idx_participantes_torneo y Vista V_Participantes_Torneo

SELECT *
FROM V_Participantes_Torneo
WHERE torneo_id = 1;  -- Cambiar el ID del torneo según sea necesario

-- Consulta: Obtener los premios asignados a los participantes de un torneo
-- Usa: idx_Usuarios_Premios_usuario y Vista V_Premios_Asignados

SELECT *
FROM V_Premios_Asignados
WHERE torneo_nombre = 'Torneo 1';  -- Cambiar el nombre del torneo según sea necesario

-- Consulta: Obtener todos los premios asignados a un usuario específico
-- Usa: idx_Usuarios_Premios_usuario y Vista V_Premios_Asignados

SELECT *
FROM V_Premios_Asignados
WHERE participante_nombre = 'Juan Perez';  -- Cambiar el nombre del participante según sea necesario









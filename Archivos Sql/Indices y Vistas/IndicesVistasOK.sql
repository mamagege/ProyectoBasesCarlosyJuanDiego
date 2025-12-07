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





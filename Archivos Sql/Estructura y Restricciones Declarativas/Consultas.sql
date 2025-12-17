--Consultas Gerenciales

--¿Cuales son los juegos que generan más apuestas perdidas?

--Utilidad = Apuesta Perdida

SELECT juegos.id, juegos.nombre, COUNT(apuestas.estado) AS Total_Apuestas_Perdidas FROM JUEGOS
JOIN APUESTAS ON juegos.id = apuestas.id
WHERE apuestas.estado = 'Perdida'
GROUP BY juegos.id, juegos.nombre;


--¿Quiénes son los clientes más valiosos?

--Puede ser valor de: monto de Apuestas, cantidad de apuestas pérdidas o cantidad de cambio de fichas

--Por monto de Apuestas:

SELECT UsuariosFrecuentes.id, Usuarios.nombre, apuestas.monto FROM UsuariosFrecuentes
JOIN APUESTAS on UsuariosFrecuentes.id = apuestas.id 
JOIN USUARIOS on UsuariosFrecuentes.id = Usuarios.id 
ORDER BY apuestas.monto DESC;

--Por cantidad de apuestas perdidas

SELECT UsuariosFrecuentes.id, Usuarios.nombre, COUNT(apuestas.estado) AS Total_Apuestas_Perdidas FROM UsuariosFrecuentes
JOIN APUESTAS on UsuariosFrecuentes.id = apuestas.id 
JOIN USUARIOS on UsuariosFrecuentes.id = Usuarios.id 
WHERE apuestas.estado = 'Perdida'
GROUP BY Usuarios.nombre, UsuariosFrecuentes.id;

--Por cantidad de cambio de fichas

SELECT UsuariosFrecuentes.id, Usuarios.nombre, CambioFichas.monto FROM UsuariosFrecuentes
JOIN CambioFichas on UsuariosFrecuentes.id = CambioFichas.id 
JOIN USUARIOS on UsuariosFrecuentes.id = Usuarios.id
ORDER BY CambioFichas.monto DESC;

--¿Cuales son los dealers que generan mas ingresos para el casino?

SELECT Dealers.id, Empleados.nombre, COUNT(apuestas.estado) AS TOTAL_PERDIDOS FROM DEALERS
JOIN APUESTAS ON apuestas.id = dealers.id 
JOIN EMPLEADOS ON empleados.id = dealers.id
GROUP BY Dealers.id, Empleados.nombre;

--CICLO 2


--Consultas con torneos y premios

--¿Cuáles son los torneos que dan mayor cantidad de premios?


SELECT t.nombre AS torneo_nombre, COUNT(p.id) AS cantidad_premios
FROM Torneos t
JOIN Premios p ON t.id = p.torneo
GROUP BY t.id, t.nombre
ORDER BY cantidad_premios DESC;

--¿Cuales son los participantes que han ganado más premios?

SELECT u.nombre AS participante_nombre, COUNT(up.premio) AS cantidad_premios
FROM Usuarios u
JOIN Usuarios_Premios up ON u.id = up.usuario
WHERE up.puesto = 1  -- Asumiendo que el puesto 1 es el ganador
GROUP BY u.id, u.nombre
ORDER BY cantidad_premios DESC;




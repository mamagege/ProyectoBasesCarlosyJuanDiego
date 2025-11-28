--Consultas Gerenciales

--¿Cuales son los juegos que generan más apuestas perdidas?

--Utilidad = Apuesta Perdida

SELECT juegos.id, juegos.nombre, COUNT(apuestas.estado) AS Total_Apuestas_Perdidas FROM JUEGOS
JOIN APUESTAS ON juegos.id = apuestas.id
WHERE apuestas.estado = 'Perdida'
GROUP BY juegos.id, juegos.nombre


--¿Quiénes son los clientes más valiosos?

--Puede ser valor de: monto de Apuestas, cantidad de apuestas pérdidas o cantidad de cambio de fichas

--Por monto de Apuestas:

SELECT UsuariosFrecuentes.id, Usuarios.nombre, apuestas.monto FROM UsuariosFrecuentes
JOIN APUESTAS on UsuariosFrecuentes.id = apuestas.id 
JOIN USUARIOS on UsuariosFrecuentes.id = Usuarios.id 
ORDER BY apuestas.monto DESC

--Por cantidad de apuestas perdidas

SELECT UsuariosFrecuentes.id, Usuarios.nombre, COUNT(apuestas.estado) AS Total_Apuestas_Perdidas FROM UsuariosFrecuentes
JOIN APUESTAS on UsuariosFrecuentes.id = apuestas.id 
JOIN USUARIOS on UsuariosFrecuentes.id = Usuarios.id 
WHERE apuestas.estado = 'Perdida'
GROUP BY Usuarios.nombre, UsuariosFrecuentes.id

--Por cantidad de cambio de fichas

SELECT UsuariosFrecuentes.id, Usuarios.nombre, Fichas.monto FROM UsuariosFrecuentes
JOIN FICHAS on UsuariosFrecuentes.id = fichas.id 
JOIN USUARIOS on UsuariosFrecuentes.id = Usuarios.id
ORDER BY Fichas.monto DESC

--¿Cuales son los dealers que generan mas ingresos para el casino?

SELECT Dealers.id, Empleados.nombre, COUNT(apuestas.estado) FROM DEALERS
JOIN APUESTAS ON apuestas.id = dealers.id 
JOIN EMPLEADOS ON empleados.id = dealers.id
GROUP BY Dealers.id, Empleados.nombre

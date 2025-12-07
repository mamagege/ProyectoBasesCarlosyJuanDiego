--VISTAS

--1. Información Completa de Usuarios (FRECUENTES, INVITADOS Y SUS BENEFICIOS)
--Esta vista es clave pues la información del usuario es muy frecuente y común querer saberla para analizar datos y balance.

CREATE OR REPLACE VIEW V_UsuariosCompleto AS
SELECT 
    u.id,
    u.nombre,
    u.balance,
    uf.correo,
    uf.celular,
    uf.puntos,
    b.id AS beneficio_id,
    b.requisito AS beneficio_requisito,
    b.descripcion AS beneficio_descripcion
FROM Usuarios u
LEFT JOIN UsuariosFrecuentes uf ON u.id = uf.id
LEFT JOIN UsuariosFrecuentes_Beneficios ufb ON uf.id = ufb.usuarioFrecuente
LEFT JOIN Beneficios b ON ufb.beneficio = b.id;

--2. Detalles de Cambios de fichas entre el cajero y el usuario pues es muy común querer verlas y rastrearlas

CREATE OR REPLACE VIEW V_CambioFichas_Detalle AS
SELECT
    cf.id,
    cf.monto,
    cf.fechaHora,
    cf.cajaRecibe,
    u.id AS usuario_id,
    u.nombre AS usuario,
    c.id AS cajero_id,
    e.nombre AS cajero_nombre,
    e.turno AS cajero_turno
FROM CambioFichas cf
JOIN Usuarios u ON cf.usuario = u.id
JOIN Cajeros c ON cf.cajero = c.id
JOIN Empleados e ON c.id = e.id;

--3. Vista a detalle sobre la mesa y cómo está asignada para verificar estados de mesas y dealers.

CREATE OR REPLACE VIEW V_Mesas_Detalle AS
SELECT 
    m.id AS mesa_id,
    m.numeroMesa,
    m.estado,
    j.id AS juego_id,
    j.nombre AS juego,
    d.id AS dealer_id,
    e.nombre AS dealer_nombre,
    e.turno AS dealer_turno
FROM Mesas m
JOIN Juegos j ON m.juego = j.id
JOIN Dealers d ON m.dealer = d.id
JOIN Empleados e ON d.id = e.id;

--4. Vista a detaller sobre la apuesta, quien la hizo, quién la recibió y el estado de ésta. 

CREATE OR REPLACE VIEW V_Apuestas_Detalle AS
SELECT
    a.id AS apuesta_id,
    a.monto,
    a.fechaHora,
    a.estado,
    u.nombre AS usuario,
    m.numeroMesa AS mesa,
    j.nombre AS juego,
    e.nombre AS dealer
FROM Apuestas a
JOIN Usuarios u ON a.usuario = u.id
JOIN Mesas m ON a.mesa = m.id
JOIN Juegos j ON m.juego = j.id
JOIN Dealers d ON m.dealer = d.id
JOIN Empleados e ON d.id = e.id;

--5. Vista EMPLEADO/ROL útil para un paneo administrativo

CREATE OR REPLACE VIEW V_Empleados_Roles AS
SELECT 
    e.id,
    e.nombre,
    e.turno,
    CASE 
        WHEN c.id IS NOT NULL THEN 'Cajero'
        WHEN d.id IS NOT NULL THEN 'Dealer'
        ELSE 'Otro'
    END AS rol
FROM Empleados e
LEFT JOIN Cajeros c ON e.id = c.id
LEFT JOIN Dealers d ON e.id = d.id;

--6 Vista sobre resumen financiero con sums y cuentas del balance de los usuarios y sus apuestas

CREATE OR REPLACE VIEW V_Usuario_ResumenFinanciero AS
SELECT 
    u.id,
    u.nombre,
    u.balance,
    (SELECT SUM(a.monto) FROM Apuestas a WHERE a.usuario = u.id) AS total_apuestas,
    (SELECT SUM(cf.monto) FROM CambioFichas cf WHERE cf.usuario = u.id) AS total_cambios_fichas
FROM Usuarios u;








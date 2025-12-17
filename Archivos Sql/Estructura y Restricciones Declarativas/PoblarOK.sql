--Poblar OK
-- Poblar OK (Corregido para Auto-Incremento)

-- NOTA: Se asume que las tablas principales (Usuarios, Empleados, Juegos, etc.)
-- están definidas con GENERATED ALWAYS AS IDENTITY, por lo que se omite el campo 'id'
-- en la inserción. Las tablas hijas (Cajeros, Dealers, etc.) mantienen el 'id'
-- porque es una Clave Foránea (FK) que referencia el ID generado por el padre.

-- ============================================================
-- 1. USUARIOS
-- ============================================================
INSERT INTO Usuarios (nombre, balance) VALUES ('Carlos Pérez', 500000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Laura Gómez', 350000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Andrés López', 1200000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Marta Ruiz', 800000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Julián Torres', 250000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Paola Ríos', 650000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Diego Castro', 700000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Sandra León', 950000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Ricardo Peña', 400000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Valentina Mora', 1100000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Samuel Ortega', 720000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Catalina Pardo', 560000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Felipe Navarro', 830000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Daniela Prieto', 410000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Santiago Vargas', 980000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Natalia Cuéllar', 300000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Óscar Ramírez', 1500000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Karen Salinas', 470000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Esteban Muñoz', 890000);
INSERT INTO Usuarios (nombre, balance) VALUES ('Luisa Cárdenas', 620000);


-- ============================================================
-- 2. USUARIOS FRECUENTES
-- ============================================================
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (1, 'carlosp@gmail.com', '3001112233', 150);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (2, 'laurag@gmail.com', '3002223344', 200);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (3, 'andresl@gmail.com', '3003334455', 350);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (4, 'martar@gmail.com', '3004445566', 180);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (5, 'julian.t@gmail.com', '3005556677', 90);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (6, 'paolar@gmail.com', '3006667788', 120);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (7, 'diegoc@gmail.com', '3007778899', 500);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (8, 'sandraleon@gmail.com', '3008889900', 240);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (9, 'ricardop@gmail.com', '3011112233', 310);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (10, 'valentinam@gmail.com', '3012223344', 400);

-- ============================================================
-- 3. USUARIOS INVITADOS
-- ============================================================
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (11, 3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (12, 2);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (13, 4);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (14, 1);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (15, 5);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (16, 2);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (17, 6);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (18, 1);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (19, 3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (20, 2);

-- ============================================================
-- 4. BENEFICIOS
-- ============================================================
INSERT INTO Beneficios (requisito, descripcion) VALUES ('100 puntos', '1 bebida gratis');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('200 puntos', 'Descuento 10% en fichas');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('300 puntos', 'Entrada VIP');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('400 puntos', 'Comida gratis');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('500 puntos', 'Crédito adicional de juego');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('150 puntos', 'Estacionamiento gratis');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('250 puntos', 'Acceso a ruleta exclusiva');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('350 puntos', '2x1 en bebidas');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('450 puntos', 'Descuento en mesa VIP');
INSERT INTO Beneficios (requisito, descripcion) VALUES ('600 puntos', 'Regalo sorpresa');

-- ============================================================
-- 5. USUARIOS FRECUENTES - BENEFICIOS
-- ============================================================
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (1, 1);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (2, 2);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (3, 3);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (4, 4);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (5, 5);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (6, 6);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (7, 7);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (8, 8);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (9, 9);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (10, 10);

-- ============================================================
-- 6. EMPLEADOS
-- ============================================================
INSERT INTO Empleados (nombre, turno) VALUES ('Juan Herrera', 'Manana');
INSERT INTO Empleados (nombre, turno) VALUES ('Sofía Díaz', 'Tarde');
INSERT INTO Empleados (nombre, turno) VALUES ('Pedro Rincón', 'Noche');
INSERT INTO Empleados (nombre, turno) VALUES ('Camila Ortiz', 'Manana');
INSERT INTO Empleados (nombre, turno) VALUES ('Luis Ramírez', 'Tarde');
INSERT INTO Empleados (nombre, turno) VALUES ('Daniela Gómez', 'Noche');
INSERT INTO Empleados (nombre, turno) VALUES ('Esteban Cruz', 'Manana');
INSERT INTO Empleados (nombre, turno) VALUES ('Ana Morales', 'Tarde');
INSERT INTO Empleados (nombre, turno) VALUES ('Felipe Vargas', 'Noche');
INSERT INTO Empleados (nombre, turno) VALUES ('Lucía Ochoa', 'Manana');

-- ============================================================
-- 7. CAJEROS
-- ============================================================
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (1, 'Alto', 1);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (2, 'Medio', 2);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (3, 'Bajo', 3);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (4, 'Alto', 4);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (5, 'Medio', 5);

-- ============================================================
-- 8. DEALERS
-- ============================================================
INSERT INTO Dealers (id, especialidad) VALUES (6, 'Blackjack');
INSERT INTO Dealers (id, especialidad) VALUES (7, 'Ruleta');
INSERT INTO Dealers (id, especialidad) VALUES (8, 'Poker');
INSERT INTO Dealers (id, especialidad) VALUES (9, 'Blackjack');
INSERT INTO Dealers (id, especialidad) VALUES (10, 'Baccarat');

-- ============================================================
-- 9. JUEGOS
-- ============================================================
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Blackjack', 5, 5000, 500000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Poker Texas', 8, 10000, 1000000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Ruleta', 6, 2000, 200000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Baccarat', 7, 5000, 300000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Craps', 8, 3000, 400000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Poker Omaha', 8, 10000, 700000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Blackjack VIP', 4, 20000, 2000000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Mini Ruleta', 4, 1000, 100000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Super Poker', 6, 15000, 1500000);
INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
VALUES ('Mega Blackjack', 5, 5000, 600000);

-- ============================================================
-- 10. MESAS
-- ============================================================
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (101, 'Abierta', 1, 6);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (102, 'Cerrada', 2, 7);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (103, 'Abierta', 3, 8);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (104, 'En mantenimiento', 4, 9);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (105, 'Abierta', 5, 10);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (106, 'Cerrada', 6, 6);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (107, 'Abierta', 7, 7);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (108, 'Abierta', 8, 8);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (109, 'En mantenimiento', 9, 9);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (110, 'Abierta', 10, 10);

-- ============================================================
-- 11. CambioFichas
-- ============================================================
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (50000, TO_DATE('2025-10-25 15:30', 'YYYY-MM-DD HH24:MI'), 1, 1, 'Dinero');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (20000, TO_DATE('2025-10-25 16:10', 'YYYY-MM-DD HH24:MI'), 2, 2, 'Fichas');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (100000, TO_DATE('2025-10-26 17:00', 'YYYY-MM-DD HH24:MI'), 3, 3, 'Dinero');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (70000, TO_DATE('2025-10-26 18:00', 'YYYY-MM-DD HH24:MI'), 4, 4, 'Fichas');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (150000, TO_DATE('2025-10-27 19:00', 'YYYY-MM-DD HH24:MI'), 5, 5, 'Dinero');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (30000, TO_DATE('2025-10-27 19:30', 'YYYY-MM-DD HH24:MI'), 6, 1, 'Fichas');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (80000, TO_DATE('2025-10-28 20:00', 'YYYY-MM-DD HH24:MI'), 7, 2, 'Dinero');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (60000, TO_DATE('2025-10-28 20:30', 'YYYY-MM-DD HH24:MI'), 8, 3, 'Fichas');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (90000, TO_DATE('2025-10-29 21:00', 'YYYY-MM-DD HH24:MI'), 9, 4, 'Dinero');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (50000, TO_DATE('2025-10-30 22:00', 'YYYY-MM-DD HH24:MI'), 10, 5, 'Fichas');

-- ============================================================
-- 12. APUESTAS
-- ============================================================
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (5000, TO_DATE('2025-10-25 15:45', 'YYYY-MM-DD HH24:MI'), 'En proceso', 1, 9);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (10000, TO_DATE('2025-10-25 16:20', 'YYYY-MM-DD HH24:MI'), 'Ganada', 2, 10);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (20000, TO_DATE('2025-10-26 17:20', 'YYYY-MM-DD HH24:MI'), 'Perdida', 3, 11);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (8000, TO_DATE('2025-10-26 18:30', 'YYYY-MM-DD HH24:MI'), 'Ganada', 4, 12);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (15000, TO_DATE('2025-10-27 19:15', 'YYYY-MM-DD HH24:MI'), 'Perdida', 5, 13);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (10000, TO_DATE('2025-10-27 20:00', 'YYYY-MM-DD HH24:MI'), 'Ganada', 6, 6);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (25000, TO_DATE('2025-10-28 21:00', 'YYYY-MM-DD HH24:MI'), 'En proceso', 7, 7);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (30000, TO_DATE('2025-10-28 21:30', 'YYYY-MM-DD HH24:MI'), 'Ganada', 8, 8);


--CICLO 2  --CORREGIR POBLAR OK

-- ============================================================
-- 13. Torneos
-- ============================================================

INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo A', TO_DATE('2025-12-01', 'YYYY-MM-DD'), TO_DATE('2025-12-15', 'YYYY-MM-DD'), 'Activo', 1000000, 1);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo B', TO_DATE('2025-12-10', 'YYYY-MM-DD'), TO_DATE('2025-12-20', 'YYYY-MM-DD'), 'Activo', 500000, 2);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo C', TO_DATE('2025-12-05', 'YYYY-MM-DD'), TO_DATE('2025-12-10', 'YYYY-MM-DD'), 'Finalizado', 750000, 3);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo D', TO_DATE('2025-12-12', 'YYYY-MM-DD'), TO_DATE('2025-12-22', 'YYYY-MM-DD'), 'Activo', 1500000, 4);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo E', TO_DATE('2025-12-15', 'YYYY-MM-DD'), TO_DATE('2025-12-25', 'YYYY-MM-DD'), 'Activo', 2000000, 5);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo F', TO_DATE('2025-12-20', 'YYYY-MM-DD'), TO_DATE('2025-12-30', 'YYYY-MM-DD'), 'Activo', 2500000, 6);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo G', TO_DATE('2025-12-01', 'YYYY-MM-DD'), TO_DATE('2025-12-10', 'YYYY-MM-DD'), 'Cancelado', 1000000, 7);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo H', TO_DATE('2025-12-03', 'YYYY-MM-DD'), TO_DATE('2025-12-15', 'YYYY-MM-DD'), 'Activo', 3000000, 8);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo I', TO_DATE('2025-12-07', 'YYYY-MM-DD'), TO_DATE('2025-12-18', 'YYYY-MM-DD'), 'Activo', 1200000, 9);
INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego)
VALUES ('Torneo J', TO_DATE('2025-12-10', 'YYYY-MM-DD'), TO_DATE('2025-12-20', 'YYYY-MM-DD'), 'Activo', 1800000, 10);

-- ============================================================
-- 14. Participantes
-- ============================================================
-- Participantes en el torneo 1
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (1, 1, TO_DATE('2025-12-01', 'YYYY-MM-DD'), 'Inscrito');
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (1, 2, TO_DATE('2025-12-02', 'YYYY-MM-DD'), 'Inscrito');
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (1, 3, TO_DATE('2025-12-03', 'YYYY-MM-DD'), 'Inscrito');
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (1, 4, TO_DATE('2025-12-04', 'YYYY-MM-DD'), 'Inscrito');
-- Participantes en el torneo 2
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (2, 5, TO_DATE('2025-12-05', 'YYYY-MM-DD'), 'Eliminado');
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (2, 6, TO_DATE('2025-12-06', 'YYYY-MM-DD'), 'Eliminado');
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (2, 7, TO_DATE('2025-12-07', 'YYYY-MM-DD'), 'Inscrito');
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (2, 8, TO_DATE('2025-12-08', 'YYYY-MM-DD'), 'Inscrito');
-- Participantes en el torneo 3
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (3, 9, TO_DATE('2025-12-09', 'YYYY-MM-DD'), 'Inscrito');
INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
VALUES (3, 10, TO_DATE('2025-12-10', 'YYYY-MM-DD'), 'Inscrito');


-- ============================================================
-- 15. Premios
-- ============================================================

-- Premios para el torneo 1
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (1, 1, '1er Lugar: $100,000', 100000, 'Asignado');
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (1, 2, '2do Lugar: $50,000', 50000, 'Asignado');
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (1, 3, '3er Lugar: $25,000', 25000, 'Asignado');
-- Premios para el torneo 2
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (2, 4, '1er Lugar: $150,000', 150000, 'Asignado');
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (2, 5, '2do Lugar: $75,000', 75000, 'Asignado');
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (2, 6, '3er Lugar: $50,000', 50000, 'Asignado');
-- Premios para el torneo 3
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (3, 7, '1er Lugar: $200,000', 200000, 'Asignado');
INSERT INTO Premios (torneo, participante, premio, monto, estado)
VALUES (3, 8, '2do Lugar: $100,000', 100000, 'Asignado');

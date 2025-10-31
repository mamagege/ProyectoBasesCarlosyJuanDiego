Poblar OK

-- ============================================================
-- 1. USUARIOS
-- ============================================================
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Carlos Pérez', 500000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (2, 'Laura Gómez', 350000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (3, 'Andrés López', 1200000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (4, 'Marta Ruiz', 800000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (5, 'Julián Torres', 250000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (6, 'Paola Ríos', 650000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (7, 'Diego Castro', 700000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (8, 'Sandra León', 950000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (9, 'Ricardo Peña', 400000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (10, 'Valentina Mora', 1100000);

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
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (5, 3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (6, 2);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (7, 4);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (8, 1);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (9, 5);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (10, 2);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (1, 6);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (2, 1);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (3, 3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (4, 2);

-- ============================================================
-- 4. BENEFICIOS
-- ============================================================
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '100 puntos', '1 bebida gratis');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (2, '200 puntos', 'Descuento 10% en fichas');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (3, '300 puntos', 'Entrada VIP');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (4, '400 puntos', 'Comida gratis');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (5, '500 puntos', 'Crédito adicional de juego');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (6, '150 puntos', 'Estacionamiento gratis');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (7, '250 puntos', 'Acceso a ruleta exclusiva');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (8, '350 puntos', '2x1 en bebidas');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (9, '450 puntos', 'Descuento en mesa VIP');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (10, '600 puntos', 'Regalo sorpresa');

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
INSERT INTO Empleados (id, nombre, turno) VALUES (1, 'Juan Herrera', 'Manana');
INSERT INTO Empleados (id, nombre, turno) VALUES (2, 'Sofía Díaz', 'Tarde');
INSERT INTO Empleados (id, nombre, turno) VALUES (3, 'Pedro Rincón', 'Noche');
INSERT INTO Empleados (id, nombre, turno) VALUES (4, 'Camila Ortiz', 'Manana');
INSERT INTO Empleados (id, nombre, turno) VALUES (5, 'Luis Ramírez', 'Tarde');
INSERT INTO Empleados (id, nombre, turno) VALUES (6, 'Daniela Gómez', 'Noche');
INSERT INTO Empleados (id, nombre, turno) VALUES (7, 'Esteban Cruz', 'Manana');
INSERT INTO Empleados (id, nombre, turno) VALUES (8, 'Ana Morales', 'Tarde');
INSERT INTO Empleados (id, nombre, turno) VALUES (9, 'Felipe Vargas', 'Noche');
INSERT INTO Empleados (id, nombre, turno) VALUES (10, 'Lucía Ochoa', 'Manana');

-- ============================================================
-- 7. CAJEROS
-- ============================================================
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (1, 'Alto', 1);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (2, 'Medio', 2);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (3, 'Bajo', 3);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (4, 'Alto', 4);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (5, 'Medio', 5);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (6, 'Bajo', 6);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (7, 'Alto', 7);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (8, 'Medio', 8);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (9, 'Bajo', 9);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (10, 'Alto', 10);

-- ============================================================
-- 8. DEALERS
-- ============================================================
INSERT INTO Dealers (id, especialidad) VALUES (1, 'Blackjack');
INSERT INTO Dealers (id, especialidad) VALUES (2, 'Poker');
INSERT INTO Dealers (id, especialidad) VALUES (3, 'Ruleta');
INSERT INTO Dealers (id, especialidad) VALUES (4, 'Baccarat');
INSERT INTO Dealers (id, especialidad) VALUES (5, 'Poker');
INSERT INTO Dealers (id, especialidad) VALUES (6, 'Blackjack');
INSERT INTO Dealers (id, especialidad) VALUES (7, 'Ruleta');
INSERT INTO Dealers (id, especialidad) VALUES (8, 'Poker');
INSERT INTO Dealers (id, especialidad) VALUES (9, 'Blackjack');
INSERT INTO Dealers (id, especialidad) VALUES (10, 'Baccarat');

-- ============================================================
-- 9. JUEGOS
-- ============================================================
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (1, 'Blackjack', 5, 5000, 500000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (2, 'Poker Texas', 8, 10000, 1000000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (3, 'Ruleta', 6, 2000, 200000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (4, 'Baccarat', 7, 5000, 300000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (5, 'Craps', 8, 3000, 400000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (6, 'Poker Omaha', 8, 10000, 700000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (7, 'Blackjack VIP', 4, 20000, 2000000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (8, 'Mini Ruleta', 4, 1000, 100000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (9, 'Super Poker', 6, 15000, 1500000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (10, 'Mega Blackjack', 5, 5000, 600000);

-- ============================================================
-- 10. MESAS
-- ============================================================
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (1, 101, 'Abierta', 1, 1);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (2, 102, 'Cerrada', 2, 2);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (3, 103, 'Abierta', 3, 3);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (4, 104, 'En mantenimiento', 4, 4);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (5, 105, 'Abierta', 5, 5);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (6, 106, 'Cerrada', 6, 6);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (7, 107, 'Abierta', 7, 7);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (8, 108, 'Abierta', 8, 8);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (9, 109, 'En mantenimiento', 9, 9);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (10, 110, 'Abierta', 10, 10);

-- ============================================================
-- 11. FICHAS
-- ============================================================
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (1, 50000, TO_DATE('2025-10-25 15:30', 'YYYY-MM-DD HH24:MI'), 1, 1, 'Dinero');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (2, 20000, TO_DATE('2025-10-25 16:10', 'YYYY-MM-DD HH24:MI'), 2, 2, 'Fichas');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (3, 100000, TO_DATE('2025-10-26 17:00', 'YYYY-MM-DD HH24:MI'), 3, 3, 'Dinero');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (4, 70000, TO_DATE('2025-10-26 18:00', 'YYYY-MM-DD HH24:MI'), 4, 4, 'Fichas');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (5, 150000, TO_DATE('2025-10-27 19:00', 'YYYY-MM-DD HH24:MI'), 5, 5, 'Dinero');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (6, 30000, TO_DATE('2025-10-27 19:30', 'YYYY-MM-DD HH24:MI'), 6, 6, 'Fichas');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (7, 80000, TO_DATE('2025-10-28 20:00', 'YYYY-MM-DD HH24:MI'), 7, 7, 'Dinero');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (8, 60000, TO_DATE('2025-10-28 20:30', 'YYYY-MM-DD HH24:MI'), 8, 8, 'Fichas');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (9, 90000, TO_DATE('2025-10-29 21:00', 'YYYY-MM-DD HH24:MI'), 9, 9, 'Dinero');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (10, 50000, TO_DATE('2025-10-30 22:00', 'YYYY-MM-DD HH24:MI'), 10, 10, 'Fichas');

-- ============================================================
-- 12. APUESTAS
-- ============================================================
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (1, 5000, TO_DATE('2025-10-25 15:45', 'YYYY-MM-DD HH24:MI'), 'En proceso', 1, 1);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (2, 10000, TO_DATE('2025-10-25 16:20', 'YYYY-MM-DD HH24:MI'), 'Ganada', 2, 2);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (3, 20000, TO_DATE('2025-10-26 17:20', 'YYYY-MM-DD HH24:MI'), 'Perdida', 3, 3);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (4, 8000, TO_DATE('2025-10-26 18:30', 'YYYY-MM-DD HH24:MI'), 'Ganada', 4, 4);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (5, 15000, TO_DATE('2025-10-27 19:15', 'YYYY-MM-DD HH24:MI'), 'Perdida', 5, 5);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (6, 10000, TO_DATE('2025-10-27 20:00', 'YYYY-MM-DD HH24:MI'), 'Ganada', 6, 6);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (7, 25000, TO_DATE('2025-10-28 21:00', 'YYYY-MM-DD HH24:MI'), 'En proceso', 7, 7);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (8, 30000, TO_DATE('2025-10-28 21:30', 'YYYY-MM-DD HH24:MI'), 'Ganada', 8, 8);



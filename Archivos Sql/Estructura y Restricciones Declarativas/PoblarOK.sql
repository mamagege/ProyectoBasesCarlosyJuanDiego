--Poblar OK
-- Poblar OK (Corregido para Auto-Incremento)

-- NOTA: Se asume que las tablas principales (Usuarios, Empleados, Juegos, etc.)
-- están definidas con GENERATED ALWAYS AS IDENTITY, por lo que se omite el campo 'id'
-- en la inserción. Las tablas hijas (Cajeros, Dealers, etc.) mantienen el 'id'
-- porque es una Clave Foránea (FK) que referencia el ID generado por el padre.

-- ============================================================
-- 1. USUARIOS (Master Table - AUTO-INCREMENTA ID)
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
-- 2. USUARIOS FRECUENTES (Dependent Table - Usa IDs 1-10)
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
-- 3. USUARIOS INVITADOS (Dependent Table - Usa IDs 11-20)
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
-- 4. BENEFICIOS (Master Table - AUTO-INCREMENTA ID)
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
-- 5. USUARIOS FRECUENTES - BENEFICIOS (Relationship Table - FKs)
-- ============================================================
-- Se mantiene la asignación explícita ya que son FKs a IDs generados
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
-- 6. EMPLEADOS (Master Table - AUTO-INCREMENTA ID)
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
-- 7. CAJEROS (Dependent Table - Usa IDs 1-10)
-- ============================================================
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (1, 'Alto', 1);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (2, 'Medio', 2);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (3, 'Bajo', 3);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (4, 'Alto', 4);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (5, 'Medio', 5);

-- ============================================================
-- 8. DEALERS (Dependent Table - Usa IDs 1-10)
-- ============================================================
INSERT INTO Dealers (id, especialidad) VALUES (6, 'Blackjack');
INSERT INTO Dealers (id, especialidad) VALUES (7, 'Ruleta');
INSERT INTO Dealers (id, especialidad) VALUES (8, 'Poker');
INSERT INTO Dealers (id, especialidad) VALUES (9, 'Blackjack');
INSERT INTO Dealers (id, especialidad) VALUES (10, 'Baccarat');

-- ============================================================
-- 9. JUEGOS (Master Table - AUTO-INCREMENTA ID)
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
-- 10. MESAS (Master Table - AUTO-INCREMENTA ID. Usa FKs generados)
-- ============================================================
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (101, 'Abierta', 1, 1);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (102, 'Cerrada', 2, 2);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (103, 'Abierta', 3, 3);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (104, 'En mantenimiento', 4, 4);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (105, 'Abierta', 5, 5);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (106, 'Cerrada', 6, 6);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (107, 'Abierta', 7, 7);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (108, 'Abierta', 8, 8);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (109, 'En mantenimiento', 9, 9);
INSERT INTO Mesas (numeroMesa, estado, juego, dealer) VALUES (110, 'Abierta', 10, 10);

-- ============================================================
-- 11. CambioFichas (Master Table - AUTO-INCREMENTA ID)
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
VALUES (30000, TO_DATE('2025-10-27 19:30', 'YYYY-MM-DD HH24:MI'), 6, 6, 'Fichas');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (80000, TO_DATE('2025-10-28 20:00', 'YYYY-MM-DD HH24:MI'), 7, 7, 'Dinero');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (60000, TO_DATE('2025-10-28 20:30', 'YYYY-MM-DD HH24:MI'), 8, 8, 'Fichas');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (90000, TO_DATE('2025-10-29 21:00', 'YYYY-MM-DD HH24:MI'), 9, 9, 'Dinero');
INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (50000, TO_DATE('2025-10-30 22:00', 'YYYY-MM-DD HH24:MI'), 10, 10, 'Fichas');

-- ============================================================
-- 12. APUESTAS (Master Table - AUTO-INCREMENTA ID)
-- ============================================================
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (5000, TO_DATE('2025-10-25 15:45', 'YYYY-MM-DD HH24:MI'), 'En proceso', 1, 1);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (10000, TO_DATE('2025-10-25 16:20', 'YYYY-MM-DD HH24:MI'), 'Ganada', 2, 2);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (20000, TO_DATE('2025-10-26 17:20', 'YYYY-MM-DD HH24:MI'), 'Perdida', 3, 3);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (8000, TO_DATE('2025-10-26 18:30', 'YYYY-MM-DD HH24:MI'), 'Ganada', 4, 4);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (15000, TO_DATE('2025-10-27 19:15', 'YYYY-MM-DD HH24:MI'), 'Perdida', 5, 5);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (10000, TO_DATE('2025-10-27 20:00', 'YYYY-MM-DD HH24:MI'), 'Ganada', 6, 6);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (25000, TO_DATE('2025-10-28 21:00', 'YYYY-MM-DD HH24:MI'), 'En proceso', 7, 7);
INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
VALUES (30000, TO_DATE('2025-10-28 21:30', 'YYYY-MM-DD HH24:MI'), 'Ganada', 8, 8);
--POBLAR NO OK

--------------------------------------------------------------------------------
-- SCRIPT DE PRUEBAS DE RESTRICCIONES (INSERTS INVÁLIDOS)
-- Autor: ChatGPT (GPT-5)
-- Fecha: 2025-10-31
--------------------------------------------------------------------------------

-- ============================================================
-- 1. USUARIOS (PK duplicadas)
-- ============================================================
-- PK repetida (id = 1)
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Duplicado Usuario', 99999);
-- Balance negativo (no hay check pero podría ser inválido lógicamente)
INSERT INTO Usuarios (id, nombre, balance) VALUES (11, 'Saldo Negativo', -500);
-- Nulos en campos NOT NULL
INSERT INTO Usuarios (id, nombre, balance) VALUES (12, NULL, 10000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (13, 'Usuario sin balance', NULL);
-- 6 inserts con id repetido
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Usuario Duplicado 2', 30000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Usuario Duplicado 3', 40000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Usuario Duplicado 4', 50000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Usuario Duplicado 5', 60000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Usuario Duplicado 6', 70000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (1, 'Usuario Duplicado 7', 80000);

-- ============================================================
-- 2. USUARIOS FRECUENTES (FK, UK, CHECK)
-- ============================================================
-- FK inválida: id no existe en Usuarios
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (99, 'invalido@gmail.com', '3019999999', 100);
-- Correo sin '@' (viola CHECK)
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (2, 'correoSinArroba.com', '3001111111', 100);
-- Celular repetido (viola UNIQUE)
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (3, 'nuevo@gmail.com', '3001112233', 200);
-- Correo repetido (viola UNIQUE)
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (4, 'carlosp@gmail.com', '3022223333', 300);
-- Campos nulos no permitidos
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (5, NULL, '3033334444', 100);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (6, 'sinCelular@gmail.com', NULL, 150);
-- Puntos negativos (posiblemente lógico inválido)
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (7, 'negativo@gmail.com', '3044445555', -100);
-- Más violaciones FK
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (88, 'fknoexiste@gmail.com', '3055556666', 10);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (89, 'fknoexiste2@gmail.com', '3055556667', 20);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (90, 'fknoexiste3@gmail.com', '3055556668', 30);

-- ============================================================
-- 3. USUARIOS INVITADOS (FK inválida)
-- ============================================================
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (99, 2);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (100, 3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (101, 5);
-- Duplicado PK
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (1, 10);
-- Nulos
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (NULL, 3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (2, NULL);
-- Valores fuera de rango lógico
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (3, -1);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (4, -2);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (5, -3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (6, 99);

-- ============================================================
-- 4. BENEFICIOS (PK duplicada)
-- ============================================================
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '100 puntos', 'Duplicado');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '200 puntos', 'Duplicado 2');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '300 puntos', 'Duplicado 3');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '400 puntos', 'Duplicado 4');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '500 puntos', 'Duplicado 5');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '600 puntos', 'Duplicado 6');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '700 puntos', 'Duplicado 7');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '800 puntos', 'Duplicado 8');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '900 puntos', 'Duplicado 9');
INSERT INTO Beneficios (id, requisito, descripcion) VALUES (1, '1000 puntos', 'Duplicado 10');

-- ============================================================
-- 5. USUARIOS FRECUENTES - BENEFICIOS (PK compuesta y FK inválida)
-- ============================================================
-- Duplicado en PK compuesta
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (1, 1);
-- FK inválidas
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (99, 1);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (1, 99);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (99, 99);
-- Nulos
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (NULL, 1);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (1, NULL);
-- Duplicados
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (2, 2);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (2, 2);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (3, 3);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (3, 3);

-- ============================================================
-- 6. EMPLEADOS (CHECK turno)
-- ============================================================
INSERT INTO Empleados (id, nombre, turno) VALUES (11, 'Turno inválido', 'Mañanita');
INSERT INTO Empleados (id, nombre, turno) VALUES (12, 'Turno inválido 2', 'Tardecita');
INSERT INTO Empleados (id, nombre, turno) VALUES (13, 'Turno inválido 3', 'Madrugada');
INSERT INTO Empleados (id, nombre, turno) VALUES (14, 'Turno inválido 4', 'Mediodía');
INSERT INTO Empleados (id, nombre, turno) VALUES (15, 'Turno inválido 5', 'Descanso');
INSERT INTO Empleados (id, nombre, turno) VALUES (16, 'Turno inválido 6', 'Libre');
INSERT INTO Empleados (id, nombre, turno) VALUES (17, 'Turno inválido 7', 'Turnonoche');
INSERT INTO Empleados (id, nombre, turno) VALUES (18, 'Turno inválido 8', 'Turnodia');
INSERT INTO Empleados (id, nombre, turno) VALUES (19, 'Turno inválido 9', 'TardeNoche');
INSERT INTO Empleados (id, nombre, turno) VALUES (20, 'Turno inválido 10', 'Otro');

-- ============================================================
-- 7. CAJEROS (FK Empleado)
-- ============================================================
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (99, 'Alto', 1); -- Empleado inexistente
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (100, 'Medio', 2);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (101, 'Bajo', 3);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (102, 'Alto', 4);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (103, 'Medio', 5);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (104, 'Bajo', 6);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (105, 'Medio', 7);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (106, 'Alto', 8);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (107, 'Bajo', 9);
INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (108, 'Extra', 10); -- valor inventado no restringido, pero fuera de lógica

-- ============================================================
-- 8. DEALERS (CHECK especialidad, FK)
-- ============================================================
INSERT INTO Dealers (id, especialidad) VALUES (99, 'Domino');
INSERT INTO Dealers (id, especialidad) VALUES (100, 'Ajedrez');
INSERT INTO Dealers (id, especialidad) VALUES (101, 'Dados');
INSERT INTO Dealers (id, especialidad) VALUES (102, 'Slots');
INSERT INTO Dealers (id, especialidad) VALUES (103, 'Cartas');
INSERT INTO Dealers (id, especialidad) VALUES (104, 'Ninguna');
INSERT INTO Dealers (id, especialidad) VALUES (105, 'Truco');
INSERT INTO Dealers (id, especialidad) VALUES (106, 'Otra');
INSERT INTO Dealers (id, especialidad) VALUES (107, 'Sin especialidad');
INSERT INTO Dealers (id, especialidad) VALUES (108, NULL);

-- ============================================================
-- 9. JUEGOS (UK y CHECK lógicos)
-- ============================================================
-- Nombre repetido (viola UNIQUE)
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (11, 'Blackjack', 6, 5000, 600000);
-- minApuesta > maxApuesta (ilógico)
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (12, 'JuegoLoco', 4, 100000, 1000);
-- maxJugadores negativos
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (13, 'JuegoNegativo', -5, 5000, 10000);
-- Nulos en NOT NULL
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (14, NULL, 6, 1000, 50000);
-- Duplicados de nombre
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (15, 'Poker Texas', 8, 2000, 10000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (16, 'Poker Texas', 5, 1000, 20000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (17, 'Poker Texas', 3, 1000, 30000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (18, 'Poker Texas', 2, 1000, 40000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (19, 'Poker Texas', 1, 1000, 50000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
VALUES (20, 'Poker Texas', 10, 1000, 60000);

-- ============================================================
-- 10. MESAS (FK y CHECK estado)
-- ============================================================
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (99, 999, 'Abiertita', 1, 1); -- estado inválido
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (100, 998, 'Cerradita', 2, 2);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (101, 997, 'Disponible', 3, 3);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (102, 996, 'No existe', 4, 4);
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (103, 995, 'Abierta', 99, 1); -- FK juego no existe
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (104, 994, 'Abierta', 1, 99); -- FK dealer no existe
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (105, NULL, 'Abierta', 1, 1); -- numeroMesa nulo
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (106, 993, NULL, 1, 1); -- estado nulo
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (107, 992, 'Abierta', NULL, 1); -- FK nula
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (108, 991, 'Cerrada', 1, NULL);

-- ============================================================
-- 11. FICHAS (CHECK cajaRecibe y FK)
-- ============================================================
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (99, 10000, TO_DATE('2025-10-30','YYYY-MM-DD'), 99, 1, 'Dinero'); -- FK usuario no existe
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (100, 20000, TO_DATE('2025-10-30','YYYY-MM-DD'), 1, 99, 'Fichas'); -- FK cajero no existe
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (101, 30000, TO_DATE('2025-10-30','YYYY-MM-DD'), 1, 1, 'Tarjeta'); -- CHECK cajaRecibe inválido
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (102, 40000, TO_DATE('2025-10-30','YYYY-MM-DD'), 1, 1, 'Efectivo');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (103, 50000, TO_DATE('2025-10-30','YYYY-MM-DD'), 1, 1, 'Nada');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (104, NULL, TO_DATE('2025-10-30','YYYY-MM-DD'), 1, 1, 'Dinero');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (105, 70000, NULL, 1, 1, 'Fichas');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (106, 80000, TO_DATE('2025-10-30','YYYY-MM-DD'), NULL, 1, 'Dinero');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (107, 90000, TO_DATE('2025-10-30','YYYY-MM-DD'), 1, NULL, 'Fichas');
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (108, 100000, TO_DATE('2025-10-30','YYYY-MM-DD'), 1, 1, NULL);

-- ============================================================
-- 12. APUESTAS (CHECK estado, FK)
-- ============================================================
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (99, 5000, TO_DATE('2025-10-25','YYYY-MM-DD'), 'Jugando', 1, 1);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (100, 10000, TO_DATE('2025-10-25','YYYY-MM-DD'), 'Cancelada', 1, 1);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (101, 15000, TO_DATE('2025-10-25','YYYY-MM-DD'), 'Pausada', 


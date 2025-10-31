--Activadores Poblar NO OK

--Disparador: Una apuesta solo puede pasar de “En proceso” a “Ganada” o “Perdida”.

--------------------------------------------------------------------------------
-- 1. PRUEBA NEGATIVA: trg_control_estado_apuesta
--------------------------------------------------------------------------------

-- Insertar apuesta “En proceso” (válida)
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (300, 5000, SYSDATE, 'En proceso', 1, 1);

-- ❌ Intentar actualizar de “En proceso” a un estado no permitido
UPDATE Apuestas SET estado = 'Cancelada' WHERE id = 300; -- DEBERÍA FALLAR

-- ❌ Intentar cambiar un estado final (ya Ganada → Perdida)
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (301, 7000, SYSDATE, 'Ganada', 2, 2);
UPDATE Apuestas SET estado = 'Perdida' WHERE id = 301; -- DEBERÍA FALLAR

-- ❌ Intentar devolver “Perdida” a “En proceso”
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (302, 7000, SYSDATE, 'Perdida', 3, 3);
UPDATE Apuestas SET estado = 'En proceso' WHERE id = 302; -- DEBERÍA FALLAR

-- Otros estados no válidos
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (303, 7000, SYSDATE, 'Suspendida', 4, 4);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (304, 7000, SYSDATE, 'Cancelada', 5, 5);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (305, 7000, SYSDATE, 'Devuelta', 6, 6);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (306, 7000, SYSDATE, 'Nula', 7, 7);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (307, 7000, SYSDATE, 'Anulada', 8, 8);
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (308, 7000, SYSDATE, 'Cobrada', 9, 9);

--Disparador: Al registrar fichas, Si cajaRecibe es igual a dinero, el monto del cambio se resta al balance del usuario si no, el monto se suma al balance.

--------------------------------------------------------------------------------
-- 2. PRUEBA NEGATIVA: trg_actualizar_balance_fichas
--------------------------------------------------------------------------------

-- ❌ Valor no permitido en cajaRecibe
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (310, 10000, SYSDATE, 1, 1, 'Tarjeta'); -- DEBERÍA FALLAR

-- ❌ Valor nulo en cajaRecibe
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (311, 5000, SYSDATE, 2, 2, NULL); -- DEBERÍA FALLAR

-- ❌ FK inválida (usuario inexistente)
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (312, 5000, SYSDATE, 999, 1, 'Dinero'); -- DEBERÍA FALLAR

-- ❌ FK inválida (cajero inexistente)
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (313, 5000, SYSDATE, 1, 999, 'Fichas'); -- DEBERÍA FALLAR

-- ❌ Monto negativo
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (314, -5000, SYSDATE, 1, 1, 'Dinero'); -- DEBERÍA FALLAR

-- ❌ Balance insuficiente (simulado, si quieres probar lógica)
INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (315, 999999999, SYSDATE, 1, 1, 'Dinero'); -- podría fallar por lógica de negocio

-- 4 adicionales con valor cajaRecibe erróneo
INSERT INTO Fichas VALUES (316, 20000, SYSDATE, 2, 2, 'Nada');
INSERT INTO Fichas VALUES (317, 20000, SYSDATE, 2, 2, 'Cheque');
INSERT INTO Fichas VALUES (318, 20000, SYSDATE, 2, 2, 'Oro');
INSERT INTO Fichas VALUES (319, 20000, SYSDATE, 2, 2, 'Crédito');

--Disparador: Un usuario no puede pasar de Usuario frecuente a Usuario invitado

--------------------------------------------------------------------------------
-- 3. PRUEBA NEGATIVA: trg_evitar_frecuente_a_invitado
--------------------------------------------------------------------------------

-- ❌ Usuarios 1–10 ya son frecuentes → no se pueden registrar como invitados
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (1, 1);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (2, 2);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (3, 3);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (4, 4);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (5, 5);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (6, 6);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (7, 7);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (8, 8);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (9, 9);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (10, 10);

--Disparador: Al completar 10 visitas, el usuario invitado se convierte en usuario frecuente.

--------------------------------------------------------------------------------
-- 4. PRUEBA NEGATIVA: trg_promover_a_frecuente
--------------------------------------------------------------------------------

-- ❌ Intentar promover de nuevo a alguien ya promovido (debería no insertar duplicado)
UPDATE UsuariosInvitados SET numeroDeVisitas = 10 WHERE id = 11; -- Ya es frecuente

-- ❌ Intentar bajar visitas y subir de nuevo (trigger ignora si ya existe)
UPDATE UsuariosInvitados SET numeroDeVisitas = 5 WHERE id = 12;
UPDATE UsuariosInvitados SET numeroDeVisitas = 10 WHERE id = 12;

-- ❌ Insertar manualmente un UsuarioFrecuente duplicado
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos)
VALUES (11, 'duplicado@gmail.com', '3009999999', 100); -- Violación de PK/UK

-- 7 intentos adicionales de duplicado (ya promovidos)
INSERT INTO UsuariosFrecuentes VALUES (12, 'test@gmail.com', '3008888888', 0);
INSERT INTO UsuariosFrecuentes VALUES (13, 'test@gmail.com', '3007777777', 0);
INSERT INTO UsuariosFrecuentes VALUES (14, 'test@gmail.com', '3006666666', 0);
INSERT INTO UsuariosFrecuentes VALUES (15, 'test@gmail.com', '3005555555', 0);
INSERT INTO UsuariosFrecuentes VALUES (11, 'otra@gmail.com', '3011111111', 0);
INSERT INTO UsuariosFrecuentes VALUES (12, 'otra2@gmail.com', '3022222222', 0);
INSERT INTO UsuariosFrecuentes VALUES (13, 'otra3@gmail.com', '3033333333', 0);

--Diaparador: Un usuario invitado no puede recibir Beneficios

--------------------------------------------------------------------------------
-- 5. PRUEBA NEGATIVA: trg_evitar_beneficios_invitados
--------------------------------------------------------------------------------

-- ❌ Usuarios 16–20 son invitados (no frecuentes) → no deberían recibir beneficios
INSERT INTO Usuarios (id, nombre, balance) VALUES (16, 'Invitado 6', 200000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (16, 2);

INSERT INTO Usuarios (id, nombre, balance) VALUES (17, 'Invitado 7', 250000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (17, 4);

INSERT INTO Usuarios (id, nombre, balance) VALUES (18, 'Invitado 8', 180000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (18, 5);

INSERT INTO Usuarios (id, nombre, balance) VALUES (19, 'Invitado 9', 300000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (19, 1);

INSERT INTO Usuarios (id, nombre, balance) VALUES (20, 'Invitado 10', 350000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (20, 7);

-- ❌ Intentar dar beneficios a esos invitados → DEBERÍA FALLAR
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (1, 16);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (2, 17);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (3, 18);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (4, 19);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (5, 20);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (6, 16);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (7, 17);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (8, 18);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (9, 19);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (10, 20);


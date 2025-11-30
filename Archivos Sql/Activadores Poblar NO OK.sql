--Activadores Poblar NO OK

--Disparador: Una apuesta solo puede pasar de “En proceso” a “Ganada” o “Perdida”.

--------------------------------------------------------------------------------
-- 1. PRUEBA NEGATIVA: trg_control_estado_apuesta
--------------------------------------------------------------------------------

-- Insertar apuesta “En proceso” (válida)
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (300, 5000, SYSDATE, 'En proceso', 1, 1);

--  Intentar actualizar de “En proceso” a un estado no permitido
UPDATE Apuestas SET estado = 'Cancelada' WHERE id = 300; -- DEBERÍA FALLAR

--  Intentar cambiar un estado final (ya Ganada → Perdida)
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (301, 7000, SYSDATE, 'Ganada', 2, 2);
UPDATE Apuestas SET estado = 'Perdida' WHERE id = 301; -- DEBERÍA FALLAR

--  Intentar devolver “Perdida” a “En proceso”
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (302, 7000, SYSDATE, 'Perdida', 3, 3);
UPDATE Apuestas SET estado = 'En proceso' WHERE id = 302; -- DEBERÍA FALLAR


--Disparador: Al registrar CambioFichas, Si cajaRecibe es igual a dinero, el monto del cambio se resta al balance del usuario si no, el monto se suma al balance.

--------------------------------------------------------------------------------
-- 2. PRUEBA NEGATIVA: trg_actualizar_balance_fichas
--------------------------------------------------------------------------------

--  Valor no permitido en cajaRecibe
INSERT INTO CambioFichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (310, 10000, SYSDATE, 1, 1, 'Tarjeta'); -- DEBERÍA FALLAR

--  Valor nulo en cajaRecibe
INSERT INTO CambioFichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (311, 5000, SYSDATE, 2, 2, NULL); -- DEBERÍA FALLAR

--  FK inválida (usuario inexistente)
INSERT INTO CambioFichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (312, 5000, SYSDATE, 999, 1, 'Dinero'); -- DEBERÍA FALLAR

--  FK inválida (cajero inexistente)
INSERT INTO CambioFichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (313, 5000, SYSDATE, 1, 999, 'Fichas'); -- DEBERÍA FALLAR


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


--  Insertar manualmente un UsuarioFrecuente duplicado
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos)
VALUES (10, 'duplicado@gmail.com', '3009999999', 100); -- Violación de PK/UK

--Diaparador: Un usuario invitado no puede recibir Beneficios

--------------------------------------------------------------------------------
-- 5. PRUEBA NEGATIVA: trg_evitar_beneficios_invitados
--------------------------------------------------------------------------------

--  Intentar dar beneficios a usuarios invitados → DEBERÍA FALLAR
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (1, 16);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (2, 17);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (3, 18);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (4, 12);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (5, 13);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (6, 16);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (7, 17);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (8, 18);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (9, 19);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (10, 20);


--Disparador: Una apuesta solo puede pasar de “En proceso” a “Ganada” o “Perdida”.

--------------------------------------------------------------------------------
-- 1. PRUEBA TRIGGER: trg_control_estado_apuesta
--------------------------------------------------------------------------------
-- Insertar apuestas válidas
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (100, 5000, SYSDATE, 'En proceso', 1, 1);

INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (101, 7000, SYSDATE, 'En proceso', 2, 2);

INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (102, 12000, SYSDATE, 'En proceso', 3, 3);

-- Actualizar a Ganada o Perdida (válido, activa trigger sin error)
UPDATE Apuestas SET estado = 'Ganada' WHERE id = 100;
UPDATE Apuestas SET estado = 'Perdida' WHERE id = 101;
UPDATE Apuestas SET estado = 'Ganada' WHERE id = 102;

-- Más casos válidos
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (103, 15000, SYSDATE, 'En proceso', 4, 4);
UPDATE Apuestas SET estado = 'Perdida' WHERE id = 103;

INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (104, 9000, SYSDATE, 'En proceso', 5, 5);
UPDATE Apuestas SET estado = 'Ganada' WHERE id = 104;

INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (105, 10000, SYSDATE, 'En proceso', 6, 6);
UPDATE Apuestas SET estado = 'Perdida' WHERE id = 105;

INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
VALUES (106, 8000, SYSDATE, 'En proceso', 7, 7);
UPDATE Apuestas SET estado = 'Ganada' WHERE id = 106;

--Disparador: Al registrar fichas, Si cajaRecibe es igual a dinero, el monto del cambio se resta al balance del usuario si no, el monto se suma al balance.

--------------------------------------------------------------------------------
-- 2. PRUEBA TRIGGER: trg_actualizar_balance_fichas
--------------------------------------------------------------------------------
-- Los montos con 'Dinero' restan al balance del usuario.
-- Los montos con 'Fichas' suman al balance.

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (212, 100000, SYSDATE, 1, 1, 'Fichas');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (201, 5000, SYSDATE, 2, 2, 'Fichas');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (202, 30000, SYSDATE, 3, 3, 'Dinero');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (203, 40000, SYSDATE, 4, 4, 'Fichas');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (204, 15000, SYSDATE, 5, 5, 'Dinero');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (205, 8000, SYSDATE, 6, 6, 'Fichas');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (206, 25000, SYSDATE, 7, 7, 'Dinero');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (207, 10000, SYSDATE, 8, 8, 'Fichas');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (208, 20000, SYSDATE, 9, 9, 'Fichas');

INSERT INTO Fichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
VALUES (209, 50000, SYSDATE, 10, 10, 'Dinero');

--Disparador: Un usuario no puede pasar de Usuario frecuente a Usuario invitado

--------------------------------------------------------------------------------
-- 3. PRUEBA TRIGGER: trg_evitar_frecuente_a_invitado
--------------------------------------------------------------------------------
-- Estos usuarios no existen como frecuentes, por lo tanto el insert es válido.

INSERT INTO Usuarios (id, nombre, balance) VALUES (30, 'Nuevo Invitado 1', 300000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (30, 1);

INSERT INTO Usuarios (id, nombre, balance) VALUES (31, 'Nuevo Invitado 2', 250000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (31, 2);

INSERT INTO Usuarios (id, nombre, balance) VALUES (32, 'Nuevo Invitado 3', 400000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (32, 5);

INSERT INTO Usuarios (id, nombre, balance) VALUES (33, 'Nuevo Invitado 4', 500000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (33, 9);

INSERT INTO Usuarios (id, nombre, balance) VALUES (34, 'Nuevo Invitado 5', 150000);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (34, 3);

--Disparador: Al completar 10 visitas, el usuario invitado se convierte en usuario frecuente.

--------------------------------------------------------------------------------
-- 4. PRUEBA TRIGGER: trg_promover_a_frecuente
--------------------------------------------------------------------------------
UPDATE UsuariosInvitados SET numeroDeVisitas = 10 WHERE id = 11;
UPDATE UsuariosInvitados SET numeroDeVisitas = 10 WHERE id = 12;
UPDATE UsuariosInvitados SET numeroDeVisitas = 10 WHERE id = 13;
UPDATE UsuariosInvitados SET numeroDeVisitas = 10 WHERE id = 14;
UPDATE UsuariosInvitados SET numeroDeVisitas = 10 WHERE id = 15;

-- Ahora estos nuevos usuarios deberían aparecer en UsuariosFrecuentes

--Diaparador: Un usuario invitado no puede recibir Beneficios


--------------------------------------------------------------------------------
-- 5. PRUEBA TRIGGER: trg_evitar_beneficios_invitados
--------------------------------------------------------------------------------
-- Estos usuarios (1–10) sí son frecuentes → permitido
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (1, 2);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (2, 3);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (3, 4);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (4, 5);
INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente) VALUES (5, 6);

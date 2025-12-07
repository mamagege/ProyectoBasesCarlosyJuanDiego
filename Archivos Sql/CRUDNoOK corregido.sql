SET SERVEROUTPUT ON;
WHENEVER SQLERROR EXIT FAILURE;

-- ==========================================================
-- 0. PREPARACIÓN DE DATOS PARA PRUEBAS NEGATIVAS
-- ==========================================================

-- Usuarios de prueba (IDs 990-992)
INSERT INTO Usuarios (id, nombre, balance) VALUES (990, 'User Test Delete', 10000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (991, 'User Test FK', 50000);
INSERT INTO Usuarios (id, nombre, balance) VALUES (992, 'User Test Frecuente', 50000);
INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos) VALUES (992, 'frecuente@test.com', '1111', 0);
INSERT INTO Usuarios (id, nombre, balance) VALUES (993, 'User Test Invitado', 0);
INSERT INTO UsuariosInvitados (id, numeroDeVisitas) VALUES (993, 1);


-- Empleado/Juego/Mesa de prueba
INSERT INTO Empleados (id, nombre, turno) VALUES (990, 'Dealer Test', 'Manana');
INSERT INTO Dealers (id, especialidad) VALUES (990, 'Poker');
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta) VALUES (990, 'PokerTest', 10, 500, 50000);
INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta) VALUES (999, 'JuegoDuplicado', 5, 100, 1000); 
INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer) VALUES (990, 100, 'Abierta', 990, 990);

-- Apuesta de prueba (ID 990) ya finalizada (para probar el trigger ORA-20002)
INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa) 
VALUES (990, 1000, SYSDATE, 'Ganada', 990, 990); 

COMMIT;

-- ==========================================================
-- 1. PROCEDIMIENTO DE PRUEBA NEGATIVA (CRUDNoOK)
-- ==========================================================

CREATE OR REPLACE PROCEDURE probar_crud_no_ok AS
    v_error_code NUMBER;
    v_error_msg  VARCHAR2(500);
    
    -- Excepciones de PCK_EXCEPCIONES (Códigos ORA-201xx)
    e_id_existe EXCEPTION; PRAGMA EXCEPTION_INIT(e_id_existe, -20101);
    e_no_existe EXCEPTION; PRAGMA EXCEPTION_INIT(e_no_existe, -20102);
    e_fk_violada EXCEPTION; PRAGMA EXCEPTION_INIT(e_fk_violada, -20103);
    
    -- Excepciones de Triggers y Reglas de Negocio (Códigos ORA-2000x y ORA-201xx específicos)
    e_apuesta_finalizada EXCEPTION; PRAGMA EXCEPTION_INIT(e_apuesta_finalizada, -20002);
    e_usuario_no_invitado EXCEPTION; PRAGMA EXCEPTION_INIT(e_usuario_no_invitado, -20105);
    e_nombre_duplicado EXCEPTION; PRAGMA EXCEPTION_INIT(e_nombre_duplicado, -20108);
    e_registro_dependiente EXCEPTION; PRAGMA EXCEPTION_INIT(e_registro_dependiente, -20110);
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' INICIO DE PRUEBAS NEGATIVAS (CRUDNoOK.sql) ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- ==========================================================
    -- TEST 1: PCK_APUESTAS - Registrar con ID existente (ORA-20101)
    -- ==========================================================
    BEGIN
        SAVEPOINT T1_ID_EXISTE;
        DBMS_OUTPUT.PUT_LINE('1. Probando PCK_APUESTAS.registrar_apuesta con ID existente (Debe fallar ORA-20101)...');
        PCK_APUESTAS.registrar_apuesta(p_id => 990, p_monto => 100, p_usuario_id => 990, p_mesa_id => 990);
        
        DBMS_OUTPUT.PUT_LINE('-> FALLO: Se registró la apuesta y NO lanzó ORA-20101.');
        ROLLBACK TO T1_ID_EXISTE;
    EXCEPTION
        WHEN e_id_existe THEN
            DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20101 (e_id_existe) capturada correctamente.');
            ROLLBACK TO T1_ID_EXISTE;
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            ROLLBACK TO T1_ID_EXISTE;
    END;

    -- ==========================================================
    -- TEST 2: PCK_APUESTAS - Registrar con FK inválida (Usuario 9999) (ORA-20103)
    -- ==========================================================
    BEGIN
        SAVEPOINT T2_FK_INVALIDA;
        DBMS_OUTPUT.PUT_LINE('2. Probando PCK_APUESTAS.registrar_apuesta con FK inexistente (Debe fallar ORA-20103)...');
        PCK_APUESTAS.registrar_apuesta(p_id => 998, p_monto => 100, p_usuario_id => 9999, p_mesa_id => 990);
        
        DBMS_OUTPUT.PUT_LINE('-> FALLO: Se registró la apuesta y NO lanzó ORA-20103.');
        ROLLBACK TO T2_FK_INVALIDA;
    EXCEPTION
        WHEN e_fk_violada THEN
            DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20103 (e_fk_violada) capturada correctamente.');
            ROLLBACK TO T2_FK_INVALIDA;
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            ROLLBACK TO T2_FK_INVALIDA;
    END;
    
    -- ==========================================================
    -- TEST 3: PCK_APUESTAS - Finalizar apuesta ya finalizada (Trigger ORA-20002)
    -- ==========================================================
    BEGIN
        SAVEPOINT T3_TRIGGER_ESTADO;
        DBMS_OUTPUT.PUT_LINE('3. Probando PCK_APUESTAS.finalizar_apuesta ya finalizada (Debe fallar ORA-20002)...');
        PCK_APUESTAS.finalizar_apuesta(p_id => 990, p_nuevo_estado => 'Perdida'); -- 990 ya está 'Ganada'
        
        DBMS_OUTPUT.PUT_LINE('-> FALLO: Se actualizó el estado y NO lanzó la excepción del Trigger.');
        ROLLBACK TO T3_TRIGGER_ESTADO;
    EXCEPTION
        WHEN e_apuesta_finalizada THEN
            DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20002 (Control de estado) capturada correctamente.');
            ROLLBACK TO T3_TRIGGER_ESTADO;
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            ROLLBACK TO T3_TRIGGER_ESTADO;
    END;

    -- ==========================================================
    -- TEST 4: PCK_USUARIOS_FUNC - Registrar visita a Usuario Frecuente (ORA-20105)
    -- ==========================================================
    BEGIN
        SAVEPOINT T4_VISITA_FRECUENTE;
        DBMS_OUTPUT.PUT_LINE('4. Probando PCK_USUARIOS_FUNC.registrar_visita a usuario frecuente (Debe fallar ORA-20105)...');
        PCK_USUARIOS_FUNC.registrar_visita(p_usuario_id => 992); -- ID 992 es Usuario Frecuente
        
        DBMS_OUTPUT.PUT_LINE('-> FALLO: Se registró la visita y NO lanzó la excepción.');
        ROLLBACK TO T4_VISITA_FRECUENTE;
    EXCEPTION
        WHEN e_usuario_no_invitado THEN
            DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20105 (Usuario no es invitado) capturada correctamente.');
            ROLLBACK TO T4_VISITA_FRECUENTE;
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            ROLLBACK TO T4_VISITA_FRECUENTE;
    END;

    -- ==========================================================
    -- TEST 5: PCK_MANTENIMIENTO - Eliminar Usuario con Registros Dependientes (ORA-20110)
    -- ==========================================================
    BEGIN
        SAVEPOINT T5_DELETE_FK;
        DBMS_OUTPUT.PUT_LINE('5. Probando PCK_MANTENIMIENTO.eliminar_usuario con registros dependientes (Debe fallar ORA-20110)...');
        PCK_MANTENIMIENTO.eliminar_usuario(p_id => 990); -- El usuario 990 tiene apuestas asociadas
        
        DBMS_OUTPUT.PUT_LINE('-> FALLO: Se eliminó el usuario y NO lanzó ORA-20110.');
        ROLLBACK TO T5_DELETE_FK;
    EXCEPTION
        WHEN e_registro_dependiente THEN
            DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20110 (Registros dependientes) capturada correctamente.');
            ROLLBACK TO T5_DELETE_FK;
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            ROLLBACK TO T5_DELETE_FK;
    END;

    -- ==========================================================
    -- TEST 6: PCK_MANTENIMIENTO - Actualizar Juego con nombre duplicado (ORA-20108)
    -- ==========================================================
    BEGIN
        SAVEPOINT T6_UQ_JUEGO;
        
        DBMS_OUTPUT.PUT_LINE('6. Probando PCK_MANTENIMIENTO.actualizar_juego con nombre duplicado (Debe fallar ORA-20108)...');
        -- Intentamos actualizar el juego 999 con el nombre del juego 990 ('PokerTest')
        PCK_MANTENIMIENTO.actualizar_juego(p_id => 999, p_nombre => 'PokerTest', p_maxJugadores => 10, p_minApuesta => 500, p_maxApuesta => 50000);
        
        DBMS_OUTPUT.PUT_LINE('-> FALLO: Se actualizó el juego y NO lanzó la excepción de unicidad.');
        ROLLBACK TO T6_UQ_JUEGO;
    EXCEPTION
        WHEN e_nombre_duplicado THEN
            DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20108 (Nombre de juego duplicado) capturada correctamente.');
            ROLLBACK TO T6_UQ_JUEGO;
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            ROLLBACK TO T6_UQ_JUEGO;
    END;
    
    -- ==========================================================
    -- TEST 7: PCK_USUARIOS_FUNC - Consultar saldo inexistente (ORA-20102)
    -- ==========================================================
    BEGIN
        SAVEPOINT T7_CONSULTA_NO_EXISTE;
        DBMS_OUTPUT.PUT_LINE('7. Probando PCK_USUARIOS_FUNC.consultar_saldo inexistente (Debe fallar ORA-20102)...');
        
        -- Intentamos consultar un usuario que no existe
        DECLARE
            v_saldo NUMBER;
        BEGIN
            v_saldo := PCK_USUARIOS_FUNC.consultar_saldo(p_usuario_id => 99999);
        END;
        
        DBMS_OUTPUT.PUT_LINE('-> FALLO: La función devolvió saldo sin error.');
        ROLLBACK TO T7_CONSULTA_NO_EXISTE;
    EXCEPTION
        WHEN e_no_existe THEN
            DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20102 (e_no_existe) capturada correctamente.');
            ROLLBACK TO T7_CONSULTA_NO_EXISTE;
        WHEN OTHERS THEN
            v_error_code := SQLCODE;
            DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            ROLLBACK TO T7_CONSULTA_NO_EXISTE;
    END;

    -- ==========================================================
    -- TEST 8: PCK_MANTENIMIENTO - Asignar beneficio a usuario invitado (Trigger ORA-20005)
    -- ==========================================================
    BEGIN
        SAVEPOINT T8_BENEFICIO_INVITADO;
        -- Creamos un beneficio de prueba
        PCK_MANTENIMIENTO.crear_beneficio(p_id => 999, p_requisito => 'Test', p_descripcion => 'Test Beneficio');

        DBMS_OUTPUT.PUT_LINE('8. Probando PCK_MANTENIMIENTO.asignar_beneficio_a_frecuente a Invitado (Debe fallar ORA-20005)...');
        -- Intentamos asignar el beneficio 999 al usuario invitado 993
        PCK_MANTENIMIENTO.asignar_beneficio_a_frecuente(p_beneficio_id => 999, p_usuario_id => 993);

        DBMS_OUTPUT.PUT_LINE('-> FALLO: Se asignó el beneficio a un usuario invitado y NO lanzó la excepción.');
        ROLLBACK TO T8_BENEFICIO_INVITADO;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20005 THEN
                DBMS_OUTPUT.PUT_LINE('-> ÉXITO: Excepción ORA-20005 (Bloquear beneficios a invitados) capturada correctamente.');
            ELSE
                v_error_code := SQLCODE;
                DBMS_OUTPUT.PUT_LINE('-> FALLO: Error inesperado: ' || v_error_code);
            END IF;
            ROLLBACK TO T8_BENEFICIO_INVITADO;
    END;


    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' FIN DE PRUEBAS NEGATIVAS ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

END probar_crud_no_ok;
/

-- 2. EJECUCIÓN DEL PROCEDIMIENTO
EXEC probar_crud_no_ok;

-- 3. LIMPIEZA DE DATOS DE PRUEBA
DELETE FROM Apuestas WHERE id = 990;
DELETE FROM Mesas WHERE id = 990;
DELETE FROM Dealers WHERE id = 990;
DELETE FROM Empleados WHERE id = 990;
DELETE FROM Juegos WHERE id IN (990, 999);
DELETE FROM UsuariosFrecuentes WHERE id = 992;
DELETE FROM UsuariosInvitados WHERE id = 993;
DELETE FROM Beneficios WHERE id = 999;
DELETE FROM Usuarios WHERE id IN (990, 991, 992, 993);
COMMIT;
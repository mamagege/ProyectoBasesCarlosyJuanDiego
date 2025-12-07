SET SERVEROUTPUT ON;
-- Continuar la ejecución a pesar de los errores para probar todos los casos
WHENEVER SQLERROR CONTINUE;

-- ==========================================================
-- 0. CONFIGURACIÓN Y PROCEDIMIENTO AUXILIAR
-- ==========================================================
CREATE OR REPLACE PROCEDURE print_result_ok (p_test_name IN VARCHAR2) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('-> OK: ' || p_test_name || ' falló como se esperaba (Excepción capturada).');
END;
/

CREATE OR REPLACE PROCEDURE probar_crud_no_ok AS
    -- Variables para datos de prueba que deben existir
    v_dealer_fk             Empleados.id%TYPE;
    v_cajero_fk             Empleados.id%TYPE;
    v_juego_fk              Juegos.id%TYPE;
    v_mesa_fk               Mesas.id%TYPE;
    v_usuario_frecuente_fk  Usuarios.id%TYPE;
    v_beneficio_fk          Beneficios.id%TYPE;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' INICIO DE PRUEBAS NEGATIVAS CRUD (CRUDNoOK.sql) ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- ==========================================================
    -- A. PREPARACIÓN: Crear un set de datos válidos para las pruebas FK
    -- (Los IDs se generan automáticamente)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- A: PREPARACIÓN DE DATOS FK ---');

    -- Crear Empleado (Dealer)
    PCK_MANTENIMIENTO.crear_dealer('Dealer FK Test', 'Manana', 'Blackjack');
    SELECT MAX(id) INTO v_dealer_fk FROM Empleados;
    
    -- Crear Cajero
    PCK_MANTENIMIENTO.crear_cajero('Cajero FK Test', 'Tarde', 'Nivel 1', 1);
    SELECT MAX(id) INTO v_cajero_fk FROM Empleados;
    
    -- Crear Juego (para FK)
    PCK_MANTENIMIENTO.crear_juego('Juego FK Test', 4, 100, 1000);
    SELECT MAX(id) INTO v_juego_fk FROM Juegos;
    
    -- Crear Mesa (usando FKs)
    PCK_MANTENIMIENTO.crear_mesa(1000, 'Abierta', v_juego_fk, v_dealer_fk);
    SELECT MAX(id) INTO v_mesa_fk FROM Mesas;
    
    -- Crear Usuario Frecuente (para FK)
    PCK_MANTENIMIENTO.crear_usuario_frecuente('Usuario FK Test', 1000, 'fk@test.com', '00000000');
    SELECT MAX(id) INTO v_usuario_frecuente_fk FROM Usuarios;
    
    -- Crear Beneficio
    PCK_MANTENIMIENTO.crear_beneficio(100, 'Test Benefit');
    SELECT MAX(id) INTO v_beneficio_fk FROM Beneficios;

    DBMS_OUTPUT.PUT_LINE('   Datos FK creados (Dealer: ' || v_dealer_fk || ', Usuario: ' || v_usuario_frecuente_fk || ', etc.).');

    -- ==========================================================
    -- I. PRUEBAS DE EXISTENCIA (Error -20102: Registro no existe)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- I: Prueba de IDs No Existentes (-20102) ---');
    
    -- Usamos un ID muy alto que no debe existir
    DECLARE
        v_non_existent_id CONSTANT NUMBER := 99999;
        v_cursor SYS_REFCURSOR;
        v_balance Usuarios.balance%TYPE;
    BEGIN
        -- 1. READ
        v_cursor := PCK_MANTENIMIENTO.consultar_empleado(v_non_existent_id);
        print_result_ok('READ - Empleado ' || v_non_existent_id);
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20102 THEN print_result_ok('READ - Empleado ' || v_non_existent_id); END IF;
    END;

    BEGIN
        -- 2. UPDATE
        PCK_MANTENIMIENTO.actualizar_empleado(v_non_existent_id, p_nombre => 'Fail');
        print_result_ok('UPDATE - Empleado ' || v_non_existent_id);
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20102 THEN print_result_ok('UPDATE - Empleado ' || v_non_existent_id); END IF;
    END;

    BEGIN
        -- 3. DELETE
        PCK_MANTENIMIENTO.eliminar_empleado(v_non_existent_id);
        print_result_ok('DELETE - Empleado ' || v_non_existent_id);
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20102 THEN print_result_ok('DELETE - Empleado ' || v_non_existent_id); END IF;
    END;
    
    BEGIN
        -- 4. READ - Saldo
        v_balance := PCK_USUARIOS_FUNC.consultar_saldo(v_non_existent_id);
        print_result_ok('READ - Saldo Usuario ' || v_non_existent_id);
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20102 THEN print_result_ok('READ - Saldo Usuario ' || v_non_existent_id); END IF;
    END;
    
    -- ==========================================================
    -- II. PRUEBAS DE RESTRICCIONES (Error -20108: Unique)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- II: Prueba de Restricciones UNIQUE (-20108 / -20101) ---');

    -- 1. Duplicar nombre de Juego (-20108)
    DECLARE
    BEGIN
        PCK_MANTENIMIENTO.crear_juego('Juego FK Test', 5, 50, 500); -- Nombre repetido
        print_result_ok('UNIQUE - Nombre de Juego');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20108 THEN print_result_ok('UNIQUE - Nombre de Juego'); END IF;
    END;
    
    -- 2. Duplicar correo de Usuario Frecuente (-20101 en este caso)
    DECLARE
    BEGIN
        PCK_MANTENIMIENTO.crear_usuario_frecuente('Usuario Fail', 100, 'fk@test.com', '11111111'); -- Correo repetido
        print_result_ok('UNIQUE - Correo de Usuario');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20101 THEN print_result_ok('UNIQUE - Correo de Usuario'); END IF;
    END;

    -- ==========================================================
    -- III. PRUEBAS DE LLAVES FORÁNEAS (Error -20103: Violación de FK)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- III: Prueba de Violación de FK (-20103) ---');
    
    -- Usamos un ID de FK muy alto que no existe
    DECLARE
        v_bad_fk_id CONSTANT NUMBER := 99998;
    BEGIN
        -- 1. Crear Mesa con Juego o Dealer inexistente
        PCK_MANTENIMIENTO.crear_mesa(1001, 'Abierta', v_bad_fk_id, v_dealer_fk); -- Juego no existe
        print_result_ok('FK - Mesa (Juego inexistente)');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN print_result_ok('FK - Mesa (Juego inexistente)'); END IF;
    END;

    DECLARE
        v_bad_fk_id CONSTANT NUMBER := 99997;
    BEGIN
        PCK_MANTENIMIENTO.crear_mesa(1002, 'Abierta', v_juego_fk, v_bad_fk_id); -- Dealer no existe
        print_result_ok('FK - Mesa (Dealer inexistente)');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN print_result_ok('FK - Mesa (Dealer inexistente)'); END IF;
    END;

    DECLARE
        v_bad_fk_id CONSTANT NUMBER := 99996;
    BEGIN
        -- 2. Registrar Apuesta con Usuario o Mesa inexistente
        PCK_APUESTAS.registrar_apuesta(100, v_bad_fk_id, v_mesa_fk); -- Usuario no existe
        print_result_ok('FK - Apuesta (Usuario inexistente)');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN print_result_ok('FK - Apuesta (Usuario inexistente)'); END IF;
    END;
    
    DECLARE
        v_bad_fk_id CONSTANT NUMBER := 99995;
    BEGIN
        -- 3. Registrar Transacción con Cajero o Usuario inexistente
        PCK_TRANSACCIONES.registrar_cambio_fichas(500, v_usuario_frecuente_fk, v_bad_fk_id, 'Dinero'); -- Cajero no existe
        print_result_ok('FK - Transacción (Cajero inexistente)');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20103 THEN print_result_ok('FK - Transacción (Cajero inexistente)'); END IF;
    END;
    
    -- ==========================================================
    -- IV. PRUEBAS DE INTEGRIDAD REFERENCIAL (Error -20110: Registros dependientes)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- IV: Prueba de Registros Dependientes (-20110) ---');

    -- Para estas pruebas, necesitamos un registro dependiente que exista.
    
    -- 1. Intentar eliminar un Juego que tiene Mesas activas (v_juego_fk)
    DECLARE
    BEGIN
        PCK_MANTENIMIENTO.eliminar_juego(v_juego_fk);
        print_result_ok('DEP - Eliminar Juego con Mesa activa');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20110 THEN print_result_ok('DEP - Eliminar Juego con Mesa activa'); END IF;
    END;

    -- 2. Intentar eliminar un Usuario que tiene Transacciones activas
    DECLARE
    BEGIN
        -- Creamos una transacción con este usuario
        PCK_TRANSACCIONES.registrar_cambio_fichas(100, v_usuario_frecuente_fk, v_cajero_fk, 'Fichas');

        PCK_MANTENIMIENTO.eliminar_usuario(v_usuario_frecuente_fk);
        print_result_ok('DEP - Eliminar Usuario con Transacciones');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20110 THEN print_result_ok('DEP - Eliminar Usuario con Transacciones'); END IF;
    END;

    -- 3. Intentar registrar visita a un usuario que no es invitado (-20105: Usuario no es invitado)
    DECLARE
    BEGIN
        PCK_USUARIOS_FUNC.registrar_visita(v_usuario_frecuente_fk);
        print_result_ok('NEGOCIO - Registrar visita a Usuario Frecuente');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20105 THEN print_result_ok('NEGOCIO - Registrar visita a Usuario Frecuente'); END IF;
    END;
    
    
    -- ==========================================================
    -- Z. LIMPIEZA DE DATOS DE PRUEBA FK
    -- (La limpieza se hace en orden inverso para evitar más errores FK)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Z: LIMPIEZA ---');
    
    -- Eliminar registro dependiente de prueba creado arriba (si existe)
    DELETE FROM CambioFichas WHERE usuario = v_usuario_frecuente_fk AND monto = 100;
    
    -- Eliminar Mesa (no tiene dependencias)
    PCK_MANTENIMIENTO.eliminar_mesa(v_mesa_fk);
    
    -- Eliminar Usuario (la eliminación del padre borra el hijo por CASCADE)
    PCK_MANTENIMIENTO.eliminar_usuario(v_usuario_frecuente_fk);
    
    -- Eliminar Empleados (la eliminación del padre borra el hijo por CASCADE)
    PCK_MANTENIMIENTO.eliminar_empleado(v_dealer_fk);
    PCK_MANTENIMIENTO.eliminar_empleado(v_cajero_fk);
    
    -- Eliminar Juego
    PCK_MANTENIMIENTO.eliminar_juego(v_juego_fk);
    
    -- Eliminar Beneficio
    DELETE FROM Beneficios WHERE id = v_beneficio_fk;

    DBMS_OUTPUT.PUT_LINE('   Limpieza de datos temporales completada. COMMIT final.');
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' FIN DE PRUEBAS NEGATIVAS.');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

END probar_crud_no_ok;
/

-- 2. EJECUCIÓN DEL PROCEDIMIENTO
EXEC probar_crud_no_ok;

-- 3. LIMPIEZA DE OBJETOS AUXILIARES
DROP PROCEDURE print_result_ok;
DROP PROCEDURE probar_crud_no_ok;

-- Restaurar manejo de errores
WHENEVER SQLERROR EXIT FAILURE;
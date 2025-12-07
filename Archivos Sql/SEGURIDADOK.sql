SET SERVEROUTPUT ON;

-- ==========================================================
-- 0. PROCEDIMIENTO AUXILIAR PARA IMPRIMIR CURSORES (PERMANENTE)
-- Se mantiene para la verificación de las consultas READ.
-- ==========================================================
CREATE OR REPLACE PROCEDURE print_refcursor_results (
    p_cursor IN SYS_REFCURSOR,
    p_title  IN VARCHAR2
) AS
    v_id          NUMBER;
    v_nombre      VARCHAR2(50);
    v_monto       NUMBER;
    v_estado      VARCHAR2(20);
    v_fecha       DATE;
    v_dummy_line  VARCHAR2(200);
BEGIN
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- ' || p_title || ' ---');
    LOOP
        -- Asumimos la estructura más común para estas consultas (ID, Nombre, Monto, Estado, Fecha)
        FETCH p_cursor INTO v_id, v_nombre, v_monto, v_estado, v_fecha;
        EXIT WHEN p_cursor%NOTFOUND;
        
        v_dummy_line := 'ID: ' || v_id || 
                        COALESCE(', Nombre: ' || v_nombre, '') ||
                        COALESCE(', Monto: ' || v_monto, '') ||
                        COALESCE(', Estado: ' || v_estado, '') ||
                        COALESCE(', Fecha: ' || TO_CHAR(v_fecha, 'YYYY-MM-DD HH24:MI'), '');

        DBMS_OUTPUT.PUT_LINE('   ' || v_dummy_line);
    END LOOP;
    CLOSE p_cursor;
    DBMS_OUTPUT.PUT_LINE('-----------------------------');
EXCEPTION
    WHEN OTHERS THEN
        IF p_cursor%ISOPEN THEN CLOSE p_cursor; END IF;
        DBMS_OUTPUT.PUT_LINE('ERROR al imprimir cursor: ' || SQLERRM);
END;
/


-- ==========================================================
-- 1. PROCEDIMIENTO DE PRUEBA POSITIVA DE SEGURIDAD (SeguridadOK)
-- Crea datos con IDs a partir de 2000.
-- ==========================================================
CREATE OR REPLACE PROCEDURE generar_datos_seguridad_ok AS
    v_cursor SYS_REFCURSOR;
    v_saldo  Usuarios.balance%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' INICIO DE CREACIÓN DE DATOS PERMANENTES (SeguridadOK.sql) ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- ==========================================================
    -- I. PCK_ADM_SISTEMA (Datos Iniciales de Mantenimiento)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'I. DATOS CREADOS POR ROL_ADM_SISTEMA');
    
    -- 1. Crear Empleado (Dealer 2000)
    PCK_ADM_SISTEMA.crear_dealer(2000, 'Dealer Bruno D.', 'Noche', 'Ruleta');
    DBMS_OUTPUT.PUT_LINE('-> OK: Dealer 2000 creado.');

    -- 2. Crear Empleado (Cajero 2001)
    PCK_ADM_SISTEMA.crear_cajero(2001, 'Cajero Sofía T.', 'Tarde', 'Nivel 1', 10);
    DBMS_OUTPUT.PUT_LINE('-> OK: Cajero 2001 creado.');

    -- 3. Crear Juego 2000
    PCK_ADM_SISTEMA.crear_juego(2000, 'Ruleta Francesa', 15, 100, 50000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Juego 2000 creado.');
    
    -- 4. Crear Mesa 2000
    PCK_ADM_SISTEMA.crear_mesa(2000, 301, 'Abierta', 2000, 2000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Mesa 2000 creada.');

    -- 5. Crear Usuario Frecuente 2000
    PCK_ADM_SISTEMA.crear_usuario_frecuente(2000, 'Frecuente Javier', 50000, 'frec2000@test.com', '999-9999');
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuario Frecuente 2000 creado (Balance 50000).');
    
    -- 6. Consulta de Empleado (Verificación)
    v_cursor := PCK_ADM_SISTEMA.consultar_empleado(2000);
    print_refcursor_results(v_cursor, 'Consulta de Dealer 2000 (Verificación ADM)');


    -- ==========================================================
    -- II. PCK_CAJERO (Datos de Usuarios y Transacciones)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'II. DATOS CREADOS POR ROL_CAJERO');
    
    -- 1. Crear Nuevo Invitado (ID 2002)
    PCK_CAJERO.registrar_nuevo_invitado(2002, 'Invitado Marco');
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuario Invitado 2002 creado.');

    -- 2. Registrar Transacción de Fichas (Compra)
    -- Usuario 2000 (Frecuente) compra 10,000 fichas.
    PCK_CAJERO.registrar_cambio_fichas(
        p_id => 2000, -- ID Transacción
        p_monto => 10000, 
        p_usuario_id => 2000, 
        p_cajaRecibe => 'Fichas',
        p_cajero_id => 2001 -- Cajero que realiza la acción
    );
    DBMS_OUTPUT.PUT_LINE('-> OK: Transacción 2000 registrada. Balance de 2000 actualizado a 60000.');

    -- 3. Consulta de Saldo por Cajero (Verificación)
    v_saldo := PCK_CAJERO.consultar_saldo_usuario(2000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Saldo de Usuario 2000 consultado por Cajero: ' || v_saldo);

    -- ==========================================================
    -- III. PCK_DEALER (Datos de Operación)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'III. DATOS CREADOS POR ROL_DEALER');
    
    -- 1. Registrar Visita (Usuario 2002)
    PCK_DEALER.registrar_visita_usuario(2002);
    DBMS_OUTPUT.PUT_LINE('-> OK: Visita de Invitado 2002 registrada.');
    
    -- 2. Registrar Apuesta (ID 2000)
    PCK_DEALER.registrar_apuesta(
        p_id => 2000, 
        p_monto => 5000, 
        p_usuario_id => 2000, 
        p_mesa_id => 2000
    );
    DBMS_OUTPUT.PUT_LINE('-> OK: Apuesta 2000 registrada.');
    
    -- 3. Finalizar Apuesta
    PCK_DEALER.finalizar_apuesta(
        p_id => 2000, 
        p_nuevo_estado => 'Perdida'
    );
    DBMS_OUTPUT.PUT_LINE('-> OK: Apuesta 2000 finalizada como "Perdida".');

    -- 4. Actualizar estado de Mesa
    PCK_DEALER.actualizar_estado_mesa(2000, 'Mantenimiento');
    DBMS_OUTPUT.PUT_LINE('-> OK: Mesa 2000 actualizada a "Mantenimiento".');

    -- ==========================================================
    -- IV. PCK_USUARIO (Consultas para Verificación de Auditoría)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'IV. VERIFICACIÓN DE CONSULTAS (ROL_USUARIO_APLICACION)');

    -- 1. Consultar Saldo Propio (Usuario 2000)
    v_saldo := PCK_USUARIO.consultar_mi_saldo(2000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Saldo de Usuario 2000 consultado: ' || v_saldo);
    
    -- 2. Consultar Historial Propio (Usuario 2000)
    v_cursor := PCK_USUARIO.consultar_mi_historial_apuestas(2000);
    print_refcursor_results(v_cursor, 'Historial de Apuestas de Usuario 2000');


    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' FIN DE CREACIÓN DE DATOS. Se hace COMMIT. ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    
    COMMIT;

END generar_datos_seguridad_ok;
/

-- 2. EJECUCIÓN DEL PROCEDIMIENTO
EXEC generar_datos_seguridad_ok;
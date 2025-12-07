SET SERVEROUTPUT ON;

-- ==========================================================
-- 0. PROCEDIMIENTO AUXILIAR PARA IMPRIMIR CURSORES
-- (Se mantiene para verificar consultas)
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
-- 1. PROCEDIMIENTO DE CREACIÓN DE DATOS PERMANENTES
-- ==========================================================
CREATE OR REPLACE PROCEDURE generar_datos_seguridad_ok AS
    v_cursor SYS_REFCURSOR;
    v_saldo  Usuarios.balance%TYPE;

    -- Variables para capturar los IDs generados y usarlos como FKs
    v_dealer_id             Empleados.id%TYPE;
    v_cajero_id             Empleados.id%TYPE;
    v_juego_id              Juegos.id%TYPE;
    v_mesa_id               Mesas.id%TYPE;
    v_usuario_frecuente_id  Usuarios.id%TYPE;
    v_usuario_invitado_id   Usuarios.id%TYPE;
    v_apuesta_id            Apuestas.id%TYPE;
    v_transaccion_id        CambioFichas.id%TYPE;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' INICIO DE CREACIÓN DE DATOS PERMANENTES (SeguridadOK.sql) ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- ==========================================================
    -- I. DATOS CREADOS POR ROL_ADM_SISTEMA
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'I. DATOS CREADOS POR ROL_ADM_SISTEMA');
    
    -- 1. Crear Empleado (Dealer)
    PCK_ADM_SISTEMA.crear_dealer('Dealer Bruno D.', 'Noche', 'Ruleta');
    SELECT MAX(id) INTO v_dealer_id FROM Empleados; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Dealer creado con ID: ' || v_dealer_id);

    -- 2. Crear Empleado (Cajero)
    PCK_ADM_SISTEMA.crear_cajero('Cajero Sofía T.', 'Tarde', 'Nivel 1', 10);
    SELECT MAX(id) INTO v_cajero_id FROM Empleados; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Cajero creado con ID: ' || v_cajero_id);

    -- 3. Crear Juego
    PCK_ADM_SISTEMA.crear_juego('Ruleta Francesa', 15, 100, 50000);
    SELECT MAX(id) INTO v_juego_id FROM Juegos; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Juego creado con ID: ' || v_juego_id);
    
    -- 4. Crear Mesa, usando FKs (Dealer y Juego)
    PCK_ADM_SISTEMA.crear_mesa(301, 'Abierta', v_juego_id, v_dealer_id);
    SELECT MAX(id) INTO v_mesa_id FROM Mesas; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Mesa creada con ID: ' || v_mesa_id);

    -- 5. Crear Usuario Frecuente
    PCK_ADM_SISTEMA.crear_usuario_frecuente('Frecuente Javier', 50000, 'frec_javier@test.com', '999-9999');
    SELECT MAX(id) INTO v_usuario_frecuente_id FROM Usuarios; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuario Frecuente creado con ID: ' || v_usuario_frecuente_id || ' (Balance 50000).');
    
    -- 6. Consulta de Empleado (Verificación de READ)
    v_cursor := PCK_ADM_SISTEMA.consultar_empleado(v_dealer_id);
    print_refcursor_results(v_cursor, 'Consulta de Dealer (Verificación ADM)');


    -- ==========================================================
    -- II. DATOS CREADOS POR ROL_CAJERO
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'II. DATOS CREADOS POR ROL_CAJERO');
    
    -- 1. Crear Nuevo Invitado
    PCK_CAJERO.registrar_nuevo_invitado('Invitado Marco');
    SELECT MAX(id) INTO v_usuario_invitado_id FROM Usuarios; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuario Invitado creado con ID: ' || v_usuario_invitado_id);

    -- 2. Registrar Transacción de Fichas (Compra)
    -- Usuario Frecuente (v_usuario_frecuente_id) compra 10,000 fichas.
    PCK_CAJERO.registrar_cambio_fichas(
        p_monto => 10000, 
        p_usuario_id => v_usuario_frecuente_id, -- FK al Usuario
        p_cajaRecibe => 'Fichas',
        p_cajero_id => v_cajero_id -- FK al Cajero
    );
    SELECT MAX(id) INTO v_transaccion_id FROM CambioFichas; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Transacción registrada con ID: ' || v_transaccion_id || '. Balance actualizado a 60000.');

    -- 3. Consulta de Saldo por Cajero (Verificación de READ)
    v_saldo := PCK_CAJERO.consultar_saldo_usuario(v_usuario_frecuente_id);
    DBMS_OUTPUT.PUT_LINE('-> OK: Saldo de Usuario consultado por Cajero: ' || v_saldo);

    -- ==========================================================
    -- III. DATOS CREADOS POR ROL_DEALER
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'III. DATOS CREADOS POR ROL_DEALER');
    
    -- 1. Registrar Visita (Usuario Invitado)
    PCK_DEALER.registrar_visita_usuario(v_usuario_invitado_id);
    DBMS_OUTPUT.PUT_LINE('-> OK: Visita de Invitado ' || v_usuario_invitado_id || ' registrada.');
    
    -- 2. Registrar Apuesta
    PCK_DEALER.registrar_apuesta(
        p_monto => 5000, 
        p_usuario_id => v_usuario_frecuente_id, 
        p_mesa_id => v_mesa_id
    );
    SELECT MAX(id) INTO v_apuesta_id FROM Apuestas; -- Captura el ID generado
    DBMS_OUTPUT.PUT_LINE('-> OK: Apuesta registrada con ID: ' || v_apuesta_id);
    
    -- 3. Finalizar Apuesta
    PCK_DEALER.finalizar_apuesta(v_apuesta_id, 'Perdida');
    DBMS_OUTPUT.PUT_LINE('-> OK: Apuesta ' || v_apuesta_id || ' finalizada como "Perdida".');

    -- 4. Actualizar estado de Mesa
    PCK_DEALER.actualizar_estado_mesa(v_mesa_id, 'Mantenimiento');
    DBMS_OUTPUT.PUT_LINE('-> OK: Mesa ' || v_mesa_id || ' actualizada a "Mantenimiento".');

    -- ==========================================================
    -- IV. VERIFICACIÓN DE CONSULTAS (ROL_USUARIO_APLICACION)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'IV. VERIFICACIÓN DE CONSULTAS (ROL_USUARIO_APLICACION)');

    -- 1. Consultar Saldo Propio (Usuario Frecuente)
    v_saldo := PCK_USUARIO.consultar_mi_saldo(v_usuario_frecuente_id);
    DBMS_OUTPUT.PUT_LINE('-> OK: Saldo de Usuario ' || v_usuario_frecuente_id || ' consultado: ' || v_saldo);
    
    -- 2. Consultar Historial Propio (Usuario Frecuente)
    v_cursor := PCK_USUARIO.consultar_mi_historial_apuestas(v_usuario_frecuente_id);
    print_refcursor_results(v_cursor, 'Historial de Apuestas de Usuario ' || v_usuario_frecuente_id);


    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' FIN DE CREACIÓN DE DATOS. Se hace COMMIT. ');
    DBMS_OUTPUT.PUT_LINE(' Los IDs generados son variables y persisten en la base.');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    
    COMMIT;

END generar_datos_seguridad_ok;
/

-- 2. EJECUCIÓN DEL PROCEDIMIENTO
EXEC generar_datos_seguridad_ok;

-- 3. LIMPIEZA DE OBJETO AUXILIAR (Se mantiene la limpieza del auxiliar)
DROP PROCEDURE print_refcursor_results;
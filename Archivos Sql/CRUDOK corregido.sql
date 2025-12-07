SET SERVEROUTPUT ON;

-- ID base para las pruebas (se usará 1000 en adelante)
-- DELETE FROM Usuarios WHERE id >= 1000; -- Limpieza opcional

-- ==========================================================
-- 0. PROCEDIMIENTO AUXILIAR PARA IMPRIMIR CURSORES
-- (Necesario para demostrar el éxito de las funciones READ que devuelven SYS_REFCURSOR)
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
        FETCH p_cursor INTO v_id, v_nombre, v_monto, v_estado, v_fecha; -- Ajustar campos según el cursor
        EXIT WHEN p_cursor%NOTFOUND;
        -- Intenta leer algunos campos comunes
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
-- 1. PROCEDIMIENTO DE PRUEBA POSITIVA (CRUDOK)
-- ==========================================================

CREATE OR REPLACE PROCEDURE probar_crud_ok AS
    v_cursor SYS_REFCURSOR;
    v_saldo  Usuarios.balance%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' INICIO DE PRUEBAS POSITIVAS (CRUDOK.sql) ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- ==========================================================
    -- I. PCK_MANTENIMIENTO: Setup (CREATE)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE('I. CONFIGURACIÓN INICIAL (CREATE)');

    -- Empleados
    PCK_MANTENIMIENTO.crear_dealer(1000, 'Dealer Bruno', 'Tarde', 'Poker');
    DBMS_OUTPUT.PUT_LINE('-> OK: Dealer 1000 creado.');
    PCK_MANTENIMIENTO.crear_cajero(1001, 'Cajero Sofía', 'Manana', 'Nivel 2', 5);
    DBMS_OUTPUT.PUT_LINE('-> OK: Cajero 1001 creado.');

    -- Juegos y Mesas
    PCK_MANTENIMIENTO.crear_juego(1000, 'Blackjack VIP', 7, 1000, 100000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Juego 1000 creado.');
    PCK_MANTENIMIENTO.crear_mesa(1000, 201, 'Abierta', 1000, 1000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Mesa 1000 creada.');

    -- Usuarios y Beneficios
    PCK_MANTENIMIENTO.crear_usuario_frecuente(1000, 'Cliente Frecuente', 100000, 'frecuente@testok.com', '555-1234');
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuario Frecuente 1000 creado (Balance 100000).');
    PCK_MANTENIMIENTO.crear_usuario_frecuente(1002, 'Cliente UF 2', 50000, 'frecuente2@testok.com', '555-4321');
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuario Frecuente 1002 creado (Balance 50000).');
    PCK_MANTENIMIENTO.crear_usuario_invitado(1001, 'Visitante Juan', 0);
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuario Invitado 1001 creado.');
    PCK_MANTENIMIENTO.crear_beneficio(1000, 500, 'Bono 500 Puntos');
    DBMS_OUTPUT.PUT_LINE('-> OK: Beneficio 1000 creado.');
    
    -- ==========================================================
    -- II. PCK_TRANSACCIONES: Flujo de Fichas (CREATE & READ)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'II. TRANSACCIONES Y BALANCE');

    -- CREATE: El usuario 1000 compra 10,000 en fichas (cajaRecibe='Fichas'). Su balance debe subir a 110,000.
    PCK_TRANSACCIONES.registrar_cambio_fichas(1000, 10000, 1000, 1001, 'Fichas');
    DBMS_OUTPUT.PUT_LINE('-> OK: Transacción 1000 registrada (Compra de fichas +10,000).');

    -- READ: Consultar saldo y verificar cambio (Balance esperado: 110000)
    v_saldo := PCK_USUARIOS_FUNC.consultar_saldo(1000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Saldo de Usuario 1000 consultado. Saldo actual: ' || v_saldo);
    IF v_saldo = 110000 THEN
        DBMS_OUTPUT.PUT_LINE('   (Verificación: Balance actualizado correctamente por Trigger).');
    ELSE
        DBMS_OUTPUT.PUT_LINE('   (¡ALERTA! El balance no se actualizó al valor esperado: 110000).');
    END IF;

    -- READ: Consultar transacciones del cajero 1001
    v_cursor := PCK_TRANSACCIONES.consultar_transacciones_cajero(1001, 'Manana');
    print_refcursor_results(v_cursor, 'Historial de Transacciones de Cajero 1001');

    -- ==========================================================
    -- III. PCK_APUESTAS: Flujo de Apuestas (CREATE & UPDATE & READ)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'III. FLUJO DE APUESTAS');

    -- CREATE: Registrar una apuesta
    PCK_APUESTAS.registrar_apuesta(1000, 5000, 1000, 1000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Apuesta 1000 registrada ("En proceso").');

    -- UPDATE: Finalizar la apuesta como 'Ganada' (Trigger debe permitirlo)
    PCK_APUESTAS.finalizar_apuesta(1000, 'Ganada');
    DBMS_OUTPUT.PUT_LINE('-> OK: Apuesta 1000 finalizada como "Ganada".');
    
    -- CREATE: Registrar otra apuesta (Perdida)
    PCK_APUESTAS.registrar_apuesta(1001, 2000, 1002, 1000);
    PCK_APUESTAS.finalizar_apuesta(1001, 'Perdida');
    DBMS_OUTPUT.PUT_LINE('-> OK: Apuesta 1001 finalizada como "Perdida".');

    -- READ: Consultar historial de apuestas del usuario 1000
    v_cursor := PCK_APUESTAS.consultar_historial_usuario(1000);
    print_refcursor_results(v_cursor, 'Historial de Apuestas de Usuario 1000');

    -- ==========================================================
    -- IV. PCK_USUARIOS_FUNC: Visitas y Promoción (UPDATE)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'IV. REGISTRO DE VISITAS Y PROMOCIÓN');

    -- Registrar 8 visitas adicionales al usuario 1001 (ya tiene 1, total 9)
    FOR i IN 1..8 LOOP
        PCK_USUARIOS_FUNC.registrar_visita(1001);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('-> OK: 8 visitas registradas para Usuario 1001 (Total: 9).');

    -- Registrar la visita número 10 (Debe activar el TRIGGER de promoción a Usuario Frecuente)
    PCK_USUARIOS_FUNC.registrar_visita(1001);
    DBMS_OUTPUT.PUT_LINE('-> OK: Visita #10 registrada. (Verificar log de Trigger: el usuario 1001 debería ser ahora Frecuente).');

    -- ==========================================================
    -- V. PCK_MANTENIMIENTO: Mantenimiento (UPDATE & MANTENER)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'V. MANTENIMIENTO Y ACTUALIZACIONES');

    -- UPDATE: Actualizar nombre del juego
    PCK_MANTENIMIENTO.actualizar_juego(1000, 'Blackjack VIP - High Roller', 5, 2000, 200000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Juego 1000 actualizado.');

    -- UPDATE: Cambiar estado de mesa
    PCK_MANTENIMIENTO.actualizar_mesa_estado(1000, 'Cerrada');
    DBMS_OUTPUT.PUT_LINE('-> OK: Mesa 1000 estado actualizado a "Cerrada".');
    
    -- MANTENER: Asignar beneficio a usuario frecuente
    PCK_MANTENIMIENTO.asignar_beneficio_a_frecuente(1000, 1002);
    DBMS_OUTPUT.PUT_LINE('-> OK: Beneficio 1000 asignado a Usuario Frecuente 1002.');

    -- ==========================================================
    -- VI. PCK_MANTENIMIENTO: Eliminación (DELETE)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'VI. ELIMINACIÓN DE DATOS (CLEANUP)');
    
    -- Eliminar Mesa y Juego
    PCK_MANTENIMIENTO.eliminar_mesa(1000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Mesa 1000 eliminada.');
    PCK_MANTENIMIENTO.eliminar_juego(1000);
    DBMS_OUTPUT.PUT_LINE('-> OK: Juego 1000 eliminado.');

    -- Eliminar Empleados
    PCK_MANTENIMIENTO.eliminar_empleado(1000); -- Dealer
    PCK_MANTENIMIENTO.eliminar_empleado(1001); -- Cajero
    DBMS_OUTPUT.PUT_LINE('-> OK: Empleados 1000 y 1001 eliminados.');

    -- Eliminar Usuarios y Beneficios (Los usuarios 1000 y 1002 no se pueden eliminar por las Apuestas/Transacciones)
    DELETE FROM UsuariosFrecuentes_Beneficios WHERE beneficio = 1000;
    DELETE FROM Apuestas WHERE id IN (1000, 1001);
    DELETE FROM CambioFichas WHERE id = 1000;
    
    PCK_MANTENIMIENTO.eliminar_usuario(1000); 
    PCK_MANTENIMIENTO.eliminar_usuario(1001); -- Ya fue promovido, se borra de UsuariosFrecuentes/Usuarios
    PCK_MANTENIMIENTO.eliminar_usuario(1002);
    DBMS_OUTPUT.PUT_LINE('-> OK: Usuarios de prueba 1000, 1001 y 1002 eliminados (tras borrar dependencias).');
    
    DELETE FROM Beneficios WHERE id = 1000;
    DBMS_OUTPUT.PUT_LINE('-> OK: Beneficio 1000 eliminado.');

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' FIN DE PRUEBAS POSITIVAS (COMMIT OK) ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    
    COMMIT;

END probar_crud_ok;
/

-- 2. EJECUCIÓN DEL PROCEDIMIENTO
EXEC probar_crud_ok;

-- 3. LIMPIEZA DE OBJETO AUXILIAR
DROP PROCEDURE print_refcursor_results;
SET SERVEROUTPUT ON;
WHENEVER SQLERROR EXIT FAILURE;

-- ==========================================================
-- 0. PROCEDIMIENTO AUXILIAR PARA IMPRIMIR CURSORES
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
-- 1. PROCEDIMIENTO PRINCIPAL DE PRUEBA CRUD
-- Los datos se crearán con IDs altos (9000+) para evitar conflictos
-- ==========================================================
CREATE OR REPLACE PROCEDURE probar_crud_ok AS
    v_cursor SYS_REFCURSOR;
    
    -- Variables para capturar IDs auto-generados
    v_dealer_id             Empleados.id%TYPE;
    v_cajero_id             Empleados.id%TYPE;
    v_juego_id              Juegos.id%TYPE;
    v_mesa_id               Mesas.id%TYPE;
    v_usuario_frecuente_id  Usuarios.id%TYPE;
    v_usuario_invitado_id   Usuarios.id%TYPE;
    v_apuesta_id            Apuestas.id%TYPE;
    v_transaccion_id        CambioFichas.id%TYPE;
    v_beneficio_id          Beneficios.id%TYPE;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' INICIO DE PRUEBAS CRUD (Auto-Incremento OK) ');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    -- ==========================================================
    -- C: CREATE (Creación de Registros)
    -- Se omite p_id y se captura el ID generado
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- C: CREATE (Creación) ---');

    -- Crear Empleados (Dealer y Cajero)
    PCK_MANTENIMIENTO.crear_dealer('Dealer Test CRUD', 'Manana', 'Blackjack');
    SELECT MAX(id) INTO v_dealer_id FROM Empleados;
    DBMS_OUTPUT.PUT_LINE('1. OK: Dealer creado con ID: ' || v_dealer_id);

    PCK_MANTENIMIENTO.crear_cajero('Cajero Test CRUD', 'Tarde', 'Nivel 5', 99);
    SELECT MAX(id) INTO v_cajero_id FROM Empleados;
    DBMS_OUTPUT.PUT_LINE('2. OK: Cajero creado con ID: ' || v_cajero_id);
    
    -- Crear Juego y Mesa (usando FKs)
    PCK_MANTENIMIENTO.crear_juego('Poker Chino', 4, 2000, 200000);
    SELECT MAX(id) INTO v_juego_id FROM Juegos;
    DBMS_OUTPUT.PUT_LINE('3. OK: Juego creado con ID: ' || v_juego_id);
    
    PCK_MANTENIMIENTO.crear_mesa(999, 'Abierta', v_juego_id, v_dealer_id); -- FKs
    SELECT MAX(id) INTO v_mesa_id FROM Mesas;
    DBMS_OUTPUT.PUT_LINE('4. OK: Mesa creada con ID: ' || v_mesa_id);

    -- Crear Usuarios
    PCK_MANTENIMIENTO.crear_usuario_frecuente('Usuario Frecuente CRUD', 100000, 'crudok@test.com', '12345678');
    SELECT MAX(id) INTO v_usuario_frecuente_id FROM Usuarios;
    DBMS_OUTPUT.PUT_LINE('5. OK: Usuario Frecuente creado con ID: ' || v_usuario_frecuente_id);

    PCK_MANTENIMIENTO.crear_usuario_invitado('Usuario Invitado CRUD', 5000);
    SELECT MAX(id) INTO v_usuario_invitado_id FROM Usuarios;
    DBMS_OUTPUT.PUT_LINE('6. OK: Usuario Invitado creado con ID: ' || v_usuario_invitado_id);
    
    -- Crear Transacción y Apuesta (usando FKs)
    PCK_TRANSACCIONES.registrar_cambio_fichas(5000, v_usuario_frecuente_id, v_cajero_id, 'Dinero'); -- FKs
    SELECT MAX(id) INTO v_transaccion_id FROM CambioFichas;
    DBMS_OUTPUT.PUT_LINE('7. OK: Transacción creada con ID: ' || v_transaccion_id);

    PCK_APUESTAS.registrar_apuesta(1000, v_usuario_frecuente_id, v_mesa_id); -- FKs
    SELECT MAX(id) INTO v_apuesta_id FROM Apuestas;
    DBMS_OUTPUT.PUT_LINE('8. OK: Apuesta creada con ID: ' || v_apuesta_id);
    
    -- Crear Beneficio
    PCK_MANTENIMIENTO.crear_beneficio(700, 'Bono de bienvenida VIP');
    SELECT MAX(id) INTO v_beneficio_id FROM Beneficios;
    DBMS_OUTPUT.PUT_LINE('9. OK: Beneficio creado con ID: ' || v_beneficio_id);

    -- ==========================================================
    -- R: READ (Consulta de Registros)
    -- Se usan los IDs capturados
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- R: READ (Consulta) ---');
    
    v_cursor := PCK_MANTENIMIENTO.consultar_empleado(v_dealer_id);
    print_refcursor_results(v_cursor, 'Consulta de Dealer ' || v_dealer_id);

    v_cursor := PCK_APUESTAS.consultar_historial_usuario(v_usuario_frecuente_id);
    print_refcursor_results(v_cursor, 'Historial de Apuestas de Usuario ' || v_usuario_frecuente_id);
    
    -- ==========================================================
    -- U: UPDATE (Actualización de Registros)
    -- Se usan los IDs capturados
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- U: UPDATE (Actualización) ---');
    
    -- Actualizar Empleado
    PCK_MANTENIMIENTO.actualizar_empleado(v_dealer_id, p_turno => 'Noche');
    DBMS_OUTPUT.PUT_LINE('10. OK: Dealer ' || v_dealer_id || ' actualizado a turno Noche.');
    
    -- Finalizar Apuesta
    PCK_APUESTAS.finalizar_apuesta(v_apuesta_id, 'Ganada');
    DBMS_OUTPUT.PUT_LINE('11. OK: Apuesta ' || v_apuesta_id || ' finalizada como Ganada.');
    
    -- Actualizar Estado de Mesa
    PCK_MANTENIMIENTO.actualizar_mesa_estado(v_mesa_id, 'Cerrada');
    DBMS_OUTPUT.PUT_LINE('12. OK: Mesa ' || v_mesa_id || ' actualizada a Cerrada.');

    -- ==========================================================
    -- D: DELETE (Eliminación de Registros)
    -- Se eliminan todos los registros creados (Limpieza de prueba)
    -- ==========================================================
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- D: DELETE (Eliminación) ---');
    
    -- 13. Eliminar Transacción y Apuesta
    PCK_TRANSACCIONES.eliminar_transaccion(v_transaccion_id);
    DBMS_OUTPUT.PUT_LINE('13. OK: Transacción ' || v_transaccion_id || ' eliminada.');
    
    -- 14. Eliminar Apuesta (Ya está finalizada, se puede eliminar)
    DELETE FROM Apuestas WHERE id = v_apuesta_id; -- Eliminación directa ya que no hay procedimiento CRUD
    DBMS_OUTPUT.PUT_LINE('14. OK: Apuesta ' || v_apuesta_id || ' eliminada.');

    -- 15. Eliminar Mesa y Juego (Mesa primero por FK)
    PCK_MANTENIMIENTO.eliminar_mesa(v_mesa_id);
    DBMS_OUTPUT.PUT_LINE('15. OK: Mesa ' || v_mesa_id || ' eliminada.');
    
    PCK_MANTENIMIENTO.eliminar_juego(v_juego_id);
    DBMS_OUTPUT.PUT_LINE('16. OK: Juego ' || v_juego_id || ' eliminado.');
    
    -- 17. Eliminar Usuarios (La eliminación en Usuarios elimina automáticamente Invitado/Frecuente)
    PCK_MANTENIMIENTO.eliminar_usuario(v_usuario_frecuente_id);
    DBMS_OUTPUT.PUT_LINE('17. OK: Usuario Frecuente ' || v_usuario_frecuente_id || ' eliminado.');

    PCK_MANTENIMIENTO.eliminar_usuario(v_usuario_invitado_id);
    DBMS_OUTPUT.PUT_LINE('18. OK: Usuario Invitado ' || v_usuario_invitado_id || ' eliminado.');

    -- 19. Eliminar Empleados (La eliminación en Empleados elimina automáticamente Dealer/Cajero)
    PCK_MANTENIMIENTO.eliminar_empleado(v_dealer_id);
    DBMS_OUTPUT.PUT_LINE('19. OK: Dealer ' || v_dealer_id || ' eliminado.');

    PCK_MANTENIMIENTO.eliminar_empleado(v_cajero_id);
    DBMS_OUTPUT.PUT_LINE('20. OK: Cajero ' || v_cajero_id || ' eliminado.');
    
    -- 21. Eliminar Beneficio
    DELETE FROM Beneficios WHERE id = v_beneficio_id;
    DBMS_OUTPUT.PUT_LINE('21. OK: Beneficio ' || v_beneficio_id || ' eliminado.');

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE(' FIN DE PRUEBAS CRUD. Limpieza de datos completada. COMMIT final.');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    
    COMMIT;

END probar_crud_ok;
/

-- 2. EJECUCIÓN DEL PROCEDIMIENTO
EXEC probar_crud_ok;

-- 3. LIMPIEZA DE OBJETO AUXILIAR
DROP PROCEDURE print_refcursor_results;
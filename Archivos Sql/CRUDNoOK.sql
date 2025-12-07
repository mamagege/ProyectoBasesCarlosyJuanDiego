SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- INICIO PRUEBAS DE ERROR (CRUDNoOK) ---');
    
    -- Bloque para aislar la prueba
    SAVEPOINT TestStart;

    -- =========================================================================
    -- PRUEBA 1: Error de Duplicidad (PCK_PERSONAL)
    -- Intenta crear el Dealer 100 de nuevo.
    -- Espera Error: ORA-20030 (ID ya existe)
    -- =========================================================================
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '1. Probando: Creación de Dealer con ID duplicado (100).');
        PCK_PERSONAL.crear_dealer(
            p_id => 100,
            p_nombre => 'Duplicado',
            p_turno => 'Manana',
            p_especialidad => 'Ruleta'
        );
        DBMS_OUTPUT.PUT_LINE('FALLO: La creación con ID duplicado NO generó el error esperado.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20030 THEN
                DBMS_OUTPUT.PUT_LINE('OK: Error -20030 capturado. (ID de empleado duplicado).');
            ELSE
                DBMS_OUTPUT.PUT_LINE('FALLO: Se obtuvo el error inesperado: ' || SQLERRM);
            END IF;
    END;
    ROLLBACK TO TestStart;
    
    -- =========================================================================
    -- PRUEBA 2: Error de No Existencia (PCK_PERSONAL)
    -- Intenta actualizar un empleado con ID que no existe (999).
    -- Espera Error: ORA-20011 (Empleado no existe)
    -- =========================================================================
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '2. Probando: Actualizar Empleado con ID inexistente (999).');
        PCK_PERSONAL.actualizar_empleado(
            p_id => 999,
            p_nombre => 'No existe'
        );
        DBMS_OUTPUT.PUT_LINE('FALLO: La actualización de empleado inexistente NO generó el error esperado.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20011 THEN
                DBMS_OUTPUT.PUT_LINE('OK: Error -20011 capturado. (No se puede actualizar. Empleado no existe).');
            ELSE
                DBMS_OUTPUT.PUT_LINE('FALLO: Se obtuvo el error inesperado: ' || SQLERRM);
            END IF;
    END;
    ROLLBACK TO TestStart;

    -- =========================================================================
    -- PRUEBA 3: Error de Restricción de Atributo (PCK_CASINO)
    -- Intenta cambiar el estado de la mesa a un valor no permitido ('Destruida').
    -- Espera Error: ORA-20216 (Restricción CHECK de la tabla Mesas)
    -- =========================================================================
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '3. Probando: Actualizar Estado de Mesa con valor inválido (Restricción Declarativa).');
        PCK_CASINO.actualizar_estado_mesa(
            p_id => 50,
            p_estado => 'Destruida'
        );
        DBMS_OUTPUT.PUT_LINE('FALLO: El estado inválido NO generó el error esperado.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20216 THEN -- El error de la tabla es capturado por el WHEN OTHERS del paquete.
                DBMS_OUTPUT.PUT_LINE('OK: Error -20216 capturado. (Error al actualizar estado, violó CHECK constraint).');
            ELSE
                DBMS_OUTPUT.PUT_LINE('FALLO: Se obtuvo el error inesperado: ' || SQLERRM);
            END IF;
    END;
    ROLLBACK TO TestStart;

    -- =========================================================================
    -- PRUEBA 4: Error de Flujo (PCK_CASINO - Trigger)
    -- Intenta cambiar la apuesta 2000 (Ganada) a 'En proceso' (prohibido por trigger).
    -- Espera Error: ORA-20234 (que envuelve el error del trigger)
    -- =========================================================================
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '4. Probando: Finalizar Apuesta con flujo de estado ilegal (Ganada -> En proceso).');
        PCK_CASINO.finalizar_apuesta(
            p_id => 2000,
            p_nuevo_estado => 'En proceso'
        );
        DBMS_OUTPUT.PUT_LINE('FALLO: La actualización ilegal de estado NO generó el error esperado.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20234 THEN
                DBMS_OUTPUT.PUT_LINE('OK: Error -20234 capturado. (Error de flujo en Apuesta controlado por el trigger).');
            ELSE
                DBMS_OUTPUT.PUT_LINE('FALLO: Se obtuvo el error inesperado: ' || SQLERRM);
            END IF;
    END;
    
    ROLLBACK; -- Deshace todas las pruebas de este script

END;
/
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- 1. PCK_PERSONAL: Creación de Empleados (Dealer y Cajero) ---');
    
    -- 1.1 Crear Dealer (ID 100)
    PCK_PERSONAL.crear_dealer(
        p_id => 100,
        p_nombre => 'Alan Turing',
        p_turno => 'Tarde',
        p_especialidad => 'Poker'
    );
    DBMS_OUTPUT.PUT_LINE('OK: Dealer 100 (Alan Turing) creado.');

    -- 1.2 Crear Cajero (ID 101)
    PCK_PERSONAL.crear_cajero(
        p_id => 101,
        p_nombre => 'Grace Hopper',
        p_turno => 'Manana',
        p_nivelAcceso => 'Alto',
        p_ventanilla => 10
    );
    DBMS_OUTPUT.PUT_LINE('OK: Cajero 101 (Grace Hopper) creado.');


    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 2. PCK_USUARIOS: Creación de Usuarios y Beneficios ---');

    -- 2.1 Crear Usuario Invitado (ID 200)
    PCK_USUARIOS.crear_usuario_invitado(
        p_id => 200,
        p_nombre => 'Elon Musk',
        p_balance => 1000,
        p_numeroDeVisitas => 1
    );
    DBMS_OUTPUT.PUT_LINE('OK: Usuario Invitado 200 (Elon Musk) creado.');

    -- 2.2 Crear Usuario Frecuente (ID 201)
    PCK_USUARIOS.crear_usuario_frecuente(
        p_id => 201,
        p_nombre => 'Ada Lovelace',
        p_balance => 5000,
        p_correo => 'ada.l@tech.com',
        p_celular => '5551234567',
        p_puntos => 100
    );
    DBMS_OUTPUT.PUT_LINE('OK: Usuario Frecuente 201 (Ada Lovelace) creado.');

    -- 2.3 Crear Beneficio (ID 1)
    PCK_USUARIOS.crear_beneficio(
        p_id => 1,
        p_requisito => '1000 puntos',
        p_descripcion => 'Bono de Cena Gratis'
    );
    DBMS_OUTPUT.PUT_LINE('OK: Beneficio 1 creado.');
    
    -- 2.4 Asignar Beneficio a Frecuente
    PCK_USUARIOS.asignar_beneficio_a_frecuente(
        p_beneficio_id => 1,
        p_usuario_id => 201
    );
    DBMS_OUTPUT.PUT_LINE('OK: Beneficio 1 asignado al usuario 201.');


    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 3. PCK_CASINO: Creación de Juegos, Mesas y Transacciones ---');

    -- 3.1 Crear Juego (ID 1)
    PCK_CASINO.crear_juego(
        p_id => 1,
        p_nombre => 'Blackjack',
        p_maxJugadores => 7,
        p_minApuesta => 50,
        p_maxApuesta => 5000
    );
    DBMS_OUTPUT.PUT_LINE('OK: Juego 1 (Blackjack) creado.');

    -- 3.2 Crear Mesa (ID 50)
    PCK_CASINO.crear_mesa(
        p_id => 50,
        p_juego_id => 1,
        p_dealer_id => 100, -- Alan Turing
        p_estado => 'Abierta'
    );
    DBMS_OUTPUT.PUT_LINE('OK: Mesa 50 creada y asignada a Dealer 100.');

    -- 3.3 Registrar Cambio de Fichas (ID 1000 - Compra de fichas)
    PCK_CASINO.registrar_cambio_fichas(
        p_id => 1000,
        p_monto => 500,
        p_usuario_id => 201,
        p_cajero_id => 101,
        p_cajaRecibe => 'Fichas' -- Debería SUMAR 500 al balance (por trigger)
    );
    DBMS_OUTPUT.PUT_LINE('OK: Transacción de Fichas 1000 registrada. (Se espera que el balance de Ada Lovelace suba a 5500)');
    
    -- 3.4 Registrar Apuesta (ID 2000)
    PCK_CASINO.registrar_apuesta(
        p_id => 2000,
        p_monto => 500,
        p_usuario_id => 201,
        p_mesa_id => 50
    );
    DBMS_OUTPUT.PUT_LINE('OK: Apuesta 2000 registrada en Mesa 50.');
    
    -- 3.5 Finalizar Apuesta (Ganada)
    PCK_CASINO.finalizar_apuesta(
        p_id => 2000,
        p_nuevo_estado => 'Ganada'
    );
    DBMS_OUTPUT.PUT_LINE('OK: Apuesta 2000 finalizada como Ganada.');

    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 4. VERIFICACIÓN: Consultas (Read) ---');
    
    DECLARE
        v_nombre Empleados.nombre%TYPE;
        v_balance Usuarios.balance%TYPE;
    BEGIN
        -- Verificar Balance de Usuario Frecuente 201
        SELECT balance INTO v_balance FROM Usuarios WHERE id = 201;
        DBMS_OUTPUT.PUT_LINE('VERIFICADO: Nuevo Balance de Usuario 201 es: ' || v_balance || ' (Esperado: 5500, si el trigger funciona).');

        -- Consultar Mesa 50
        PCK_CASINO.consultar_mesa(50, NULL, v_nombre, NULL); -- Reutilizando v_nombre
        DBMS_OUTPUT.PUT_LINE('VERIFICADO: Mesa 50 está asignada al Dealer: ' || v_nombre);
        
        COMMIT; -- Confirma todas las operaciones exitosas
    END;
END;
/
--Correcion CRUDI

SET SERVEROUTPUT ON;

-- ==========================================================
-- 0. PCK_EXCEPCIONES BODY (No tiene lógica de implementación)
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_EXCEPCIONES AS
END PCK_EXCEPCIONES;
/

-- ==========================================================
-- 1. PCK_APUESTAS BODY: Registrar y Mantener Apuestas
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_APUESTAS AS

    -- Función Auxiliar: Verifica si una apuesta existe
    FUNCTION verificar_existencia(p_id IN Apuestas.id%TYPE) RETURN BOOLEAN
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Apuestas WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia;

    -- (CREATE)
    PROCEDURE registrar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_monto         IN Apuestas.monto%TYPE,
        p_usuario_id    IN Apuestas.usuario%TYPE,
        p_mesa_id       IN Apuestas.mesa%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia(p_id) THEN
            RAISE PCK_EXCEPCIONES.e_id_existe; -- ORA-20101
        END IF;

        INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
        VALUES (p_id, p_monto, SYSDATE, 'En proceso', p_usuario_id, p_mesa_id);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN -- Captura violación de FK a Usuario o Mesa
                RAISE PCK_EXCEPCIONES.e_fk_violada; -- ORA-20103
            ELSE
                RAISE;
            END IF;
    END registrar_apuesta;

    -- (READ)
    FUNCTION consultar_historial_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        c_apuestas SYS_REFCURSOR;
    BEGIN
        -- Verificar si el usuario existe antes de consultar
        SELECT 'X' INTO c_apuestas FROM Usuarios WHERE id = p_usuario_id;
        
        OPEN c_apuestas FOR
            SELECT id, monto, fechaHora, estado, mesa
            FROM Apuestas
            WHERE usuario = p_usuario_id
            ORDER BY fechaHora DESC;
            
        RETURN c_apuestas;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE PCK_EXCEPCIONES.e_no_existe;
    END consultar_historial_usuario;

    -- (UPDATE/MANTENER)
    PROCEDURE finalizar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_nuevo_estado  IN Apuestas.estado%TYPE
    )
    IS
    BEGIN
        IF NOT verificar_existencia(p_id) THEN
            RAISE PCK_EXCEPCIONES.e_no_existe; -- ORA-20102
        END IF;

        UPDATE Apuestas
        SET estado = p_nuevo_estado
        WHERE id = p_id;

        -- El trigger trg_control_estado_apuesta verifica el cambio de estado

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20001 OR SQLCODE = -20002 THEN
                RAISE; -- Relanza el error del Trigger
            ELSE
                RAISE;
            END IF;
    END finalizar_apuesta;

    -- (DELETE)
    PROCEDURE eliminar_apuesta(p_id IN Apuestas.id%TYPE)
    IS
    BEGIN
        DELETE FROM Apuestas WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE PCK_EXCEPCIONES.e_no_existe;
        END IF;
    END eliminar_apuesta;

END PCK_APUESTAS;
/


-- ==========================================================
-- 2. PCK_TRANSACCIONES BODY: Registrar Transacciones de Fichas
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_TRANSACCIONES AS

    -- Función Auxiliar: Verifica si una transacción existe
    FUNCTION verificar_existencia(p_id IN CambioFichas.id%TYPE) RETURN BOOLEAN
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM CambioFichas WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia;

    -- (CREATE)
    PROCEDURE registrar_cambio_fichas(
        p_id            IN CambioFichas.id%TYPE,
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajero_id     IN CambioFichas.cajero%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia(p_id) THEN
            RAISE PCK_EXCEPCIONES.e_id_existe; -- ORA-20101
        END IF;

        -- La actualización del balance del usuario se maneja mediante el TRIGGER trg_actualizar_balance_fichas
        INSERT INTO CambioFichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
        VALUES (p_id, p_monto, SYSDATE, p_usuario_id, p_cajero_id, p_cajaRecibe);

    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN -- Captura violación de FK a Usuario o Cajero
                RAISE PCK_EXCEPCIONES.e_fk_violada; -- ORA-20103
            ELSIF SQLCODE = -20003 THEN -- Captura el error de cajaRecibe del Trigger
                RAISE; 
            ELSE
                RAISE;
            END IF;
    END registrar_cambio_fichas;

    -- (READ)
    PROCEDURE consultar_transaccion(p_id IN CambioFichas.id%TYPE)
    IS
        v_monto CambioFichas.monto%TYPE;
        v_usuario CambioFichas.usuario%TYPE;
        v_cajero CambioFichas.cajero%TYPE;
    BEGIN
        SELECT monto, usuario, cajero
        INTO v_monto, v_usuario, v_cajero
        FROM CambioFichas
        WHERE id = p_id;
        
        DBMS_OUTPUT.PUT_LINE('Transacción ' || p_id || ': Monto=' || v_monto || ', Usuario=' || v_usuario || ', Cajero=' || v_cajero);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE PCK_EXCEPCIONES.e_no_existe; -- ORA-20102
    END consultar_transaccion;

    -- (READ OPERACIONAL)
    FUNCTION consultar_transacciones_cajero(p_cajero_id IN Cajeros.id%TYPE, p_turno IN Empleados.turno%TYPE)
        RETURN SYS_REFCURSOR
    IS
        c_transacciones SYS_REFCURSOR;
    BEGIN
        OPEN c_transacciones FOR
            SELECT c.id, c.monto, c.fechaHora, u.nombre AS nombre_usuario
            FROM CambioFichas c
            JOIN Empleados e ON c.cajero = e.id
            JOIN Usuarios u ON c.usuario = u.id
            WHERE c.cajero = p_cajero_id
              AND e.turno = p_turno
            ORDER BY c.fechaHora DESC;

        RETURN c_transacciones;
    END consultar_transacciones_cajero;

    -- (DELETE)
    PROCEDURE eliminar_transaccion(p_id IN CambioFichas.id%TYPE)
    IS
    BEGIN
        DELETE FROM CambioFichas WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE PCK_EXCEPCIONES.e_no_existe;
        END IF;
    END eliminar_transaccion;

END PCK_TRANSACCIONES;
/


-- ==========================================================
-- 3. PCK_USUARIOS_FUNC BODY: Registrar Visitas y Saldo
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_USUARIOS_FUNC AS

    -- Función Auxiliar: Verifica si un usuario existe
    FUNCTION verificar_existencia_usuario(p_id IN Usuarios.id%TYPE) RETURN BOOLEAN
    IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Usuarios WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia_usuario;

    -- (CREATE)
    PROCEDURE crear_usuario_invitado(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia_usuario(p_id) THEN
            RAISE PCK_EXCEPCIONES.e_id_existe; -- ORA-20101
        END IF;

        INSERT INTO Usuarios (id, nombre, balance)
        VALUES (p_id, p_nombre, p_balance);

        -- numeroDeVisitas inicia en 1
        INSERT INTO UsuariosInvitados (id, numeroDeVisitas)
        VALUES (p_id, 1);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN 
            RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN
            IF SQLCODE = -20004 THEN -- Captura el error del Trigger trg_evitar_frecuente_a_invitado
                RAISE;
            ELSE
                RAISE;
            END IF;
    END crear_usuario_invitado;

    -- (REGISTRAR VISITA)
    PROCEDURE registrar_visita(p_usuario_id IN Usuarios.id%TYPE)
    IS
        v_tipo VARCHAR2(20);
    BEGIN
        -- Intentar actualizar solo a UsuariosInvitados
        UPDATE UsuariosInvitados
        SET numeroDeVisitas = numeroDeVisitas + 1
        WHERE id = p_usuario_id;

        IF SQL%ROWCOUNT = 0 THEN
             -- Si no se actualizó, verificamos si el usuario existe para dar un error más específico
            IF verificar_existencia_usuario(p_usuario_id) THEN
                RAISE_APPLICATION_ERROR(-20105, 'El usuario ' || p_usuario_id || ' es un Usuario Frecuente (no invitado) o no se puede actualizar.');
            ELSE
                 RAISE PCK_EXCEPCIONES.e_no_existe;
            END IF;
        END IF;

        -- El trigger trg_promover_a_frecuente manejará el paso a UsuarioFrecuente si llega a 10 visitas

    END registrar_visita;

    -- (READ OPERACIONAL)
    FUNCTION consultar_saldo(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE
    IS
        v_balance Usuarios.balance%TYPE;
    BEGIN
        SELECT balance INTO v_balance
        FROM Usuarios
        WHERE id = p_usuario_id;
        
        RETURN v_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE PCK_EXCEPCIONES.e_no_existe; -- ORA-20102
    END consultar_saldo;

END PCK_USUARIOS_FUNC;
/


-- ==========================================================
-- 4. PCK_MANTENIMIENTO BODY: Operaciones de Setup y Mantenimiento
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_MANTENIMIENTO AS

    -- Funciones Auxiliares de Existencia
    FUNCTION verificar_existencia_empleado(p_id IN Empleados.id%TYPE) RETURN BOOLEAN
    IS v_count NUMBER; BEGIN SELECT COUNT(*) INTO v_count FROM Empleados WHERE id = p_id; RETURN v_count > 0; END verificar_existencia_empleado;
    
    FUNCTION verificar_existencia_usuario(p_id IN Usuarios.id%TYPE) RETURN BOOLEAN
    IS v_count NUMBER; BEGIN SELECT COUNT(*) INTO v_count FROM Usuarios WHERE id = p_id; RETURN v_count > 0; END verificar_existencia_usuario;
    
    FUNCTION verificar_existencia_juego(p_id IN Juegos.id%TYPE) RETURN BOOLEAN
    IS v_count NUMBER; BEGIN SELECT COUNT(*) INTO v_count FROM Juegos WHERE id = p_id; RETURN v_count > 0; END verificar_existencia_juego;
    
    FUNCTION verificar_existencia_mesa(p_id IN Mesas.id%TYPE) RETURN BOOLEAN
    IS v_count NUMBER; BEGIN SELECT COUNT(*) INTO v_count FROM Mesas WHERE id = p_id; RETURN v_count > 0; END verificar_existencia_mesa;
    

    -- -------------------------
    -- I. CRUD EMPLEADOS (Dealer y Cajero)
    -- -------------------------
    PROCEDURE crear_dealer(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_especialidad  IN Dealers.especialidad%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia_empleado(p_id) THEN RAISE PCK_EXCEPCIONES.e_id_existe; END IF;
        
        INSERT INTO Empleados (id, nombre, turno) VALUES (p_id, p_nombre, p_turno);
        INSERT INTO Dealers (id, especialidad) VALUES (p_id, p_especialidad);
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN RAISE;
    END crear_dealer;
    
    PROCEDURE crear_cajero(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_nivelAcceso   IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla    IN Cajeros.ventanilla%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia_empleado(p_id) THEN RAISE PCK_EXCEPCIONES.e_id_existe; END IF;
        
        INSERT INTO Empleados (id, nombre, turno) VALUES (p_id, p_nombre, p_turno);
        INSERT INTO Cajeros (id, nivelAcceso, ventanilla) VALUES (p_id, p_nivelAcceso, p_ventanilla);
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN RAISE;
    END crear_cajero;

    PROCEDURE eliminar_empleado(p_id IN Empleados.id%TYPE)
    IS
    BEGIN
        DELETE FROM Empleados WHERE id = p_id;
        IF SQL%ROWCOUNT = 0 THEN RAISE PCK_EXCEPCIONES.e_no_existe; END IF;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN 
                RAISE_APPLICATION_ERROR(-20107, 'No se puede eliminar el empleado ' || p_id || ' porque existen registros dependientes (mesas, transacciones).');
            ELSE
                RAISE;
            END IF;
    END eliminar_empleado;

    -- -------------------------
    -- II. CRUD JUEGOS
    -- -------------------------
    PROCEDURE crear_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia_juego(p_id) THEN RAISE PCK_EXCEPCIONES.e_id_existe; END IF;

        INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
        VALUES (p_id, p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta);

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN RAISE;
    END crear_juego;

    PROCEDURE actualizar_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    )
    IS
    BEGIN
        UPDATE Juegos
        SET nombre = p_nombre,
            maxJugadores = p_maxJugadores,
            minApuesta = p_minApuesta,
            maxApuesta = p_maxApuesta
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN RAISE PCK_EXCEPCIONES.e_no_existe; END IF;
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE_APPLICATION_ERROR(-20108, 'El nombre del juego ya está en uso.');
        WHEN OTHERS THEN RAISE;
    END actualizar_juego;
    
    PROCEDURE eliminar_juego(p_id IN Juegos.id%TYPE)
    IS
    BEGIN
        DELETE FROM Juegos WHERE id = p_id;
        IF SQL%ROWCOUNT = 0 THEN RAISE PCK_EXCEPCIONES.e_no_existe; END IF;
    
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN 
                RAISE_APPLICATION_ERROR(-20109, 'No se puede eliminar el juego porque existen mesas asociadas.');
            ELSE
                RAISE;
            END IF;
    END eliminar_juego;

    -- -------------------------
    -- III. CRUD MESAS
    -- -------------------------
    PROCEDURE crear_mesa(
        p_id            IN Mesas.id%TYPE,
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia_mesa(p_id) THEN RAISE PCK_EXCEPCIONES.e_id_existe; END IF;

        INSERT INTO Mesas (id, numeroMesa, estado, juego, dealer)
        VALUES (p_id, p_numeroMesa, p_estado, p_juego_id, p_dealer_id);
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN RAISE PCK_EXCEPCIONES.e_fk_violada;
            ELSE RAISE;
            END IF;
    END crear_mesa;
    
    PROCEDURE actualizar_mesa_estado(p_id IN Mesas.id%TYPE, p_nuevo_estado IN Mesas.estado%TYPE)
    IS
    BEGIN
        UPDATE Mesas
        SET estado = p_nuevo_estado
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN RAISE PCK_EXCEPCIONES.e_no_existe; END IF;
    END actualizar_mesa_estado;


    -- -------------------------
    -- IV. CRUD USUARIOS FRECUENTES y BENEFICIOS
    -- -------------------------
    PROCEDURE crear_usuario_frecuente(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE,
        p_correo        IN UsuariosFrecuentes.correo%TYPE,
        p_celular       IN UsuariosFrecuentes.celular%TYPE
    )
    IS
    BEGIN
        IF verificar_existencia_usuario(p_id) THEN RAISE PCK_EXCEPCIONES.e_id_existe; END IF;

        -- Insertar en la tabla padre (Usuarios)
        INSERT INTO Usuarios (id, nombre, balance) VALUES (p_id, p_nombre, p_balance);

        -- Insertar en la tabla subtipo (UsuariosFrecuentes)
        INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos)
        VALUES (p_id, p_correo, p_celular, 0); -- Puntos iniciales en 0
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN RAISE;
    END crear_usuario_frecuente;

    PROCEDURE crear_beneficio(
        p_id            IN Beneficios.id%TYPE,
        p_requisito     IN Beneficios.requisito%TYPE,
        p_descripcion   IN Beneficios.descripcion%TYPE
    )
    IS
    BEGIN
        INSERT INTO Beneficios (id, requisito, descripcion)
        VALUES (p_id, p_requisito, p_descripcion);
    
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN RAISE PCK_EXCEPCIONES.e_id_existe;
        WHEN OTHERS THEN RAISE;
    END crear_beneficio;

    PROCEDURE asignar_beneficio_a_frecuente(
        p_beneficio_id  IN Beneficios.id%TYPE,
        p_usuario_id    IN UsuariosFrecuentes.id%TYPE
    )
    IS
    BEGIN
        INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente)
        VALUES (p_beneficio_id, p_usuario_id);
    
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20005 THEN -- Captura el error del trigger de invitado
                RAISE;
            ELSIF SQLCODE = -2291 THEN -- Captura violación de FK
                 RAISE PCK_EXCEPCIONES.e_fk_violada;
            ELSE
                RAISE;
            END IF;
    END asignar_beneficio_a_frecuente;
    
    -- -------------------------
    -- V. ELIMINACIÓN GENÉRICA
    -- -------------------------
    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE)
    IS
    BEGIN
        DELETE FROM Usuarios WHERE id = p_id;
        IF SQL%ROWCOUNT = 0 THEN RAISE PCK_EXCEPCIONES.e_no_existe; END IF;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN 
                RAISE_APPLICATION_ERROR(-20110, 'No se puede eliminar el usuario ' || p_id || ' porque existen registros dependientes.');
            ELSE
                RAISE;
            END IF;
    END eliminar_usuario;

END PCK_MANTENIMIENTO;
/
--Correcion CRUDI

SET SERVEROUTPUT ON;
WHENEVER SQLERROR EXIT FAILURE;

-- ==========================================================
-- 1. PCK_MANTENIMIENTO: CRUD para Tablas Maestras
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_MANTENIMIENTO AS

    -- -------------------------
    -- 2.1 EMPLEADOS (CREATE) - Dealer
    -- El ID se genera automáticamente para la tabla Empleados
    -- -------------------------
    PROCEDURE crear_dealer(
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_especialidad  IN Dealers.especialidad%TYPE
    ) AS
        v_new_id Empleados.id%TYPE; -- Variable para capturar el ID
    BEGIN
        -- 1. Insertar en tabla padre (Empleados) y capturar el ID
        INSERT INTO Empleados (nombre, turno)
        VALUES (p_nombre, p_turno)
        RETURNING id INTO v_new_id;

        -- 2. Insertar en tabla hija (Dealers) usando el ID capturado
        INSERT INTO Dealers (id, especialidad)
        VALUES (v_new_id, p_especialidad);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20101, 'Error 20101: El ID (generado) o un valor UNIQUE ya existe.');
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20103, 'Error 20103: Violación de FK al crear Dealer.');
            ELSE
                RAISE;
            END IF;
    END crear_dealer;
    
    -- -------------------------
    -- 2.1 EMPLEADOS (CREATE) - Cajero
    -- -------------------------
    PROCEDURE crear_cajero(
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_nivelAcceso   IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla    IN Cajeros.ventanilla%TYPE
    ) AS
        v_new_id Empleados.id%TYPE; -- Variable para capturar el ID
    BEGIN
        -- 1. Insertar en tabla padre (Empleados) y capturar el ID
        INSERT INTO Empleados (nombre, turno)
        VALUES (p_nombre, p_turno)
        RETURNING id INTO v_new_id;

        -- 2. Insertar en tabla hija (Cajeros) usando el ID capturado
        INSERT INTO Cajeros (id, nivelAcceso, ventanilla)
        VALUES (v_new_id, p_nivelAcceso, p_ventanilla);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20101, 'Error 20101: El ID (generado) o un valor UNIQUE ya existe.');
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20103, 'Error 20103: Violación de FK al crear Cajero.');
            ELSE
                RAISE;
            END IF;
    END crear_cajero;

    -- -------------------------
    -- 2.3 JUEGOS (CREATE)
    -- -------------------------
    PROCEDURE crear_juego(
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    ) AS
    BEGIN
        -- No se incluye el ID en la lista de columnas, se genera automáticamente
        INSERT INTO Juegos (nombre, maxJugadores, minApuesta, maxApuesta)
        VALUES (p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20108, 'Error 20108: Ya existe un juego con el nombre ' || p_nombre || '.');
        WHEN OTHERS THEN
            RAISE;
    END crear_juego;
    
    -- -------------------------
    -- 2.5 MESAS (CREATE)
    -- -------------------------
    PROCEDURE crear_mesa(
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    ) AS
    BEGIN
        -- No se incluye el ID en la lista de columnas, se genera automáticamente
        INSERT INTO Mesas (numeroMesa, estado, juego, dealer)
        VALUES (p_numeroMesa, p_estado, p_juego_id, p_dealer_id);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20101, 'Error 20101: El número de mesa ' || p_numeroMesa || ' ya existe.');
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20103, 'Error 20103: El juego o dealer especificado no existe.');
            ELSE
                RAISE;
            END IF;
    END crear_mesa;

    -- -------------------------
    -- 2.7 USUARIOS (CREATE) - Frecuente
    -- -------------------------
    PROCEDURE crear_usuario_frecuente(
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE,
        p_correo        IN UsuariosFrecuentes.correo%TYPE,
        p_celular       IN UsuariosFrecuentes.celular%TYPE
    ) AS
        v_new_id Usuarios.id%TYPE; -- Variable para capturar el ID
    BEGIN
        -- 1. Insertar en tabla padre (Usuarios) y capturar el ID
        INSERT INTO Usuarios (nombre, balance)
        VALUES (p_nombre, p_balance)
        RETURNING id INTO v_new_id;

        -- 2. Insertar en tabla hija (UsuariosFrecuentes)
        INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos)
        VALUES (v_new_id, p_correo, p_celular, 0);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
             RAISE_APPLICATION_ERROR(-20101, 'Error 20101: El ID (generado) o correo ya existe.');
        WHEN OTHERS THEN
            RAISE;
    END crear_usuario_frecuente;

    -- -------------------------
    -- 2.7 USUARIOS (CREATE) - Invitado
    -- -------------------------
    PROCEDURE crear_usuario_invitado(
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE
    ) AS
        v_new_id Usuarios.id%TYPE; -- Variable para capturar el ID
    BEGIN
        -- 1. Insertar en tabla padre (Usuarios) y capturar el ID
        INSERT INTO Usuarios (nombre, balance)
        VALUES (p_nombre, p_balance)
        RETURNING id INTO v_new_id;

        -- 2. Insertar en tabla hija (UsuariosInvitados)
        INSERT INTO UsuariosInvitados (id, numeroDeVisitas)
        VALUES (v_new_id, 0);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
             RAISE_APPLICATION_ERROR(-20101, 'Error 20101: El ID (generado) ya existe.');
        WHEN OTHERS THEN
            RAISE;
    END crear_usuario_invitado;
    
    -- -------------------------
    -- 2.9 BENEFICIOS (CREATE)
    -- -------------------------
    PROCEDURE crear_beneficio(
        p_requisito     IN Beneficios.requisito%TYPE,
        p_descripcion   IN Beneficios.descripcion%TYPE
    ) AS
    BEGIN
        -- No se incluye el ID en la lista de columnas, se genera automáticamente
        INSERT INTO Beneficios (requisito, descripcion)
        VALUES (p_requisito, p_descripcion);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END crear_beneficio;

    -- *** READ, UPDATE, DELETE PROCEDURES *** (Se mantienen sin cambios en su lógica interna)

    FUNCTION consultar_empleado(p_id IN Empleados.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT e.id, e.nombre, e.turno, d.especialidad, c.nivelAcceso, c.ventanilla
            FROM Empleados e
            LEFT JOIN Dealers d ON e.id = d.id
            LEFT JOIN Cajeros c ON e.id = c.id
            WHERE e.id = p_id;
            
        -- Verificar si se encontró el empleado
        FETCH v_cursor INTO v_cursor;
        IF v_cursor%NOTFOUND THEN
            CLOSE v_cursor;
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: El empleado con ID ' || p_id || ' no existe.');
        END IF;
        
        RETURN v_cursor;
    END consultar_empleado;

    PROCEDURE actualizar_empleado(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno         IN Empleados.turno%TYPE DEFAULT NULL
    ) AS
    BEGIN
        UPDATE Empleados
        SET nombre = NVL(p_nombre, nombre),
            turno = NVL(p_turno, turno)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Empleado con ID ' || p_id || ' no encontrado para actualizar.');
        END IF;
        COMMIT;
    END actualizar_empleado;

    PROCEDURE eliminar_empleado(p_id IN Empleados.id%TYPE) AS
    BEGIN
        -- La eliminación se propagará a Dealers o Cajeros por la FK (ON DELETE CASCADE)
        DELETE FROM Empleados WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Empleado con ID ' || p_id || ' no encontrado para eliminar.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN
                RAISE_APPLICATION_ERROR(-20110, 'Error 20110: No se puede eliminar el empleado ' || p_id || ' porque tiene mesas o transacciones dependientes.');
            ELSE
                RAISE;
            END IF;
    END eliminar_empleado;

    FUNCTION consultar_juego(p_id IN Juegos.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM Juegos WHERE id = p_id;

        RETURN v_cursor;
    END consultar_juego;
    
    PROCEDURE actualizar_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE DEFAULT NULL,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE DEFAULT NULL,
        p_minApuesta    IN Juegos.minApuesta%TYPE DEFAULT NULL,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE DEFAULT NULL
    ) AS
    BEGIN
        UPDATE Juegos
        SET nombre = NVL(p_nombre, nombre),
            maxJugadores = NVL(p_maxJugadores, maxJugadores),
            minApuesta = NVL(p_minApuesta, minApuesta),
            maxApuesta = NVL(p_maxApuesta, maxApuesta)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Juego con ID ' || p_id || ' no encontrado para actualizar.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20108, 'Error 20108: El nombre de juego ' || p_nombre || ' ya está en uso.');
        WHEN OTHERS THEN
            RAISE;
    END actualizar_juego;
    
    PROCEDURE eliminar_juego(p_id IN Juegos.id%TYPE) AS
    BEGIN
        DELETE FROM Juegos WHERE id = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Juego con ID ' || p_id || ' no encontrado para eliminar.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN
                RAISE_APPLICATION_ERROR(-20110, 'Error 20110: No se puede eliminar el juego ' || p_id || ' porque tiene mesas dependientes.');
            ELSE
                RAISE;
            END IF;
    END eliminar_juego;

    FUNCTION consultar_mesa(p_id IN Mesas.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT m.id, m.numeroMesa, m.estado, j.nombre AS juego_nombre, e.nombre AS dealer_nombre
            FROM Mesas m
            JOIN Juegos j ON m.juego = j.id
            JOIN Empleados e ON m.dealer = e.id
            WHERE m.id = p_id;

        RETURN v_cursor;
    END consultar_mesa;

    PROCEDURE actualizar_mesa_estado(
        p_id            IN Mesas.id%TYPE,
        p_nuevo_estado  IN Mesas.estado%TYPE
    ) AS
    BEGIN
        UPDATE Mesas
        SET estado = p_nuevo_estado
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Mesa con ID ' || p_id || ' no encontrada para actualizar.');
        END IF;
        COMMIT;
    END actualizar_mesa_estado;

    PROCEDURE eliminar_mesa(p_id IN Mesas.id%TYPE) AS
    BEGIN
        DELETE FROM Mesas WHERE id = p_id;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Mesa con ID ' || p_id || ' no encontrada para eliminar.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN
                RAISE_APPLICATION_ERROR(-20110, 'Error 20110: No se puede eliminar la mesa ' || p_id || ' porque tiene apuestas dependientes.');
            ELSE
                RAISE;
            END IF;
    END eliminar_mesa;

    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE) AS
    BEGIN
        -- La eliminación se propagará a UsuariosFrecuentes/Invitados por la FK (ON DELETE CASCADE)
        DELETE FROM Usuarios WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Usuario con ID ' || p_id || ' no encontrado para eliminar.');
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2292 THEN
                RAISE_APPLICATION_ERROR(-20110, 'Error 20110: No se puede eliminar el usuario ' || p_id || ' porque tiene apuestas o transacciones dependientes.');
            ELSE
                RAISE;
            END IF;
    END eliminar_usuario;

    PROCEDURE asignar_beneficio_a_frecuente(
        p_beneficio_id  IN Beneficios.id%TYPE,
        p_usuario_id    IN UsuariosFrecuentes.id%TYPE
    ) AS
    BEGIN
        INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuario)
        VALUES (p_beneficio_id, p_usuario_id);
        
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20103, 'Error 20103: El beneficio o el usuario frecuente no existe.');
            ELSE
                RAISE;
            END IF;
    END asignar_beneficio_a_frecuente;

END PCK_MANTENIMIENTO;
/

-- ------------------------------------------------------------------

-- ==========================================================
-- 2. PCK_APUESTAS: CRUD y Flujo de Apuestas
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_APUESTAS AS

    -- -------------------------
    -- 3.1 APUESTAS (CREATE)
    -- -------------------------
    PROCEDURE registrar_apuesta(
        p_monto         IN Apuestas.monto%TYPE,
        p_usuario_id    IN Apuestas.usuario%TYPE,
        p_mesa_id       IN Apuestas.mesa%TYPE
    ) AS
    BEGIN
        -- No se incluye el ID en la lista de columnas, se genera automáticamente
        INSERT INTO Apuestas (monto, fechaHora, estado, usuario, mesa)
        VALUES (p_monto, SYSDATE, 'En proceso', p_usuario_id, p_mesa_id);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20103, 'Error 20103: El usuario o la mesa especificada no existe.');
            ELSE
                RAISE;
            END IF;
    END registrar_apuesta;

    -- -------------------------
    -- 3.2 APUESTAS (UPDATE, READ)
    -- -------------------------
    PROCEDURE finalizar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_nuevo_estado  IN Apuestas.estado%TYPE
    ) AS
    BEGIN
        UPDATE Apuestas
        SET estado = p_nuevo_estado
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Apuesta con ID ' || p_id || ' no encontrada para finalizar.');
        END IF;
        COMMIT;
    END finalizar_apuesta;

    FUNCTION consultar_historial_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT a.id, j.nombre AS juego, a.monto, a.estado, a.fechaHora
            FROM Apuestas a
            JOIN Mesas m ON a.mesa = m.id
            JOIN Juegos j ON m.juego = j.id
            WHERE a.usuario = p_usuario_id
            ORDER BY a.fechaHora DESC;

        RETURN v_cursor;
    END consultar_historial_usuario;
        
END PCK_APUESTAS;
/

-- ------------------------------------------------------------------

-- ==========================================================
-- 3. PCK_TRANSACCIONES: CRUD y Flujo de Transacciones
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_TRANSACCIONES AS

    -- -------------------------
    -- 4.1 CAMBIO FICHAS (CREATE)
    -- -------------------------
    PROCEDURE registrar_cambio_fichas(
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajero_id     IN Cajeros.id%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE
    ) AS
    BEGIN
        -- No se incluye el ID en la lista de columnas, se genera automáticamente
        INSERT INTO CambioFichas (monto, fechaHora, usuario, cajero, cajaRecibe)
        VALUES (p_monto, SYSDATE, p_usuario_id, p_cajero_id, p_cajaRecibe);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20103, 'Error 20103: El usuario o el cajero especificado no existe.');
            ELSE
                RAISE;
            END IF;
    END registrar_cambio_fichas;

    -- -------------------------
    -- 4.2 CAMBIO FICHAS (READ, DELETE)
    -- -------------------------
    FUNCTION consultar_transacciones_cajero(
        p_cajero_id     IN Cajeros.id%TYPE,
        p_turno         IN Empleados.turno%TYPE
    )
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT t.id, u.nombre AS usuario_nombre, t.monto, t.fechaHora, t.cajaRecibe
            FROM CambioFichas t
            JOIN Usuarios u ON t.usuario = u.id
            JOIN Empleados e ON t.cajero = e.id
            WHERE t.cajero = p_cajero_id
            AND e.turno = p_turno
            ORDER BY t.fechaHora DESC;

        RETURN v_cursor;
    END consultar_transacciones_cajero;

    PROCEDURE eliminar_transaccion(p_id IN CambioFichas.id%TYPE) AS
    BEGIN
        DELETE FROM CambioFichas WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Transacción con ID ' || p_id || ' no encontrada para eliminar.');
        END IF;
        COMMIT;
    END eliminar_transaccion;

END PCK_TRANSACCIONES;
/

-- ------------------------------------------------------------------

-- ==========================================================
-- 4. PCK_USUARIOS_FUNC: Funciones de Usuario (READ/Logic)
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_USUARIOS_FUNC AS

    PROCEDURE registrar_visita(p_usuario_id IN Usuarios.id%TYPE) AS
        v_es_invitado BOOLEAN := FALSE;
        v_visitas UsuariosInvitados.numeroDeVisitas%TYPE;
    BEGIN
        -- 1. Verificar si el usuario es un invitado
        SELECT numeroDeVisitas INTO v_visitas
        FROM UsuariosInvitados
        WHERE id = p_usuario_id;
        
        v_es_invitado := TRUE;
        
        -- 2. Actualizar el contador de visitas (el trigger trg_promover_a_frecuente se encargará de la promoción)
        UPDATE UsuariosInvitados
        SET numeroDeVisitas = numeroDeVisitas + 1
        WHERE id = p_usuario_id;
        
        COMMIT;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Si no está en UsuariosInvitados, es un Frecuente o no existe
            BEGIN
                SELECT 'X' INTO v_visitas FROM UsuariosFrecuentes WHERE id = p_usuario_id;
                
                -- Si existe en Frecuentes, lanza el error de negocio
                RAISE_APPLICATION_ERROR(-20105, 'Error 20105: No se puede registrar visita al usuario ' || p_usuario_id || '. Solo aplica a invitados.');
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- Si no existe en ninguna, lanza el error de inexistencia
                    RAISE_APPLICATION_ERROR(-20102, 'Error 20102: El usuario con ID ' || p_usuario_id || ' no existe.');
                WHEN OTHERS THEN
                    RAISE;
            END;
        WHEN OTHERS THEN
            RAISE;
    END registrar_visita;

    FUNCTION consultar_saldo(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE
    AS
        v_balance Usuarios.balance%TYPE;
    BEGIN
        SELECT balance INTO v_balance
        FROM Usuarios
        WHERE id = p_usuario_id;
        
        RETURN v_balance;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Usuario con ID ' || p_usuario_id || ' no encontrado.');
        WHEN OTHERS THEN
            RAISE;
    END consultar_saldo;
        
END PCK_USUARIOS_FUNC;
/
--CRUDI

-- ==========================================================
-- 2. PCK_EMPLEADOS: CRUD para Registrar y Mantener empleados
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_REGISTRAR_EMPLEADOS AS


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

END PCK_REGISTRAR_EMPLEADOS;
/


CREATE OR REPLACE PACKAGE BODY PCK_MANTENER_EMPLEADOS AS

    FUNCTION consultar_empleado(p_id IN Empleados.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
        v_dummy  NUMBER;
    BEGIN
        -- Validar existencia del empleado antes de abrir el cursor
        SELECT 1 INTO v_dummy
        FROM Empleados
        WHERE id = p_id;

        OPEN v_cursor FOR
            SELECT e.id, e.nombre, e.turno,
                   d.especialidad,
                   c.nivelAcceso, c.ventanilla
            FROM Empleados e
            LEFT JOIN Dealers d ON e.id = d.id
            LEFT JOIN Cajeros  c ON e.id = c.id
            WHERE e.id = p_id;

        RETURN v_cursor;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: El empleado con ID ' || p_id || ' no existe.');
        WHEN OTHERS THEN
            RAISE;
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
        -- La eliminación se propagará a Dealers/Cajeros por la FK (ON DELETE CASCADE)
        DELETE FROM Empleados WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Empleado con ID ' || p_id || ' no encontrado para eliminar.');
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            -- -2292: hay dependencias. -1407: intento de ON DELETE SET NULL sobre columna NOT NULL (según modelo)
            IF SQLCODE IN (-2292, -1407) THEN
                RAISE_APPLICATION_ERROR(-20110,
                    'Error 20110: No se puede eliminar el empleado ' || p_id ||
                    ' porque tiene registros dependientes (mesas/transacciones).');
            ELSE
                RAISE;
            END IF;
    END eliminar_empleado;

END PCK_MANTENER_EMPLEADOS;
/


CREATE OR REPLACE PACKAGE BODY PCK_REGISTRAR_ESTABLECIMIENTO AS


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

    -- Crear un nuevo torneo
    PROCEDURE crear_torneo(
        p_nombre        IN Torneos.nombre%TYPE,
        p_fecha_inicio  IN Torneos.fecha_inicio%TYPE,
        p_fecha_fin     IN Torneos.fecha_fin%TYPE,
        p_estado        IN Torneos.estado%TYPE,
        p_pozo_premios  IN Torneos.pozoDePremios%TYPE,
        p_juego         IN Torneos.juego%TYPE,
        p_jugadores     IN Torneos.jugadoresActuales%TYPE,
        p_valor_entrada IN Torneos.valorEntrada%TYPE
    ) AS
    BEGIN
        INSERT INTO Torneos (nombre, fecha_inicio, fecha_fin, estado, pozoDePremios, juego, jugadoresActuales, valorEntrada)
        VALUES (p_nombre, p_fecha_inicio, p_fecha_fin, p_estado, p_pozo_premios, p_juego, NVL(p_jugadores, 0), p_valor_entrada);
        COMMIT;
    END crear_torneo;


END PCK_REGISTRAR_ESTABLECIMIENTO;
/


CREATE OR REPLACE PACKAGE BODY PCK_MANTENER_ESTABLECIMIENTO AS

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
        v_dummy  NUMBER;
    BEGIN
        SELECT 1 INTO v_dummy
        FROM Mesas
        WHERE id = p_id;

        OPEN v_cursor FOR
            SELECT m.id, m.numeroMesa, m.estado,
                   j.nombre AS juego_nombre,
                   e.nombre AS dealer_nombre
            FROM Mesas m
            JOIN Juegos j ON m.juego = j.id
            JOIN Empleados e ON m.dealer = e.id
            WHERE m.id = p_id;

        RETURN v_cursor;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: La mesa con ID ' || p_id || ' no existe.');
        WHEN OTHERS THEN
            RAISE;
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

    FUNCTION consultar_juego(p_id IN Juegos.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
        v_dummy  NUMBER;
    BEGIN
        SELECT 1 INTO v_dummy
        FROM Juegos
        WHERE id = p_id;

        OPEN v_cursor FOR
            SELECT * FROM Juegos WHERE id = p_id;

        RETURN v_cursor;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: El juego con ID ' || p_id || ' no existe.');
        WHEN OTHERS THEN
            RAISE;
    END consultar_juego;


     -- Actualizar un torneo existente
    PROCEDURE actualizar_torneo(
        p_id            IN Torneos.id%TYPE,
        p_nombre        IN Torneos.nombre%TYPE DEFAULT NULL,
        p_fecha_inicio  IN Torneos.fecha_inicio%TYPE DEFAULT NULL,
        p_fecha_fin     IN Torneos.fecha_fin%TYPE DEFAULT NULL,
        p_estado        IN Torneos.estado%TYPE DEFAULT NULL,
        p_pozo_premios  IN Torneos.pozoDePremios%TYPE DEFAULT NULL,
        p_juego         IN Torneos.juego%TYPE DEFAULT NULL,
        p_jugadores     IN Torneos.jugadoresActuales%TYPE DEFAULT NULL,
        p_valor_entrada IN Torneos.valorEntrada%TYPE DEFAULT NULL
    ) AS
    BEGIN
        UPDATE Torneos
        SET nombre = NVL(p_nombre, nombre),
            fecha_inicio = NVL(p_fecha_inicio, fecha_inicio),
            fecha_fin = NVL(p_fecha_fin, fecha_fin),
            estado = NVL(p_estado, estado),
            pozoDePremios = NVL(p_pozo_premios, pozoDePremios),
            juego = NVL(p_juego, juego),
            jugadoresActuales = NVL(p_jugadores, jugadoresActuales),
            valorEntrada = NVL(p_valor_entrada, valorEntrada)
        WHERE id = p_id;
        COMMIT;
    END actualizar_torneo;

    -- Consultar un torneo por su ID
    FUNCTION consultar_torneo(p_id IN Torneos.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM Torneos WHERE id = p_id;
        RETURN v_cursor;
    END consultar_torneo;

    -- Consultar todos los torneos activos
    FUNCTION consultar_torneos_activos
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT * FROM Torneos WHERE estado = 'Activo';
        RETURN v_cursor;
    END consultar_torneos_activos;

    -- Procedimiento para cerrar un torneo
    PROCEDURE cerrar_torneo(
        p_torneo_id IN NUMBER -- ID del torneo
    ) AS
    BEGIN
        -- Actualizar el estado del torneo a 'Finalizado'
        UPDATE Torneos
        SET estado = 'Finalizado'
        WHERE id = p_torneo_id;

        COMMIT;
    END cerrar_torneo;

    -- Eliminar un torneo
    PROCEDURE eliminar_torneo(p_id IN Torneos.id%TYPE)
    IS
    BEGIN
        DELETE FROM Torneos WHERE id = p_id;
        COMMIT;
    END eliminar_torneo;



END PCK_MANTENER_ESTABLECIMIENTO;
/

CREATE OR REPLACE PACKAGE BODY PCK_REGISTRAR_APUESTAS AS


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


END PCK_REGISTRAR_APUESTAS;
/

CREATE OR REPLACE PACKAGE BODY PCK_MANTENER_APUESTAS AS

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

END PCK_MANTENER_APUESTAS;
/

CREATE OR REPLACE PACKAGE BODY PCK_REGISTRAR_TRANSACCIONES AS


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


END PCK_REGISTRAR_TRANSACCIONES;
/

CREATE OR REPLACE PACKAGE BODY PCK_MANTENER_TRANSACCIONES AS


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


END PCK_MANTENER_TRANSACCIONES;
/

CREATE OR REPLACE PACKAGE BODY PCK_REGISTRAR_USUARIOS AS

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


    -- Procedimiento para registrar un jugador en un torneo
    PROCEDURE registrar_participante(
        p_torneo_id      IN NUMBER,     -- ID del torneo
        p_usuario_id     IN NUMBER,     -- ID del usuario
        p_estado         IN VARCHAR2    -- Estado (Inscrito, Eliminado)
    ) AS
    BEGIN
        -- Insertar el participante en la tabla de Participantes
        INSERT INTO Participantes (torneo, usuario, fecha_registro, estado)
        VALUES (p_torneo_id, p_usuario_id, SYSDATE, p_estado);
        
        COMMIT;
    END registrar_participante;



END PCK_REGISTRAR_USUARIOS;
/


CREATE OR REPLACE PACKAGE BODY PCK_MANTENER_USUARIOS AS

PROCEDURE actualizar_datos_usuario_frecuente(
    p_id IN UsuariosFrecuentes.id%TYPE,
    p_nombre_nuevo IN Usuarios.nombre%TYPE DEFAULT NULL,
    p_correo_nuevo IN UsuariosFrecuentes.correo%TYPE DEFAULT NULL,
    p_celular_nuevo IN UsuariosFrecuentes.celular%TYPE DEFAULT NULL
) AS
    v_rows_affected NUMBER := 0;
BEGIN
    -- 1. Actualizar tabla padre (Usuarios)
    UPDATE Usuarios
    SET nombre = NVL(p_nombre_nuevo, nombre)
    WHERE id = p_id;
    
    v_rows_affected := v_rows_affected + SQL%ROWCOUNT;

    -- 2. Actualizar tabla hija (UsuariosFrecuentes)
    UPDATE UsuariosFrecuentes
    SET correo = NVL(p_correo_nuevo, correo),
        celular = NVL(p_celular_nuevo, celular)
    WHERE id = p_id;

    v_rows_affected := v_rows_affected + SQL%ROWCOUNT;
    
    -- 3. Validar si existe (el usuario debe existir al menos en Usuarios)
    IF v_rows_affected = 0 THEN
        RAISE_APPLICATION_ERROR(-20102, 'Error 20102: Usuario frecuente con ID ' || p_id || ' no encontrado para actualizar.');
    END IF;

    COMMIT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20101, 'Error 20101: El correo o celular ya está en uso por otro usuario.');
    WHEN OTHERS THEN
        RAISE;
END actualizar_datos_usuario_frecuente;




    PROCEDURE registrar_visita(p_usuario_id IN Usuarios.id%TYPE) AS
        v_dummy NUMBER;
    BEGIN
        -- Incrementa visitas solo si el usuario es invitado
        UPDATE UsuariosInvitados
        SET numeroDeVisitas = NVL(numeroDeVisitas, 0) + 1
        WHERE id = p_usuario_id;

        IF SQL%ROWCOUNT = 1 THEN
            COMMIT;
            RETURN;
        END IF;

        -- Si no era invitado, validar si existe como frecuente o si no existe
        BEGIN
            SELECT 1 INTO v_dummy
            FROM UsuariosFrecuentes
            WHERE id = p_usuario_id;

            -- Si existe como frecuente, es un error de negocio
            RAISE_APPLICATION_ERROR(-20105,
                'Error 20105: No se puede registrar visita al usuario ' || p_usuario_id || '. Solo aplica a invitados.');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20102, 'Error 20102: El usuario con ID ' || p_usuario_id || ' no existe.');
        END;

    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END registrar_visita;


    FUNCTION consultar_usuario(p_id IN Usuarios.id%TYPE)
    RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;  -- Variable de cursor para retornar el resultado
BEGIN
    -- Abrir el cursor con la consulta que devuelve los detalles del usuario
    OPEN v_cursor FOR
        SELECT u.id, 
               u.nombre, 
               u.balance, 
               -- Si no hay registro en UsuariosFrecuentes, correo y celular serán NULL
               uf.correo, 
               uf.celular
        FROM Usuarios u
        LEFT JOIN UsuariosFrecuentes uf ON u.id = uf.id
        WHERE u.id = p_id;

    -- Retornar el cursor con los resultados
    RETURN v_cursor;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Si no se encuentra el usuario, generamos un error
        RAISE_APPLICATION_ERROR(-20102, 'Error 20102: El usuario con ID ' || p_id || ' no existe.');
    WHEN OTHERS THEN
        -- Capturamos otros errores no anticipados
        RAISE;
END consultar_usuario;

PROCEDURE eliminar_beneficio(p_id IN Beneficios.id%TYPE) AS
BEGIN
    -- Eliminar primero las relaciones del beneficio en la tabla de asignaciones
    DELETE FROM UsuariosFrecuentes_Beneficios
    WHERE beneficio = p_id;

    -- Ahora, eliminar el beneficio de la tabla Beneficios
    DELETE FROM Beneficios
    WHERE id = p_id;

    COMMIT;  -- Confirmar los cambios
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Si no se encuentra el beneficio, se lanza un error
        RAISE_APPLICATION_ERROR(-20103, 'El beneficio con ID ' || p_id || ' no existe.');
    WHEN OTHERS THEN
        -- Capturar otros errores no anticipados
        RAISE;
END eliminar_beneficio;

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
        INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente)
        VALUES (p_beneficio_id, p_usuario_id);

        COMMIT;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20101, 'Error 20101: El beneficio ya está asignado a ese usuario frecuente.');
        WHEN OTHERS THEN
            IF SQLCODE = -2291 THEN
                RAISE_APPLICATION_ERROR(-20103, 'Error 20103: El beneficio o el usuario frecuente no existe.');
            ELSE
                RAISE;
            END IF;
    END asignar_beneficio_a_frecuente;

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

    FUNCTION consultar_historial_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR
    IS
        v_cursor SYS_REFCURSOR;
        v_dummy  NUMBER;
    BEGIN
        -- Validar existencia del usuario
        SELECT 1 INTO v_dummy
        FROM Usuarios
        WHERE id = p_usuario_id;

        OPEN v_cursor FOR
            SELECT a.id, j.nombre AS juego, a.monto, a.estado, a.fechaHora
            FROM Apuestas a
            JOIN Mesas m ON a.mesa = m.id
            JOIN Juegos j ON m.juego = j.id
            WHERE a.usuario = p_usuario_id
            ORDER BY a.fechaHora DESC;

        RETURN v_cursor;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20102, 'Error 20102: El usuario con ID ' || p_usuario_id || ' no existe.');
        WHEN OTHERS THEN
            RAISE;
    END consultar_historial_usuario;

    -- Procedimiento para actualizar la participación de un jugador
    PROCEDURE actualizar_participante(
        p_participante_id IN NUMBER,    -- ID del participante
        p_estado          IN VARCHAR2   -- Nuevo estado (Inscrito, Eliminado, etc.)
    ) AS
    BEGIN
        -- Actualizar el estado del participante
        UPDATE Participantes
        SET estado = p_estado
        WHERE id = p_participante_id;
        
        COMMIT;
    END actualizar_participante;

    -- Procedimiento para actualizar los ganadores de un torneo
    PROCEDURE actualizar_ganadores(
        p_torneo_id       IN NUMBER,   -- ID del torneo
        p_participante_id IN NUMBER,   -- ID del ganador
        p_premio          IN VARCHAR2, -- Descripción del premio
        p_monto           IN NUMBER    -- Monto del premio
    ) AS
    BEGIN
        -- Actualizar el premio para el ganador
        INSERT INTO Premios (torneo, participante, premio, monto, estado)
        VALUES (p_torneo_id, p_participante_id, p_premio, p_monto, 'Asignado');
        
        -- Actualizar el estado del torneo a 'Finalizado'
        UPDATE Torneos
        SET estado = 'Finalizado'
        WHERE id = p_torneo_id;
        
        COMMIT;
    END actualizar_ganadores;


END PCK_MANTENER_USUARIOS;
/


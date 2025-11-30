--------------------------------------------------------------------------------
-- CUERPO DEL PAQUETE: PCK_PERSONAL (CRUDI)
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY PCK_PERSONAL AS

    -- Función auxiliar (se mantiene para la gestión de errores)
    FUNCTION verificar_existencia (p_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Empleados WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia;
    
    ----------------------------------------------------------------------------
    -- Empleados Base (Padre) - Leer, Actualizar, Eliminar
    ----------------------------------------------------------------------------

    -- Read (Leer)
    PROCEDURE consultar_empleado (
        p_id          IN  NUMBER,
        p_nombre      OUT Empleados.nombre%TYPE,
        p_turno       OUT Empleados.turno%TYPE
    )
    AS
    BEGIN
        SELECT nombre, turno
        INTO p_nombre, p_turno
        FROM Empleados
        WHERE id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20010, 'Empleado con ID ' || p_id || ' no encontrado.');
    END consultar_empleado;

    -- Update (Actualizar)
    PROCEDURE actualizar_empleado (
        p_id          IN NUMBER,
        p_nombre      IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno       IN Empleados.turno%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        IF NOT verificar_existencia(p_id) THEN
            RAISE_APPLICATION_ERROR(-20011, 'No se puede actualizar. Empleado con ID ' || p_id || ' no existe.');
        END IF;

        UPDATE Empleados
        SET
            nombre = NVL(p_nombre, nombre),
            turno = NVL(p_turno, turno)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20012, 'Actualización fallida para Empleado ' || p_id);
        END IF;
    END actualizar_empleado;

    -- Delete (Eliminar)
    PROCEDURE eliminar_empleado (
        p_id          IN NUMBER
    )
    AS
    BEGIN
        IF NOT verificar_existencia(p_id) THEN
            RAISE_APPLICATION_ERROR(-20013, 'No se puede eliminar. Empleado con ID ' || p_id || ' no existe.');
        END IF;

        DELETE FROM Empleados
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20014, 'Eliminación fallida para Empleado ' || p_id);
        END IF;
    END eliminar_empleado;
    
    ----------------------------------------------------------------------------
    -- Cajeros - Crear, Leer, Actualizar
    ----------------------------------------------------------------------------
    
    -- Create (Crear)
    PROCEDURE crear_cajero (
        p_id             IN NUMBER,
        p_nombre         IN Empleados.nombre%TYPE,
        p_turno          IN Empleados.turno%TYPE,
        p_nivelAcceso    IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla     IN Cajeros.ventanilla%TYPE
    )
    AS
    BEGIN
        -- 1. Insertar en la tabla padre (Empleados)
        INSERT INTO Empleados (id, nombre, turno)
        VALUES (p_id, p_nombre, p_turno);

        -- 2. Insertar en la tabla hija (Cajeros)
        INSERT INTO Cajeros (id, nivelAcceso, ventanilla)
        VALUES (p_id, p_nivelAcceso, p_ventanilla);
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20020, 'ID ' || p_id || ' ya existe o ya fue asignado a otro empleado.');
        WHEN OTHERS THEN
            RAISE;
    END crear_cajero;
    
    -- Read (Leer)
    PROCEDURE consultar_cajero (
        p_id             IN NUMBER,
        p_nombre         OUT Empleados.nombre%TYPE,
        p_turno          OUT Empleados.turno%TYPE,
        p_nivelAcceso    OUT Cajeros.nivelAcceso%TYPE,
        p_ventanilla     OUT Cajeros.ventanilla%TYPE
    )
    AS
    BEGIN
        SELECT e.nombre, e.turno, c.nivelAcceso, c.ventanilla
        INTO p_nombre, p_turno, p_nivelAcceso, p_ventanilla
        FROM Empleados e
        JOIN Cajeros c ON e.id = c.id
        WHERE e.id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20021, 'Cajero con ID ' || p_id || ' no encontrado.');
    END consultar_cajero;
    
    -- Update (Actualizar)
    PROCEDURE actualizar_cajero (
        p_id             IN NUMBER,
        p_nivelAcceso    IN Cajeros.nivelAcceso%TYPE DEFAULT NULL,
        p_ventanilla     IN Cajeros.ventanilla%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        UPDATE Cajeros
        SET
            nivelAcceso = NVL(p_nivelAcceso, nivelAcceso),
            ventanilla = NVL(p_ventanilla, ventanilla)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20022, 'Actualización fallida para Cajero ' || p_id || '. (El Cajero no existe)');
        END IF;
    END actualizar_cajero;
    
    ----------------------------------------------------------------------------
    -- Dealers - Crear, Leer, Actualizar
    ----------------------------------------------------------------------------
    
    -- Create (Crear)
    PROCEDURE crear_dealer (
        p_id             IN NUMBER,
        p_nombre         IN Empleados.nombre%TYPE,
        p_turno          IN Empleados.turno%TYPE,
        p_especialidad   IN Dealers.especialidad%TYPE
    )
    AS
    BEGIN
        -- 1. Insertar en la tabla padre (Empleados)
        INSERT INTO Empleados (id, nombre, turno)
        VALUES (p_id, p_nombre, p_turno);

        -- 2. Insertar en la tabla hija (Dealers)
        INSERT INTO Dealers (id, especialidad)
        VALUES (p_id, p_especialidad);
        
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20030, 'ID ' || p_id || ' ya existe o ya fue asignado a otro empleado.');
        WHEN OTHERS THEN
            RAISE;
    END crear_dealer;
    
    -- Read (Leer)
    PROCEDURE consultar_dealer (
        p_id             IN NUMBER,
        p_nombre         OUT Empleados.nombre%TYPE,
        p_turno          OUT Empleados.turno%TYPE,
        p_especialidad   OUT Dealers.especialidad%TYPE
    )
    AS
    BEGIN
        SELECT e.nombre, e.turno, d.especialidad
        INTO p_nombre, p_turno, p_especialidad
        FROM Empleados e
        JOIN Dealers d ON e.id = d.id
        WHERE e.id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20031, 'Dealer con ID ' || p_id || ' no encontrado.');
    END consultar_dealer;
    
    -- Update (Actualizar)
    PROCEDURE actualizar_dealer (
        p_id             IN NUMBER,
        p_especialidad   IN Dealers.especialidad%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        UPDATE Dealers
        SET especialidad = NVL(p_especialidad, especialidad)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20032, 'Actualización fallida para Dealer ' || p_id || '. (El Dealer no existe)');
        END IF;
    END actualizar_dealer;

END PCK_PERSONAL;
/




--------------------------------------------------------------------------------
-- CUERPO DEL PAQUETE: PCK_USUARIOS (CRUDI)
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY PCK_USUARIOS AS

    -- Funciones auxiliares (se mantienen para la gestión de errores)
    FUNCTION verificar_existencia_usuario (p_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Usuarios WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia_usuario;

    FUNCTION verificar_existencia_frecuente (p_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM UsuariosFrecuentes WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia_frecuente;
    
    FUNCTION verificar_existencia_beneficio (p_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Beneficios WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia_beneficio;

    ----------------------------------------------------------------------------
    -- 1. Gestión de Usuarios Base (Leer, Actualizar, Eliminar)
    ----------------------------------------------------------------------------

    -- Read (Leer)
    PROCEDURE consultar_usuario (
        p_id          IN  NUMBER,
        p_nombre      OUT Usuarios.nombre%TYPE,
        p_balance     OUT Usuarios.balance%TYPE
    )
    AS
    BEGIN
        SELECT nombre, balance
        INTO p_nombre, p_balance
        FROM Usuarios
        WHERE id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20100, 'Usuario con ID ' || p_id || ' no encontrado.');
    END consultar_usuario;

    -- Update (Actualizar)
    PROCEDURE actualizar_usuario (
        p_id          IN NUMBER,
        p_nombre      IN Usuarios.nombre%TYPE DEFAULT NULL,
        p_balance     IN Usuarios.balance%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        IF NOT verificar_existencia_usuario(p_id) THEN
            RAISE_APPLICATION_ERROR(-20101, 'No se puede actualizar. Usuario con ID ' || p_id || ' no existe.');
        END IF;

        UPDATE Usuarios
        SET
            nombre = NVL(p_nombre, nombre),
            balance = NVL(p_balance, balance)
        WHERE id = p_id;
    
        -- COMMIT ELIMINADO
    END actualizar_usuario;

    -- Delete (Eliminar)
    PROCEDURE eliminar_usuario (
        p_id          IN NUMBER
    )
    AS
    BEGIN
        IF NOT verificar_existencia_usuario(p_id) THEN
            RAISE_APPLICATION_ERROR(-20102, 'No se puede eliminar. Usuario con ID ' || p_id || ' no existe.');
        END IF;

        DELETE FROM Usuarios
        WHERE id = p_id;
        
        -- COMMIT ELIMINADO
    END eliminar_usuario;

    ----------------------------------------------------------------------------
    -- 2. Gestión de Usuarios Invitados
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_usuario_invitado (
        p_id             IN NUMBER,
        p_nombre         IN Usuarios.nombre%TYPE,
        p_balance        IN Usuarios.balance%TYPE DEFAULT 0,
        p_numeroDeVisitas IN UsuariosInvitados.numeroDeVisitas%TYPE DEFAULT 1
    )
    AS
    BEGIN
        -- 1. Insertar en la tabla padre (Usuarios)
        INSERT INTO Usuarios (id, nombre, balance)
        VALUES (p_id, p_nombre, p_balance);

        -- 2. Insertar en la tabla hija (UsuariosInvitados)
        INSERT INTO UsuariosInvitados (id, numeroDeVisitas)
        VALUES (p_id, p_numeroDeVisitas);
        
        -- COMMIT ELIMINADO
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20110, 'ID ' || p_id || ' ya existe o ya fue asignado a otro usuario.');
        WHEN OTHERS THEN
            -- ROLLBACK ELIMINADO
            RAISE;
    END crear_usuario_invitado;
    
    -- Update (Registrar visita)
    PROCEDURE registrar_visita_invitado (
        p_id             IN NUMBER
    )
    AS
    BEGIN
        UPDATE UsuariosInvitados
        SET numeroDeVisitas = numeroDeVisitas + 1
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20111, 'No se pudo registrar la visita. Usuario Invitado con ID ' || p_id || ' no existe.');
        END IF;

        -- COMMIT ELIMINADO (El trigger de promoción se activará sin problemas)
    END registrar_visita_invitado;

    -- Read (Leer)
    PROCEDURE consultar_usuario_invitado (
        p_id             IN NUMBER,
        p_nombre         OUT Usuarios.nombre%TYPE,
        p_balance        OUT Usuarios.balance%TYPE,
        p_numeroDeVisitas OUT UsuariosInvitados.numeroDeVisitas%TYPE
    )
    AS
    BEGIN
        SELECT u.nombre, u.balance, i.numeroDeVisitas
        INTO p_nombre, p_balance, p_numeroDeVisitas
        FROM Usuarios u
        JOIN UsuariosInvitados i ON u.id = i.id
        WHERE u.id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20112, 'Usuario Invitado con ID ' || p_id || ' no encontrado.');
    END consultar_usuario_invitado;

    ----------------------------------------------------------------------------
    -- 3. Gestión de Usuarios Frecuentes
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_usuario_frecuente (
        p_id             IN NUMBER,
        p_nombre         IN Usuarios.nombre%TYPE,
        p_balance        IN Usuarios.balance%TYPE DEFAULT 0,
        p_correo         IN UsuariosFrecuentes.correo%TYPE DEFAULT NULL,
        p_celular        IN UsuariosFrecuentes.celular%TYPE DEFAULT NULL,
        p_puntos         IN UsuariosFrecuentes.puntos%TYPE DEFAULT 0
    )
    AS
    BEGIN
        -- 1. Insertar en la tabla padre (Usuarios)
        INSERT INTO Usuarios (id, nombre, balance)
        VALUES (p_id, p_nombre, p_balance);

        -- 2. Insertar en la tabla hija (UsuariosFrecuentes)
        INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos)
        VALUES (p_id, p_correo, p_celular, p_puntos);

        -- COMMIT ELIMINADO
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20120, 'ID ' || p_id || ' ya existe o ya fue asignado a otro usuario.');
        WHEN OTHERS THEN
            -- ROLLBACK ELIMINADO
            RAISE;
    END crear_usuario_frecuente;

    -- Read (Leer)
    PROCEDURE consultar_usuario_frecuente (
        p_id             IN NUMBER,
        p_nombre         OUT Usuarios.nombre%TYPE,
        p_balance        OUT Usuarios.balance%TYPE,
        p_correo         OUT UsuariosFrecuentes.correo%TYPE,
        p_celular        OUT UsuariosFrecuentes.celular%TYPE,
        p_puntos         OUT UsuariosFrecuentes.puntos%TYPE
    )
    AS
    BEGIN
        SELECT u.nombre, u.balance, f.correo, f.celular, f.puntos
        INTO p_nombre, p_balance, p_correo, p_celular, p_puntos
        FROM Usuarios u
        JOIN UsuariosFrecuentes f ON u.id = f.id
        WHERE u.id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20121, 'Usuario Frecuente con ID ' || p_id || ' no encontrado.');
    END consultar_usuario_frecuente;

    -- Update (Actualizar)
    PROCEDURE actualizar_usuario_frecuente (
        p_id             IN NUMBER,
        p_correo         IN UsuariosFrecuentes.correo%TYPE DEFAULT NULL,
        p_celular        IN UsuariosFrecuentes.celular%TYPE DEFAULT NULL,
        p_puntos         IN UsuariosFrecuentes.puntos%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        UPDATE UsuariosFrecuentes
        SET
            correo = NVL(p_correo, correo),
            celular = NVL(p_celular, celular),
            puntos = NVL(p_puntos, puntos)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20122, 'Actualización fallida para Usuario Frecuente ' || p_id || '. (El usuario no existe)');
        END IF;

        -- COMMIT ELIMINADO
    END actualizar_usuario_frecuente;

    ----------------------------------------------------------------------------
    -- 4. Gestión de Beneficios (Lookup Table)
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_beneficio (
        p_id             IN NUMBER,
        p_requisito      IN Beneficios.requisito%TYPE,
        p_descripcion    IN Beneficios.descripcion%TYPE
    )
    AS
    BEGIN
        INSERT INTO Beneficios (id, requisito, descripcion)
        VALUES (p_id, p_requisito, p_descripcion);

        -- COMMIT ELIMINADO
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20130, 'ID ' || p_id || ' ya existe en Beneficios.');
        WHEN OTHERS THEN
            -- ROLLBACK ELIMINADO
            RAISE;
    END crear_beneficio;

    -- Read (Leer)
    PROCEDURE consultar_beneficio (
        p_id             IN NUMBER,
        p_requisito      OUT Beneficios.requisito%TYPE,
        p_descripcion    OUT Beneficios.descripcion%TYPE
    )
    AS
    BEGIN
        SELECT requisito, descripcion
        INTO p_requisito, p_descripcion
        FROM Beneficios
        WHERE id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20131, 'Beneficio con ID ' || p_id || ' no encontrado.');
    END consultar_beneficio;

    -- Update (Actualizar)
    PROCEDURE actualizar_beneficio (
        p_id             IN NUMBER,
        p_requisito      IN Beneficios.requisito%TYPE DEFAULT NULL,
        p_descripcion    IN Beneficios.descripcion%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        IF NOT verificar_existencia_beneficio(p_id) THEN
            RAISE_APPLICATION_ERROR(-20132, 'No se puede actualizar. Beneficio con ID ' || p_id || ' no existe.');
        END IF;

        UPDATE Beneficios
        SET
            requisito = NVL(p_requisito, requisito),
            descripcion = NVL(p_descripcion, descripcion)
        WHERE id = p_id;

        -- COMMIT ELIMINADO
    END actualizar_beneficio;

    -- Delete (Eliminar)
    PROCEDURE eliminar_beneficio (
        p_id          IN NUMBER
    )
    AS
    BEGIN
        IF NOT verificar_existencia_beneficio(p_id) THEN
            RAISE_APPLICATION_ERROR(-20133, 'No se puede eliminar. Beneficio con ID ' || p_id || ' no existe.');
        END IF;

        DELETE FROM Beneficios
        WHERE id = p_id;

        -- COMMIT ELIMINADO
    END eliminar_beneficio;

    ----------------------------------------------------------------------------
    -- 5. Gestión de Asignación de Beneficios
    ----------------------------------------------------------------------------

    -- Create (Asignar)
    PROCEDURE asignar_beneficio_a_frecuente (
        p_beneficio_id   IN UsuariosFrecuentes_Beneficios.beneficio%TYPE,
        p_usuario_id     IN UsuariosFrecuentes_Beneficios.usuarioFrecuente%TYPE
    )
    AS
    BEGIN
        INSERT INTO UsuariosFrecuentes_Beneficios (beneficio, usuarioFrecuente)
        VALUES (p_beneficio_id, p_usuario_id);

        -- COMMIT ELIMINADO
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20140, 'El beneficio ' || p_beneficio_id || ' ya está asignado al usuario ' || p_usuario_id || '.');
        WHEN OTHERS THEN
            -- ROLLBACK ELIMINADO
            RAISE_APPLICATION_ERROR(-20141, 'Error al asignar beneficio. Verifique que el Usuario sea Frecuente y que el Beneficio exista. Detalle: ' || SQLERRM);
    END asignar_beneficio_a_frecuente;

    -- Delete (Desasignar)
    PROCEDURE desasignar_beneficio_a_frecuente (
        p_beneficio_id   IN UsuariosFrecuentes_Beneficios.beneficio%TYPE,
        p_usuario_id     IN UsuariosFrecuentes_Beneficios.usuarioFrecuente%TYPE
    )
    AS
    BEGIN
        DELETE FROM UsuariosFrecuentes_Beneficios
        WHERE beneficio = p_beneficio_id
        AND usuarioFrecuente = p_usuario_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20142, 'La asignación del Beneficio ' || p_beneficio_id || ' al Usuario ' || p_usuario_id || ' no existe.');
        END IF;

        -- COMMIT ELIMINADO
    END desasignar_beneficio_a_frecuente;

END PCK_USUARIOS;
/


--------------------------------------------------------------------------------
-- CUERPO DEL PAQUETE: PCK_CASINO (CRUDI) 
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE BODY PCK_CASINO AS

    -- Funciones auxiliares
    FUNCTION verificar_existencia_juego (p_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Juegos WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia_juego;
    
    FUNCTION verificar_existencia_mesa (p_id IN NUMBER) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM Mesas WHERE id = p_id;
        RETURN v_count > 0;
    END verificar_existencia_mesa;

    ----------------------------------------------------------------------------
    -- 1. Gestión de Juegos
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_juego (
        p_id             IN NUMBER,
        p_nombre         IN Juegos.nombre%TYPE,
        p_maxJugadores   IN Juegos.maxJugadores%TYPE,
        p_minApuesta     IN Juegos.minApuesta%TYPE,
        p_maxApuesta     IN Juegos.maxApuesta%TYPE
    )
    AS
    BEGIN
        INSERT INTO Juegos (id, nombre, maxJugadores, minApuesta, maxApuesta)
        VALUES (p_id, p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20200, 'ID de Juego ' || p_id || ' ya existe.');
        WHEN OTHERS THEN
            RAISE;
    END crear_juego;

    -- Read (Leer)
    PROCEDURE consultar_juego (
        p_id             IN NUMBER,
        p_nombre         OUT Juegos.nombre%TYPE,
        p_maxJugadores   OUT Juegos.maxJugadores%TYPE,
        p_minApuesta     OUT Juegos.minApuesta%TYPE,
        p_maxApuesta     OUT Juegos.maxApuesta%TYPE
    )
    AS
    BEGIN
        SELECT nombre, maxJugadores, minApuesta, maxApuesta
        INTO p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta
        FROM Juegos
        WHERE id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20201, 'Juego con ID ' || p_id || ' no encontrado.');
    END consultar_juego;

    -- Update (Actualizar)
    PROCEDURE actualizar_juego (
        p_id             IN NUMBER,
        p_nombre         IN Juegos.nombre%TYPE DEFAULT NULL,
        p_maxJugadores   IN Juegos.maxJugadores%TYPE DEFAULT NULL,
        p_minApuesta     IN Juegos.minApuesta%TYPE DEFAULT NULL,
        p_maxApuesta     IN Juegos.maxApuesta%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        UPDATE Juegos
        SET
            nombre = NVL(p_nombre, nombre),
            maxJugadores = NVL(p_maxJugadores, maxJugadores),
            minApuesta = NVL(p_minApuesta, minApuesta),
            maxApuesta = NVL(p_maxApuesta, maxApuesta)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20202, 'Actualización fallida para Juego ' || p_id || '. (El juego no existe)');
        END IF;
    END actualizar_juego;

    -- Delete (Eliminar)
    PROCEDURE eliminar_juego (
        p_id             IN NUMBER
    )
    AS
    BEGIN
        DELETE FROM Juegos
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20203, 'Eliminación fallida para Juego ' || p_id || '. (El juego no existe)');
        END IF;
    END eliminar_juego;

    ----------------------------------------------------------------------------
    -- 2. Gestión de Mesas
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_mesa (
        p_id             IN NUMBER,
        p_juego_id       IN Mesas.juego%TYPE,
        p_dealer_id      IN Mesas.dealer%TYPE,
        p_estado         IN Mesas.estado%TYPE DEFAULT 'Abierta'
    )
    AS
    BEGIN
        INSERT INTO Mesas (id, juego, dealer, estado)
        VALUES (p_id, p_juego_id, p_dealer_id, p_estado);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20210, 'ID de Mesa ' || p_id || ' ya existe.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20211, 'Error al crear la mesa. Verifique ID de Juego, ID de Dealer y el Estado. Detalle: ' || SQLERRM);
    END crear_mesa;

    -- Read (Leer)
    PROCEDURE consultar_mesa (
        p_id             IN NUMBER,
        p_juego_id       OUT Mesas.juego%TYPE,
        p_dealer_id      OUT Mesas.dealer%TYPE,
        p_estado         OUT Mesas.estado%TYPE
    )
    AS
    BEGIN
        SELECT juego, dealer, estado
        INTO p_juego_id, p_dealer_id, p_estado
        FROM Mesas
        WHERE id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20212, 'Mesa con ID ' || p_id || ' no encontrado.');
    END consultar_mesa;

    -- Update (Actualizar) - Cambiar Juego o Dealer
    PROCEDURE actualizar_mesa (
        p_id             IN NUMBER,
        p_juego_id       IN Mesas.juego%TYPE DEFAULT NULL,
        p_dealer_id      IN Mesas.dealer%TYPE DEFAULT NULL
    )
    AS
    BEGIN
        UPDATE Mesas
        SET
            juego = NVL(p_juego_id, juego),
            dealer = NVL(p_dealer_id, dealer)
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20213, 'Actualización fallida para Mesa ' || p_id || '. (La mesa no existe)');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20214, 'Error al actualizar la mesa. Verifique ID de Juego y ID de Dealer. Detalle: ' || SQLERRM);
    END actualizar_mesa;

    -- Update (Actualizar Estado)
    PROCEDURE actualizar_estado_mesa (
        p_id             IN NUMBER,
        p_estado         IN Mesas.estado%TYPE
    )
    AS
    BEGIN
        UPDATE Mesas
        SET estado = p_estado
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20215, 'Actualización de estado fallida para Mesa ' || p_id || '. (La mesa no existe)');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20216, 'Error al actualizar el estado de la mesa. Verifique que el estado sea válido (Abierta, Cerrada, En mantenimiento). Detalle: ' || SQLERRM);
    END actualizar_estado_mesa;

    -- Delete (Eliminar)
    PROCEDURE eliminar_mesa (
        p_id             IN NUMBER
    )
    AS
    BEGIN
        DELETE FROM Mesas
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20217, 'Eliminación fallida para Mesa ' || p_id || '. (La mesa no existe)');
        END IF;
    END eliminar_mesa;
    
    ----------------------------------------------------------------------------
    -- 3. Gestión de CambioFichas
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE registrar_cambio_fichas (
        p_id             IN NUMBER,
        p_monto          IN CambioFichas.monto%TYPE,
        p_usuario_id     IN CambioFichas.usuario%TYPE,
        p_cajero_id      IN CambioFichas.cajero%TYPE,
        p_cajaRecibe     IN CambioFichas.cajaRecibe%TYPE
    )
    AS
    BEGIN
        INSERT INTO CambioFichas (id, monto, fechaHora, usuario, cajero, cajaRecibe)
        VALUES (p_id, p_monto, SYSDATE, p_usuario_id, p_cajero_id, p_cajaRecibe);

        -- El trigger trg_actualizar_balance_fichas actualizará el balance del usuario automáticamente.
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20220, 'ID de CambioFichas ' || p_id || ' ya existe.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20221, 'Error al registrar el cambio de fichas. Verifique ID de Usuario, ID de Cajero y cajaRecibe. Detalle: ' || SQLERRM);
    END registrar_cambio_fichas;

    -- Read (Leer)
    PROCEDURE consultar_cambio_fichas (
        p_id             IN NUMBER,
        p_monto          OUT CambioFichas.monto%TYPE,
        p_fechaHora      OUT CambioFichas.fechaHora%TYPE,
        p_usuario_id     OUT CambioFichas.usuario%TYPE,
        p_cajero_id      OUT CambioFichas.cajero%TYPE,
        p_cajaRecibe     OUT CambioFichas.cajaRecibe%TYPE
    )
    AS
    BEGIN
        SELECT monto, fechaHora, usuario, cajero, cajaRecibe
        INTO p_monto, p_fechaHora, p_usuario_id, p_cajero_id, p_cajaRecibe
        FROM CambioFichas
        WHERE id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20222, 'Registro de CambioFichas con ID ' || p_id || ' no encontrado.');
    END consultar_cambio_fichas;

    -- Delete (Eliminar)
    PROCEDURE eliminar_cambio_fichas (
        p_id             IN NUMBER
    )
    AS
    BEGIN
        DELETE FROM CambioFichas
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20223, 'Eliminación fallida para CambioFichas ' || p_id || '. (El registro no existe)');
        END IF;
    END eliminar_cambio_fichas;
    
    ----------------------------------------------------------------------------
    -- 4. Gestión de Apuestas
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE registrar_apuesta (
        p_id             IN NUMBER,
        p_monto          IN Apuestas.monto%TYPE,
        p_usuario_id     IN Apuestas.usuario%TYPE,
        p_mesa_id        IN Apuestas.mesa%TYPE
    )
    AS
    BEGIN
        INSERT INTO Apuestas (id, monto, fechaHora, estado, usuario, mesa)
        VALUES (p_id, p_monto, SYSDATE, 'En proceso', p_usuario_id, p_mesa_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            RAISE_APPLICATION_ERROR(-20230, 'ID de Apuesta ' || p_id || ' ya existe.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20231, 'Error al registrar la apuesta. Verifique ID de Usuario, ID de Mesa y Monto. Detalle: ' || SQLERRM);
    END registrar_apuesta;

    -- Read (Leer)
    PROCEDURE consultar_apuesta (
        p_id             IN NUMBER,
        p_monto          OUT Apuestas.monto%TYPE,
        p_fechaHora      OUT Apuestas.fechaHora%TYPE,
        p_estado         OUT Apuestas.estado%TYPE,
        p_usuario_id     OUT Apuestas.usuario%TYPE,
        p_mesa_id        OUT Apuestas.mesa%TYPE
    )
    AS
    BEGIN
        SELECT monto, fechaHora, estado, usuario, mesa
        INTO p_monto, p_fechaHora, p_estado, p_usuario_id, p_mesa_id
        FROM Apuestas
        WHERE id = p_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20232, 'Apuesta con ID ' || p_id || ' no encontrada.');
    END consultar_apuesta;

    -- Update (Finalizar)
    PROCEDURE finalizar_apuesta (
        p_id             IN NUMBER,
        p_nuevo_estado   IN Apuestas.estado%TYPE
    )
    AS
    BEGIN
        UPDATE Apuestas
        SET estado = p_nuevo_estado
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20233, 'Finalización de apuesta fallida para ID ' || p_id || '. (La apuesta no existe)');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20234, 'Error al finalizar la apuesta. Recuerde: solo puede pasar de "En proceso" a "Ganada" o "Perdida". Detalle: ' || SQLERRM);
    END finalizar_apuesta;

    -- Delete (Eliminar)
    PROCEDURE eliminar_apuesta (
        p_id             IN NUMBER
    )
    AS
    BEGIN
        DELETE FROM Apuestas
        WHERE id = p_id;

        IF SQL%ROWCOUNT = 0 THEN
             RAISE_APPLICATION_ERROR(-20235, 'Eliminación fallida para Apuesta ' || p_id || '. (La apuesta no existe)');
        END IF;
    END eliminar_apuesta;

END PCK_CASINO;
/
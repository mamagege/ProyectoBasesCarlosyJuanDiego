-- CRUDE.sql: Especificación de Paquetes (Componentes Funcionales)

-- Definición de Excepciones Comunes
CREATE OR REPLACE PACKAGE PCK_EXCEPCIONES AS
    e_id_existe         EXCEPTION;  -- ORA-20101: El ID ya existe
    PRAGMA EXCEPTION_INIT(e_id_existe, -20101);

    e_no_existe         EXCEPTION;  -- ORA-20102: El registro no existe
    PRAGMA EXCEPTION_INIT(e_no_existe, -20102);

    e_fk_violada        EXCEPTION;  -- ORA-20103: Violación de llave foránea (entidad dependiente no existe)
    PRAGMA EXCEPTION_INIT(e_fk_violada, -20103);
END PCK_EXCEPCIONES;
/

-- ----------------------------------------------------------
-- 1. PCK_APUESTAS: Registrar y Mantener Apuestas
-- ----------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_APUESTAS AS
    -- Registrar una nueva apuesta (CREATE)
    PROCEDURE registrar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_monto         IN Apuestas.monto%TYPE,
        p_usuario_id    IN Apuestas.usuario%TYPE,
        p_mesa_id       IN Apuestas.mesa%TYPE
    );

    -- Consultar el historial de apuestas de un usuario (READ)
    FUNCTION consultar_historial_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR;

    -- Cambiar el estado a 'Ganada' o 'Perdida' (UPDATE/MANTENER)
    PROCEDURE finalizar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_nuevo_estado  IN Apuestas.estado%TYPE
    );

    -- Eliminar una apuesta (DELETE)
    PROCEDURE eliminar_apuesta(p_id IN Apuestas.id%TYPE);
END PCK_APUESTAS;
/

-- ----------------------------------------------------------
-- 2. PCK_TRANSACCIONES: Registrar Transacciones de Fichas
-- ----------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_TRANSACCIONES AS
    -- Registrar una nueva transacción de fichas/dinero (CREATE)
    PROCEDURE registrar_cambio_fichas(
        p_id            IN CambioFichas.id%TYPE,
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajero_id     IN CambioFichas.cajero%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE
    );
    
    -- Consultar una transacción específica por ID (READ)
    PROCEDURE consultar_transaccion(p_id IN CambioFichas.id%TYPE);

    -- Consultar transacciones realizadas por un cajero en su turno (READ OPERACIONAL)
    FUNCTION consultar_transacciones_cajero(p_cajero_id IN Cajeros.id%TYPE, p_turno IN Empleados.turno%TYPE)
        RETURN SYS_REFCURSOR;
    
    -- Eliminar una transacción (DELETE)
    PROCEDURE eliminar_transaccion(p_id IN CambioFichas.id%TYPE);
END PCK_TRANSACCIONES;
/

-- ----------------------------------------------------------
-- 3. PCK_USUARIOS_FUNC: Registrar Visitas y Consultas de Saldo
-- ----------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_USUARIOS_FUNC AS
    -- Crear un usuario invitado (Requisito para registrar visita)
    PROCEDURE crear_usuario_invitado(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE
    );
    
    -- Registrar la visita de un usuario (Actualiza numeroDeVisitas)
    PROCEDURE registrar_visita(p_usuario_id IN Usuarios.id%TYPE);
    
    -- Consultar el saldo de un usuario (READ OPERACIONAL)
    FUNCTION consultar_saldo(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE;
END PCK_USUARIOS_FUNC;
/

-- ----------------------------------------------------------
-- 4. PCK_MANTENIMIENTO: Operaciones de Setup y Mantenimiento
-- (CRUDs Completos para entidades auxiliares)
-- ----------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_MANTENIMIENTO AS
    -- ===================================
    -- EMPLEADOS (Dealer y Cajero)
    -- ===================================
    PROCEDURE crear_dealer(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_especialidad  IN Dealers.especialidad%TYPE
    );

    PROCEDURE crear_cajero(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_nivelAcceso   IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla    IN Cajeros.ventanilla%TYPE
    );
    
    FUNCTION consultar_empleado(p_id IN Empleados.id%TYPE)
        RETURN SYS_REFCURSOR;
        
    PROCEDURE actualizar_empleado(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno         IN Empleados.turno%TYPE DEFAULT NULL
    );

    PROCEDURE eliminar_empleado(p_id IN Empleados.id%TYPE);
    
    -- ===================================
    -- JUEGOS
    -- ===================================
    PROCEDURE crear_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    );
    
    FUNCTION consultar_juego(p_id IN Juegos.id%TYPE) 
        RETURN SYS_REFCURSOR;

    PROCEDURE actualizar_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE DEFAULT NULL,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE DEFAULT NULL,
        p_minApuesta    IN Juegos.minApuesta%TYPE DEFAULT NULL,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE DEFAULT NULL
    );
    
    PROCEDURE eliminar_juego(p_id IN Juegos.id%TYPE);

    -- ===================================
    -- MESAS
    -- ===================================
    PROCEDURE crear_mesa(
        p_id            IN Mesas.id%TYPE,
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    );
    
    FUNCTION consultar_mesa(p_id IN Mesas.id%TYPE)
        RETURN SYS_REFCURSOR;

    PROCEDURE actualizar_mesa_estado(p_id IN Mesas.id%TYPE, p_nuevo_estado IN Mesas.estado%TYPE);
    
    PROCEDURE eliminar_mesa(p_id IN Mesas.id%TYPE);

    -- ===================================
    -- USUARIOS FRECUENTES y BENEFICIOS
    -- ===================================
    PROCEDURE crear_usuario_frecuente(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE,
        p_correo        IN UsuariosFrecuentes.correo%TYPE,
        p_celular       IN UsuariosFrecuentes.celular%TYPE
    );
    
    PROCEDURE actualizar_usuario_frecuente(
        p_id            IN Usuarios.id%TYPE,
        p_correo        IN UsuariosFrecuentes.correo%TYPE DEFAULT NULL,
        p_celular       IN UsuariosFrecuentes.celular%TYPE DEFAULT NULL
    );

    PROCEDURE crear_beneficio(
        p_id            IN Beneficios.id%TYPE,
        p_requisito     IN Beneficios.requisito%TYPE,
        p_descripcion   IN Beneficios.descripcion%TYPE
    );
    
    PROCEDURE asignar_beneficio_a_frecuente(
        p_beneficio_id  IN Beneficios.id%TYPE,
        p_usuario_id    IN UsuariosFrecuentes.id%TYPE
    );

    -- ===================================
    -- ELIMINACIÓN GENÉRICA
    -- ===================================
    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE);

END PCK_MANTENIMIENTO;
/
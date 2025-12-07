-- CRUDE.sql: Especificación de Paquetes CRUD

-- ==========================================================
-- 1. PCK_EXCEPCIONES: Definición de Excepciones Personalizadas
-- (No requiere cambios)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_EXCEPCIONES AS
    -- ORA-20101: El ID ya existe (para UPDATEs/DELETEs con registros no existentes)
    e_id_existe EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_id_existe, -20101);
    
    -- ORA-20102: El registro no existe (para READs)
    e_no_existe EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_no_existe, -20102);
    
    -- ORA-20103: Violación de Llave Foránea
    e_fk_violada EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_fk_violada, -20103);
    
    -- ORA-20108: Violación de restricción UNIQUE (ej. nombre de juego duplicado)
    e_nombre_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_nombre_duplicado, -20108);

    -- ORA-20110: Violación de restricción de integridad (Registros dependientes al eliminar)
    e_registro_dependiente EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_registro_dependiente, -20110);
    
    -- ORA-20105: Usuario no es invitado (para funciones específicas de invitados)
    e_usuario_no_invitado EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_usuario_no_invitado, -20105);
    
END PCK_EXCEPCIONES;
/


-- ==========================================================
-- 2. PCK_MANTENIMIENTO: CRUD para Tablas Maestras
-- (Se elimina p_id de todos los procedimientos CREATE)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_MANTENIMIENTO AS

    -- -------------------------
    -- 2.1 EMPLEADOS (CREATE)
    -- -------------------------
    PROCEDURE crear_dealer(
        -- p_id se elimina. El ID se generará automáticamente.
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_especialidad  IN Dealers.especialidad%TYPE
    );
    
    PROCEDURE crear_cajero(
        -- p_id se elimina. El ID se generará automáticamente.
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_nivelAcceso   IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla    IN Cajeros.ventanilla%TYPE
    );

    -- -------------------------
    -- 2.2 EMPLEADOS (READ, UPDATE, DELETE)
    -- -------------------------
    FUNCTION consultar_empleado(p_id IN Empleados.id%TYPE)
        RETURN SYS_REFCURSOR;
        
    PROCEDURE actualizar_empleado(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno         IN Empleados.turno%TYPE DEFAULT NULL
    );

    PROCEDURE eliminar_empleado(p_id IN Empleados.id%TYPE);
    
    -- -------------------------
    -- 2.3 JUEGOS (CREATE)
    -- -------------------------
    PROCEDURE crear_juego(
        -- p_id se elimina. El ID se generará automáticamente.
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    );
    
    -- -------------------------
    -- 2.4 JUEGOS (READ, UPDATE, DELETE)
    -- -------------------------
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

    -- -------------------------
    -- 2.5 MESAS (CREATE)
    -- -------------------------
    PROCEDURE crear_mesa(
        -- p_id se elimina. El ID se generará automáticamente.
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    );

    -- -------------------------
    -- 2.6 MESAS (READ, UPDATE, DELETE)
    -- -------------------------
    FUNCTION consultar_mesa(p_id IN Mesas.id%TYPE)
        RETURN SYS_REFCURSOR;

    PROCEDURE actualizar_mesa_estado(
        p_id            IN Mesas.id%TYPE,
        p_nuevo_estado  IN Mesas.estado%TYPE
    );

    PROCEDURE eliminar_mesa(p_id IN Mesas.id%TYPE);

    -- -------------------------
    -- 2.7 USUARIOS (CREATE)
    -- -------------------------
    PROCEDURE crear_usuario_frecuente(
        -- p_id se elimina. El ID se generará automáticamente.
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE,
        p_correo        IN UsuariosFrecuentes.correo%TYPE,
        p_celular       IN UsuariosFrecuentes.celular%TYPE
    );

    PROCEDURE crear_usuario_invitado(
        -- p_id se elimina. El ID se generará automáticamente.
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE
    );

    -- -------------------------
    -- 2.8 USUARIOS (DELETE)
    -- -------------------------
    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE);

    -- -------------------------
    -- 2.9 BENEFICIOS (CREATE, MANTENIMIENTO)
    -- -------------------------
    PROCEDURE crear_beneficio(
        -- p_id se elimina. El ID se generará automáticamente.
        p_requisito     IN Beneficios.requisito%TYPE,
        p_descripcion   IN Beneficios.descripcion%TYPE
    );

    PROCEDURE asignar_beneficio_a_frecuente(
        p_beneficio_id  IN Beneficios.id%TYPE,
        p_usuario_id    IN UsuariosFrecuentes.id%TYPE
    );

END PCK_MANTENIMIENTO;
/


-- ==========================================================
-- 3. PCK_APUESTAS: CRUD y Flujo de Apuestas
-- (Se elimina p_id de registrar_apuesta)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_APUESTAS AS

    -- -------------------------
    -- 3.1 APUESTAS (CREATE)
    -- -------------------------
    PROCEDURE registrar_apuesta(
        -- p_id se elimina. El ID se generará automáticamente.
        p_monto         IN Apuestas.monto%TYPE,
        p_usuario_id    IN Apuestas.usuario%TYPE,
        p_mesa_id       IN Apuestas.mesa%TYPE
    );

    -- -------------------------
    -- 3.2 APUESTAS (UPDATE, READ)
    -- -------------------------
    PROCEDURE finalizar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_nuevo_estado  IN Apuestas.estado%TYPE
    );

    FUNCTION consultar_historial_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR;
        
END PCK_APUESTAS;
/


-- ==========================================================
-- 4. PCK_TRANSACCIONES: CRUD y Flujo de Transacciones
-- (Se elimina p_id de registrar_cambio_fichas)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_TRANSACCIONES AS

    -- -------------------------
    -- 4.1 CAMBIO FICHAS (CREATE)
    -- -------------------------
    PROCEDURE registrar_cambio_fichas(
        -- p_id se elimina. El ID se generará automáticamente.
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajero_id     IN Cajeros.id%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE -- 'Dinero' o 'Fichas'
    );

    -- -------------------------
    -- 4.2 CAMBIO FICHAS (READ, DELETE)
    -- -------------------------
    FUNCTION consultar_transacciones_cajero(
        p_cajero_id     IN Cajeros.id%TYPE,
        p_turno         IN Empleados.turno%TYPE
    )
        RETURN SYS_REFCURSOR;

    PROCEDURE eliminar_transaccion(p_id IN CambioFichas.id%TYPE);

END PCK_TRANSACCIONES;
/


-- ==========================================================
-- 5. PCK_USUARIOS_FUNC: Funciones de Usuario (READ/Logic)
-- (No requiere cambios en la interfaz)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_USUARIOS_FUNC AS

    PROCEDURE registrar_visita(p_usuario_id IN Usuarios.id%TYPE);

    FUNCTION consultar_saldo(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE;
        
END PCK_USUARIOS_FUNC;
/
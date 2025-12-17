-- ActoresI.sql: Implementación del Cuerpo de los Paquetes de Actores


-- ==========================================================
-- 1. PCK_ADM_SISTEMA: Administrador (Implementación)
-- Llama directamente a PCK_MANTENIMIENTO
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_ADM_SISTEMA AS

    -- Empleados
    PROCEDURE crear_dealer(
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_especialidad  IN Dealers.especialidad%TYPE
    ) AS
    BEGIN
        PCK_REGISTRAR_EMPLEADOS.crear_dealer(p_nombre, p_turno, p_especialidad);
    END crear_dealer;

    PROCEDURE crear_cajero(
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_nivelAcceso   IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla    IN Cajeros.ventanilla%TYPE
    ) AS
    BEGIN
        PCK_REGISTRAR_EMPLEADOS.crear_cajero(p_nombre, p_turno, p_nivelAcceso, p_ventanilla);
    END crear_cajero;

    FUNCTION consultar_empleado(p_id IN Empleados.id%TYPE)
        RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := PCK_MANTENER_EMPLEADOS.consultar_empleado(p_id);
        RETURN v_cursor;
    END consultar_empleado;


    FUNCTION consultar_usuario(p_id IN Usuarios.id%TYPE)
    RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := PCK_MANTENER_USUARIOS.consultar_usuario(p_id);
        RETURN v_cursor;
    END consultar_usuario;

    PROCEDURE actualizar_empleado(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno         IN Empleados.turno%TYPE DEFAULT NULL
    ) AS
    BEGIN
        PCK_MANTENER_EMPLEADOS.actualizar_empleado(p_id, p_nombre, p_turno);
    END actualizar_empleado;

    PROCEDURE eliminar_empleado(p_id IN Empleados.id%TYPE) AS
    BEGIN
        PCK_MANTENER_EMPLEADOS.eliminar_empleado(p_id);
    END eliminar_empleado;

    -- Juegos
    PROCEDURE crear_juego(
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    ) AS
    BEGIN
        PCK_REGISTRAR_ESTABLECIMIENTO.crear_juego(p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta);
    END crear_juego;

    PROCEDURE actualizar_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE DEFAULT NULL,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE DEFAULT NULL,
        p_minApuesta    IN Juegos.minApuesta%TYPE DEFAULT NULL,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE DEFAULT NULL
    ) AS
    BEGIN
        PCK_MANTENER_ESTABLECIMIENTO.actualizar_juego(p_id, p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta);
    END actualizar_juego;

    PROCEDURE eliminar_juego(p_id IN Juegos.id%TYPE) AS
    BEGIN
        PCK_MANTENER_ESTABLECIMIENTO.eliminar_juego(p_id);
    END eliminar_juego;

    -- Mesas
    PROCEDURE crear_mesa(
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    ) AS
    BEGIN
        PCK_REGISTRAR_ESTABLECIMIENTO.crear_mesa(p_numeroMesa, p_estado, p_juego_id, p_dealer_id);
    END crear_mesa;

    PROCEDURE eliminar_mesa(p_id IN Mesas.id%TYPE) AS
    BEGIN
        PCK_MANTENER_ESTABLECIMIENTO.eliminar_mesa(p_id);
    END eliminar_mesa;

    -- Usuarios Frecuentes y Beneficios
    PROCEDURE actualizar_datos_usuario_frecuente(
        p_id IN UsuariosFrecuentes.id%TYPE,
        p_nombre_nuevo IN Usuarios.nombre%TYPE DEFAULT NULL,
        p_correo_nuevo IN UsuariosFrecuentes.correo%TYPE DEFAULT NULL,
        p_celular_nuevo IN UsuariosFrecuentes.celular%TYPE DEFAULT NULL
    ) AS
    BEGIN
        PCK_MANTENER_USUARIOS.actualizar_datos_usuario_frecuente(p_id, p_nombre_nuevo, p_correo_nuevo, p_celular_nuevo);
    END actualizar_datos_usuario_frecuente;

    PROCEDURE crear_beneficio(
        p_requisito     IN Beneficios.requisito%TYPE,
        p_descripcion   IN Beneficios.descripcion%TYPE
    ) AS
    BEGIN
        PCK_REGISTRAR_USUARIOS.crear_beneficio(p_requisito, p_descripcion);
    END crear_beneficio;


    PROCEDURE eliminar_beneficio(p_id IN Beneficios.id%TYPE) AS
    BEGIN
        PCK_MANTENER_USUARIOS.eliminar_beneficio(p_id);
    END eliminar_beneficio; 

    
    PROCEDURE asignar_beneficio_a_frecuente(
        p_beneficio_id  IN Beneficios.id%TYPE,
        p_usuario_id    IN UsuariosFrecuentes.id%TYPE
    ) AS
    BEGIN
        PCK_MANTENER_USUARIOS.asignar_beneficio_a_frecuente(p_beneficio_id, p_usuario_id);
    END asignar_beneficio_a_frecuente;

    -- Eliminación Genérica
    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE) AS
    BEGIN
        PCK_MANTENER_USUARIOS.eliminar_usuario(p_id);
    END eliminar_usuario;

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
        PCK.PCK_REGISTRAR_ESTABLECIMIENTO.crear_torneo(
            p_nombre,
            p_fecha_inicio,
            p_fecha_fin,
            p_estado,
            p_pozo_premios,
            p_juego,
            p_jugadores,
            p_valor_entrada
        );
    END crear_torneo;

     -- Actualizar la información de un torneo
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
        PCK.MANTENER_ESTABLECIMIENTO.actualizar_torneo(
            p_id,
            p_nombre,
            p_fecha_inicio,
            p_fecha_fin,
            p_estado,
            p_pozo_premios,
            p_juego,
            p_jugadores,
            p_valor_entrada
        );
    END actualizar_torneo;


    -- Consultar un torneo por su ID
    FUNCTION consultar_torneo(p_id IN Torneos.id%TYPE)
        RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := PCK_MANTENER_ESTABLECIMIENTO.consultar_torneo(p_id);
        RETURN v_cursor;
    END consultar_torneo;

    -- Consultar todos los torneos activos
    FUNCTION consultar_torneos_activos
        RETURN SYS_REFCURSOR 
    AS 
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := PCK_MANTENER_ESTABLECIMIENTO.consultar_torneos_activos();
        RETURN v_cursor;
    END consultar_torneos_activos;

    -- Procedimiento para cerrar un torneo (actualiza el estado y pozo de premios)
    PROCEDURE cerrar_torneo(
        p_torneo_id IN NUMBER -- ID del torneo
    ) AS
    BEGIN
        PCK_MANTENER_ESTABLECIMIENTO.cerrar_torneo(p_torneo_id);
    END cerrar_torneo;

    -- Eliminar un torneo
    PROCEDURE eliminar_torneo(p_id IN Torneos.id%TYPE) AS 
    BEGIN 
        PCK_MANTENER_ESTABLECIMIENTO.eliminar_torneo(p_id);
    END eliminar_torneo;

END PCK_ADM_SISTEMA;
/

-- ==========================================================
-- 2. PCK_CAJERO: Cajero (Implementación)
-- Llama a PCK_TRANSACCIONES, PCK_USUARIOS_FUNC y PCK_MANTENIMIENTO
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_CAJERO AS

    -- Crear nuevo usuario invitado
    PROCEDURE registrar_nuevo_invitado(
        p_nombre        IN Usuarios.nombre%TYPE
    ) AS
    BEGIN
        -- Se asume un balance inicial de 0
        PCK_MANTENER_USUARIOS.crear_usuario_invitado(p_nombre, 0);
    END registrar_nuevo_invitado;

    -- Registrar transacción de fichas (Compra/Venta)
    PROCEDURE registrar_cambio_fichas(
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajero_id     IN Cajeros.id%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE
    ) AS
    BEGIN
        PCK_REGISTRAR_TRANSACCIONES.registrar_cambio_fichas(p_monto, p_usuario_id, p_cajero_id, p_cajaRecibe);
    END registrar_cambio_fichas;

    -- Consultar transacciones de su turno
    FUNCTION consultar_transacciones_turno(
        p_cajero_id IN Cajeros.id%TYPE,
        p_turno     IN Empleados.turno%TYPE
    )
        RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := PCK_MANTENER_TRANSACCIONES.consultar_transacciones_cajero(p_cajero_id, p_turno);
        RETURN v_cursor;
    END consultar_transacciones_turno;

    -- Consultar saldo de un usuario
    FUNCTION consultar_saldo_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE
    AS
        v_balance Usuarios.balance%TYPE;
    BEGIN
        v_balance := PCK_MANTENER_USUARIOS.consultar_saldo(p_usuario_id);
        RETURN v_balance;
    END consultar_saldo_usuario;

    -- Registrar la visita de un usuario invitado
    PROCEDURE registrar_visita_usuario(p_usuario_id IN Usuarios.id%TYPE) AS
    BEGIN
        PCK_MANTENER_USUARIOS.registrar_visita(p_usuario_id);
    END registrar_visita_usuario;


    -- Procedimiento para registrar un nuevo jugador en un torneo
    PROCEDURE registrar_participante(
        p_torneo_id      IN NUMBER,     -- ID del torneo
        p_usuario_id     IN NUMBER,     -- ID del usuario
        p_estado         IN VARCHAR2    -- Estado (Inscrito, Eliminado)
    ) AS 
    BEGIN
        PCK_MANTENER_USUARIOS.registrar_participante(p_torneo_id, p_usuario_id, p_estado);
    END registrar_participante;

    -- Procedimiento para actualizar la participación de un jugador
    PROCEDURE actualizar_participante(
        p_participante_id IN NUMBER,    -- ID del participante
        p_estado          IN VARCHAR2   -- Nuevo estado (Inscrito, Eliminado, etc.)
    ) AS 
    BEGIN
        PCK_MANTENER_USUARIOS.actualizar_participante(p_participante_id, p_estado);
    END actualizar_participante;

    -- Procedimiento para actualizar los ganadores de un torneo
    PROCEDURE actualizar_ganadores(
        p_torneo_id       IN NUMBER,   -- ID del torneo
        p_participante_id IN NUMBER,   -- ID del ganador
        p_premio          IN VARCHAR2, -- Descripción del premio
        p_monto           IN NUMBER    -- Monto del premio
    ) AS 
    BEGIN
        PCK_MANTENER_USUARIOS.actualizar_ganadores(p_torneo_id, p_participante_id, p_premio, p_monto);
    END actualizar_ganadores
    
    ;
END PCK_CAJERO;
/

-- ==========================================================
-- 3. PCK_DEALER: Dealer (Implementación)
-- Llama a PCK_APUESTAS y PCK_MANTENIMIENTO
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_DEALER AS

    -- Registrar una nueva apuesta
    PROCEDURE registrar_apuesta(
        p_monto         IN Apuestas.monto%TYPE,
        p_usuario_id    IN Apuestas.usuario%TYPE,
        p_mesa_id       IN Apuestas.mesa%TYPE

    ) AS
    BEGIN
        PCK_REGISTRAR_APUESTAS.registrar_apuesta(p_monto, p_usuario_id, p_mesa_id);
    END registrar_apuesta;

    -- Finalizar la apuesta (Ganada/Perdida)
    PROCEDURE finalizar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_nuevo_estado  IN Apuestas.estado%TYPE
    ) AS
    BEGIN
        PCK_MANTENER_APUESTAS.finalizar_apuesta(p_id, p_nuevo_estado);
    END finalizar_apuesta;

    -- Marcar la mesa como Abierta/Cerrada/Mantenimiento
    PROCEDURE actualizar_estado_mesa(
        p_id            IN Mesas.id%TYPE, 
        p_nuevo_estado  IN Mesas.estado%TYPE
    ) AS
    BEGIN
        PCK_MANTENER_ESTABLECIMIENTO.actualizar_mesa_estado(p_id, p_nuevo_estado);
    END actualizar_estado_mesa;

END PCK_DEALER;
/

-- ==========================================================
-- 4. PCK_USUARIO: Usuario (Implementación)
-- Llama a PCK_USUARIOS_FUNC y PCK_APUESTAS
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_USUARIO AS

    -- Consultar saldo propio
    FUNCTION consultar_mi_saldo(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE
    AS
        v_balance Usuarios.balance%TYPE;
    BEGIN
        -- **Aquí se implementaría la validación de seguridad (ej: p_usuario_id debe ser el ID de la sesión)**
        v_balance := PCK_MANTENER_USUARIOS.consultar_saldo(p_usuario_id);
        RETURN v_balance;
    END consultar_mi_saldo;

    -- Consultar historial de apuestas propio
    FUNCTION consultar_mi_historial_apuestas(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        -- **Aquí se implementaría la validación de seguridad (ej: p_usuario_id debe ser el ID de la sesión)**
        v_cursor := PCK_MANTENER_USUARIOS.consultar_historial_usuario(p_usuario_id);
        RETURN v_cursor;
    END consultar_mi_historial_apuestas;

END PCK_USUARIO;
/

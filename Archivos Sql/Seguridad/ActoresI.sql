-- ActoresI.sql: Implementación del Cuerpo de los Paquetes de Actores

-- ==========================================================
-- 1. PCK_ADM_SISTEMA: Administrador (Implementación)
-- Llama directamente a PCK_MANTENIMIENTO
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_ADM_SISTEMA AS

    -- Empleados
    PROCEDURE crear_dealer(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_especialidad  IN Dealers.especialidad%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.crear_dealer(p_id, p_nombre, p_turno, p_especialidad);
    END crear_dealer;
    
    PROCEDURE crear_cajero(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_nivelAcceso   IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla    IN Cajeros.ventanilla%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.crear_cajero(p_id, p_nombre, p_turno, p_nivelAcceso, p_ventanilla);
    END crear_cajero;

    FUNCTION consultar_empleado(p_id IN Empleados.id%TYPE)
        RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := PCK_MANTENIMIENTO.consultar_empleado(p_id);
        RETURN v_cursor;
    END consultar_empleado;
        
    PROCEDURE actualizar_empleado(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno         IN Empleados.turno%TYPE DEFAULT NULL
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.actualizar_empleado(p_id, p_nombre, p_turno);
    END actualizar_empleado;

    PROCEDURE eliminar_empleado(p_id IN Empleados.id%TYPE) AS
    BEGIN
        PCK_MANTENIMIENTO.eliminar_empleado(p_id);
    END eliminar_empleado;

    -- Juegos
    PROCEDURE crear_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.crear_juego(p_id, p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta);
    END crear_juego;
    
    PROCEDURE actualizar_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE DEFAULT NULL,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE DEFAULT NULL,
        p_minApuesta    IN Juegos.minApuesta%TYPE DEFAULT NULL,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE DEFAULT NULL
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.actualizar_juego(p_id, p_nombre, p_maxJugadores, p_minApuesta, p_maxApuesta);
    END actualizar_juego;
    
    PROCEDURE eliminar_juego(p_id IN Juegos.id%TYPE) AS
    BEGIN
        PCK_MANTENIMIENTO.eliminar_juego(p_id);
    END eliminar_juego;

    -- Mesas
    PROCEDURE crear_mesa(
        p_id            IN Mesas.id%TYPE,
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.crear_mesa(p_id, p_numeroMesa, p_estado, p_juego_id, p_dealer_id);
    END crear_mesa;

    PROCEDURE eliminar_mesa(p_id IN Mesas.id%TYPE) AS
    BEGIN
        PCK_MANTENIMIENTO.eliminar_mesa(p_id);
    END eliminar_mesa;

    -- Usuarios Frecuentes y Beneficios
    PROCEDURE crear_usuario_frecuente(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE,
        p_correo        IN UsuariosFrecuentes.correo%TYPE,
        p_celular       IN UsuariosFrecuentes.celular%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.crear_usuario_frecuente(p_id, p_nombre, p_balance, p_correo, p_celular);
    END crear_usuario_frecuente;
    
    PROCEDURE crear_beneficio(
        p_id            IN Beneficios.id%TYPE,
        p_requisito     IN Beneficios.requisito%TYPE,
        p_descripcion   IN Beneficios.descripcion%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.crear_beneficio(p_id, p_requisito, p_descripcion);
    END crear_beneficio;
    
    PROCEDURE asignar_beneficio_a_frecuente(
        p_beneficio_id  IN Beneficios.id%TYPE,
        p_usuario_id    IN UsuariosFrecuentes.id%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.asignar_beneficio_a_frecuente(p_beneficio_id, p_usuario_id);
    END asignar_beneficio_a_frecuente;
    
    -- Eliminación Genérica
    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE) AS
    BEGIN
        PCK_MANTENIMIENTO.eliminar_usuario(p_id);
    END eliminar_usuario;

END PCK_ADM_SISTEMA;
/

-- ==========================================================
-- 2. PCK_CAJERO: Cajero (Implementación)
-- Llama a PCK_TRANSACCIONES y PCK_USUARIOS_FUNC
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_CAJERO AS

    -- Crear nuevo usuario invitado
    PROCEDURE registrar_nuevo_invitado(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE
    ) AS
    BEGIN
        -- Se asume un balance inicial de 0
        PCK_USUARIOS_FUNC.crear_usuario_invitado(p_id, p_nombre, 0);
    END registrar_nuevo_invitado;

    -- Registrar transacción de fichas (Compra/Venta)
    PROCEDURE registrar_cambio_fichas(
        p_id            IN CambioFichas.id%TYPE,
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE, 
        p_cajero_id     IN Cajeros.id%TYPE
    ) AS
    BEGIN
        PCK_TRANSACCIONES.registrar_cambio_fichas(p_id, p_monto, p_usuario_id, p_cajero_id, p_cajaRecibe);
    END registrar_cambio_fichas;
    
    -- Consultar transacciones de su turno
    FUNCTION consultar_transacciones_turno(p_cajero_id IN Cajeros.id%TYPE, p_turno IN Empleados.turno%TYPE)
        RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := PCK_TRANSACCIONES.consultar_transacciones_cajero(p_cajero_id, p_turno);
        RETURN v_cursor;
    END consultar_transacciones_turno;

    -- Consultar saldo de un usuario
    FUNCTION consultar_saldo_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE
    AS
        v_balance Usuarios.balance%TYPE;
    BEGIN
        v_balance := PCK_USUARIOS_FUNC.consultar_saldo(p_usuario_id);
        RETURN v_balance;
    END consultar_saldo_usuario;

    -- Registrar la visita de un usuario invitado
    PROCEDURE registrar_visita_usuario(p_usuario_id IN Usuarios.id%TYPE) AS
    BEGIN
        PCK_MANTENIMIENTO.registrar_visita(p_usuario_id);
    END registrar_visita_usuario;

END PCK_CAJERO;
/

-- ==========================================================
-- 3. PCK_DEALER: Dealer (Implementación)
-- Llama a PCK_APUESTAS y PCK_MANTENIMIENTO
-- ==========================================================
CREATE OR REPLACE PACKAGE BODY PCK_DEALER AS
    
    -- Registrar una nueva apuesta
    PROCEDURE registrar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_monto         IN Apuestas.monto%TYPE,
        p_usuario_id    IN Apuestas.usuario%TYPE,
        p_mesa_id       IN Apuestas.mesa%TYPE
    ) AS
    BEGIN
        PCK_APUESTAS.registrar_apuesta(p_id, p_monto, p_usuario_id, p_mesa_id);
    END registrar_apuesta;

    -- Finalizar la apuesta (Ganada/Perdida)
    PROCEDURE finalizar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_nuevo_estado  IN Apuestas.estado%TYPE
    ) AS
    BEGIN
        PCK_APUESTAS.finalizar_apuesta(p_id, p_nuevo_estado);
    END finalizar_apuesta;

    -- Marcar la mesa como Abierta/Cerrada/Mantenimiento
    PROCEDURE actualizar_estado_mesa(
        p_id            IN Mesas.id%TYPE, 
        p_nuevo_estado  IN Mesas.estado%TYPE
    ) AS
    BEGIN
        PCK_MANTENIMIENTO.actualizar_mesa_estado(p_id, p_nuevo_estado);
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
        v_balance := PCK_USUARIOS_FUNC.consultar_saldo(p_usuario_id);
        RETURN v_balance;
    END consultar_mi_saldo;
        
    -- Consultar historial de apuestas propio
    FUNCTION consultar_mi_historial_apuestas(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR
    AS
        v_cursor SYS_REFCURSOR;
    BEGIN
        -- **Aquí se implementaría la validación de seguridad (ej: p_usuario_id debe ser el ID de la sesión)**
        v_cursor := PCK_APUESTAS.consultar_historial_usuario(p_usuario_id);
        RETURN v_cursor;
    END consultar_mi_historial_apuestas;
        
END PCK_USUARIO;
/
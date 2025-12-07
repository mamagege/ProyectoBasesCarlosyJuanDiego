-- ActoresE.sql: Especificación de Paquetes de Actores (Roles de Seguridad)

-- ==========================================================
-- 1. PCK_ADM_SISTEMA: Administrador (Acceso Total a Mantenimiento)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_ADM_SISTEMA AS

    -- Empleados
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

    -- Juegos
    PROCEDURE crear_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE,
        p_minApuesta    IN Juegos.minApuesta%TYPE,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE
    );
    
    PROCEDURE actualizar_juego(
        p_id            IN Juegos.id%TYPE,
        p_nombre        IN Juegos.nombre%TYPE DEFAULT NULL,
        p_maxJugadores  IN Juegos.maxJugadores%TYPE DEFAULT NULL,
        p_minApuesta    IN Juegos.minApuesta%TYPE DEFAULT NULL,
        p_maxApuesta    IN Juegos.maxApuesta%TYPE DEFAULT NULL
    );
    
    PROCEDURE eliminar_juego(p_id IN Juegos.id%TYPE);

    -- Mesas
    PROCEDURE crear_mesa(
        p_id            IN Mesas.id%TYPE,
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    );

    PROCEDURE eliminar_mesa(p_id IN Mesas.id%TYPE);

    -- Usuarios Frecuentes y Beneficios
    PROCEDURE crear_usuario_frecuente(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE,
        p_balance       IN Usuarios.balance%TYPE,
        p_correo        IN UsuariosFrecuentes.correo%TYPE,
        p_celular       IN UsuariosFrecuentes.celular%TYPE
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
    
    -- Eliminación Genérica
    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE);
END PCK_ADM_SISTEMA;
/


-- ==========================================================
-- 2. PCK_CAJERO: Cajero (Transacciones, Registro de Invitados)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_CAJERO AS

    -- Crear nuevo usuario invitado
    PROCEDURE registrar_nuevo_invitado(
        p_id            IN Usuarios.id%TYPE,
        p_nombre        IN Usuarios.nombre%TYPE
    );

    -- Registrar transacción de fichas (Compra/Venta)
    PROCEDURE registrar_cambio_fichas(
        p_id            IN CambioFichas.id%TYPE,
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE, -- 'Dinero' o 'Fichas'
        p_cajero_id     IN Cajeros.id%TYPE -- Se requiere el ID del cajero que ejecuta
    );
    
    -- Consultar transacciones de su turno
    FUNCTION consultar_transacciones_turno(p_cajero_id IN Cajeros.id%TYPE, p_turno IN Empleados.turno%TYPE)
        RETURN SYS_REFCURSOR;

    -- Consultar saldo de un usuario
    FUNCTION consultar_saldo_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE;

END PCK_CAJERO;
/


-- ==========================================================
-- 3. PCK_DEALER: Dealer (Manejo de Mesas y Apuestas)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_DEALER AS
    
    -- Registrar una nueva apuesta
    PROCEDURE registrar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_monto         IN Apuestas.monto%TYPE,
        p_usuario_id    IN Apuestas.usuario%TYPE,
        p_mesa_id       IN Apuestas.mesa%TYPE
    );

    -- Finalizar la apuesta (Ganada/Perdida)
    PROCEDURE finalizar_apuesta(
        p_id            IN Apuestas.id%TYPE,
        p_nuevo_estado  IN Apuestas.estado%TYPE
    );

    -- Marcar la mesa como Abierta/Cerrada/Mantenimiento
    PROCEDURE actualizar_estado_mesa(
        p_id            IN Mesas.id%TYPE, 
        p_nuevo_estado  IN Mesas.estado%TYPE
    );

    -- Registrar la visita de un usuario invitado
    PROCEDURE registrar_visita_usuario(p_usuario_id IN Usuarios.id%TYPE);
    
END PCK_DEALER;
/


-- ==========================================================
-- 4. PCK_USUARIO: Usuario (Funcionalidad de Consulta)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_USUARIO AS
    
    -- Consultar saldo propio
    FUNCTION consultar_mi_saldo(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE;
        
    -- Consultar historial de apuestas propio
    FUNCTION consultar_mi_historial_apuestas(p_usuario_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR;
        
END PCK_USUARIO;
/
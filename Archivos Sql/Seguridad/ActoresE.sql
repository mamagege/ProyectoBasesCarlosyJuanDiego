-- ActoresE.sql: Especificación de Paquetes de Actores (Roles de Seguridad)

-- ==========================================================
-- 1. PCK_ADM_SISTEMA: Administrador (Acceso Total a Mantenimiento)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_ADM_SISTEMA AS

    -- Empleados
    PROCEDURE crear_dealer(
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_especialidad  IN Dealers.especialidad%TYPE
    );

    PROCEDURE crear_cajero(
        p_nombre        IN Empleados.nombre%TYPE,
        p_turno         IN Empleados.turno%TYPE,
        p_nivelAcceso   IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla    IN Cajeros.ventanilla%TYPE
    );

    FUNCTION consultar_empleado(p_id IN Empleados.id%TYPE)
        RETURN SYS_REFCURSOR;


    FUNCTION consultar_usuario(p_id IN Usuarios.id%TYPE)
        RETURN SYS_REFCURSOR;

    PROCEDURE actualizar_empleado(
        p_id            IN Empleados.id%TYPE,
        p_nombre        IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno         IN Empleados.turno%TYPE DEFAULT NULL
    );

    PROCEDURE eliminar_empleado(p_id IN Empleados.id%TYPE);

    -- Juegos
    PROCEDURE crear_juego(
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
        p_numeroMesa    IN Mesas.numeroMesa%TYPE,
        p_estado        IN Mesas.estado%TYPE,
        p_juego_id      IN Mesas.juego%TYPE,
        p_dealer_id     IN Mesas.dealer%TYPE
    );

    PROCEDURE eliminar_mesa(p_id IN Mesas.id%TYPE);

    PROCEDURE crear_beneficio(
        p_requisito     IN Beneficios.requisito%TYPE,
        p_descripcion   IN Beneficios.descripcion%TYPE
    );

    PROCEDURE asignar_beneficio_a_frecuente(
        p_beneficio_id  IN Beneficios.id%TYPE,
        p_usuario_id    IN UsuariosFrecuentes.id%TYPE
    );


    PROCEDURE eliminar_beneficio(p_id IN Beneficios.id%TYPE);

    --TORNEOS

    PROCEDURE crear_torneo(
        p_nombre        IN Torneos.nombre%TYPE,
        p_fecha_inicio  IN Torneos.fecha_inicio%TYPE,
        p_fecha_fin     IN Torneos.fecha_fin%TYPE,
        p_estado        IN Torneos.estado%TYPE,
        p_pozo_premios  IN Torneos.pozoDePremios%TYPE,
        p_juego         IN Torneos.juego%TYPE,
        p_jugadores     IN Torneos.jugadoresActuales%TYPE,
        p_valor_entrada IN Torneos.valorEntrada%TYPE
    );

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
    );

    -- Consultar un torneo por su ID
    FUNCTION consultar_torneo(p_id IN Torneos.id%TYPE)
        RETURN SYS_REFCURSOR;

    -- Consultar todos los torneos activos
    FUNCTION consultar_torneos_activos
        RETURN SYS_REFCURSOR;

    -- Procedimiento para cerrar un torneo (actualiza el estado y pozo de premios)
    PROCEDURE cerrar_torneo(
        p_torneo_id IN NUMBER -- ID del torneo
    );

    -- Eliminar un torneo
    PROCEDURE eliminar_torneo(p_id IN Torneos.id%TYPE);

END PCK_ADM_SISTEMA;

/

-- ==========================================================
-- 2. PCK_CAJERO: Cajero (Transacciones, Registro de Invitados)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_CAJERO AS

    -- Crear nuevo usuario invitado
    PROCEDURE registrar_nuevo_invitado(
        p_nombre        IN Usuarios.nombre%TYPE
    );

    -- Registrar la visita de un usuario invitado
    PROCEDURE registrar_visita_usuario(p_usuario_id IN Usuarios.id%TYPE);

    -- Registrar transacción de fichas (Compra/Venta)
    PROCEDURE registrar_cambio_fichas(
        p_monto         IN CambioFichas.monto%TYPE,
        p_usuario_id    IN CambioFichas.usuario%TYPE,
        p_cajero_id     IN Cajeros.id%TYPE,
        p_cajaRecibe    IN CambioFichas.cajaRecibe%TYPE -- 'Dinero' o 'Fichas'
    );

    -- Consultar transacciones de su turno
    FUNCTION consultar_transacciones_turno(
        p_cajero_id IN Cajeros.id%TYPE,
        p_turno     IN Empleados.turno%TYPE
    )
        RETURN SYS_REFCURSOR;

    -- Consultar saldo de un usuario
    FUNCTION consultar_saldo_usuario(p_usuario_id IN Usuarios.id%TYPE)
        RETURN Usuarios.balance%TYPE;


    -- Eliminación Genérica
    PROCEDURE eliminar_usuario(p_id IN Usuarios.id%TYPE);

    -- Usuarios Frecuentes y Beneficios
    PROCEDURE actualizar_datos_usuario_frecuente(
        p_id IN UsuariosFrecuentes.id%TYPE,
        p_nombre_nuevo IN Usuarios.nombre%TYPE DEFAULT NULL,
        p_correo_nuevo IN UsuariosFrecuentes.correo%TYPE DEFAULT NULL,
        p_celular_nuevo IN UsuariosFrecuentes.celular%TYPE DEFAULT NULL
    );

    -- Procedimiento para registrar un nuevo jugador en un torneo
    PROCEDURE registrar_participante(
        p_torneo_id      IN NUMBER,     -- ID del torneo
        p_usuario_id     IN NUMBER,     -- ID del usuario
        p_estado         IN VARCHAR2    -- Estado (Inscrito, Eliminado)
    );

    -- Procedimiento para actualizar la participación de un jugador
    PROCEDURE actualizar_participante(
        p_participante_id IN NUMBER,    -- ID del participante
        p_estado          IN VARCHAR2   -- Nuevo estado (Inscrito, Eliminado, etc.)
    );

    -- Procedimiento para actualizar los ganadores de un torneo
    PROCEDURE actualizar_ganadores(
        p_torneo_id       IN NUMBER,   -- ID del torneo
        p_participante_id IN NUMBER,   -- ID del ganador
        p_premio          IN VARCHAR2, -- Descripción del premio
        p_monto           IN NUMBER    -- Monto del premio
    );


END PCK_CAJERO;
/

-- ==========================================================
-- 3. PCK_DEALER: Dealer (Manejo de Mesas y Apuestas)
-- ==========================================================
CREATE OR REPLACE PACKAGE PCK_DEALER AS

    -- Registrar una nueva apuesta
    PROCEDURE registrar_apuesta(
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

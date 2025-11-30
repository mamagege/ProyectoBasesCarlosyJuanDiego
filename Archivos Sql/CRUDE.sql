--------------------------------------------------------------------------------
-- ESPECIFICACIÓN DEL PAQUETE: PCK_PERSONAL (CRUDE)
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_PERSONAL AS

    -- Procedimientos CRUD para Empleados Base (Padre)
    -- Los Empleados NO se crean directamente.
    -- Se usan para la funcionalidad de Leer (R), Actualizar (U) y Eliminar (D).

    -- Read (Leer)
    PROCEDURE consultar_empleado (
        p_id          IN  NUMBER,
        p_nombre      OUT Empleados.nombre%TYPE,
        p_turno       OUT Empleados.turno%TYPE
    );

    -- Update (Actualizar)
    PROCEDURE actualizar_empleado (
        p_id          IN NUMBER,
        p_nombre      IN Empleados.nombre%TYPE DEFAULT NULL,
        p_turno       IN Empleados.turno%TYPE DEFAULT NULL
    );

    -- Delete (Eliminar)
    -- Elimina el empleado base y, por FK ON DELETE CASCADE, sus registros en Cajeros/Dealers.
    PROCEDURE eliminar_empleado (
        p_id          IN NUMBER
    );
    
    ----------------------------------------------------------------------------
    -- Procedimientos CRUD para Cajeros (Crear, Leer, Actualizar, Eliminar)
    ----------------------------------------------------------------------------
    
    -- Create (Crear)
    PROCEDURE crear_cajero (
        p_id             IN NUMBER,
        p_nombre         IN Empleados.nombre%TYPE,
        p_turno          IN Empleados.turno%TYPE,
        p_nivelAcceso    IN Cajeros.nivelAcceso%TYPE,
        p_ventanilla     IN Cajeros.ventanilla%TYPE
    );
    
    -- Read (Leer)
    PROCEDURE consultar_cajero (
        p_id             IN NUMBER,
        p_nombre         OUT Empleados.nombre%TYPE,
        p_turno          OUT Empleados.turno%TYPE,
        p_nivelAcceso    OUT Cajeros.nivelAcceso%TYPE,
        p_ventanilla     OUT Cajeros.ventanilla%TYPE
    );
    
    -- Update (Actualizar)
    PROCEDURE actualizar_cajero (
        p_id             IN NUMBER,
        p_nivelAcceso    IN Cajeros.nivelAcceso%TYPE DEFAULT NULL,
        p_ventanilla     IN Cajeros.ventanilla%TYPE DEFAULT NULL
        -- Se omite nombre y turno aquí para usar el procedimiento general actualizar_empleado
    );
    
    ----------------------------------------------------------------------------
    -- Procedimientos CRUD para Dealers (Crear, Leer, Actualizar, Eliminar)
    ----------------------------------------------------------------------------
    
    -- Create (Crear)
    PROCEDURE crear_dealer (
        p_id             IN NUMBER,
        p_nombre         IN Empleados.nombre%TYPE,
        p_turno          IN Empleados.turno%TYPE,
        p_especialidad   IN Dealers.especialidad%TYPE
    );
    
    -- Read (Leer)
    PROCEDURE consultar_dealer (
        p_id             IN NUMBER,
        p_nombre         OUT Empleados.nombre%TYPE,
        p_turno          OUT Empleados.turno%TYPE,
        p_especialidad   OUT Dealers.especialidad%TYPE
    );
    
    -- Update (Actualizar)
    PROCEDURE actualizar_dealer (
        p_id             IN NUMBER,
        p_especialidad   IN Dealers.especialidad%TYPE DEFAULT NULL
        -- Se omite nombre y turno aquí para usar el procedimiento general actualizar_empleado
    );

END PCK_PERSONAL;
/



--------------------------------------------------------------------------------
-- ESPECIFICACIÓN DEL PAQUETE: PCK_USUARIOS (CRUDE)
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_USUARIOS AS

    ----------------------------------------------------------------------------
    -- 1. Gestión de Usuarios Base (Leer, Actualizar, Eliminar)
    ----------------------------------------------------------------------------

    -- Read (Leer)
    PROCEDURE consultar_usuario (
        p_id          IN  NUMBER,
        p_nombre      OUT Usuarios.nombre%TYPE,
        p_balance     OUT Usuarios.balance%TYPE
    );

    -- Update (Actualizar)
    PROCEDURE actualizar_usuario (
        p_id          IN NUMBER,
        p_nombre      IN Usuarios.nombre%TYPE DEFAULT NULL,
        p_balance     IN Usuarios.balance%TYPE DEFAULT NULL -- Para ajustes manuales o por sistema
    );

    -- Delete (Eliminar)
    -- Elimina el usuario base. Por FK ON DELETE CASCADE, también elimina sus registros en UsuariosFrecuentes/Invitados/Fichas/Apuestas.
    PROCEDURE eliminar_usuario (
        p_id          IN NUMBER
    );

    ----------------------------------------------------------------------------
    -- 2. Gestión de Usuarios Invitados
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_usuario_invitado (
        p_id             IN NUMBER,
        p_nombre         IN Usuarios.nombre%TYPE,
        p_balance        IN Usuarios.balance%TYPE DEFAULT 0, -- Balance inicial
        p_numeroDeVisitas IN UsuariosInvitados.numeroDeVisitas%TYPE DEFAULT 1 -- Asume la primera visita
    );

    -- Update (Actualizar) - Registrar visita (puede disparar promoción por trigger)
    PROCEDURE registrar_visita_invitado (
        p_id             IN NUMBER
    );

    -- Read (Leer)
    PROCEDURE consultar_usuario_invitado (
        p_id             IN NUMBER,
        p_nombre         OUT Usuarios.nombre%TYPE,
        p_balance        OUT Usuarios.balance%TYPE,
        p_numeroDeVisitas OUT UsuariosInvitados.numeroDeVisitas%TYPE
    );

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
    );

    -- Read (Leer)
    PROCEDURE consultar_usuario_frecuente (
        p_id             IN NUMBER,
        p_nombre         OUT Usuarios.nombre%TYPE,
        p_balance        OUT Usuarios.balance%TYPE,
        p_correo         OUT UsuariosFrecuentes.correo%TYPE,
        p_celular        OUT UsuariosFrecuentes.celular%TYPE,
        p_puntos         OUT UsuariosFrecuentes.puntos%TYPE
    );

    -- Update (Actualizar)
    PROCEDURE actualizar_usuario_frecuente (
        p_id             IN NUMBER,
        p_correo         IN UsuariosFrecuentes.correo%TYPE DEFAULT NULL,
        p_celular        IN UsuariosFrecuentes.celular%TYPE DEFAULT NULL,
        p_puntos         IN UsuariosFrecuentes.puntos%TYPE DEFAULT NULL
    );

    ----------------------------------------------------------------------------
    -- 4. Gestión de Beneficios (Lookup Table)
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_beneficio (
        p_id             IN NUMBER,
        p_requisito      IN Beneficios.requisito%TYPE,
        p_descripcion    IN Beneficios.descripcion%TYPE
    );

    -- Read (Leer)
    PROCEDURE consultar_beneficio (
        p_id             IN NUMBER,
        p_requisito      OUT Beneficios.requisito%TYPE,
        p_descripcion    OUT Beneficios.descripcion%TYPE
    );

    -- Update (Actualizar)
    PROCEDURE actualizar_beneficio (
        p_id             IN NUMBER,
        p_requisito      IN Beneficios.requisito%TYPE DEFAULT NULL,
        p_descripcion    IN Beneficios.descripcion%TYPE DEFAULT NULL
    );

    -- Delete (Eliminar)
    PROCEDURE eliminar_beneficio (
        p_id          IN NUMBER
    );

    ----------------------------------------------------------------------------
    -- 5. Gestión de Asignación de Beneficios (UsuariosFrecuentes_Beneficios)
    ----------------------------------------------------------------------------

    -- Create (Asignar)
    PROCEDURE asignar_beneficio_a_frecuente (
        p_beneficio_id   IN UsuariosFrecuentes_Beneficios.beneficio%TYPE,
        p_usuario_id     IN UsuariosFrecuentes_Beneficios.usuarioFrecuente%TYPE
    );

    -- Delete (Desasignar)
    PROCEDURE desasignar_beneficio_a_frecuente (
        p_beneficio_id   IN UsuariosFrecuentes_Beneficios.beneficio%TYPE,
        p_usuario_id     IN UsuariosFrecuentes_Beneficios.usuarioFrecuente%TYPE
    );

END PCK_USUARIOS;
/





--------------------------------------------------------------------------------
-- ESPECIFICACIÓN DEL PAQUETE: PCK_CASINO (CRUDE)
--------------------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PCK_CASINO AS

    ----------------------------------------------------------------------------
    -- 1. Gestión de Juegos (CRUD)
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_juego (
        p_id             IN NUMBER,
        p_nombre         IN Juegos.nombre%TYPE,
        p_maxJugadores   IN Juegos.maxJugadores%TYPE,
        p_minApuesta     IN Juegos.minApuesta%TYPE,
        p_maxApuesta     IN Juegos.maxApuesta%TYPE
    );

    -- Read (Leer)
    PROCEDURE consultar_juego (
        p_id             IN NUMBER,
        p_nombre         OUT Juegos.nombre%TYPE,
        p_maxJugadores   OUT Juegos.maxJugadores%TYPE,
        p_minApuesta     OUT Juegos.minApuesta%TYPE,
        p_maxApuesta     OUT Juegos.maxApuesta%TYPE
    );

    -- Update (Actualizar)
    PROCEDURE actualizar_juego (
        p_id             IN NUMBER,
        p_nombre         IN Juegos.nombre%TYPE DEFAULT NULL,
        p_maxJugadores   IN Juegos.maxJugadores%TYPE DEFAULT NULL,
        p_minApuesta     IN Juegos.minApuesta%TYPE DEFAULT NULL,
        p_maxApuesta     IN Juegos.maxApuesta%TYPE DEFAULT NULL
    );

    -- Delete (Eliminar)
    PROCEDURE eliminar_juego (
        p_id             IN NUMBER
    );

    ----------------------------------------------------------------------------
    -- 2. Gestión de Mesas (CRUD)
    ----------------------------------------------------------------------------

    -- Create (Crear)
    PROCEDURE crear_mesa (
        p_id             IN NUMBER,
        p_juego_id       IN Mesas.juego%TYPE,
        p_dealer_id      IN Mesas.dealer%TYPE,
        p_estado         IN Mesas.estado%TYPE DEFAULT 'Abierta' -- Estado inicial
    );

    -- Read (Leer)
    PROCEDURE consultar_mesa (
        p_id             IN NUMBER,
        p_juego_id       OUT Mesas.juego%TYPE,
        p_dealer_id      OUT Mesas.dealer%TYPE,
        p_estado         OUT Mesas.estado%TYPE
    );

    -- Update (Actualizar) - Permite cambiar el dealer y el juego
    PROCEDURE actualizar_mesa (
        p_id             IN NUMBER,
        p_juego_id       IN Mesas.juego%TYPE DEFAULT NULL,
        p_dealer_id      IN Mesas.dealer%TYPE DEFAULT NULL
    );

    -- Update (Actualizar Estado) - Procedimiento específico para Abrir/Cerrar/Mantenimiento
    PROCEDURE actualizar_estado_mesa (
        p_id             IN NUMBER,
        p_estado         IN Mesas.estado%TYPE
    );

    -- Delete (Eliminar)
    PROCEDURE eliminar_mesa (
        p_id             IN NUMBER
    );

    ----------------------------------------------------------------------------
    -- 3. Gestión de CambioFichas (CREATE y READ)
    ----------------------------------------------------------------------------

    -- Create (Crear) - Registra una transacción de fichas/dinero (Activará trigger de balance)
    PROCEDURE registrar_cambio_fichas (
        p_id             IN NUMBER,
        p_monto          IN CambioFichas.monto%TYPE,
        p_usuario_id     IN CambioFichas.usuario%TYPE,
        p_cajero_id      IN CambioFichas.cajero%TYPE,
        p_cajaRecibe     IN CambioFichas.cajaRecibe%TYPE -- 'Dinero' o 'Fichas'
    );

    -- Read (Leer)
    PROCEDURE consultar_cambio_fichas (
        p_id             IN NUMBER,
        p_monto          OUT CambioFichas.monto%TYPE,
        p_fechaHora      OUT CambioFichas.fechaHora%TYPE,
        p_usuario_id     OUT CambioFichas.usuario%TYPE,
        p_cajero_id      OUT CambioFichas.cajero%TYPE,
        p_cajaRecibe     OUT CambioFichas.cajaRecibe%TYPE
    );

    -- Delete (Eliminar) - Normalmente no se debe eliminar un log de transacciones
    PROCEDURE eliminar_cambio_fichas (
        p_id             IN NUMBER
    );
    
    ----------------------------------------------------------------------------
    -- 4. Gestión de Apuestas (CREATE, READ y Update (Finalizar))
    ----------------------------------------------------------------------------

    -- Create (Crear) - Registra una nueva apuesta
    PROCEDURE registrar_apuesta (
        p_id             IN NUMBER,
        p_monto          IN Apuestas.monto%TYPE,
        p_usuario_id     IN Apuestas.usuario%TYPE,
        p_mesa_id        IN Apuestas.mesa%TYPE
    );

    -- Read (Leer)
    PROCEDURE consultar_apuesta (
        p_id             IN NUMBER,
        p_monto          OUT Apuestas.monto%TYPE,
        p_fechaHora      OUT Apuestas.fechaHora%TYPE,
        p_estado         OUT Apuestas.estado%TYPE,
        p_usuario_id     OUT Apuestas.usuario%TYPE,
        p_mesa_id        OUT Apuestas.mesa%TYPE
    );

    -- Update (Finalizar) - Cambia el estado a 'Ganada' o 'Perdida' (Activará trigger de estado)
    PROCEDURE finalizar_apuesta (
        p_id             IN NUMBER,
        p_nuevo_estado   IN Apuestas.estado%TYPE
    );

    -- Delete (Eliminar)
    PROCEDURE eliminar_apuesta (
        p_id             IN NUMBER
    );

END PCK_CASINO;
/
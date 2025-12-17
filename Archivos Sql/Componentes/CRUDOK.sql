
-- 1. Probar CRUD para la tabla `Empleados`
-- ================================================
-- C: Crear un nuevo Empleado (Dealer)
BEGIN
    PCK_REGISTRAR_EMPLEADOS.crear_dealer('Juan Pérez', 'Mañana', 'Poker');
END;
/

-- C: Crear un nuevo Empleado (Cajero)
BEGIN
    PCK_REGISTRAR_EMPLEADOS.crear_cajero('Ana Gómez', 'Tarde', 'Alto', 1);
END;
/

-- R: Leer información de un empleado (consulta con ID)

VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_EMPLEADOS.consultar_empleado(32);
PRINT c_resultado;


-- U: Actualizar la información de un empleado
BEGIN
    PCK_MANTENER_EMPLEADOS.actualizar_empleado(1, 'Juan Pérez Actualizado', 'Noche');  -- Cambia el ID y nuevos valores
END;
/

-- D: Eliminar un empleado
BEGIN
    PCK_MANTENER_EMPLEADOS.eliminar_empleado(1);  -- Cambia el ID según sea necesario
END;
/

-- ================================================
-- 2. Probar CRUD para la tabla `Usuarios`
-- ================================================
-- C: Crear un nuevo Usuario Frecuente
BEGIN
    PCK_MANTENER_USUARIOS.actualizar_datos_usuario_frecuente(1,'Carlos Rivera','carlos@mail.com', 1234567890);
END;
/

-- C: Crear un nuevo Usuario Invitado
BEGIN
    PCK_REGISTRAR_USUARIOS.crear_usuario_invitado('María López',0);
END;
/
-- R: Leer información de un usuario (consulta con ID)
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_USUARIOS.consultar_usuario(32);
PRINT c_resultado;

-- D: Eliminar un usuario
BEGIN
    PCK_MANTENER_USUARIOS.eliminar_usuario(2);  -- Cambia el ID según sea necesario
END;
/

-- ================================================
-- 3. Probar CRUD para la tabla `Apuestas`
-- ================================================
-- C: Registrar una nueva apuesta
BEGIN
    PCK_REGISTRAR_APUESTAS.registrar_apuesta(1000, 2, 1);  -- Monto, ID de usuario, ID de mesa
END;
/

-- R: Consultar historial de apuestas de un usuario
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_USUARIOS.consultar_historial_usuario(32);
PRINT c_resultado;

-- U: Finalizar una apuesta (cambiar su estado)
BEGIN
    PCK_MANTENER_APUESTAS.finalizar_apuesta(1, 'Ganada');  -- ID de la apuesta, nuevo estado
END;
/

-- D: Eliminar una apuesta
BEGIN
    PCK_MANTENER_APUESTAS.eliminar_apuesta(1);  -- Cambia el ID según sea necesario
END;
/

-- ================================================
-- 4. Probar CRUD para la tabla `Mesas`
-- ================================================
-- C: Crear una nueva mesa
BEGIN
    PCK_REGISTRAR_ESTABLECIMIENTO.crear_mesa(1, 'Abierta', 1, 2);  -- Número de mesa, estado, ID del juego, ID del dealer
END;
/

-- R: Consultar información de una mesa
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_ESTABLECIMIENTO.consultar_mesa(32);
PRINT c_resultado;


-- U: Actualizar el estado de una mesa
BEGIN
    PCK_MANTENER_ESTABLECIMIENTO.actualizar_mesa_estado(1, 'Cerrada');  -- ID de la mesa, nuevo estado
END;
/

-- D: Eliminar una mesa
BEGIN
    PCK_MANTENER_ESTABLECIMIENTO.eliminar_mesa(1);  -- Cambia el ID según sea necesario
END;
/

-- ================================================
-- 5. Probar CRUD para la tabla `CambioFichas`
-- ================================================
-- C: Registrar una transacción de cambio de fichas
BEGIN
    PCK_REGISTRAR_TRANSACCIONES.registrar_cambio_fichas(500, 2, 1, 'Fichas');  -- Monto, usuario_id, cajero_id, cajaRecibe
END;
/

-- R: Consultar transacciones de un cajero
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_TRANSACCIONES.consultar_transacciones_cajero(32,'Tarde');
PRINT c_resultado;

-- D: Eliminar una transacción
BEGIN
    PCK_MANTENER_TRANSACCIONES.eliminar_transaccion(1);  -- Cambia el ID según sea necesario
END;
/

-- ================================================
-- 6. Probar CRUD para la tabla `Beneficios`
-- ================================================
-- C: Crear un nuevo beneficio
BEGIN
    PCK_REGISTRAR_USUARIOS.crear_beneficio('Requisito X', 'Descripción del beneficio');
END;
/


-- D: Eliminar un beneficio
BEGIN
    PCK_MANTENER_USUARIOS.eliminar_beneficio(1);  -- Cambia el ID según sea necesario
END;
/

-- ================================================
-- FIN DE LAS PRUEBAS CRUDOK
-- ================================================
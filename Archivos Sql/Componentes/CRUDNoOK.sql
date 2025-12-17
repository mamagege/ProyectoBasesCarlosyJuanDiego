-- ================================================
-- 1. Probar CRUD para la tabla `Empleados` (Escenarios NoOK)
-- ================================================
-- C: Intentar crear un nuevo Empleado (Dealer) con un ID duplicado (si se configura una restricción de unicidad)
BEGIN
    -- Intentar insertar un empleado con un ID ya existente
    PCK_REGISTRAR_EMPLEADOS.crear_dealer('Juan Pérez', 'Mañana', 'Poker');
    PCK_REGISTRAR_EMPLEADOS.crear_dealer('Juan Pérez', 'Tarde', 'Blackjack');  -- Duplicado, debe fallar
END;
/

-- C: Intentar crear un nuevo Empleado (Cajero) con datos incompletos (por ejemplo, sin nivel de acceso)
BEGIN
    PCK_REGISTRAR_EMPLEADOS.crear_cajero('Ana Gómez', 'Tarde', NULL, 1);  -- Nivel de acceso es NULL, debe fallar
END;
/

-- R: Intentar leer información de un empleado que no existe (ID no válido)
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_EMPLEADOS.consultar_empleado(-999);
PRINT c_resultado;


-- U: Intentar actualizar un empleado con un ID no existente
BEGIN
    PCK_MANTENER_EMPLEADOS.actualizar_empleado(9999, 'Juan Pérez Actualizado', 'Noche');  -- ID no existe, debe fallar
END;
/

-- D: Intentar eliminar un empleado que no existe
BEGIN
    PCK_MANTENER_EMPLEADOS.eliminar_empleado(9999);  -- ID no existe, debe fallar
END;
/

-- ================================================
-- 2. Probar CRUD para la tabla `Usuarios` (Escenarios NoOK)
-- ================================================


-- R: Intentar leer un usuario con un ID no válido
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_USUARIOS.consultar_usuario(9999999999999999999);
PRINT c_resultado;

-- U: Intentar actualizar un usuario con un balance negativo (si se aplica validación de balance)
BEGIN
    PCK_MANTENER_USUARIOS.actualizar_usuario(2, NULL, NULL);  -- Balance negativo o nulo, debe fallar
END;
/

-- D: Intentar eliminar un usuario que está en uso (relaciones en otras tablas)
BEGIN
    PCK_MANTENER_USUARIOS.eliminar_usuario(1);  -- El usuario está asignado a apuestas u otros registros, debe fallar
END;
/

-- ================================================
-- 3. Probar CRUD para la tabla `Apuestas` (Escenarios NoOK)
-- ================================================
-- C: Intentar registrar una apuesta con un monto negativo
BEGIN
    PCK_REGISTRAR_APUESTAS.registrar_apuesta(-1000, 2, 1);  -- Monto negativo, debe fallar
END;
/

-- R: Intentar consultar apuestas de un usuario con un ID no válido

-- R: Consultar historial de apuestas de un usuario
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_USUARIOS.consultar_historial_usuario('332');
PRINT c_resultado;

-- U: Intentar finalizar una apuesta con un ID no válido
BEGIN
    PCK_MANTENER_APUESTAS.finalizar_apuesta(9999, 'Ganada');  -- ID no existe, debe fallar
END;
/

-- D: Intentar eliminar una apuesta con un ID no válido
BEGIN
    PCK_MANTENER_APUESTAS.eliminar_apuesta(9999);  -- ID no existe, debe fallar
END;
/

-- ================================================
-- 4. Probar CRUD para la tabla `Mesas` (Escenarios NoOK)
-- ================================================
-- C: Intentar crear una mesa con un ID de juego no válido
BEGIN
    PCK_REGISTRAR_ESTABLECIMIENTO.crear_mesa(1, 'Abierta', 9999, 2);  -- ID de juego no existe, debe fallar
END;
/

-- R: Intentar consultar una mesa con un ID no válido
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_ESTABLECIMIENTO.consultar_mesa(0);
PRINT c_resultado;


-- U: Intentar actualizar una mesa con un estado no válido
BEGIN
    PCK_MANTENER_ESTABLECIMIENTO.actualizar_mesa_estado(1, 'Inactivo');  -- Estado no válido, debe fallar
END;
/

-- D: Intentar eliminar una mesa con apuestas activas
BEGIN
    PCK_MANTENER_ESTABLECIMIENTO.eliminar_mesa(1);  -- La mesa está en uso, debe fallar
END;
/

-- ================================================
-- 5. Probar CRUD para la tabla `CambioFichas` (Escenarios NoOK)
-- ================================================
-- C: Intentar registrar un cambio de fichas con un monto negativo
BEGIN
    PCK_REGISTRAR_TRANSACCIONES.registrar_cambio_fichas(-500, 2, 1, 'Fichas');  -- Monto negativo, debe fallar
END;
/

-- R: Intentar consultar las transacciones de un cajero con un ID no válido
-- R: Consultar transacciones de un cajero
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_MANTENER_TRANSACCIONES.consultar_transacciones_cajero(32,'Tarde','Manana');
PRINT c_resultado;

-- D: Intentar eliminar una transacción que no existe
BEGIN
    PCK_MANTENER_TRANSACCIONES.eliminar_transaccion(9999);  -- ID no existe, debe fallar
END;
/

-- ================================================
-- 6. Probar CRUD para la tabla `Beneficios` (Escenarios NoOK)
-- ================================================
-- C: Intentar crear un beneficio con descripción vacía o nula
BEGIN
    PCK_REGISTRAR_USUARIOS.crear_beneficio('Requisito X', NULL);  -- Descripción nula, debe fallar
END;
/



-- D: Intentar eliminar un beneficio que está asignado a un usuario
BEGIN
    PCK_MANTENER_USUARIOS.eliminar_beneficio(1);  -- El beneficio está asignado a usuarios, debe fallar
END;
/

-- ================================================
-- FIN DE LAS PRUEBAS CRUDNOOK
-- ================================================

-- ================================================
-- 1. Asignación de Roles a los Usuarios
-- ================================================
-- Asignar el rol de Administrador del Sistema (Acceso Total a Mantenimiento)
GRANT ROL_ADM_SISTEMA TO usuario_admin;

-- Asignar el rol de Cajero (Registro de Invitados y Transacciones)
GRANT ROL_CAJERO TO usuario_cajero;

-- Asignar el rol de Dealer (Gestión de Mesas y Apuestas)
GRANT ROL_DEALER TO usuario_dealer;

-- Asignar el rol de Usuario de la Aplicación (Consultas propias)
GRANT ROL_USUARIO_APLICACION TO usuario_usuario;

-- ================================================
-- 2. Verificar la Asignación de Roles
-- ================================================
-- Verificar los roles asignados a `usuario_admin`
SELECT * FROM user_role_privs WHERE grantee = 'USUARIO_ADMIN';

-- Verificar los roles asignados a `usuario_cajero`
SELECT * FROM user_role_privs WHERE grantee = 'USUARIO_CAJERO';

-- Verificar los roles asignados a `usuario_dealer`
SELECT * FROM user_role_privs WHERE grantee = 'USUARIO_DEALER';

-- Verificar los roles asignados a `usuario_usuario`
SELECT * FROM user_role_privs WHERE grantee = 'USUARIO_USUARIO';

-- ================================================
-- 3. Verificar los permisos sobre los paquetes
-- ================================================
-- Verificar los permisos sobre el paquete `PCK_ADM_SISTEMA`
SELECT * FROM dba_tab_privs WHERE grantee = 'ROL_ADM_SISTEMA' AND table_name = 'PCK_ADM_SISTEMA';

-- Verificar los permisos sobre el paquete `PCK_CAJERO`
SELECT * FROM dba_tab_privs WHERE grantee = 'ROL_CAJERO' AND table_name = 'PCK_CAJERO';

-- Verificar los permisos sobre el paquete `PCK_DEALER`
SELECT * FROM dba_tab_privs WHERE grantee = 'ROL_DEALER' AND table_name = 'PCK_DEALER';

-- Verificar los permisos sobre el paquete `PCK_USUARIO`
SELECT * FROM dba_tab_privs WHERE grantee = 'ROL_USUARIO_APLICACION' AND table_name = 'PCK_USUARIO';

-- ================================================
-- 4. Consultar si los usuarios tienen permisos adecuados
-- ================================================
-- Consultar si `usuario_admin` tiene permisos sobre el paquete `PCK_ADM_SISTEMA`
SELECT * 
FROM all_tab_privs
WHERE grantee = 'USUARIO_ADMIN' AND table_name = 'PCK_ADM_SISTEMA';

-- Consultar si `usuario_cajero` tiene permisos sobre el paquete `PCK_CAJERO`
SELECT * 
FROM all_tab_privs
WHERE grantee = 'USUARIO_CAJERO' AND table_name = 'PCK_CAJERO';

-- Consultar si `usuario_dealer` tiene permisos sobre el paquete `PCK_DEALER`
SELECT * 
FROM all_tab_privs
WHERE grantee = 'USUARIO_DEALER' AND table_name = 'PCK_DEALER';

-- Consultar si `usuario_usuario` tiene permisos sobre el paquete `PCK_USUARIO`
SELECT * 
FROM all_tab_privs
WHERE grantee = 'USUARIO_USUARIO' AND table_name = 'PCK_USUARIO';

-- ================================================
-- 5. Probar la ejecución de un procedimiento
-- ================================================
-- Probar que `usuario_admin` puede ejecutar el procedimiento `consultar_empleado` en `PCK_ADM_SISTEMA`
BEGIN
    PCK_ADM_SISTEMA.consultar_empleado(1);
    DBMS_OUTPUT.PUT_LINE('El procedimiento consultar_empleado fue ejecutado con éxito por usuario_admin.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al ejecutar el procedimiento consultar_empleado por usuario_admin: ' || SQLERRM);
END;
/

-- Probar que `usuario_cajero` puede ejecutar el procedimiento `registrar_cambio_fichas` en `PCK_CAJERO`
BEGIN
    PCK_CAJERO.registrar_cambio_fichas(1000, 2, 3, 'Fichas');
    DBMS_OUTPUT.PUT_LINE('El procedimiento registrar_cambio_fichas fue ejecutado con éxito por usuario_cajero.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al ejecutar el procedimiento registrar_cambio_fichas por usuario_cajero: ' || SQLERRM);
END;
/

-- Probar que `usuario_dealer` puede ejecutar el procedimiento `registrar_apuesta` en `PCK_DEALER`
BEGIN
    PCK_DEALER.registrar_apuesta(500, 2, 3);
    DBMS_OUTPUT.PUT_LINE('El procedimiento registrar_apuesta fue ejecutado con éxito por usuario_dealer.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error al ejecutar el procedimiento registrar_apuesta por usuario_dealer: ' || SQLERRM);
END;
/

-- ================================================
-- FIN DE LA CONFIGURACIÓN DE SEGURIDAD Y PRUEBAS
-- ================================================
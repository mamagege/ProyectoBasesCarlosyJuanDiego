SET SERVEROUTPUT ON;
-- Continúa la ejecución incluso si hay errores (ej: si el objeto ya no existe)
WHENEVER SQLERROR CONTINUE;

-- ==========================================================
-- 1. REVOCACIÓN DE PERMISOS
-- Revocamos los permisos de ejecución de los paquetes de Actores a los Roles.
-- ==========================================================

-- ROL_ADM_SISTEMA
REVOKE EXECUTE ON PCK_ADM_SISTEMA FROM ROL_ADM_SISTEMA;

-- ROL_CAJERO
REVOKE EXECUTE ON PCK_CAJERO FROM ROL_CAJERO;

-- ROL_DEALER
REVOKE EXECUTE ON PCK_DEALER FROM ROL_DEALER;

-- ROL_USUARIO_APLICACION
REVOKE EXECUTE ON PCK_USUARIO FROM ROL_USUARIO_APLICACION;

DBMS_OUTPUT.PUT_LINE('   Permisos revocados.');

-- ==========================================================
-- 2. ELIMINACIÓN DE PAQUETES DE ACTORES
-- Se eliminan la Especificación y el Cuerpo de cada paquete.
-- ==========================================================

DROP PACKAGE PCK_ADM_SISTEMA;
DROP PACKAGE PCK_CAJERO;
DROP PACKAGE PCK_DEALER;
DROP PACKAGE PCK_USUARIO;

DBMS_OUTPUT.PUT_LINE('   Paquetes de Actores eliminados.');

-- ==========================================================
-- 3. ELIMINACIÓN DE ROLES
-- Usamos CASCADE para asegurar la limpieza total si algún rol fue asignado a usuarios.
-- ==========================================================

DROP ROLE ROL_ADM_SISTEMA CASCADE;
DROP ROLE ROL_CAJERO CASCADE;
DROP ROLE ROL_DEALER CASCADE;
DROP ROLE ROL_USUARIO_APLICACION CASCADE;

DBMS_OUTPUT.PUT_LINE('   Roles de Aplicación eliminados.');


-- Reactivar el manejo de errores
WHENEVER SQLERROR EXIT FAILURE;
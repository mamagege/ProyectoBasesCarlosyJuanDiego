-- 1. Creación de Roles de Aplicación
CREATE ROLE ROL_ADM_SISTEMA;
CREATE ROLE ROL_CAJERO;
CREATE ROLE ROL_DEALER;
CREATE ROLE ROL_USUARIO_APLICACION;

-- 2. Asignación de Permisos de Ejecución (GRANT)

-- A. ROL_ADM_SISTEMA: Acceso total a mantenimiento y setup.
GRANT EXECUTE ON PCK_ADM_SISTEMA TO ROL_ADM_SISTEMA;

-- B. ROL_CAJERO: Registro de invitados y transacciones de fichas/dinero.
GRANT EXECUTE ON PCK_CAJERO TO ROL_CAJERO;

-- C. ROL_DEALER: Gestión de mesas, apuestas y registro de visitas.
GRANT EXECUTE ON PCK_DEALER TO ROL_DEALER;

-- D. ROL_USUARIO_APLICACION: Consultas propias de saldo e historial.
GRANT EXECUTE ON PCK_USUARIO TO ROL_USUARIO_APLICACION;

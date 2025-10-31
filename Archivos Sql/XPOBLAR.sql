--XPOBLAR

-- 1. Apuestas depende de Mesas y Usuarios
DELETE FROM Apuestas;

-- 2. Fichas depende de Cajeros y Usuarios
DELETE FROM Fichas;

-- 3. Mesas depende de Juegos y Dealers
DELETE FROM Mesas;

-- 4. UsuariosFrecuentes_Beneficios depende de Beneficios y UsuariosFrecuentes
DELETE FROM UsuariosFrecuentes_Beneficios;

-- 5. UsuariosInvitados depende de Usuarios
DELETE FROM UsuariosInvitados;

-- 6. UsuariosFrecuentes depende de Usuarios
DELETE FROM UsuariosFrecuentes;

-- 7. Dealers depende de Empleados
DELETE FROM Dealers;

-- 8. Cajeros depende de Empleados
DELETE FROM Cajeros;

-- 9. Beneficios no tiene dependencias hacia atrás
DELETE FROM Beneficios;

-- 10. Empleados no depende de nadie
DELETE FROM Empleados;

-- 11. Finalmente, Usuarios (padre base)
DELETE FROM Usuarios;
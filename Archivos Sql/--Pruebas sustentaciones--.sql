--Pruebas sustentaciones--
SET SERVEROUTPUT ON;

BEGIN
    
    -- 1.1 Eliminar datos de Apuestas (Depende de Usuarios y Mesas)
    DELETE FROM Apuestas;
    
    -- 1.2 Eliminar datos de CambioFichas (Depende de Usuarios y Cajeros)
    DELETE FROM CambioFichas;
    
    -- 1.3 Eliminar datos de Mesas (Depende de Juegos y Dealers)
    DELETE FROM Mesas;

    -- 1.4 Eliminar la tabla de relación N:N (Depende de Beneficios y UsuariosFrecuentes)
    DELETE FROM UsuariosFrecuentes_Beneficios;
    
    -- 1.5 Eliminar subtipos de Usuarios (Deben ir antes que Usuarios)
    DELETE FROM UsuariosInvitados;
    DELETE FROM UsuariosFrecuentes;
    
    -- 1.6 Eliminar Beneficios y Juegos (No tienen dependencias salientes)
    DELETE FROM Beneficios;
    DELETE FROM Juegos;
    
    -- 1.7 Eliminar subtipos de Empleados (Deben ir antes que Empleados)
    DELETE FROM Cajeros;
    DELETE FROM Dealers;
    
    -- 1.8 Eliminar las tablas raíz
    DELETE FROM Usuarios;
    DELETE FROM Empleados;
    
    -- Confirma la eliminación de todos los datos
    COMMIT; 
    
END;
/
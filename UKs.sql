-- #Unique Keys OK
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Correo UNIQUE (correo);
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Celular UNIQUE (celular);
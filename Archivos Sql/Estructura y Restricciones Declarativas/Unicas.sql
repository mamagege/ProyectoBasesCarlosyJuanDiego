-- #Unique Keys OK
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Correo UNIQUE (correo);
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Celular UNIQUE (celular);
ALTER TABLE JUEGOS ADD CONSTRAINT uq_juegos_nombre UNIQUE(nombre);

--CICLO 2
ALTER TABLE Torneos ADD CONSTRAINT UQ_Torneos_nombre UNIQUE(nombre);
ALTER TABLE Usuarios_Premios ADD CONSTRAINT UQ_puesto UNIQUE(puesto);
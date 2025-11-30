-- #Foreing Key OK
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT FK_UsuariosFrecuentes_Usuario
FOREIGN KEY (usuario) REFERENCES Usuarios(id);

ALTER TABLE UsuariosInvitados ADD CONSTRAINT FK_UsuariosInvitados_Usuario
FOREIGN KEY (usuario) REFERENCES Usuarios(id);

ALTER TABLE Cajeros ADD CONSTRAINT FK_Cajeros_Empleado
FOREIGN KEY (empleado) REFERENCES Empleados(id);

ALTER TABLE Dealers ADD CONSTRAINT FK_Dealers_Empleado
FOREIGN KEY (empleado) REFERENCES Empleados(id);

ALTER TABLE Fichas ADD CONSTRAINT FK_Fichas_Usuario
FOREIGN KEY (usuario) REFERENCES Usuarios(id);

ALTER TABLE Fichas ADD CONSTRAINT FK_Fichas_Cajero
FOREIGN KEY (cajero) REFERENCES Cajeros(id);

ALTER TABLE Mesas ADD CONSTRAINT FK_Mesas_Juego
FOREIGN KEY (juego) REFERENCES Juegos(id);

ALTER TABLE Mesas ADD CONSTRAINT FK_Mesas_Dealer
FOREIGN KEY (dealer) REFERENCES Dealers(id);

ALTER TABLE Apuestas ADD CONSTRAINT FK_Apuestas_Usuario
FOREIGN KEY (usuario) REFERENCES Usuarios(id);

ALTER TABLE Apuestas ADD CONSTRAINT FK_Apuestas_Mesa
FOREIGN KEY (mesa) REFERENCES Mesas(id);

ALTER TABLE UsuariosFrecuentes_Beneficios ADD CONSTRAINT FK_UFB_Beneficio
FOREIGN KEY (beneficio) REFERENCES Beneficios(id);

ALTER TABLE UsuariosFrecuentes_Beneficios ADD CONSTRAINT FK_UFB_UsuarioFrecuente
FOREIGN KEY (usuarioFrecuente) REFERENCES UsuariosFrecuentes(id);

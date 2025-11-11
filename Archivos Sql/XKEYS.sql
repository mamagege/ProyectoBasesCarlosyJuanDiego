--XKEYS

-- ============================================================
-- 1. ELIMINAR CONSTRAINTS (FOREIGN KEYS, CHECKS, UNIQUE, PK)
-- ============================================================

-- --- TABLA: UsuariosFrecuentes
ALTER TABLE UsuariosFrecuentes DROP CONSTRAINT FK_UsuariosFrecuentes_Usuario;
ALTER TABLE UsuariosFrecuentes DROP CONSTRAINT UQ_UsuariosFrecuentes_Correo;
ALTER TABLE UsuariosFrecuentes DROP CONSTRAINT UQ_UsuariosFrecuentes_Celular;
ALTER TABLE UsuariosFrecuentes DROP CONSTRAINT PK_UsuariosFrecuentes;
ALTER TABLE UsuariosFrecuentes DROP CONSTRAINT ck_Tcorreo;

-- --- TABLA: UsuariosInvitados
ALTER TABLE UsuariosInvitados DROP CONSTRAINT FK_UsuariosInvitados_Usuario;
ALTER TABLE UsuariosInvitados DROP CONSTRAINT PK_UsuariosInvitados;
ALTER TABLE UsuariosInvitados DROP CONSTRAINT ck_Nvisitas;

-- --- TABLA: Beneficios
ALTER TABLE Beneficios DROP CONSTRAINT PK_Beneficios;

-- --- TABLA: UsuariosFrecuentes_Beneficios
ALTER TABLE UsuariosFrecuentes_Beneficios DROP CONSTRAINT FK_UFB_Beneficio;
ALTER TABLE UsuariosFrecuentes_Beneficios DROP CONSTRAINT FK_UFB_UsuarioFrecuente;
ALTER TABLE UsuariosFrecuentes_Beneficios DROP CONSTRAINT PK_UsuariosFrecuentes_Beneficios;

-- --- TABLA: Empleados
ALTER TABLE Empleados DROP CONSTRAINT PK_Empleados;
ALTER TABLE Empleados DROP CONSTRAINT ck_Tturno;

-- --- TABLA: Cajeros
ALTER TABLE Cajeros DROP CONSTRAINT FK_Cajeros_Empleado;
ALTER TABLE Cajeros DROP CONSTRAINT PK_Cajeros;

-- --- TABLA: Dealers
ALTER TABLE Dealers DROP CONSTRAINT FK_Dealers_Empleado;
ALTER TABLE Dealers DROP CONSTRAINT PK_Dealers;
ALTER TABLE Dealers DROP CONSTRAINT ck_Tespecialidad;

-- --- TABLA: Fichas
ALTER TABLE Fichas DROP CONSTRAINT FK_Fichas_Usuario;
ALTER TABLE Fichas DROP CONSTRAINT FK_Fichas_Cajero;
ALTER TABLE Fichas DROP CONSTRAINT PK_Fichas;
ALTER TABLE Fichas DROP CONSTRAINT ck_Trecibe;

-- --- TABLA: Juegos
ALTER TABLE Juegos DROP CONSTRAINT PK_Juegos;
ALTER TABLE Juegos DROP CONSTRAINT uq_juegos_nombre;

-- --- TABLA: Mesas
ALTER TABLE Mesas DROP CONSTRAINT FK_Mesas_Juego;
ALTER TABLE Mesas DROP CONSTRAINT FK_Mesas_Dealer;
ALTER TABLE Mesas DROP CONSTRAINT PK_Mesas;
ALTER TABLE Mesas DROP CONSTRAINT ck_TestadoMesa;

-- --- TABLA: Apuestas
ALTER TABLE Apuestas DROP CONSTRAINT FK_Apuestas_Usuario;
ALTER TABLE Apuestas DROP CONSTRAINT FK_Apuestas_Mesa;
ALTER TABLE Apuestas DROP CONSTRAINT PK_Apuestas;
ALTER TABLE Apuestas DROP CONSTRAINT ck_TestadoApuesta;

-- --- TABLA: Usuarios
ALTER TABLE Usuarios DROP CONSTRAINT PK_Usuarios;

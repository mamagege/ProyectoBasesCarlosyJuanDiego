--#1CREAR TABLAS OK
CREATE TABLE Usuarios (
    id NUMBER NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    balance NUMBER NOT NULL
);

CREATE TABLE UsuariosFrecuentes (
    id NUMBER NOT NULL,
    correo VARCHAR2(50) NOT NULL,
    celular VARCHAR2(15) NOT NULL,
    puntos NUMBER(10) NOT NULL
);

CREATE TABLE UsuariosInvitados (
    id NUMBER NOT NULL,
    numeroDeVisitas NUMBER(1)
);

CREATE TABLE Beneficios (
    id NUMBER NOT NULL,
    requisito VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL
);

CREATE TABLE UsuariosFrecuentes_Beneficios (
    beneficio NUMBER NOT NULL,
    usuarioFrecuente NUMBER NOT NULL
);

CREATE TABLE Empleados (
    id NUMBER NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    turno VARCHAR2(20) NOT NULL
);

CREATE TABLE Cajeros (
    id NUMBER NOT NULL,
    nivelAcceso VARCHAR2(20) NOT NULL,
    ventanilla NUMBER(2) NOT NULL
);

CREATE TABLE Dealers (
    id NUMBER NOT NULL,
    especialidad VARCHAR2(20) 
);

CREATE TABLE Fichas (
    id NUMBER NOT NULL,
    monto NUMBER NOT NULL,
    fechaHora DATE NOT NULL,
    usuario NUMBER NOT NULL,
    cajero NUMBER NOT NULL
);

CREATE TABLE Juegos (
    id NUMBER NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    maxJugadores NUMBER NOT NULL,
    minApuesta NUMBER NOT NULL,
    maxApuesta NUMBER NOT NULL
);

CREATE TABLE Mesas (
    id NUMBER,
    numeroMesa NUMBER,
    estado VARCHAR2(20),
    juego NUMBER NOT NULL,
    dealer NUMBER NOT NULL
);

CREATE TABLE Apuestas (
    id NUMBER NOT NULL,
    monto NUMBER NOT NULL,
    fechaHora DATE NOT NULL,
    estado VARCHAR2(20) NOT NULL,
    usuario NUMBER NOT NULL,
    mesa NUMBER NOT NULL
);


-- #Primary Keys OK

ALTER TABLE Usuarios ADD CONSTRAINT PK_Usuarios PRIMARY KEY (id);
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT PK_UsuariosFrecuentes PRIMARY KEY (id);
ALTER TABLE UsuariosFrecuentes_Beneficios ADD CONSTRAINT PK_UsuariosFrecuentes_Beneficios PRIMARY KEY (beneficio, usuarioFrecuente);
ALTER TABLE UsuariosInvitados ADD CONSTRAINT PK_UsuariosInvitados PRIMARY KEY (id);
ALTER TABLE Beneficios ADD CONSTRAINT PK_Beneficios PRIMARY KEY (id);
ALTER TABLE Empleados ADD CONSTRAINT PK_Empleados PRIMARY KEY (id);
ALTER TABLE Cajeros ADD CONSTRAINT PK_Cajeros PRIMARY KEY (id);
ALTER TABLE Dealers ADD CONSTRAINT PK_Dealers PRIMARY KEY (id);
ALTER TABLE Fichas ADD CONSTRAINT PK_Fichas PRIMARY KEY (id);
ALTER TABLE Juegos ADD CONSTRAINT PK_Juegos PRIMARY KEY (id);
ALTER TABLE Mesas ADD CONSTRAINT PK_Mesas PRIMARY KEY (id);
ALTER TABLE Apuestas ADD CONSTRAINT PK_Apuestas PRIMARY KEY (id);

-- #Unique Keys OK
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Correo UNIQUE (correo);
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Celular UNIQUE (celular);

-- #Foreing Key OK
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT FK_UsuariosFrecuentes_Usuario
FOREIGN KEY (id) REFERENCES Usuarios(id);

ALTER TABLE UsuariosInvitados ADD CONSTRAINT FK_UsuariosInvitados_Usuario
FOREIGN KEY (id) REFERENCES Usuarios(id);

ALTER TABLE Cajeros ADD CONSTRAINT FK_Cajeros_Empleado
FOREIGN KEY (id) REFERENCES Empleados(id);

ALTER TABLE Dealers ADD CONSTRAINT FK_Dealers_Empleado
FOREIGN KEY (id) REFERENCES Empleados(id);

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

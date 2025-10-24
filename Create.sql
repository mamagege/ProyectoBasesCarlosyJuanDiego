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

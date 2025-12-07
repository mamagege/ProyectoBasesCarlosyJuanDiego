--#1CREAR TABLAS OK

CREATE TABLE Usuarios (
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1,
    nombre VARCHAR2(50) NOT NULL,
    balance NUMBER(10, 2) NOT NULL
);

CREATE TABLE UsuariosFrecuentes (
    id NUMBER(10) NOT NULL,
    correo VARCHAR2(100),
    celular VARCHAR2(15),
    puntos NUMBER(10) NOT NULL
);

CREATE TABLE UsuariosInvitados (
    id NUMBER NOT NULL,
    numeroDeVisitas NUMBER(2)
);

CREATE TABLE Beneficios (
    id NUMBER(10) NOT NULL,
    requisito VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL
);

CREATE TABLE UsuariosFrecuentes_Beneficios (
    beneficio NUMBER(10) NOT NULL,
    usuarioFrecuente NUMBER(10) NOT NULL
);

CREATE TABLE Empleados (
    id NUMBER(10) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    turno VARCHAR2(10) NOT NULL
);

CREATE TABLE Cajeros (
    id NUMBER(10) NOT NULL,
    nivelAcceso VARCHAR2(20) NOT NULL,
    ventanilla NUMBER(3) NOT NULL
);

CREATE TABLE Dealers (
    id NUMBER(10) NOT NULL,
    especialidad VARCHAR2(20) 
);

CREATE TABLE CambioFichas (
    id NUMBER(10) NOT NULL,
    monto NUMBER(20) NOT NULL,
    fechaHora DATE NOT NULL,
    usuario NUMBER(10) NOT NULL,
    cajero NUMBER(10) NOT NULL,
    cajaRecibe VARCHAR2(10) NOT NULL
);

CREATE TABLE Juegos (
    id NUMBER(10) NOT NULL,
    nombre VARCHAR2(50) NOT NULL,
    maxJugadores NUMBER(2) NOT NULL,
    minApuesta NUMBER(10) NOT NULL,
    maxApuesta NUMBER(20) NOT NULL
);

CREATE TABLE Mesas (
    id NUMBER(10),
    numeroMesa NUMBER(3),
    estado VARCHAR2(20),
    juego NUMBER(10) NOT NULL,
    dealer NUMBER(10) NOT NULL
);

CREATE TABLE Apuestas (
    id NUMBER(10) NOT NULL,
    monto NUMBER(20) NOT NULL,
    fechaHora DATE NOT NULL,
    estado VARCHAR2(20) NOT NULL,
    usuario NUMBER(10) NOT NULL,
    mesa NUMBER(10) NOT NULL
);

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
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1,
    requisito VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(100) NOT NULL
);

CREATE TABLE UsuariosFrecuentes_Beneficios (
    beneficio NUMBER(10) NOT NULL,
    usuarioFrecuente NUMBER(10) NOT NULL
);

CREATE TABLE Empleados (
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1,
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
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1,
    monto NUMBER(20) NOT NULL,
    fechaHora DATE NOT NULL,
    usuario NUMBER(10) NOT NULL,
    cajero NUMBER(10) NOT NULL,
    cajaRecibe VARCHAR2(10) NOT NULL
);

CREATE TABLE Juegos (
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1,
    nombre VARCHAR2(50) NOT NULL,
    maxJugadores NUMBER(2) NOT NULL,
    minApuesta NUMBER(10) NOT NULL,
    maxApuesta NUMBER(20) NOT NULL
);

CREATE TABLE Mesas (
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1,
    numeroMesa NUMBER(3),
    estado VARCHAR2(20),
    juego NUMBER(10) NOT NULL,
    dealer NUMBER(10) NOT NULL
);

CREATE TABLE Apuestas (
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1 
        INCREMENT BY 1,
    monto NUMBER(20) NOT NULL,
    fechaHora DATE NOT NULL,
    estado VARCHAR2(20) NOT NULL,
    usuario NUMBER(10) NOT NULL,
    mesa NUMBER(10) NOT NULL
);

--Ciclo 2

ALTER TABLE Mesas
ADD torneo NUMBER(10);

CREATE TABLE Torneos (
    id NUMBER(10)
    GENERATED ALWAYS AS IDENTITY
    START WITH 1
    INCREMENT BY 1,
    nombre VARCHAR2(100) NOT NULL,
    jugadoresActuales NUMBER(20),
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    estado VARCHAR2(20) NOT NULL,  -- Activo, Finalizado, Cancelado
    valorEntrada NUMBER(20) NOT NULL,
    pozoDePremios NUMBER(20) NOT NULL,  -- Total de premios
    juego NUMBER(10) NOT NULL -- FK a Juegos
);


CREATE TABLE Premios (
    id NUMBER(10) 
        GENERATED ALWAYS AS IDENTITY 
        START WITH 1
        INCREMENT BY 1,
    torneo NUMBER(10) NOT NULL,  -- FK a Torneos
    participante NUMBER(10) NOT NULL,  -- FK a Participantes
    premio VARCHAR2(200) NOT NULL,  -- Descripción del premio
    monto NUMBER(20),
    estado VARCHAR2(20) NOT NULL  -- Asignado, Entregado
);

CREATE TABLE Participantes (
    id NUMBER(10)
        GENERATED ALWAYS AS IDENTITY
        START WITH 1
        INCREMENT BY 1,
    torneo NUMBER(10) NOT NULL,  -- FK a Torneos
    usuario NUMBER(10) NOT NULL,  -- FK a Usuarios
    fecha_registro DATE DEFAULT SYSDATE,
    estado VARCHAR2(20) NOT NULL  -- Inscrito, Eliminado
);

CREATE TABLE Usuarios_Premios (
    id NUMBER(10)
        GENERATED ALWAYS AS IDENTITY
        START WITH 1
        INCREMENT BY 1,   
    usuario NUMBER(10) NOT NULL,
    premio NUMBER(10) NOT NULL,
    fechaEntrega DATE NOT NULL,
    puesto NUMBER(1) NOT NULL
);



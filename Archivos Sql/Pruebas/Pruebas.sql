--Pruebas de Aceptación

--1


--Juan Diego Gaitán que estudia Ing en Sistemas en la Escuela Julio Garavito sale de su parcial de Bases de Datos y sale contento pues respondió todo bien. 
--Cuando recibe los resultados, saca 5 por lo que decide celebrar con sus amigos en la 85.
--Cuando están allá deciden apostar un poco en el Casino Luckia con sus amigos y se registran.  

--El Cajero registra el nombre de los nuevos jugadores y los registra como su primera visita.
BEGIN
registrar_nuevo_invitado(1, 'Juan Diego Gaitán');
registrar_nuevo_invitado(2, 'Carlos Sanchez');
registrar_nuevo_invitado(3, 'Pedro Ayala');
registrar_visita(1);
registrar_visita(2);
registrar_visita(3);
END;

--Luego cada uno decide comprar fichas para apostar. Cada uno decide gastarse 500.000 pesos y entre ellos competir por quien gana más.
--El cajero Juan Pérez registra las compras de fichas de cada uno.
BEGIN
    registrar_cambio_fichas(1, 500000,1,'Fichas', 1);
    registrar_cambio_fichas(2, 500000,2,'Fichas', 1);
    registrar_cambio_fichas(3, 500000,3,'Billetes', 1);
END;
--Juan Pérez se da cuenta que al usuario 3 le puso un valor incorrecto en cajaRecibe por lo que el sistema no lo permite.
ALTER TABLE CambioFichas ADD CONSTRAINT ck_Trecibe
CHECK (cajaRecibe IN ('Dinero','Fichas'));

--Así pues corrige el error y registra la compra de fichas de Pedro Ayala.
BEGIN
    registrar_cambio_fichas(3, 500000,3,'Fichas', 1);
END;
--Cada uno de los amigos se dirige a una mesa diferente para apostar.

--Pero Pedro Ayala por los inconvenientes del cajero llamada al administrador y reclama por algún beneficio por las molestias.
--El administrador intenta darle un benificio pero el sistema no lo permite pues no es un usuario frecuente.

-------------------------------------------------------------------------------
-- TRIGGER: Bloquear beneficios para usuarios invitados
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_evitar_beneficios_invitados
BEFORE INSERT ON UsuariosFrecuentes_Beneficios
FOR EACH ROW
DECLARE
    v_existe NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_existe
    FROM UsuariosInvitados
    WHERE id = :NEW.usuarioFrecuente;

    IF v_existe > 0 THEN
        RAISE_APPLICATION_ERROR(-20005, 'Un usuario invitado no puede recibir beneficios.');
    END IF;
END;
/

--El primero en apostar en Juan Diego y decide ir por Blackjack. 
--Apuesta 100.000 a una mano.
BEGIN
    registrar_apuesta(1, 100000,1,1);
END;
--Juan Diego gana la mano y recibe 200.000 pesos.
BEGIN
    finalizar_apuesta(1, 'Ganada');
END;
--Sigue apostando y pierde 3 y gana 2. 

BEGIN
    registrar_apuesta(2, 150000,1,1);
    finalizar_apuesta(2, 'Perdida');
    registrar_apuesta(3, 200000,1,1);
    finalizar_apuesta(3, 'Perdida');
    registrar_apuesta(4, 100000,1,1);
    finalizar_apuesta(4, 'Ganada');
    registrar_apuesta(5, 50000,1,1);
    finalizar_apuesta(5, 'Ganada');
END;

--Como ganó tanto decide darle propina al dealer y el dealer como agradecimiento intenta agregarle una visita más a su registro.
--El sistema no lo permite pues las visitas solo las puede registrar el cajero.


GRANT EXECUTE ON PCK_DEALER TO ROL_DEALER;

--Al manager del casino le aparece que Juan Pérez intentó hacer eso y decide llamarlo para recordarle sus funciones asi que cierra la mesa. 

BEGIN
    actualizar_estado_mesa(1, 'Cerrada');
END;


--El cajero se pone grosero con el administrador y el administrador decide despedirlo. 

BEGIN
    eliminar_empleado(1);
END;

--El siguiente en apostar en Carlos Sanchez quien decide jugar Ruleta. Le va muy bien y todos a su alrededor lo ven con admiración y misterio.

BEGIN 
    registrar_apuesta(6, 200000,2,2);
    finalizar_apuesta(6, 'Ganada');
    registrar_apuesta(7, 300000,2,2);
    finalizar_apuesta(7, 'Ganada');
    registrar_apuesta(8, 200000,2,2);
    finalizar_apuesta(8, 'Ganada');
    registrar_apuesta(9, 300000,2,2);
    finalizar_apuesta(9, 'Ganada');
END;

--Todos están alucinados con la suerte de Carlos Sanchez quien decide retirarse con sus ganancias. 

--El administrador decide revisar las cámaras de seguridad y nota algo extraño en esa mesa. Por lo que decide cerrarla por mantenimiento y le dice al dealer de esa mesa.

BEGIN
    actualizar_estado_mesa(2, 'Mantenimiento');
END;

--Finalmente descubre una irreguralidad en la ruleta y decide eliminar esa mesa definitivamente del casino.

BEGIN
    eliminar_mesa(2);
END;

--Pedro Ayala fue el primero en perder todo lo que tenía así pues decide revisar su historial. 

BEGIN
    consultar_mi_historial_apuestas(3);
END;

--Finalmente Carlos Sanchez y Juan Diego deciden cambiar sus fichas y ver quién fue el ganador final de la noche.

BEGIN
    registrar_cambio_fichas(4, 1300000,2,'Dinero', 2);
    registrar_cambio_fichas(5, 100000,1,'Dinero', 2);
END;

--Así pues el balance de cada uno se ve modificado. 

--------------------------------------------------------------------------------
-- TRIGGER: Actualización automática de balance según transacción de fichas
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_actualizar_balance_fichas
AFTER INSERT ON CambioFichas
FOR EACH ROW
BEGIN
    IF :NEW.cajaRecibe = 'Dinero' THEN
        UPDATE Usuarios
        SET balance = balance - :NEW.monto
        WHERE id = :NEW.usuario;
    ELSIF :NEW.cajaRecibe = 'Fichas' THEN
        UPDATE Usuarios
        SET balance = balance + :NEW.monto
        WHERE id = :NEW.usuario;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'Valor inválido en cajaRecibe. Debe ser Dinero o Fichas.');
    END IF;
END;
/

--Carlos Sanchez fue el ganador de la noche con un balance final de 1.300.000 pesos mientras que Juan Diego terminó con un balance de 100.000 pesos.
--Así pues deciden retirarse felices del casino tras una noche de apuestas y diversión.


--2

--Juan Diego y sus amigos les gustó tanto la experiencia en el casino que deciden ir varias semanas seguidas.

BEGIN
    FOR i IN 1..8 LOOP
        registrar_visita(1);
        registrar_visita(2);
        registrar_visita(3);
    END LOOP;
END;


--Cuando llegan a las 10 visitas son registrados automáticamente como usuarios frecuentes sin antes el administrador pedir su información obligaotoria en la visita 9.

BEGIN
    crear_usuario_frecuente(1, 'Juan Diego Gaitán', 100000, 'juandiego@gmail.com', 2001234567);
    crear_usuario_frecuente(2, 'Carlos Sanchez', 1300000, 'juandiego@gmail.com', 2001234567);
    crear_usuario_frecuente(3, 'Pedro Ayala', 0, 'pedritoxd@gmail.com', 3007654321);
END;

--El sistema no permite que se agregue el mismo correo a diferentes usuarios frecuentes.

ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Correo UNIQUE (correo);
ALTER TABLE UsuariosFrecuentes ADD CONSTRAINT UQ_UsuariosFrecuentes_Celular UNIQUE (celular);


--Por lo que deben poner diferentes correos y celulares.

BEGIN
    crear_usuario_frecuente(1, 'Juan Diego Gaitán', 100000, 'juandiego@gmail.com', 2001234567);
    crear_usuario_frecuente(2, 'Carlos Sanchez', 1300000, 'carlosdestructor@gmail.com', 6701234567);
END;

--Por lo que al siguiente día, registran su visita y se conviernte en usuarios frecuentes.

--------------------------------------------------------------------------------
-- TRIGGER: Promover automáticamente a Usuario Frecuente
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_promover_a_frecuente
AFTER UPDATE OF numeroDeVisitas ON UsuariosInvitados
FOR EACH ROW
DECLARE
    v_existente NUMBER;
BEGIN
    IF :NEW.numeroDeVisitas >= 10 THEN
        SELECT COUNT(*) INTO v_existente
        FROM UsuariosFrecuentes
        WHERE id = :NEW.id;

        IF v_existente = 0 THEN
            INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos)
            VALUES (:NEW.id, NULL, NULL, 0);
        END IF;
    END IF;
END;

--Como regalo de bienvenido, el administrador les asigna un beneficio a cada uno.

BEGIN
    crear_beneficio(1, 'Ser usuario frecuente por primera vez', '10% de descuento en la compra de fichas');
    asignar_beneficio_a_frecuente(1, 1);
    asignar_beneficio_a_frecuente(1, 2);
    asignar_beneficio_a_frecuente(1, 3);
END;

--Así pues todos felices empiezan a jugar y a apostar en el casino.

BEGIN
    registrar_cambio_fichas(6, 200000,1,'Fichas', 1);
    registrar_cambio_fichas(7, 500000,2,'Fichas', 1);
    registrar_cambio_fichas(8, 300000,3,'Fichas', 1);
END;

--Luego de una larga jornada de apuestas, el administrador decide darle un premio al cajero que haya generado más apuestas. 
--Por lo que empiezan a revisar su historial de trsansacciones.

BEGIN
    consultar_transacciones_turno(1, 'Mañana');
    consultar_transacciones_turno(1, 'Tarde');
    consultar_transacciones_turno(2, 'Mañana');
    consultar_transacciones_turno(2, 'Tarde');
END;

--Finalmente deciden darle el premio al cajero 2 por haber generado más apuestas en su turno de la tarde y decide verificar esto con una consulta de vistas e indices.

--Consulta: Consultar total de fichas entregadas por cada cajero
--Usa: idx_cambiofichas_cajero y Vista V_CambioFichas_Detalle

SELECT cajero_nombre, SUM(monto) AS total_monto
FROM V_CambioFichas_Detalle
GROUP BY cajero_nombre
ORDER BY total_monto DESC;


--Así pues decide hacer lo mismo con el usuario que más apostó en el día para darle un premio especial.


SELECT u.nombre, COUNT(*) AS total_transacciones
FROM CambioFichas cf
JOIN Usuarios u ON cf.usuario = u.id
GROUP BY u.nombre
ORDER BY total_transacciones DESC;

--El ganador resulta ser Carlos Sanchez quien decide retirarse feliz con sus ganancias y premios del casino.


-- ==========================================================





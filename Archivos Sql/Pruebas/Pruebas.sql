--Pruebas de Aceptación 

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



--Así pues el balance de Juan Diego se ve modificado. 

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





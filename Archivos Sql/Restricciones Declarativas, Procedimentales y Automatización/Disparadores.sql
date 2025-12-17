--Disparadores

--Actor: Dealer 
--Función: Registrar las apuestas del juego
--Registro: Una apuesta solo puede pasar de “En proceso” a “Ganada” o “Perdida”.

--------------------------------------------------------------------------------
-- TRIGGER: Control de flujo de estado en Apuestas
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_control_estado_apuesta
BEFORE UPDATE OF estado ON Apuestas
FOR EACH ROW
BEGIN
    IF :OLD.estado = 'En proceso' AND :NEW.estado NOT IN ('Ganada', 'Perdida') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Una apuesta en proceso solo puede pasar a Ganada o Perdida.');
    ELSIF :OLD.estado IN ('Ganada', 'Perdida') AND :NEW.estado <> :OLD.estado THEN
        RAISE_APPLICATION_ERROR(-20002, 'No se puede cambiar el estado de una apuesta finalizada.');
    END IF;
END;
/


--Actor: Cajero

--Función: Registrar transacciones de fichas y dinero

--Registro: Al registrar CambioFichas, Si cajaRecibe es igual a dinero, el monto del cambio se resta al balance del usuario si no, el monto se suma al balance.

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


--Función: Registrar visitas de usuarios.

--Registro: Un usuario no puede pasar de Usuario frecuente a Usuario invitado

--------------------------------------------------------------------------------
-- TRIGGER: Evitar que un usuario frecuente sea registrado como invitado
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_evitar_frecuente_a_invitado
BEFORE INSERT OR UPDATE ON UsuariosInvitados
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM UsuariosFrecuentes
    WHERE id = :NEW.id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Un usuario frecuente no puede ser registrado como invitado.');
    END IF;
END;

/

--Registro: Al completar 10 visitas, el usuario invitado se convierte en usuario frecuente.

--------------------------------------------------------------------------------
-- TRIGGER: Promover automáticamente a Usuario Frecuente
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_promover_a_frecuente
FOR UPDATE OF numeroDeVisitas ON UsuariosInvitados
COMPOUND TRIGGER

    v_idx PLS_INTEGER := 0;

    AFTER EACH ROW IS
        v_existente NUMBER;
    BEGIN
        -- 1. Verificar si alcanzó el umbral (>= 10)
        IF :NEW.numeroDeVisitas >= 10 THEN
            
            -- 2. Verificar que no exista ya en UsuariosFrecuentes
            SELECT COUNT(*) INTO v_existente
            FROM UsuariosFrecuentes
            WHERE id = :NEW.id;

            IF v_existente = 0 THEN
                -- 3. Insertar el registro en UsuariosFrecuentes (¡Usando NULL para los datos faltantes!)
                INSERT INTO UsuariosFrecuentes (id, correo, celular, puntos)
                VALUES (
                    :NEW.id, 
                    NULL,   -- CORRECCIÓN: Se usa NULL porque :NEW.correo no existe en UsuariosInvitados
                    NULL,   -- CORRECCIÓN: Se usa NULL porque :NEW.celular no existe en UsuariosInvitados
                    0
                );

                -- 4. Guardar el ID para eliminarlo después del UPDATE
                v_idx := PKG_TRG_PROMOVER_HELPER.g_ids_a_eliminar.COUNT + 1;
                PKG_TRG_PROMOVER_HELPER.g_ids_a_eliminar(v_idx) := :NEW.id;
            END IF;
        END IF;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        -- 5. Eliminar los IDs guardados (Ocurre aquí para evitar el error de tabla mutante)
        IF PKG_TRG_PROMOVER_HELPER.g_ids_a_eliminar.COUNT > 0 THEN
            FOR i IN PKG_TRG_PROMOVER_HELPER.g_ids_a_eliminar.FIRST .. PKG_TRG_PROMOVER_HELPER.g_ids_a_eliminar.LAST LOOP
                DELETE FROM UsuariosInvitados
                WHERE id = PKG_TRG_PROMOVER_HELPER.g_ids_a_eliminar(i);
            END LOOP;
        END IF;
        
        PKG_TRG_PROMOVER_HELPER.g_ids_a_eliminar.DELETE;
    END AFTER STATEMENT;

END trg_promover_a_frecuente;
/
--Registro: Un usuario invitado no puede recibir Beneficios

--------------------------------------------------------------------------------
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


CREATE OR REPLACE TRIGGER trg_actualizar_participantesYPozo
AFTER INSERT ON Participantes
FOR EACH ROW
DECLARE
    v_jugadores_actuales NUMBER;
    v_pozo_premios      NUMBER;
    v_valor_entrada     NUMBER;
BEGIN
    -- 1. Actualizar jugadoresActuales
    -- Obtener el valor actual de jugadoresActuales para el torneo
    SELECT NVL(jugadoresActuales, 0) INTO v_jugadores_actuales
    FROM Torneos
    WHERE id = :NEW.torneo;

    -- Incrementar jugadoresActuales
    UPDATE Torneos
    SET jugadoresActuales = v_jugadores_actuales + 1
    WHERE id = :NEW.torneo;

    -- 2. Actualizar pozoDePremios
    -- Obtener el valor de entrada y el pozo de premios del torneo
    SELECT valorEntrada, pozoDePremios INTO v_valor_entrada, v_pozo_premios
    FROM Torneos
    WHERE id = :NEW.torneo;

    -- Incrementar el pozo de premios en un 90% del valor de entrada
    UPDATE Torneos
    SET pozoDePremios = v_pozo_premios + (v_valor_entrada * 0.9)
    WHERE id = :NEW.torneo;

    COMMIT;
END;
/



--------------------------------------------------------------------------------
-- TRIGGER: Un usuario No se puede registrar en un torneo que no esté activo
--------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER trg_comprobar_estado_torneo
BEFORE INSERT ON Participantes
FOR EACH ROW
DECLARE
    v_estado_torneo VARCHAR2(20);
BEGIN
    -- Obtener el estado del torneo
    SELECT estado INTO v_estado_torneo
    FROM Torneos
    WHERE id = :NEW.torneo;

    -- Comprobar si el estado del torneo es 'Activo'
    IF v_estado_torneo != 'Activo' THEN
        -- Si no está activo, generar un error
        RAISE_APPLICATION_ERROR(-20001, 'No se puede registrar en un torneo que no esté activo.');
    END IF;
END;
/

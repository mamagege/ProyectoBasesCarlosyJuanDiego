--Pruebas de Aceptación

--1


--Juan Diego Gaitán que estudia Ing en Sistemas en la Escuela Julio Garavito sale de su parcial de Bases de Datos y sale contento pues respondió todo bien. 
--Cuando recibe los resultados, saca 5 por lo que decide celebrar con sus amigos en la 85.
--Cuando están allá deciden apostar un poco en el Casino Luckia con sus amigos y se registran.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

--El Cajero registra el nombre de los nuevos jugadores y los registra como su primera visita.


BEGIN 
PCK_CAJERO.registrar_nuevo_invitado('Juan Diego Gaitán');
PCK_CAJERO.registrar_nuevo_invitado('Carlos Sanchez');
PCK_CAJERO.registrar_nuevo_invitado('Pedro Ayala');
PCK_CAJERO.registrar_visita_usuario(69);
PCK_CAJERO.registrar_visita_usuario(70);
PCK_CAJERO. registrar_visita_usuario(71);
END;


--Luego cada uno decide comprar fichas para apostar. Cada uno decide gastarse 500.000 pesos y entre ellos competir por quien gana más.
--El cajero registra las compras de fichas de cada uno.
BEGIN
    PCK_CAJERO.registrar_cambio_fichas(500000,69,31,'Dinero');
    PCK_CAJERO.registrar_cambio_fichas(500000,70,31,'Dinero');
END;



EXECUTE PCK_CAJERO.registrar_cambio_fichas(500000,71,31,'Billetes');

--Juan Pérez se da cuenta que al usuario 3 le puso un valor incorrecto en cajaRecibe por lo que el sistema no lo permite.
--Esto gracias a la CONSTRAINT ck_TrecibeDinero en CambioFichas
-- ALTER TABLE CambioFichas ADD CONSTRAINT ck_Trecibe
--CHECK (cajaRecibe IN ('Dinero','Fichas'));

--Así pues corrige el error y registra la compra de fichas de Pedro Ayala.

EXECUTE PCK_CAJERO.registrar_cambio_fichas(500000,71,31,'Dinero');

--Cada uno de los amigos se dirige a una mesa diferente para apostar.

--Pero, Pedro Ayala, por los inconvenientes del cajero, llama al administrador y reclama por algún beneficio por las molestias.
--El administrador intenta darle un beneficio pero el sistema no lo permite pues no es un usuario frecuente.

EXECUTE PCK_ADM_SISTEMA.asignar_beneficio_a_frecuente(31,71);

INSERT INTO Beneficios (requisito, descripcion) VALUES ('100 puntos', '1 bebida gratis');



--TRIGGER: trg_evitar_beneficios_invitados

--El primero en apostar en Juan Diego y decide ir por Blackjack. 

--Apuesta 100.000 a una mano.





BEGIN
PCK_DEALER.registrar_apuesta(100000,69,37);

----Juan Diego gana la mano y recibe 200.000 pesos.

PCK_DEALER.finalizar_apuesta(63, 'Ganada');


--Sigue apostando y pierde 3 y gana 2. 

PCK_DEALER.registrar_apuesta(150000,69,37);
PCK_DEALER.finalizar_apuesta(64, 'Perdida');
PCK_DEALER.registrar_apuesta(200000,69,37);
PCK_DEALER.finalizar_apuesta(65, 'Ganada');
PCK_DEALER.registrar_apuesta(100000,69,37);
PCK_DEALER.finalizar_apuesta(66, 'Perdida');
PCK_DEALER.registrar_apuesta(50000,69,37);
PCK_DEALER.finalizar_apuesta(67, 'Ganada');

END;


--Como ganó tanto decide darle propina al dealer y el dealer como agradecimiento le cambia una apuesta de perdida a ganada.
--El sistema no lo permite pues las visitas solo las puede registrar el cajero.
--Trigger que actúa: trg_control_estado_apuesta

EXECUTE PCK_DEALER.finalizar_apuesta(66, 'Ganada');

--Al manager del casino le aparece que el dealer intentó hacer eso y decide llamarlo para recordarle sus funciones, asi que le dice que cierre la mesa. 

EXECUTE PCK_DEALER.actualizar_estado_mesa(37, 'Cerrada');


--El cajero se pone grosero con el administrador y el administrador decide despedirlo. 


EXECUTE PCK_ADM_SISTEMA.eliminar_empleado(32);


--El siguiente en apostar en Carlos Sanchez quien decide jugar Ruleta. Le va muy bien y todos a su alrededor lo ven con admiración y misterio.

BEGIN 
    PCK_DEALER.registrar_apuesta(200000,70,37);
    PCK_DEALER.finalizar_apuesta(65, 'Ganada');
    PCK_DEALER.registrar_apuesta(300000,70,37);
    PCK_DEALER.finalizar_apuesta(66, 'Ganada');
    PCK_DEALER.registrar_apuesta(200000,70,37);
    PCK_DEALER.finalizar_apuesta(67, 'Ganada');
    PCK_DEALER.registrar_apuesta(300000,70,37);
    PCK_DEALER.finalizar_apuesta(68, 'Ganada');
END;

--Todos están alucinados con la suerte de Carlos Sanchez quien decide retirarse con sus ganancias. 

--El administrador decide revisar las cámaras de seguridad y nota algo extraño en esa mesa. Por lo que decide cerrarla por mantenimiento y le dice al dealer de esa mesa.

EXECUTE PCK_DEALER.actualizar_estado_mesa(37, 'En mantenimiento');


--Finalmente descubre una irreguralidad en la ruleta y decide eliminar esa mesa definitivamente del casino.


EXECUTE PCK_ADM_SISTEMA.eliminar_mesa(38);


--Pedro Ayala fue el primero en perder todo lo que tenía así pues decide revisar su historial. 

VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_USUARIO.consultar_mi_historial_apuestas(p_usuario_id => 70);
PRINT c_resultado;


--Finalmente Carlos Sanchez y Juan Diego deciden cambiar sus fichas y ver quién fue el ganador final de la noche.

BEGIN
    PCK_CAJERO.registrar_cambio_fichas(1300000,70,31,'Fichas');
    PCK_CAJERO.registrar_cambio_fichas(100000,69,31,'Fichas');
END;

--Así pues el balance de cada uno se ve modificado. 

--------------------------------------------------------------------------------
-- TRIGGER: Actualización automática de balance según transacción de fichas
--------------------------------------------------------------------------------

--Carlos Sanchez fue el ganador de la noche con un balance mayor a los demás y Juan Diego terminó con un balance menor al que tenía.
--Así pues deciden retirarse felices del casino tras una noche de apuestas y diversión.


--2



BEGIN
    FOR i IN 1..9 LOOP
        PCK_CAJERO.registrar_visita_usuario(69);
        PCK_CAJERO.registrar_visita_usuario(70);
        PCK_CAJERO.registrar_visita_usuario(71);
    END LOOP;
END;


--Cuando llegan a las 10 visitas sistema automaticamente los promueve a usuarios frecuentes
----------------------------------------------------------------------------------
-- TRIGGER: Promover automáticamente a Usuario Frecuente
--------------------------------------------------------------------------------
--Trigger: trg_promover_a_frecuente
--
--Así pues el administrador les pide los nuevos datos para empezar a ganar puntos
BEGIN
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(69, 'Juan Diego Gaitán','juandiego@gmail.com', 2001234567);
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(70, 'Carlos Sánchez','juandiego@gmail.com', 2001234567);
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(71, 'Pedro Ayala','pedritoxxx@gmail.com', 2001234587);
END;


--El sistema no permite que se agregue el mismo correo a diferentes usuarios frecuentes.
--Restricción UNIQUE en USUARIOSFRECUENTES(correo, celular)

BEGIN
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(69, 'Juan Diego Gaitán','juandiego@gmail.com', 2001234567);
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(70, 'Carlos Sánchez','juandiego@gmail.com', 2001234567);
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(71, 'Pedro Ayala','pedritoxxx@gmail.com', 2001234567);
END;

--Por lo que deben poner diferentes correos y celulares.

BEGIN
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(69, 'Juan Diego Gaitán','juandiego@gmail.com', 2001642341);
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(70, 'Carlos Sánchez','sanchezito321@gmail.com', 2001234867);
    PCK_ADM_SISTEMA.actualizar_datos_usuario_frecuente(71, 'Pedro Ayala','pedritoxxx@gmail.com', 2001334567);
END;


--Como regalo de bienvenido, el administrador les asigna un beneficio a cada uno.

BEGIN
    PCK_ADM_SISTEMA.crear_beneficio('Ser usuario frecuente por primera vez', '10% de descuento en la compra de fichas');
    PCK_ADM_SISTEMA.asignar_beneficio_a_frecuente(32, 69);
    PCK_ADM_SISTEMA.asignar_beneficio_a_frecuente(32, 70);
    PCK_ADM_SISTEMA.asignar_beneficio_a_frecuente(32, 71);
END;

--Así pues todos felices empiezan a jugar y a cambiar su dinero nuevamente en la caja.
--Luego de una larga jornada de apuestas, el administrador decide darle un premio al cajero que haya generado más cambios. 
--Por lo que empiezan a revisar su historial de trsansacciones.


VAR c_resultado REFCURSOR
EXEC :c_resultado := PCK_cajero.consultar_transacciones_turno(31, 'Tarde')
PRINT c_resultado;

VAR c_resultado REFCURSOR
EXEC :c_resultado := PCK_cajero.consultar_transacciones_turno(31, 'Manana')
PRINT c_resultado;


--Finalmente deciden darle el premio al cajero 31 de la Mañana por haber generado más apuestas en su turno de la tarde y decide verificar esto con una consulta de vistas e indices.

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
--Prueba de aceptacion CICLO 2
--Carlos Gaitan y Juan Sanchez estan aburridos en vacaciones de la universidad y trabajaron la semana anterior, entonces tienen dinero
--Deciden ir a apostar jugando poker en el casino Luckia, ubicado en la calle 85.
--Ambos se registran y compran fichas. Se dan cuenta que as mesas para apostar estan llenas asi que deciden inscribirse a un torneo


--Como no habian venido antes, el cajero los registra y registra su visita

-- 1. Creación de usuarios para Carlos Gaitan y Juan Sanchez
BEGIN
    -- Registro de Carlos Gaitan como invitado
    PCK_CAJERO.registrar_nuevo_invitado('Carlos Gaitan');
    -- Registro de Juan Sanchez como invitado
    PCK_CAJERO.registrar_nuevo_invitado('Juan Sanchez');
END;
/
-- 2. Registro de las visitas de los usuarios
BEGIN
    PCK_CAJERO.registrar_visita_usuario(21);  -- Carlos Gaitan
    PCK_CAJERO.registrar_visita_usuario(22);  -- Juan Sanchez
END;
/


-- Ambos amigos deciden gastar 100,000 en fichas que es el valor de la entrada al torneo

-- 3. Compra de fichas para los usuarios

BEGIN
    PCK_CAJERO.registrar_cambio_fichas(500000, 21, 1, 'Dinero');  -- Carlos Gaitan
    PCK_CAJERO.registrar_cambio_fichas(500000, 22, 1, 'Dinero');  -- Juan Sanchez
END;
/

-- 4. Creación de torneo de poker
BEGIN
    PCK_ADM_SISTEMA.crear_torneo(
        p_nombre => 'Torneo de Poker',
        p_fecha_inicio => TO_DATE('2025-12-01', 'YYYY-MM-DD'),
        p_fecha_fin => TO_DATE('2025-12-10', 'YYYY-MM-DD'),
        p_estado => 'Activo',
        p_pozo_premios => 0,
        p_juego => 1,  -- ID de juego Poker
        p_jugadores => 0,
        p_valor_entrada => 100000
    );
END;
/

-- 5. Registro de participantes en el torneo
BEGIN
    PCK_CAJERO.registrar_participante(6, 21, 'Inscrito');  -- Carlos Gaitan en el Torneo de Poker
    PCK_CAJERO.registrar_participante(6, 22, 'Inscrito');  -- Juan Sanchez en el Torneo de Poker
END;
/

-- 6. Comprobación de estado de torneo antes de inscripción (debe estar 'Activo')
BEGIN
    -- Este trigger asegurará que solo los torneos activos permitan inscripciones
    -- Si el torneo no está activo, se genera un error
    PCK_DEALER.registrar_apuesta(100000, 21, 5);  -- Carlos Gaitan hace una apuesta
END;
/

-- 7. Finalización del torneo (El ganador es asignado al finalizar el torneo)
BEGIN
    -- Supongamos que al final del torneo, Carlos Gaitan es el ganador
    PCK_USUARIO.actualizar_ganadores(6, 21, '1er Lugar - $1000', 1000);  -- Carlos gana el 1er lugar
END;
/

-- 8. Cierre del torneo
BEGIN
    PCK_ADM_SISTEMA.cerrar_torneo(6);  -- Cerrar el torneo de poker
END;
/
--Carlos Gaitan gana un premio de $1000000 de pesos
-- 9. Asignación de premio al ganador
BEGIN
    PCK_ADM_SISTEMA.actualizar_ganadores(6, 21, '1er Lugar - $1000000', 1000000);  -- Asignar el premio a Carlos
END;
/

-- 10. Ahora, Carlos Gaitan va a la caja a entregar el cheque por su premio
-- El sistema registra el cheque y suma el valor del premio a su balance
BEGIN
    PCK_CAJERO.registrar_cambio_fichas(1000, 69, 31, 'Cheque');  -- Carlos entrega el cheque para su premio
END;
/


--Los amigos quieren verificar sus balances para ver si se efectuo el cambio
-- 11. Verificación final de balances de los jugadores
VAR c_resultado REFCURSOR;
EXEC :c_resultado := PCK_CAJERO.consultar_saldo_usuario(21);  -- Balance de Carlos Gaitan
PRINT c_resultado;

EXEC :c_resultado := PCK_CAJERO.consultar_saldo_usuario(22);  -- Balance de Juan Sanchez
PRINT c_resultado;





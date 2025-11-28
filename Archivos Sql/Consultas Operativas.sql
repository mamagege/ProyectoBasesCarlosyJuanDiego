--Consultas Operativas

--/Usuario 

-- Consultar mi historial de apuestas

SELECT Usuarios.id, monto, fechaHora, estado FROM APUESTAS 
JOIN USUARIOS on Usuarios.id = usuarios.id
WHERE usuarios.id = 'Id del Usuario que quiere consultar'
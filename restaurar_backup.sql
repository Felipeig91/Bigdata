-- RESTAURAR EL BACKUP EN EL NUEVO CONTENEDOR

USE master;
GO

-- Esperar a que la BD se inicialice
WAITFOR DELAY '00:00:05';
GO

-- Obtener lista de archivos en el backup
RESTORE FILELISTONLY FROM DISK = '/var/opt/mssql/backup/BD_BigData_Relacional_Errores_FULL.bak';
GO

-- Restaurar la BD
RESTORE DATABASE BD_BigData_Relacional_Errores 
FROM DISK = '/var/opt/mssql/backup/BD_BigData_Relacional_Errores_FULL.bak'
WITH REPLACE, RECOVERY;
GO

-- Verificar que se restauró correctamente
SELECT 'BD Restaurada' AS Estado;
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
GO

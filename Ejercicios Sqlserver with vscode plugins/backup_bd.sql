-- BACKUP DE LA BASE DE DATOS BD_BigData_Relacional_Errores

USE master;
GO

BACKUP DATABASE BD_BigData_Relacional_Errores 
TO DISK = '/var/opt/mssql/backup/BD_BigData_Relacional_Errores_FULL.bak'
WITH INIT, COMPRESSION, STATS = 10;
GO

PRINT '✓ BACKUP COMPLETADO EXITOSAMENTE';
PRINT 'Ubicación: /var/opt/mssql/backup/BD_BigData_Relacional_Errores_FULL.bak';
GO

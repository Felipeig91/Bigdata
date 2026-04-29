USE BD_BigData_Relacional_Errores;
GO

-- Listar todas las tablas creadas
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'dbo' ORDER BY TABLE_NAME;
GO

-- Contar registros por tabla
SELECT 
    'Region' AS Tabla, COUNT(*) AS Registros FROM dbo.Region
UNION ALL SELECT 'Ciudad', COUNT(*) FROM dbo.Ciudad
UNION ALL SELECT 'Cliente', COUNT(*) FROM dbo.Cliente
UNION ALL SELECT 'Producto', COUNT(*) FROM dbo.Producto
UNION ALL SELECT 'Venta', COUNT(*) FROM dbo.Venta
UNION ALL SELECT 'DetalleVenta', COUNT(*) FROM dbo.DetalleVenta
UNION ALL SELECT 'CatalogoErroresEsperados', COUNT(*) FROM dbo.CatalogoErroresEsperados
ORDER BY Tabla;
GO

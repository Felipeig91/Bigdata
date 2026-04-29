-- ============================================
-- RESPUESTAS A LAS 15 PREGUNTAS - PREPARAR
-- ============================================
-- Asignatura: Big Data - Ingeniería en Informática
-- Universidad de Los Lagos
-- Tarea: Preparación y limpieza de datos

USE BD_BigData_Relacional_Errores;
GO

/*
================================================================================
PREGUNTA 1: Identificar las tablas que componen el modelo relacional y 
            explicar sus relaciones
================================================================================

TABLAS DEL MODELO RELACIONAL:

1. **Region** - Tabla maestra de regiones del país
   - Columnas: IdRegion (PK), NombreRegion
   - Relación: 1:N con Ciudad

2. **Ciudad** - Tabla de ciudades por región
   - Columnas: IdCiudad (PK), NombreCiudad, IdRegion (FK)
   - Relación: N:1 con Region, 1:N con Cliente

3. **Cliente** - Tabla de clientes
   - Columnas: IdCliente (PK), RutCliente, NombreCliente, EmailCliente, 
               TelefonoCliente, IdCiudad (FK)
   - Relación: N:1 con Ciudad, 1:N con Venta

4. **CategoriaProducto** - Tabla maestra de categorías
   - Columnas: IdCategoria (PK), NombreCategoria
   - Relación: 1:N con Producto

5. **Producto** - Tabla de productos
   - Columnas: IdProducto (PK), NombreProducto, IdCategoria (FK), PrecioLista
   - Relación: N:1 con CategoriaProducto, 1:N con DetalleVenta

6. **Vendedor** - Tabla de vendedores
   - Columnas: IdVendedor (PK), NombreVendedor
   - Relación: 1:N con Venta

7. **CanalVenta** - Tabla maestra de canales de venta
   - Columnas: IdCanal (PK), NombreCanal
   - Relación: 1:N con Venta

8. **EstadoVenta** - Tabla maestra de estados
   - Columnas: IdEstado (PK), NombreEstado
   - Relación: 1:N con Venta

9. **Venta** - Tabla de transacciones de ventas
   - Columnas: IdVenta (PK), NumeroVenta, FechaVenta, IdCliente (FK), 
               IdVendedor (FK), IdCanal (FK), IdEstado (FK), Observacion, FechaCarga
   - Relación: N:1 con Cliente, Vendedor, CanalVenta, EstadoVenta
               1:N con DetalleVenta

10. **DetalleVenta** - Tabla de ítems por venta (detalles)
    - Columnas: IdDetalle (PK), IdVenta (FK), IdProducto (FK), Cantidad, 
                PrecioUnitario, TotalLinea
    - Relación: N:1 con Venta y Producto

11. **CatalogoErroresEsperados** - Tabla de referencia de errores conocidos
    - Columnas: IdError (PK), TablaAfectada, Campo, TipoError, Descripcion
    - Relación: Tabla informativa sin relaciones de clave foránea
*/

-- Listar todas las tablas y verificar la estructura
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'dbo'
ORDER BY TABLE_NAME;
GO

-- Mostrar conteo de registros por tabla
    SELECT
        'Region' AS Tabla, COUNT(*) AS Registros
    FROM dbo.Region
UNION ALL
    SELECT 'Ciudad', COUNT(*)
    FROM dbo.Ciudad
UNION ALL
    SELECT 'Cliente', COUNT(*)
    FROM dbo.Cliente
UNION ALL
    SELECT 'CategoriaProducto', COUNT(*)
    FROM dbo.CategoriaProducto
UNION ALL
    SELECT 'Producto', COUNT(*)
    FROM dbo.Producto
UNION ALL
    SELECT 'Vendedor', COUNT(*)
    FROM dbo.Vendedor
UNION ALL
    SELECT 'CanalVenta', COUNT(*)
    FROM dbo.CanalVenta
UNION ALL
    SELECT 'EstadoVenta', COUNT(*)
    FROM dbo.EstadoVenta
UNION ALL
    SELECT 'Venta', COUNT(*)
    FROM dbo.Venta
UNION ALL
    SELECT 'DetalleVenta', COUNT(*)
    FROM dbo.DetalleVenta
ORDER BY Tabla;
GO

/*
================================================================================
PREGUNTA 2: Dibujar el modelo relacional a partir de las claves primarias 
            y foráneas
================================================================================

Diagrama ER (Entity-Relationship):

                     ┌─────────────┐
                     │   Region    │
                     ├─────────────┤
                     │ PK: IdRegion│
                     │    Nombre   │
                     └─────────────┘
                            │
                            │ 1:N
                            ▼
                     ┌─────────────┐
                     │   Ciudad    │
                     ├─────────────┤
                     │ PK: IdCiudad│
                     │ FK: IdRegion│
                     │    Nombre   │
                     └─────────────┘
                            │
                            │ 1:N
                            ▼
                     ┌──────────────┐
                     │   Cliente    │
                     ├──────────────┤
                     │ PK: IdCliente│
                     │ FK: IdCiudad │
                     │   Rut, Email │
                     │   Teléfono   │
                     └──────────────┘
                            │
                            │ 1:N
                            ▼
                    ┌───────────────┐
                    │     Venta     │
                    ├───────────────┤
                    │  PK: IdVenta  │
                    │ FK: IdCliente │
                    │ FK: IdVendedor│
                    │  FK: IdCanal  │
                    │ FK: IdEstado  │
                    │ Número, Fecha │
                    └───────────────┘
                            │
                            │ 1:N
                            ▼
                    ┌────────────────┐
                    │  DetalleVenta  │
                    ├────────────────┤
                    │ PK: IdDetalle  │
                    │ FK: IdVenta    │
                    │ FK: IdProducto │
                    │ Cantidad, Total│
                    └────────────────┘
                            │
                            └─────────────┐
                                          │ N:1
                                          ▼
                              ┌──────────────────┐
                              │   Producto       │
                              ├──────────────────┤
                              │ PK: IdProducto  │
                              │ FK: IdCategoria │
                              │    Nombre       │
                              │    PrecioLista  │
                              └──────────────────┘
                                          │
                                          │ N:1
                                          ▼
                              ┌──────────────────┐
                              │CategoriaProducto│
                              ├──────────────────┤
                              │ PK: IdCategoria│
                              │    Nombre       │
                              └──────────────────┘


OTRAS RELACIONES:
- Vendedor 1:N Venta (FK: IdVendedor)
- CanalVenta 1:N Venta (FK: IdCanal)
- EstadoVenta 1:N Venta (FK: IdEstado)
*/

-- Consultar las relaciones de clave foránea
SELECT
    t1.name AS TablaOrigen,
    c1.name AS CampoOrigen,
    t2.name AS TablaDestino,
    c2.name AS CampoDestino,
    fk.name AS NombreConstraint
FROM sys.foreign_keys AS fk
    INNER JOIN sys.tables AS t1 ON fk.parent_object_id = t1.object_id
    INNER JOIN sys.columns AS c1 ON fk.parent_column_id = c1.column_id AND c1.object_id = t1.object_id
    INNER JOIN sys.tables AS t2 ON fk.referenced_object_id = t2.object_id
    INNER JOIN sys.columns AS c2 ON fk.referenced_column_id = c2.column_id AND c2.object_id = t2.object_id
WHERE t1.schema_id = SCHEMA_ID('dbo')
ORDER BY TablaOrigen, NombreConstraint;
GO

/*
================================================================================
PREGUNTA 3: Detectar clientes con RUT duplicado lógico, ignorando puntos, 
            comas y guiones
================================================================================
*/

-- Función auxiliar para normalizar RUT (remover puntos, comas, guiones)
CREATE OR ALTER FUNCTION dbo.NormalizarRut(@rut VARCHAR(20))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @rutNormalizado VARCHAR(20);
    SET @rutNormalizado = REPLACE(REPLACE(REPLACE(@rut, '.', ''), ',', ''), '-', '');
    RETURN @rutNormalizado;
END;
GO

-- Consulta para detectar RUT duplicados lógicos
SELECT
    dbo.NormalizarRut(RutCliente) AS RutNormalizado,
    COUNT(DISTINCT IdCliente) AS CantidadClientes,
    STRING_AGG(CAST(IdCliente AS VARCHAR(10)), ', ') AS IdClientes,
    STRING_AGG(RutCliente, ' | ') AS VariantesRut,
    STRING_AGG(NombreCliente, ' | ') AS Nombres,
    STRING_AGG(EmailCliente, ' | ') AS Emails
FROM dbo.Cliente
WHERE RutCliente IS NOT NULL
GROUP BY dbo.NormalizarRut(RutCliente)
HAVING COUNT(DISTINCT IdCliente) > 1
ORDER BY CantidadClientes DESC;
GO

-- Análisis detallado de duplicados
SELECT
    dbo.NormalizarRut(RutCliente) AS RutNormalizado,
    IdCliente,
    RutCliente,
    NombreCliente,
    EmailCliente,
    TelefonoCliente,
    IdCiudad
FROM dbo.Cliente
WHERE dbo.NormalizarRut(RutCliente) IN (
    SELECT dbo.NormalizarRut(RutCliente)
FROM dbo.Cliente
WHERE RutCliente IS NOT NULL
GROUP BY dbo.NormalizarRut(RutCliente)
HAVING COUNT(DISTINCT IdCliente) > 1
)
ORDER BY RutNormalizado, IdCliente;
GO

/*
================================================================================
PREGUNTA 4: Detectar emails inválidos y proponer una regla de validación
================================================================================
*/

-- Función para validar email (regla simple)
CREATE OR ALTER FUNCTION dbo.EsEmailValido(@email VARCHAR(150))
RETURNS BIT
AS
BEGIN
    DECLARE @esValido BIT = 0;

    IF @email IS NOT NULL
        AND CHARINDEX('@', @email) > 1
        AND CHARINDEX('@', @email) < LEN(@email)
        AND CHARINDEX('.', @email, CHARINDEX('@', @email)) > CHARINDEX('@', @email)
        AND @email NOT LIKE '% %'
        AND CHARINDEX('@', REVERSE(@email)) > 2
    BEGIN
        SET @esValido = 1;
    END;

    RETURN @esValido;
END;
GO

-- Detectar emails inválidos
SELECT
    IdCliente,
    RutCliente,
    NombreCliente,
    EmailCliente,
    dbo.EsEmailValido(EmailCliente) AS EsValido,
    CASE 
        WHEN EmailCliente IS NULL THEN 'Email nulo'
        WHEN CHARINDEX('@', EmailCliente) = 0 THEN 'Sin arroba (@)'
        WHEN CHARINDEX('.', EmailCliente, CHARINDEX('@', EmailCliente)) = 0 THEN 'Sin punto después de arroba'
        WHEN EmailCliente LIKE '% %' THEN 'Contiene espacios'
        ELSE 'Posiblemente válido'
    END AS ProblemaDetectado,
    COUNT(*) OVER (PARTITION BY dbo.EsEmailValido(EmailCliente)) AS CantidadEnCategoria
FROM dbo.Cliente
ORDER BY EsValido, EmailCliente;
GO

-- Resumen de emails inválidos
SELECT
    CASE 
        WHEN EmailCliente IS NULL THEN 'Email nulo'
        WHEN CHARINDEX('@', EmailCliente) = 0 THEN 'Sin arroba (@)'
        WHEN CHARINDEX('.', EmailCliente, CHARINDEX('@', EmailCliente)) = 0 THEN 'Sin punto después de arroba'
        WHEN EmailCliente LIKE '% %' THEN 'Contiene espacios'
        ELSE 'Posiblemente válido'
    END AS ProblemaDetectado,
    COUNT(*) AS CantidadClientes,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*)
    FROM dbo.Cliente) AS DECIMAL(5,2)) AS Porcentaje
FROM dbo.Cliente
GROUP BY 
    CASE 
        WHEN EmailCliente IS NULL THEN 'Email nulo'
        WHEN CHARINDEX('@', EmailCliente) = 0 THEN 'Sin arroba (@)'
        WHEN CHARINDEX('.', EmailCliente, CHARINDEX('@', EmailCliente)) = 0 THEN 'Sin punto después de arroba'
        WHEN EmailCliente LIKE '% %' THEN 'Contiene espacios'
        ELSE 'Posiblemente válido'
    END
ORDER BY CantidadClientes DESC;
GO

/*
REGLA DE VALIDACIÓN PROPUESTA:
- El email debe contener exactamente una arroba (@)
- La arroba no debe estar al inicio
- Debe haber al menos un punto después de la arroba
- No debe contener espacios en blanco
- Debe haber al menos 2 caracteres después del último punto (dominio)
- Patrón recomendado: ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$
*/

/*
================================================================================
PREGUNTA 5: Normalizar las categorías equivalentes en una nueva tabla limpia
================================================================================
*/

-- Ver categorías actuales y sus duplicados
SELECT
    IdCategoria,
    NombreCategoria,
    COUNT(*) OVER (PARTITION BY LOWER(TRIM(NombreCategoria))) AS CategoriasEquivalentes,
    COUNT(*) AS ProductosEnCategoria
FROM dbo.CategoriaProducto
    LEFT JOIN dbo.Producto ON CategoriaProducto.IdCategoria = Producto.IdCategoria
GROUP BY IdCategoria, NombreCategoria
ORDER BY LOWER(TRIM(NombreCategoria)), IdCategoria;
GO

-- Crear tabla de categorías normalizadas
CREATE TABLE dbo.CategoriaNormalizada
(
    IdCategoriaNormalizada INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoriaLimpia VARCHAR(80) NOT NULL UNIQUE,
    CategoriasOriginales VARCHAR(MAX),
    Descripcion VARCHAR(250)
);
GO

-- Insertar categorías normalizadas
INSERT INTO dbo.CategoriaNormalizada
    (NombreCategoriaLimpia, CategoriasOriginales, Descripcion)
VALUES
    ('Tecnología', 'Tecnologia, Tecnología, tecnologia, Electrónica', 'Artículos electrónicos y tecnológicos (notebooks, monitores, audífonos)'),
    ('Hogar', 'Hogar, hogar', 'Artículos para el hogar y muebles (sillas, mesas)'),
    ('Alimentos', 'Alimentos, Alimntos', 'Productos alimenticios y bebidas'),
    ('Vestuario', 'Vestuario, Ropa', 'Prendas de vestir y accesorios'),
    ('Sin Clasificar', 'NULL', 'Productos sin categoría asignada');
GO

-- Crear tabla de mapeo para actualizar productos
CREATE TABLE dbo.MapeoCategoriaProducto
(
    IdCategoriaOriginal INT,
    IdCategoriaNormalizada INT,
    FOREIGN KEY (IdCategoriaOriginal) REFERENCES dbo.CategoriaProducto(IdCategoria),
    FOREIGN KEY (IdCategoriaNormalizada) REFERENCES dbo.CategoriaNormalizada(IdCategoriaNormalizada)
);
GO

-- Insertar mapeos
INSERT INTO dbo.MapeoCategoriaProducto
VALUES
    (1, 1),
    -- Tecnologia -> Tecnología
    (2, 1),
    -- Tecnología -> Tecnología
    (3, 1),
    -- tecnologia -> Tecnología
    (4, 2),
    -- Hogar -> Hogar
    (5, 2),
    -- hogar -> Hogar
    (6, 3),
    -- Alimentos -> Alimentos
    (7, 3),
    -- Alimntos -> Alimentos
    (8, 4),
    -- Vestuario -> Vestuario
    (9, 4),
    -- Ropa -> Vestuario
    (10, 1); -- Electrónica -> Tecnología
GO

-- Ver resultado del mapeo
SELECT
    cp.IdCategoria,
    cp.NombreCategoria,
    cn.IdCategoriaNormalizada,
    cn.NombreCategoriaLimpia,
    COUNT(p.IdProducto) AS CantidadProductos
FROM dbo.CategoriaProducto cp
    LEFT JOIN dbo.MapeoCategoriaProducto m ON cp.IdCategoria = m.IdCategoriaOriginal
    LEFT JOIN dbo.CategoriaNormalizada cn ON m.IdCategoriaNormalizada = cn.IdCategoriaNormalizada
    LEFT JOIN dbo.Producto p ON cp.IdCategoria = p.IdCategoria
GROUP BY cp.IdCategoria, cp.NombreCategoria, cn.IdCategoriaNormalizada, cn.NombreCategoriaLimpia
ORDER BY cn.NombreCategoriaLimpia, cp.NombreCategoria;
GO

/*
================================================================================
PREGUNTA 6: Normalizar regiones equivalentes y corregir ciudades mal escritas
================================================================================
*/

-- Ver regiones actuales y sus problemas
SELECT
    IdRegion,
    NombreRegion,
    COUNT(c.IdCiudad) AS CantidadCiudades,
    STRING_AGG(DISTINCT c.NombreCiudad, ', '
) AS Ciudades
FROM dbo.Region r
LEFT JOIN dbo.Ciudad c ON r.IdRegion = c.IdRegion
GROUP BY IdRegion, NombreRegion
ORDER BY IdRegion;
GO

-- Crear tabla de regiones normalizadas
CREATE TABLE dbo.RegionNormalizada
(
    IdRegionNormalizada INT IDENTITY(1,1) PRIMARY KEY,
    NombreRegionLimpia VARCHAR(80) NOT NULL UNIQUE,
    RegionesOriginales VARCHAR(MAX),
    Descripcion VARCHAR(250)
);
GO

-- Insertar regiones normalizadas
INSERT INTO dbo.RegionNormalizada
    (NombreRegionLimpia, RegionesOriginales, Descripcion)
VALUES
    ('Metropolitana', 'Metropolitana, Region Metropolitana, RM', 'Región Metropolitana de Santiago'),
    ('Valparaíso', 'Valparaíso, Valparaiso', 'Región de Valparaíso'),
    ('Bío-Bío', 'Biobío, Bio Bio', 'Región del Bío-Bío'),
    ('Araucanía', 'Araucanía, Araucania', 'Región de la Araucanía'),
    ('Los Lagos', 'Los Lagos', 'Región de Los Lagos'),
    ('Sin Clasificar', 'Vacío o Nulo', 'Registros sin región asignada');
GO

-- Crear tabla de mapeo para regiones
CREATE TABLE dbo.MapeoRegionProducto
(
    IdRegionOriginal INT,
    IdRegionNormalizada INT,
    FOREIGN KEY (IdRegionOriginal) REFERENCES dbo.Region(IdRegion),
    FOREIGN KEY (IdRegionNormalizada) REFERENCES dbo.RegionNormalizada(IdRegionNormalizada)
);
GO

-- Insertar mapeos de regiones
INSERT INTO dbo.MapeoRegionProducto
VALUES
    (1, 1),
    -- Metropolitana
    (2, 1),
    -- Region Metropolitana
    (3, 1),
    -- RM
    (4, 2),
    -- Valparaíso
    (5, 2),
    -- Valparaiso
    (6, 3),
    -- Biobío
    (7, 3),
    -- Bio Bio
    (8, 4),
    -- Araucanía
    (9, 4),
    -- Araucania
    (10, 6),
    -- Vacío
    (11, 6),
    -- NULL
    (12, 5);  -- Los Lagos
GO

-- Crear tabla de ciudades normalizadas
CREATE TABLE dbo.CiudadNormalizada
(
    IdCiudadNormalizada INT IDENTITY(1,1) PRIMARY KEY,
    NombreCiudadLimpia VARCHAR(80) NOT NULL,
    IdRegionNormalizada INT NOT NULL,
    CiudadesOriginales VARCHAR(MAX),
    UNIQUE (NombreCiudadLimpia, IdRegionNormalizada),
    FOREIGN KEY (IdRegionNormalizada) REFERENCES dbo.RegionNormalizada(IdRegionNormalizada)
);
GO

-- Insertar ciudades normalizadas
INSERT INTO dbo.CiudadNormalizada
    (NombreCiudadLimpia, IdRegionNormalizada, CiudadesOriginales)
VALUES
    ('Santiago', 1, 'Santiago, Santigo'),
    ('Valparaíso', 2, 'Valparaíso'),
    ('Concepción', 3, 'Concepción, Concepcion'),
    ('Temuco', 4, 'Temuco'),
    ('Puerto Montt', 5, 'Puerto Montt'),
    ('Viña del Mar', 2, 'Viña del Mar'),
    ('Sin Clasificar', 6, 'Vacío o Nulo');
GO

-- Ver resultado
SELECT
    r.IdRegion,
    r.NombreRegion,
    rn.NombreRegionLimpia,
    c.IdCiudad,
    c.NombreCiudad,
    cn.NombreCiudadLimpia
FROM dbo.Region r
    LEFT JOIN dbo.MapeoRegionProducto mr ON r.IdRegion = mr.IdRegionOriginal
    LEFT JOIN dbo.RegionNormalizada rn ON mr.IdRegionNormalizada = rn.IdRegionNormalizada
    LEFT JOIN dbo.Ciudad c ON r.IdRegion = c.IdRegion
    LEFT JOIN dbo.CiudadNormalizada cn ON c.NombreCiudad LIKE CONCAT('%', REPLACE(cn.NombreCiudadLimpia, ' ', '%'), '%')
        OR c.NombreCiudad LIKE '%Santigo%'
ORDER BY rn.NombreRegionLimpia, cn.NombreCiudadLimpia;
GO

/*
================================================================================
PREGUNTA 7: Detectar ventas duplicadas por NumeroVenta
================================================================================
*/

-- Detectar números de venta duplicados
SELECT
    NumeroVenta,
    COUNT(*) AS CantidadVentas,
    STRING_AGG(CAST(IdVenta AS VARCHAR(10)), ', ') AS IdVentas,
    STRING_AGG(CAST(FechaVenta AS VARCHAR(10)), ' | ') AS Fechas,
    STRING_AGG(NombreCliente, ' | ') AS Clientes,
    COUNT(DISTINCT IdCliente) AS ClientesDiferentes
FROM dbo.Venta v
    LEFT JOIN dbo.Cliente c ON v.IdCliente = c.IdCliente
WHERE NumeroVenta IS NOT NULL
GROUP BY NumeroVenta
HAVING COUNT(*) > 1
ORDER BY CantidadVentas DESC;
GO

-- Detalle completo de duplicados
SELECT
    NumeroVenta,
    IdVenta,
    FechaVenta,
    IdCliente,
    NombreCliente,
    IdVendedor,
    IdCanal,
    IdEstado,
    COUNT(*) OVER (PARTITION BY NumeroVenta) AS DuplicadosDelNumero
FROM dbo.Venta v
    LEFT JOIN dbo.Cliente c ON v.IdCliente = c.IdCliente
WHERE NumeroVenta IN (
    SELECT NumeroVenta
FROM dbo.Venta
WHERE NumeroVenta IS NOT NULL
GROUP BY NumeroVenta
HAVING COUNT(*) > 1
)
ORDER BY NumeroVenta, IdVenta;
GO

-- Estadística de duplicados
    SELECT
        'Ventas sin número' AS Tipo,
        COUNT(*) AS Cantidad
    FROM dbo.Venta
    WHERE NumeroVenta IS NULL
UNION ALL
    SELECT
        'Ventas con número único',
        COUNT(DISTINCT NumeroVenta)
    FROM dbo.Venta
    WHERE NumeroVenta IS NOT NULL
UNION ALL
    SELECT
        'Números de venta duplicados',
        COUNT(DISTINCT NumeroVenta)
    FROM dbo.Venta
    WHERE NumeroVenta IN (
    SELECT NumeroVenta
    FROM dbo.Venta
    WHERE NumeroVenta IS NOT NULL
    GROUP BY NumeroVenta
    HAVING COUNT(*) > 1
);
GO

/*
================================================================================
PREGUNTA 8: Detectar ventas sin fecha o con fecha sospechosa
================================================================================
*/

-- Detectar problemas en fechas de venta
SELECT
    IdVenta,
    NumeroVenta,
    FechaVenta,
    FechaCarga,
    DATEDIFF(DAY, FechaVenta, GETDATE()) AS DiasAntiguedad,
    CASE 
        WHEN FechaVenta IS NULL THEN 'Fecha nula'
        WHEN YEAR(FechaVenta) < 2000 THEN 'Fecha sospechosa (anterior a 2000)'
        WHEN FechaVenta > GETDATE() THEN 'Fecha futura'
        WHEN DATEDIFF(DAY, FechaVenta, GETDATE()) > 1825 THEN 'Fecha muy antigua (>5 años)'
        ELSE 'Fecha válida'
    END AS ProblemaFecha,
    IdCliente
FROM dbo.Venta
ORDER BY FechaVenta, IdVenta;
GO

-- Resumen de problemas de fecha
SELECT
    CASE 
        WHEN FechaVenta IS NULL THEN 'Fecha nula'
        WHEN YEAR(FechaVenta) < 2000 THEN 'Fecha sospechosa (anterior a 2000)'
        WHEN FechaVenta > GETDATE() THEN 'Fecha futura'
        WHEN DATEDIFF(DAY, FechaVenta, GETDATE()) > 1825 THEN 'Fecha muy antigua (>5 años)'
        ELSE 'Fecha válida'
    END AS ProblemaFecha,
    COUNT(*) AS CantidadVentas,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*)
    FROM dbo.Venta) AS DECIMAL(5,2)) AS Porcentaje,
    MIN(FechaVenta) AS FechaMinima,
    MAX(FechaVenta) AS FechaMaxima
FROM dbo.Venta
GROUP BY
    CASE 
        WHEN FechaVenta IS NULL THEN 'Fecha nula'
        WHEN YEAR(FechaVenta) < 2000 THEN 'Fecha sospechosa (anterior a 2000)'
        WHEN FechaVenta > GETDATE() THEN 'Fecha futura'
        WHEN DATEDIFF(DAY, FechaVenta, GETDATE()) > 1825 THEN 'Fecha muy antigua (>5 años)'
        ELSE 'Fecha válida'
    END
ORDER BY CantidadVentas DESC;
GO

/*
================================================================================
PREGUNTA 9: Calcular el total correcto de cada línea y compararlo con TotalLinea
================================================================================
*/

-- Calcular discrepancias en totales de línea
SELECT
    dv.IdDetalle,
    dv.IdVenta,
    v.NumeroVenta,
    dv.IdProducto,
    p.NombreProducto,
    dv.Cantidad,
    dv.PrecioUnitario,
    dv.TotalLinea,
    (dv.Cantidad * dv.PrecioUnitario) AS TotalCalculado,
    CASE 
        WHEN dv.TotalLinea IS NULL THEN 'Total nulo'
        WHEN dv.Cantidad IS NULL OR dv.PrecioUnitario IS NULL THEN 'Datos faltantes'
        WHEN ABS((dv.Cantidad * dv.PrecioUnitario) - dv.TotalLinea) > 0.01 THEN 'Discrepancia'
        ELSE 'Correcto'
    END AS Estado,
    ABS(CAST(dv.TotalLinea AS DECIMAL(12,2)) - CAST((dv.Cantidad * dv.PrecioUnitario) AS DECIMAL(12,2))) AS Diferencia
FROM dbo.DetalleVenta dv
    LEFT JOIN dbo.Venta v ON dv.IdVenta = v.IdVenta
    LEFT JOIN dbo.Producto p ON dv.IdProducto = p.IdProducto
ORDER BY 
    CASE 
        WHEN dv.TotalLinea IS NULL THEN 1
        WHEN dv.Cantidad IS NULL OR dv.PrecioUnitario IS NULL THEN 2
        WHEN ABS((dv.Cantidad * dv.PrecioUnitario) - dv.TotalLinea) > 0.01 THEN 3
        ELSE 4
    END DESC,
    Diferencia DESC;
GO

-- Resumen de errores en cálculo de totales
SELECT
    CASE 
        WHEN dv.TotalLinea IS NULL THEN 'Total nulo'
        WHEN dv.Cantidad IS NULL OR dv.PrecioUnitario IS NULL THEN 'Datos faltantes para calcular'
        WHEN dv.Cantidad <= 0 THEN 'Cantidad inválida (<= 0)'
        WHEN dv.PrecioUnitario < 0 THEN 'Precio negativo'
        WHEN ABS((dv.Cantidad * dv.PrecioUnitario) - dv.TotalLinea) > 0.01 THEN 'Discrepancia en cálculo'
        ELSE 'Correcto'
    END AS ProblemaDetectado,
    COUNT(*) AS CantidadDetalles,
    CAST(COUNT(*) * 100.0 / (SELECT COUNT(*)
    FROM dbo.DetalleVenta) AS DECIMAL(5,2)) AS Porcentaje
FROM dbo.DetalleVenta dv
GROUP BY
    CASE 
        WHEN dv.TotalLinea IS NULL THEN 'Total nulo'
        WHEN dv.Cantidad IS NULL OR dv.PrecioUnitario IS NULL THEN 'Datos faltantes para calcular'
        WHEN dv.Cantidad <= 0 THEN 'Cantidad inválida (<= 0)'
        WHEN dv.PrecioUnitario < 0 THEN 'Precio negativo'
        WHEN ABS((dv.Cantidad * dv.PrecioUnitario) - dv.TotalLinea) > 0.01 THEN 'Discrepancia en cálculo'
        ELSE 'Correcto'
    END
ORDER BY CantidadDetalles DESC;
GO

/*
================================================================================
PREGUNTA 10: Crear una vista final llamada dbo.VentasBI_Limpias solo con 
             registros válidos
================================================================================
*/

-- Crear vista de ventas limpias
CREATE OR ALTER VIEW dbo.VentasBI_Limpias
AS
    SELECT
        v.IdVenta,
        v.NumeroVenta,
        v.FechaVenta,
        c.IdCliente,
        c.RutCliente AS RutClienteNormalizado,
        c.NombreCliente,
        c.EmailCliente,
        cn.NombreCiudadLimpia AS Ciudad,
        rn.NombreRegionLimpia AS Region,
        ve.NombreVendedor,
        ca.NombreCanal,
        es.NombreEstado,
        dv.IdProducto,
        p.NombreProducto,
        cn2.NombreCategoriaLimpia AS Categoria,
        dv.Cantidad,
        dv.PrecioUnitario,
        dv.TotalLinea,
        (dv.Cantidad * dv.PrecioUnitario) AS TotalLineaCalculado,
        v.FechaCarga
    FROM dbo.Venta v
        INNER JOIN dbo.Cliente c ON v.IdCliente = c.IdCliente
        LEFT JOIN dbo.Ciudad cu ON c.IdCiudad = cu.IdCiudad
        LEFT JOIN dbo.CiudadNormalizada cn ON cu.NombreCiudad LIKE CONCAT('%', REPLACE(cn.NombreCiudadLimpia, ' ', '%'), '%')
            OR cu.NombreCiudad LIKE '%Santigo%'
        LEFT JOIN dbo.RegionNormalizada rn ON cn.IdRegionNormalizada = rn.IdRegionNormalizada
        LEFT JOIN dbo.Vendedor ve ON v.IdVendedor = ve.IdVendedor
        LEFT JOIN dbo.CanalVenta ca ON v.IdCanal = ca.IdCanal
        LEFT JOIN dbo.EstadoVenta es ON v.IdEstado = es.IdEstado
        INNER JOIN dbo.DetalleVenta dv ON v.IdVenta = dv.IdVenta
        LEFT JOIN dbo.Producto p ON dv.IdProducto = p.IdProducto
        LEFT JOIN dbo.CategoriaNormalizada cn2 ON p.IdCategoria IN (
    SELECT IdCategoriaOriginal
        FROM dbo.MapeoCategoriaProducto
        WHERE IdCategoriaNormalizada = cn2.IdCategoriaNormalizada
)
    WHERE 
    -- Cliente válido
    c.RutCliente IS NOT NULL
        AND dbo.EsEmailValido(c.EmailCliente) = 1
        -- Venta válida
        AND v.NumeroVenta IS NOT NULL
        AND v.FechaVenta IS NOT NULL
        AND YEAR(v.FechaVenta) >= 2000
        AND v.FechaVenta <= GETDATE()
        -- Línea de venta válida
        AND dv.Cantidad > 0
        AND dv.PrecioUnitario > 0
        AND dv.TotalLinea IS NOT NULL
        AND ABS((dv.Cantidad * dv.PrecioUnitario) - dv.TotalLinea) <= 0.01;
GO

-- Verificar la vista
SELECT TOP 20
    *
FROM dbo.VentasBI_Limpias
ORDER BY FechaVenta DESC;
GO

-- Contar registros válidos vs. inválidos
    SELECT
        'Ventas totales' AS Tipo,
        COUNT(DISTINCT v.IdVenta) AS Cantidad
    FROM dbo.Venta v
UNION ALL
    SELECT
        'Ventas válidas (en VentasBI_Limpias)',
        COUNT(DISTINCT IdVenta)
    FROM dbo.VentasBI_Limpias
ORDER BY Tipo;
GO

/*
================================================================================
PREGUNTA 11: Calcular ventas por mes, región, categoría, vendedor y canal
================================================================================
*/

-- Ventas por mes (2023-2024)
SELECT
    DATEFROMPARTS(YEAR(v.FechaVenta), MONTH(v.FechaVenta), 1) AS MesVenta,
    COUNT(DISTINCT v.IdVenta) AS CantidadVentas,
    SUM(dv.TotalLinea) AS MontoTotal,
    COUNT(DISTINCT v.IdCliente) AS ClientesUnicos,
    CAST(SUM(dv.TotalLinea) / NULLIF(COUNT(DISTINCT v.IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta
FROM dbo.VentasBI_Limpias v
CROSS JOIN (SELECT 1 AS aux)
-- Dummy table to group by month
GROUP BY DATEFROMPARTS(YEAR(v.FechaVenta), MONTH(v.FechaVenta), 1)
ORDER BY MesVenta;
GO

-- Ventas por región
SELECT
    Region,
    COUNT(DISTINCT IdVenta) AS CantidadVentas,
    COUNT(DISTINCT IdCliente) AS ClientesUnicos,
    SUM(TotalLinea) AS MontoTotal,
    CAST(SUM(TotalLinea) / NULLIF(COUNT(DISTINCT IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta,
    CAST(COUNT(DISTINCT IdVenta) * 100.0 / (SELECT COUNT(DISTINCT IdVenta)
    FROM dbo.VentasBI_Limpias) AS DECIMAL(5,2)) AS PorcentajeVentas
FROM dbo.VentasBI_Limpias
WHERE Region IS NOT NULL
GROUP BY Region
ORDER BY MontoTotal DESC;
GO

-- Ventas por categoría
SELECT
    Categoria,
    COUNT(DISTINCT IdVenta) AS CantidadVentas,
    COUNT(DISTINCT IdProducto) AS ProductosVendidos,
    SUM(Cantidad) AS UnidadesVendidas,
    SUM(TotalLinea) AS MontoTotal,
    CAST(SUM(TotalLinea) / NULLIF(COUNT(DISTINCT IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta,
    CAST(COUNT(DISTINCT IdVenta) * 100.0 / (SELECT COUNT(DISTINCT IdVenta)
    FROM dbo.VentasBI_Limpias) AS DECIMAL(5,2)) AS PorcentajeVentas
FROM dbo.VentasBI_Limpias
WHERE Categoria IS NOT NULL
GROUP BY Categoria
ORDER BY MontoTotal DESC;
GO

-- Ventas por vendedor
SELECT
    NombreVendedor,
    COUNT(DISTINCT IdVenta) AS CantidadVentas,
    COUNT(DISTINCT IdCliente) AS ClientesAtendidos,
    SUM(TotalLinea) AS MontoTotal,
    CAST(SUM(TotalLinea) / NULLIF(COUNT(DISTINCT IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta,
    CAST(COUNT(DISTINCT IdVenta) * 100.0 / (SELECT COUNT(DISTINCT IdVenta)
    FROM dbo.VentasBI_Limpias) AS DECIMAL(5,2)) AS PorcentajeVentas
FROM dbo.VentasBI_Limpias
WHERE NombreVendedor IS NOT NULL
GROUP BY NombreVendedor
ORDER BY MontoTotal DESC;
GO

-- Ventas por canal
SELECT
    NombreCanal,
    COUNT(DISTINCT IdVenta) AS CantidadVentas,
    COUNT(DISTINCT IdCliente) AS ClientesUnicos,
    SUM(TotalLinea) AS MontoTotal,
    CAST(SUM(TotalLinea) / NULLIF(COUNT(DISTINCT IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta,
    CAST(COUNT(DISTINCT IdVenta) * 100.0 / (SELECT COUNT(DISTINCT IdVenta)
    FROM dbo.VentasBI_Limpias) AS DECIMAL(5,2)) AS PorcentajeVentas
FROM dbo.VentasBI_Limpias
WHERE NombreCanal IS NOT NULL
GROUP BY NombreCanal
ORDER BY MontoTotal DESC;
GO

/*
================================================================================
PREGUNTA 12: Calcular porcentaje de registros con errores sobre el total 
             de ventas
================================================================================
*/

-- Calcular porcentaje de errores globales
DECLARE @TotalVentas INT = (SELECT COUNT(*)
FROM dbo.Venta);
DECLARE @TotalDetalles INT = (SELECT COUNT(*)
FROM dbo.DetalleVenta);
DECLARE @VentasLimpias INT = (SELECT COUNT(DISTINCT IdVenta)
FROM dbo.VentasBI_Limpias);
DECLARE @DetallesLimpios INT = (SELECT COUNT(*)
FROM dbo.VentasBI_Limpias);

    SELECT
        'Ventas' AS Tipo,
        @TotalVentas AS Total,
        @VentasLimpias AS Válidas,
        (@TotalVentas - @VentasLimpias) AS ConErrores,
        CAST((@TotalVentas - @VentasLimpias) * 100.0 / NULLIF(@TotalVentas, 0) AS DECIMAL(5,2)) AS PorcentajeErrores
UNION ALL
    SELECT
        'Detalles de Venta',
        @TotalDetalles,
        @DetallesLimpios,
        (@TotalDetalles - @DetallesLimpios),
        CAST((@TotalDetalles - @DetallesLimpios) * 100.0 / NULLIF(@TotalDetalles, 0) AS DECIMAL(5,2))
GO

-- Análisis detallado de errores por tipo
    SELECT
        'Cliente sin RUT válido' AS TipoError,
        COUNT(DISTINCT v.IdVenta) AS VentasAfectadas
    FROM dbo.Venta v
        INNER JOIN dbo.Cliente c ON v.IdCliente = c.IdCliente
    WHERE c.RutCliente IS NULL OR dbo.NormalizarRut(c.RutCliente) IS NULL
UNION ALL
    SELECT
        'Cliente con email inválido',
        COUNT(DISTINCT v.IdVenta)
    FROM dbo.Venta v
        INNER JOIN dbo.Cliente c ON v.IdCliente = c.IdCliente
    WHERE dbo.EsEmailValido(c.EmailCliente) = 0
UNION ALL
    SELECT
        'Venta sin número',
        COUNT(*)
    FROM dbo.Venta
    WHERE NumeroVenta IS NULL
UNION ALL
    SELECT
        'Venta sin fecha válida',
        COUNT(*)
    FROM dbo.Venta
    WHERE FechaVenta IS NULL
        OR YEAR(FechaVenta) < 2000
        OR FechaVenta > GETDATE()
UNION ALL
    SELECT
        'Detalle con cantidad inválida',
        COUNT(*)
    FROM dbo.DetalleVenta
    WHERE Cantidad IS NULL OR Cantidad <= 0
UNION ALL
    SELECT
        'Detalle con precio inválido',
        COUNT(*)
    FROM dbo.DetalleVenta
    WHERE PrecioUnitario IS NULL OR PrecioUnitario <= 0
UNION ALL
    SELECT
        'Detalle con total inconsistente',
        COUNT(*)
    FROM dbo.DetalleVenta
    WHERE TotalLinea IS NULL
        OR ABS((Cantidad * PrecioUnitario) - TotalLinea) > 0.01
ORDER BY VentasAfectadas DESC;
GO

/*
================================================================================
PREGUNTA 13: Determinar qué vendedor tiene más ventas válidas pagadas
================================================================================
*/

-- Vendedores con más ventas pagadas
SELECT
    ve.NombreVendedor,
    COUNT(DISTINCT v.IdVenta) AS CantidadVentas,
    COUNT(DISTINCT v.IdCliente) AS ClientesUnicos,
    SUM(dv.TotalLinea) AS MontoTotal,
    CAST(SUM(dv.TotalLinea) / NULLIF(COUNT(DISTINCT v.IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta,
    MAX(v.FechaVenta) AS UltimaVenta
FROM dbo.VentasBI_Limpias v
    LEFT JOIN dbo.Vendedor ve ON v.IdVendedor = ve.IdVendedor
WHERE v.NombreEstado IN ('Pagada', 'PAGADA', 'pagado')
GROUP BY ve.NombreVendedor
ORDER BY CantidadVentas DESC;
GO

-- Ranking de vendedores por monto
SELECT
    ROW_NUMBER() OVER (ORDER BY SUM(dv.TotalLinea) DESC) AS Ranking,
    ve.NombreVendedor,
    COUNT(DISTINCT v.IdVenta) AS CantidadVentas,
    SUM(dv.TotalLinea) AS MontoTotal,
    CAST(SUM(dv.TotalLinea) / NULLIF(COUNT(DISTINCT v.IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta
FROM dbo.VentasBI_Limpias v
    LEFT JOIN dbo.Vendedor ve ON v.IdVendedor = ve.IdVendedor
WHERE v.NombreEstado IN ('Pagada', 'PAGADA', 'pagado')
GROUP BY ve.NombreVendedor
ORDER BY Ranking;
GO

/*
================================================================================
PREGUNTA 14: Comparar ventas pagadas, anuladas, pendientes y rechazadas 
             considerando estados equivalentes
================================================================================
*/

-- Normalizar estados y comparar
CREATE TABLE dbo.EstadoNormalizado
(
    IdEstadoNormalizado INT IDENTITY(1,1) PRIMARY KEY,
    NombreEstadoLimpio VARCHAR(40) NOT NULL UNIQUE,
    EstadosOriginales VARCHAR(MAX),
    Descripcion VARCHAR(250)
);
GO

INSERT INTO dbo.EstadoNormalizado
    (NombreEstadoLimpio, EstadosOriginales, Descripcion)
VALUES
    ('Pagada', 'Pagada, PAGADA, pagado', 'Ventas completamente pagadas'),
    ('Pendiente', 'Pendiente, pend.', 'Ventas pendientes de pago'),
    ('Anulada', 'Anulada', 'Ventas anuladas'),
    ('Rechazada', 'Rechazada', 'Ventas rechazadas'),
    ('Sin Clasificar', 'Vacío o Nulo', 'Ventas sin estado definido');
GO

-- Comparativa de ventas por estado
SELECT
    CASE 
        WHEN es.NombreEstado IN ('Pagada', 'PAGADA', 'pagado') THEN 'Pagada'
        WHEN es.NombreEstado IN ('Pendiente', 'pend.') THEN 'Pendiente'
        WHEN es.NombreEstado = 'Anulada' THEN 'Anulada'
        WHEN es.NombreEstado = 'Rechazada' THEN 'Rechazada'
        WHEN es.NombreEstado IN ('', NULL) THEN 'Sin Clasificar'
        ELSE 'Cancelada'
    END AS EstadoNormalizado,
    COUNT(DISTINCT v.IdVenta) AS CantidadVentas,
    COUNT(DISTINCT v.IdCliente) AS ClientesUnicos,
    SUM(dv.TotalLinea) AS MontoTotal,
    CAST(SUM(dv.TotalLinea) / NULLIF(COUNT(DISTINCT v.IdVenta), 0) AS DECIMAL(12,2)) AS PromedioPorVenta,
    CAST(COUNT(DISTINCT v.IdVenta) * 100.0 / (SELECT COUNT(DISTINCT IdVenta)
    FROM dbo.Venta) AS DECIMAL(5,2)) AS PorcentajeVentas
FROM dbo.Venta v
    LEFT JOIN dbo.EstadoVenta es ON v.IdEstado = es.IdEstado
    LEFT JOIN dbo.DetalleVenta dv ON v.IdVenta = dv.IdVenta
GROUP BY 
    CASE 
        WHEN es.NombreEstado IN ('Pagada', 'PAGADA', 'pagado') THEN 'Pagada'
        WHEN es.NombreEstado IN ('Pendiente', 'pend.') THEN 'Pendiente'
        WHEN es.NombreEstado = 'Anulada' THEN 'Anulada'
        WHEN es.NombreEstado = 'Rechazada' THEN 'Rechazada'
        WHEN es.NombreEstado IN ('', NULL) THEN 'Sin Clasificar'
        ELSE 'Cancelada'
    END
ORDER BY MontoTotal DESC;
GO

/*
================================================================================
PREGUNTA 15: Proponer reglas de calidad de datos para evitar que estos 
             errores vuelvan a ocurrir
================================================================================

REGLAS DE CALIDAD DE DATOS PROPUESTAS:

1. CLIENTES
   ├─ RUT Válido:
   │  ├─ Debe ser obligatorio (NOT NULL)
   │  ├─ Debe estar normalizado (sin puntos, comas, guiones al almacenar)
   │  ├─ Debe ser único en la tabla (crear índice UNIQUE)
   │  └─ Validar formato: 8 dígitos + guion + 1 dígito verificador (ej: 12345678-5)
   │
   ├─ Email Válido:
   │  ├─ Debe cumplir formato: usuario@dominio.extensión
   │  ├─ Crear trigger para validar antes de INSERT/UPDATE
   │  ├─ Convertir a minúsculas para evitar duplicados
   │  └─ Crear índice UNIQUE para evitar duplicación
   │
   ├─ Teléfono:
   │  ├─ Standarizar formato (ej: +56 9 XXXXXXXX)
   │  └─ Validar que sea numérico (sin caracteres especiales)
   │
   └─ Ciudad:
      ├─ Debe referenciar a una ciudad válida (FK)
      └─ No permitir ciudades nulas sin revisar

2. REGIONES Y CIUDADES
   ├─ Nombres normalizados (sin acentos inconsistentes)
   ├─ Crear tabla de mapeo para equivalencias
   ├─ Revisar ciudades mal escritas (ej: Santigo, Concepcion)
   └─ No permitir regiones/ciudades nulas

3. CATEGORÍAS Y PRODUCTOS
   ├─ Normalizar nombres de categorías en tabla de referencia
   ├─ Productos deben tener categoría válida (FK obligatorio)
   ├─ Precio debe ser > 0 (validar en stored procedure)
   └─ No permitir productos sin clasificar

4. VENTAS
   ├─ Número de venta:
   │  ├─ Obligatorio (NOT NULL)
   │  ├─ Único (crear índice UNIQUE)
   │  └─ Autogenerado por secuencia o trigger
   │
   ├─ Fecha de venta:
   │  ├─ Obligatoria (NOT NULL)
   │  ├─ Debe estar entre 2020 y fecha actual
   │  ├─ Validar en trigger
   │  └─ No permitir fechas futuras
   │
   ├─ Cliente:
   │  ├─ Obligatorio (NOT NULL)
   │  ├─ Debe existir en tabla Cliente (FK)
   │  └─ Cliente debe tener RUT y email válidos
   │
   ├─ Vendedor:
   │  ├─ Obligatorio (NOT NULL)
   │  ├─ Debe existir en tabla Vendedor (FK)
   │  └─ No permitir vendedores sin nombre
   │
   ├─ Canal:
   │  ├─ Obligatorio (NOT NULL)
   │  └─ Debe ser uno de los valores válidos (Web, Tienda, App, etc.)
   │
   └─ Estado:
      ├─ Obligatorio (NOT NULL)
      ├─ Debe ser uno de: Pagada, Pendiente, Anulada, Rechazada
      └─ Normalizar valores para evitar duplicados (Pagada=PAGADA=pagado)

5. DETALLES DE VENTA
   ├─ Cantidad:
   │  ├─ Obligatoria (NOT NULL)
   │  ├─ Debe ser > 0
   │  └─ Validar en trigger antes de INSERT/UPDATE
   │
   ├─ Precio unitario:
   │  ├─ Obligatorio (NOT NULL)
   │  ├─ Debe ser > 0
   │  └─ Validar decimales (máximo 2 posiciones)
   │
   ├─ Total línea:
   │  ├─ Obligatorio (NOT NULL)
   │  ├─ Debe = Cantidad * PrecioUnitario (validar en trigger)
   │  ├─ Usar computed column o trigger
   │  └─ Permitir variación de 0.01 por redondeos
   │
   └─ Producto:
      ├─ Obligatorio (NOT NULL)
      └─ Debe existir en tabla Producto (FK)

6. INTEGRIDAD REFERENCIAL
   ├─ Usar CASCADE para borrados de Vendedor, CanalVenta, EstadoVenta
   ├─ Usar RESTRICT para borrados de Producto (mantener histórico)
   └─ Crear índices en todas las claves foráneas para performance

7. IMPLEMENTACIÓN
   ├─ Crear triggers en todas las tablas principales
   ├─ Implementar stored procedures para INSERT/UPDATE validados
   ├─ Crear jobs para limpieza de duplicados
   ├─ Auditar cambios con tabla de bitácora
   └─ Reportes diarios de calidad de datos

*/

-- Crear tabla de auditoría para rastrear cambios
CREATE TABLE dbo.AuditoriaCalidadDatos
(
    IdAuditoria INT IDENTITY(1,1) PRIMARY KEY,
    FechaAuditoria DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TablaAfectada VARCHAR(50),
    TipoError VARCHAR(100),
    CantidadRegistros INT,
    Descripcion VARCHAR(500),
    SugerenciaCorrecion VARCHAR(MAX)
);
GO

-- Insertar resumen de problemas encontrados
INSERT INTO dbo.AuditoriaCalidadDatos
    (TablaAfectada, TipoError, CantidadRegistros, Descripcion, SugerenciaCorrecion)
    SELECT
        'Cliente' AS TablaAfectada,
        'RUT duplicado lógico' AS TipoError,
        COUNT(*) AS CantidadRegistros,
        'Se encontraron clientes con mismo RUT en diferentes formatos (con puntos, comas, sin guión)' AS Descripcion,
        'Normalizar todos los RUT al formato XX.XXX.XXX-X y validar unicidad' AS SugerenciaCorrecion
    FROM (
    SELECT dbo.NormalizarRut(RutCliente)
        FROM dbo.Cliente
        WHERE RutCliente IS NOT NULL
        GROUP BY dbo.NormalizarRut(RutCliente)
        HAVING COUNT(DISTINCT IdCliente) > 1
) AS Duplicados
UNION ALL
    SELECT 'Cliente', 'Email inválido', COUNT(*), 'Emails sin arroba, con espacios o dominio incompleto',
        'Crear trigger de validación y normalizar emails a minúsculas'
    FROM dbo.Cliente
    WHERE dbo.EsEmailValido(EmailCliente) = 0
UNION ALL
    SELECT 'Venta', 'NumeroVenta duplicado', COUNT(*), 'Números de venta duplicados en la tabla',
        'Usar secuencia/identity para generar automáticamente e implementar índice UNIQUE'
    FROM (SELECT NumeroVenta
        FROM dbo.Venta
        WHERE NumeroVenta IS NOT NULL
        GROUP BY NumeroVenta
        HAVING COUNT(*) > 1) AS Dup
UNION ALL
    SELECT 'Venta', 'Fecha faltante o sospechosa', COUNT(*), 'Fechas nulas o anteriores a 2000',
        'Hacer FechaVenta obligatoria y validar rango de fechas'
    FROM dbo.Venta
    WHERE FechaVenta IS NULL OR YEAR(FechaVenta) < 2000
UNION ALL
    SELECT 'DetalleVenta', 'Cantidad o precio inválido', COUNT(*), 'Cantidades <= 0 o precios negativos',
        'Crear trigger para validar que Cantidad > 0 y PrecioUnitario > 0'
    FROM dbo.DetalleVenta
    WHERE Cantidad IS NULL OR Cantidad <= 0 OR PrecioUnitario IS NULL OR PrecioUnitario < 0
UNION ALL
    SELECT 'DetalleVenta', 'Total línea inconsistente', COUNT(*), 'Discrepancia entre TotalLinea y Cantidad*Precio',
        'Usar computed column o trigger para calcular automáticamente el total'
    FROM dbo.DetalleVenta
    WHERE TotalLinea IS NULL OR ABS((Cantidad * PrecioUnitario) - TotalLinea) > 0.01;
GO

-- Ver resumen de auditoría
SELECT *
FROM dbo.AuditoriaCalidadDatos
ORDER BY FechaAuditoria DESC;
GO

PRINT '=== ANÁLISIS COMPLETO FINALIZADO ===';
PRINT 'Todas las preguntas han sido respondidas.';
PRINT 'Use las vistas y funciones creadas para análisis futuro.';
PRINT 'La vista dbo.VentasBI_Limpias contiene solo registros válidos.';
GO

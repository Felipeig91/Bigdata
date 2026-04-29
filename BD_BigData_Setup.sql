-- Script: Creación de BD_BigData_Relacional_Errores con datos de prueba

IF DB_ID('BD_BigData_Relacional_Errores') IS NOT NULL
BEGIN
    ALTER DATABASE BD_BigData_Relacional_Errores SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BD_BigData_Relacional_Errores;
END;
GO

CREATE DATABASE BD_BigData_Relacional_Errores;
GO

USE BD_BigData_Relacional_Errores;
GO

-- ============================================
-- CREAR TABLAS
-- ============================================

CREATE TABLE dbo.Region
(
    IdRegion INT IDENTITY(1,1) PRIMARY KEY,
    NombreRegion VARCHAR(80) NULL
);
GO

CREATE TABLE dbo.Ciudad
(
    IdCiudad INT IDENTITY(1,1) PRIMARY KEY,
    NombreCiudad VARCHAR(80) NULL,
    IdRegion INT NULL,
    CONSTRAINT FK_Ciudad_Region FOREIGN KEY (IdRegion) REFERENCES dbo.Region(IdRegion)
);
GO

CREATE TABLE dbo.Cliente
(
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    RutCliente VARCHAR(20) NULL,
    NombreCliente VARCHAR(120) NULL,
    EmailCliente VARCHAR(150) NULL,
    TelefonoCliente VARCHAR(30) NULL,
    IdCiudad INT NULL,
    CONSTRAINT FK_Cliente_Ciudad FOREIGN KEY (IdCiudad) REFERENCES dbo.Ciudad(IdCiudad)
);
GO

CREATE TABLE dbo.CategoriaProducto
(
    IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
    NombreCategoria VARCHAR(80) NULL
);
GO

CREATE TABLE dbo.Producto
(
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    NombreProducto VARCHAR(120) NULL,
    IdCategoria INT NULL,
    PrecioLista DECIMAL(12,2) NULL,
    CONSTRAINT FK_Producto_Categoria FOREIGN KEY (IdCategoria) REFERENCES dbo.CategoriaProducto(IdCategoria)
);
GO

CREATE TABLE dbo.Vendedor
(
    IdVendedor INT IDENTITY(1,1) PRIMARY KEY,
    NombreVendedor VARCHAR(100) NULL
);
GO

CREATE TABLE dbo.CanalVenta
(
    IdCanal INT IDENTITY(1,1) PRIMARY KEY,
    NombreCanal VARCHAR(40) NULL
);
GO

CREATE TABLE dbo.EstadoVenta
(
    IdEstado INT IDENTITY(1,1) PRIMARY KEY,
    NombreEstado VARCHAR(40) NULL
);
GO

CREATE TABLE dbo.Venta
(
    IdVenta INT IDENTITY(1,1) PRIMARY KEY,
    NumeroVenta VARCHAR(30) NULL,
    FechaVenta DATE NULL,
    IdCliente INT NULL,
    IdVendedor INT NULL,
    IdCanal INT NULL,
    IdEstado INT NULL,
    Observacion VARCHAR(250) NULL,
    FechaCarga DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (IdCliente) REFERENCES dbo.Cliente(IdCliente),
    CONSTRAINT FK_Venta_Vendedor FOREIGN KEY (IdVendedor) REFERENCES dbo.Vendedor(IdVendedor),
    CONSTRAINT FK_Venta_Canal FOREIGN KEY (IdCanal) REFERENCES dbo.CanalVenta(IdCanal),
    CONSTRAINT FK_Venta_Estado FOREIGN KEY (IdEstado) REFERENCES dbo.EstadoVenta(IdEstado)
);
GO

CREATE TABLE dbo.DetalleVenta
(
    IdDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IdVenta INT NOT NULL,
    IdProducto INT NULL,
    Cantidad INT NULL,
    PrecioUnitario DECIMAL(12,2) NULL,
    TotalLinea DECIMAL(12,2) NULL,
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (IdVenta) REFERENCES dbo.Venta(IdVenta),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (IdProducto) REFERENCES dbo.Producto(IdProducto)
);
GO

CREATE TABLE dbo.CatalogoErroresEsperados
(
    IdError INT IDENTITY(1,1) PRIMARY KEY,
    TablaAfectada VARCHAR(100),
    Campo VARCHAR(100),
    TipoError VARCHAR(150),
    Descripcion VARCHAR(500)
);
GO

-- ============================================
-- INSERTAR DATOS: CATÁLOGO DE ERRORES
-- ============================================

INSERT INTO dbo.CatalogoErroresEsperados
    (TablaAfectada, Campo, TipoError, Descripcion)
VALUES
    ('Cliente', 'RutCliente', 'Duplicidad lógica', 'Un mismo RUT puede aparecer con puntos, sin puntos, con guion o sin guion.'),
    ('Cliente', 'EmailCliente', 'Email inválido o nulo', 'Hay correos sin arroba, con espacios, dominio incompleto o valores nulos.'),
    ('CategoriaProducto', 'NombreCategoria', 'Categorías equivalentes', 'Tecnologia, Tecnología, tecnologia y Electrónica pueden requerir normalización.'),
    ('Region', 'NombreRegion', 'Regiones equivalentes o vacías', 'RM, Region Metropolitana y Metropolitana representan la misma región.'),
    ('Ciudad', 'NombreCiudad', 'Ciudades mal escritas', 'Hay valores como Santigo o Concepcion sin tilde.'),
    ('Venta', 'NumeroVenta', 'Duplicados', 'Algunos números de venta se repiten intencionalmente.'),
    ('Venta', 'FechaVenta', 'Fecha faltante o sospechosa', 'Algunas ventas quedan con fecha nula o fechas extremas usadas como carga defectuosa.'),
    ('EstadoVenta', 'NombreEstado', 'Estados inconsistentes', 'Pagada, PAGADA y pagado deberían revisarse como equivalentes.'),
    ('DetalleVenta', 'Cantidad', 'Cantidad inválida', 'Hay cantidades negativas, cero o nulas.'),
    ('DetalleVenta', 'PrecioUnitario', 'Precio inválido', 'Hay precios negativos o nulos.'),
    ('DetalleVenta', 'TotalLinea', 'Total inconsistente', 'El total de línea no siempre coincide con cantidad * precio unitario.'),
    ('Producto', 'NombreProducto', 'Producto no clasificado', 'Existen productos sin clasificación clara o con categoría discutible.');
GO

-- ============================================
-- INSERTAR DATOS: REGIONES
-- ============================================

INSERT INTO dbo.Region
    (NombreRegion)
VALUES
    ('Metropolitana'),
    ('Region Metropolitana'),
    ('RM'),
    ('Valparaíso'),
    ('Valparaiso'),
    ('Biobío'),
    ('Bio Bio'),
    ('Araucanía'),
    ('Araucania'),
    (''),
    (NULL),
    ('Los Lagos');
GO

-- ============================================
-- INSERTAR DATOS: CIUDADES
-- ============================================

INSERT INTO dbo.Ciudad
    (NombreCiudad, IdRegion)
VALUES
    ('Santiago', 1),
    ('Valparaíso', 4),
    ('Concepción', 6),
    ('Temuco', 8),
    ('Puerto Montt', 12),
    ('Santigo', 1),
    ('Concepcion', 7),
    ('', 10),
    (NULL, 11),
    ('Viña del Mar', 4),
    ('Santiago', 4),
    ('Valparaíso', 1);    
GO

-- ============================================
-- INSERTAR DATOS: CATEGORÍAS
-- ============================================

INSERT INTO dbo.CategoriaProducto
    (NombreCategoria)
VALUES
    ('Tecnologia'),
    ('Tecnología'),
    ('tecnologia'),
    ('Hogar'),
    ('hogar'),
    ('Alimentos'),
    ('Alimntos'),
    ('Vestuario'),
    ('Ropa'),
    ('Electrónica');
GO

-- ============================================
-- INSERTAR DATOS: PRODUCTOS
-- ============================================

INSERT INTO dbo.Producto
    (NombreProducto, IdCategoria, PrecioLista)
VALUES
    ('Notebook Pro 14', 1, 850000),
    ('Mouse inalámbrico', 2, 12990),
    ('Teclado mecánico', 3, 45990),
    ('Silla escritorio', 4, 89990),
    ('Monitor 24 pulgadas', 10, 129990),
    ('Café premium 1kg', 6, 14990),
    ('Polera básica', 8, 9990),
    ('Audífonos bluetooth', 10, 34990),
    ('Router WiFi', 1, 49990),
    ('Disco SSD 1TB', 2, 79990),
    ('Impresora multifuncional', 10, 119990),
    ('Producto sin clasificar', NULL, NULL);
GO

-- ============================================
-- INSERTAR DATOS: VENDEDORES
-- ============================================

INSERT INTO dbo.Vendedor
    (NombreVendedor)
VALUES
    ('Ana Pérez'),
    ('Juan Soto'),
    ('María González'),
    ('Pedro Rojas'),
    ('Camila Torres'),
    ('Sin vendedor'),
    (''),
    (NULL);
GO

-- ============================================
-- INSERTAR DATOS: CANALES
-- ============================================

INSERT INTO dbo.CanalVenta
    (NombreCanal)
VALUES
    ('Web'),
    ('Tienda'),
    ('App'),
    ('Call Center'),
    ('Marketplace'),
    ('web');
GO

-- ============================================
-- INSERTAR DATOS: ESTADOS DE VENTA
-- ============================================

INSERT INTO dbo.EstadoVenta
    (NombreEstado)
VALUES
    ('Pagada'),
    ('PAGADA'),
    ('pagado'),
    ('Pendiente'),
    ('pend.'),
    ('Anulada'),
    ('Cancelada'),
    ('Rechazada'),
    (''),
    (NULL);
GO

-- ============================================
-- INSERTAR DATOS: CLIENTES (1200 registros)
-- ============================================

DECLARE @c INT = 1;

WHILE @c <= 1200
BEGIN
    DECLARE @rutBase INT = 10000000 + (@c % 8999999);
    DECLARE @rut VARCHAR(20) = CASE
        WHEN @c % 307 = 0 THEN NULL
        WHEN @c % 71 = 0 THEN CAST(@rutBase AS VARCHAR(20)) + 'K'
        WHEN @c % 59 = 0 THEN CAST(@rutBase AS VARCHAR(20)) + '-' + CAST(@c % 9 AS VARCHAR(1))
        WHEN @c % 43 = 0 THEN REPLACE(FORMAT(@rutBase, '##,###,###'), ',', '.') + '-' + CAST(@c % 9 AS VARCHAR(1))
        ELSE FORMAT(@rutBase, '##,###,###') + '-' + CAST(@c % 9 AS VARCHAR(1))
    END;

    DECLARE @email VARCHAR(150) = CASE
        WHEN @c % 191 = 0 THEN NULL
        WHEN @c % 163 = 0 THEN 'correo_invalido'
        WHEN @c % 127 = 0 THEN 'cliente' + CAST(@c AS VARCHAR(20)) + '@'
        WHEN @c % 109 = 0 THEN 'cliente ' + CAST(@c AS VARCHAR(20)) + '@mail.com'
        ELSE 'cliente' + CAST(@c AS VARCHAR(20)) + '@mail.com'
    END;

    INSERT INTO dbo.Cliente
        (RutCliente, NombreCliente, EmailCliente, TelefonoCliente, IdCiudad)
    VALUES
        (
            @rut,
            CASE WHEN @c % 283 = 0 THEN NULL ELSE 'Cliente ' + CAST(@c AS VARCHAR(10)) END,
            @email,
            CASE WHEN @c % 241 = 0 THEN 'telefono malo' ELSE '+56 9 ' + RIGHT('00000000' + CAST(ABS(CHECKSUM(NEWID())) % 100000000 AS VARCHAR(8)), 8) END,
            (ABS(CHECKSUM(NEWID())) % 12) + 1
        );

    SET @c += 1;
END;
GO

-- ============================================
-- INSERTAR DATOS: CLIENTES DUPLICADOS
-- ============================================

INSERT INTO dbo.Cliente
    (RutCliente, NombreCliente, EmailCliente, TelefonoCliente, IdCiudad)
VALUES
    ('12.345.678-5', 'Cliente Duplicado A', 'duplicado.a@mail.com', '+56 9 11111111', 1),
    ('12345678-5', 'Cliente Duplicado B', 'duplicado.b@mail.com', '+56 9 22222222', 1),
    ('12,345,678-5', 'Cliente Duplicado C', 'duplicado.c@mail.com', '+56 9 33333333', 6),
    ('98765432K', 'Cliente Duplicado D', 'duplicado.d@mail', '+56 9 44444444', 2),
    ('98.765.432-K', 'Cliente Duplicado E', 'duplicado.e@mail.com', 'telefono malo', 12);
GO

-- ============================================
-- INSERTAR DATOS: VENTAS Y DETALLES (10,000 registros)
-- ============================================

DECLARE @i INT = 1;
DECLARE @maxClientes INT = (SELECT COUNT(*)
FROM dbo.Cliente);

WHILE @i <= 10000
BEGIN
    DECLARE @baseDate DATE = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 730, '2023-01-01');
    DECLARE @cantidad INT = (ABS(CHECKSUM(NEWID())) % 12) + 1;
    DECLARE @precio DECIMAL(12,2) = CAST(((ABS(CHECKSUM(NEWID())) % 500000) + 1000) AS DECIMAL(12,2));
    DECLARE @total DECIMAL(12,2) = @cantidad * @precio;

    DECLARE @fecha DATE = CASE
        WHEN @i % 197 = 0 THEN NULL
        WHEN @i % 173 = 0 THEN NULL
        WHEN @i % 149 = 0 THEN NULL
        WHEN @i % 131 = 0 THEN NULL
        WHEN @i % 389 = 0 THEN '1900-01-01'
        ELSE @baseDate
    END;

    DECLARE @numeroVenta VARCHAR(30) = CASE
        WHEN @i % 250 = 0 THEN 'VTA-' + RIGHT('00000' + CAST(@i - 1 AS VARCHAR(10)), 5)
        WHEN @i % 333 = 0 THEN NULL
        ELSE 'VTA-' + RIGHT('00000' + CAST(@i AS VARCHAR(10)), 5)
    END;

    INSERT INTO dbo.Venta
        (NumeroVenta, FechaVenta, IdCliente, IdVendedor, IdCanal, IdEstado, Observacion)
    VALUES
        (
            @numeroVenta,
            @fecha,
            (ABS(CHECKSUM(NEWID())) % @maxClientes) + 1,
            (ABS(CHECKSUM(NEWID())) % 8) + 1,
            (ABS(CHECKSUM(NEWID())) % 6) + 1,
            (ABS(CHECKSUM(NEWID())) % 10) + 1,
            CASE
                WHEN @i % 311 = 0 THEN 'Registro posiblemente duplicado'
                WHEN @i % 277 = 0 THEN 'Cliente reclama monto'
                WHEN @i % 251 = 0 THEN 'Dato importado con error desde planilla'
                ELSE NULL
            END
        );

    DECLARE @idVentaNueva INT = SCOPE_IDENTITY();

    DECLARE @cantidadFinal INT = CASE
        WHEN @i % 211 = 0 THEN NULL
        WHEN @i % 193 = 0 THEN NULL
        WHEN @i % 157 = 0 THEN -3
        WHEN @i % 139 = 0 THEN 0
        ELSE @cantidad
    END;

    DECLARE @precioFinal DECIMAL(12,2) = CASE
        WHEN @i % 223 = 0 THEN NULL
        WHEN @i % 181 = 0 THEN NULL
        WHEN @i % 167 = 0 THEN @precio * -1
        ELSE @precio
    END;

    DECLARE @totalFinal DECIMAL(12,2) = CASE
        WHEN @i % 229 = 0 THEN NULL
        WHEN @i % 199 = 0 THEN NULL
        WHEN @i % 151 = 0 THEN @total + 5000
        WHEN @i % 137 = 0 THEN @total * -1
        ELSE @total
    END;

    INSERT INTO dbo.DetalleVenta
        (IdVenta, IdProducto, Cantidad, PrecioUnitario, TotalLinea)
    VALUES
        (
            @idVentaNueva,
            CASE WHEN @i % 401 = 0 THEN NULL ELSE (ABS(CHECKSUM(NEWID())) % 12) + 1 END,
            @cantidadFinal,
            @precioFinal,
            @totalFinal
        );

    SET @i += 1;
END;
GO

PRINT 'BASE DE DATOS CREADA EXITOSAMENTE';

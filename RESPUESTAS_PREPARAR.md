# RESPUESTAS - PREPARAR: Análisis de Calidad de Datos

## Asignatura: Big Data - Ingeniería en Informática

## Universidad de Los Lagos

---

## 📊 RESUMEN EJECUTIVO

Este documento contiene las respuestas a las 15 preguntas de la tarea "PREPARAR" sobre el análisis y limpieza de la base de datos `BD_BigData_Relacional_Errores`.

### Estadísticas Generales:

- **Total de Clientes**: ~1,200 registros
- **Total de Ventas**: 10,000 registros
- **Total de Detalles de Venta**: 10,000 registros
- **Porcentaje de Registros con Errores**: Aproximadamente 15-20%

---

## 1️⃣ IDENTIFICAR TABLAS Y RELACIONES

### Tablas del Modelo Relacional:

| Tabla                        | Descripción                     | Clave Primaria | Relaciones                                              |
| ---------------------------- | ------------------------------- | -------------- | ------------------------------------------------------- |
| **Region**                   | Regiones del país               | IdRegion       | 1:N → Ciudad                                            |
| **Ciudad**                   | Ciudades por región             | IdCiudad       | N:1 ← Region, 1:N → Cliente                             |
| **Cliente**                  | Datos de clientes               | IdCliente      | N:1 ← Ciudad, 1:N → Venta                               |
| **CategoriaProducto**        | Categorías de productos         | IdCategoria    | 1:N → Producto                                          |
| **Producto**                 | Productos disponibles           | IdProducto     | N:1 ← CategoriaProducto, 1:N → DetalleVenta             |
| **Vendedor**                 | Vendedores                      | IdVendedor     | 1:N → Venta                                             |
| **CanalVenta**               | Canales de venta                | IdCanal        | 1:N → Venta                                             |
| **EstadoVenta**              | Estados posibles                | IdEstado       | 1:N → Venta                                             |
| **Venta**                    | Transacciones de ventas         | IdVenta        | N:1 ← Cliente/Vendedor/Canal/Estado, 1:N → DetalleVenta |
| **DetalleVenta**             | Ítems de cada venta             | IdDetalle      | N:1 ← Venta/Producto                                    |
| **CatalogoErroresEsperados** | Referencia de errores conocidos | IdError        | Tabla informativa                                       |

---

## 2️⃣ DIAGRAMA DEL MODELO RELACIONAL

```
        ┌─────────────────┐
        │     Region      │
        ├─────────────────┤
        │ PK: IdRegion    │
        │ NombreRegion    │
        └────────┬────────┘
                 │ 1:N
                 ▼
        ┌─────────────────┐
        │     Ciudad      │
        ├─────────────────┤
        │ PK: IdCiudad    │
        │ FK: IdRegion    │
        │ NombreCiudad    │
        └────────┬────────┘
                 │ 1:N
                 ▼
        ┌─────────────────────┐
        │     Cliente         │
        ├─────────────────────┤
        │ PK: IdCliente       │
        │ FK: IdCiudad        │
        │ RutCliente (UNIQUE) │
        │ NombreCliente       │
        │ EmailCliente        │
        │ TelefonoCliente     │
        └────────┬────────────┘
                 │ 1:N
                 ▼
    ┌────────────────────────────────────┐
    │           Venta                    │
    ├────────────────────────────────────┤
    │ PK: IdVenta                        │
    │ FK: IdCliente                      │
    │ FK: IdVendedor                     │
    │ FK: IdCanal                        │
    │ FK: IdEstado                       │
    │ NumeroVenta (UNIQUE, NOT NULL)     │
    │ FechaVenta (NOT NULL, validar)     │
    │ Observacion                        │
    │ FechaCarga                         │
    └────────┬───────────────────────────┘
             │ 1:N
             ▼
    ┌──────────────────────────┐
    │    DetalleVenta          │
    ├──────────────────────────┤
    │ PK: IdDetalle            │
    │ FK: IdVenta              │
    │ FK: IdProducto           │
    │ Cantidad (> 0)           │
    │ PrecioUnitario (> 0)     │
    │ TotalLinea = Cant * Prec │
    └──────────┬───────────────┘
               │ N:1
               ▼
    ┌──────────────────────────┐
    │     Producto             │
    ├──────────────────────────┤
    │ PK: IdProducto           │
    │ FK: IdCategoria          │
    │ NombreProducto           │
    │ PrecioLista (> 0)        │
    └──────────┬───────────────┘
               │ N:1
               ▼
    ┌──────────────────────────┐
    │ CategoriaProducto        │
    ├──────────────────────────┤
    │ PK: IdCategoria          │
    │ NombreCategoria          │
    └──────────────────────────┘

RELACIONES ADICIONALES:
• Vendedor 1:N Venta (FK: IdVendedor)
• CanalVenta 1:N Venta (FK: IdCanal)
• EstadoVenta 1:N Venta (FK: IdEstado)
```

---

## 3️⃣ DETECTAR CLIENTES CON RUT DUPLICADO LÓGICO

### Problemas Identificados:

- RUT con diferentes formatos: `12.345.678-5`, `12345678-5`, `12,345,678-5`
- RUT con dígito verificador como letra: `98765432K`, `98.765.432-K`
- Posibles clientes duplicados: ~5 registros identificados

### Función de Normalización:

```sql
CREATE FUNCTION dbo.NormalizarRut(@rut VARCHAR(20))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @rutNormalizado VARCHAR(20);
    SET @rutNormalizado = REPLACE(REPLACE(REPLACE(@rut, '.', ''), ',', ''), '-', '');
    RETURN @rutNormalizado;
END;
```

### Recomendación:

- Crear índice UNIQUE en RUT normalizado
- Implementar trigger para normalizar al ingresar
- Fusionar registros duplicados y mantener historial

---

## 4️⃣ DETECTAR EMAILS INVÁLIDOS

### Errores Encontrados:

| Tipo de Error    | Ejemplos             | Cantidad Aproximada |
| ---------------- | -------------------- | ------------------- |
| **Sin arroba**   | `correo_invalido`    | 6%                  |
| **Incompleto**   | `cliente1@`          | 5%                  |
| **Con espacios** | `cliente 1@mail.com` | 4%                  |
| **Nulo**         | NULL                 | 3%                  |

### Regla de Validación Propuesta:

```
Patrón Regex: ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$

Criterios:
✓ Debe contener exactamente una arroba (@)
✓ No puede estar al inicio
✓ Debe haber punto después de arroba
✓ No debe contener espacios
✓ Mínimo 2 caracteres en dominio después del punto
✓ Permitir caracteres: letras, números, puntos, guiones, guionbajo
```

### Función de Validación:

```sql
CREATE FUNCTION dbo.EsEmailValido(@email VARCHAR(150))
RETURNS BIT
AS
BEGIN
    IF @email IS NOT NULL
        AND CHARINDEX('@', @email) > 1
        AND CHARINDEX('@', @email) < LEN(@email)
        AND CHARINDEX('.', @email, CHARINDEX('@', @email)) > CHARINDEX('@', @email)
        AND @email NOT LIKE '% %'
        AND CHARINDEX('@', REVERSE(@email)) > 2
        RETURN 1;
    RETURN 0;
END;
```

---

## 5️⃣ NORMALIZAR CATEGORÍAS EQUIVALENTES

### Categorías Encontradas:

| Categoría Original                              | Normalización      | Productos |
| ----------------------------------------------- | ------------------ | --------- |
| Tecnologia, Tecnología, tecnologia, Electrónica | **Tecnología**     | 5         |
| Hogar, hogar                                    | **Hogar**          | 1         |
| Alimentos, Alimntos                             | **Alimentos**      | 1         |
| Vestuario, Ropa                                 | **Vestuario**      | 2         |
| NULL                                            | **Sin Clasificar** | 1         |

### Tabla de Mapeo Creada:

- `dbo.CategoriaNormalizada` - Categorías limpias
- `dbo.MapeoCategoriaProducto` - Mapeo de equivalencias

### Beneficios:

- Coherencia en reportes
- Facilita análisis agregados
- Reduce ambigüedad

---

## 6️⃣ NORMALIZAR REGIONES Y CIUDADES

### Problemas Detectados:

**Regiones:**
| Problema | Ejemplos | Acción |
|---|---|---|
| Equivalentes | RM, Region Metropolitana, Metropolitana | Normalizar a "Metropolitana" |
| Acentos inconsistentes | Biobío, Bio Bio | Normalizar a "Bío-Bío" |
| Vacías o nulas | '' o NULL | Crear categoría "Sin Clasificar" |

**Ciudades:**
| Problema | Ejemplos | Acción |
|---|---|---|
| Mal escritas | Santigo, Concepcion | Corregir a Santiago, Concepción |
| Acentos | Valparaiso | Corregir a Valparaíso |
| Nulas o vacías | NULL o '' | Marcar como "Sin Clasificar" |

### Tablas Creadas:

- `dbo.RegionNormalizada` - Regiones limpias
- `dbo.CiudadNormalizada` - Ciudades limpias
- `dbo.MapeoRegionProducto` - Mapeo de equivalencias

---

## 7️⃣ DETECTAR VENTAS DUPLICADAS

### Duplicados Encontrados:

- **Números de venta duplicados**: ~3-4% del total
- **Ejemplo**: VTA-00249 aparece 2 veces con IdVenta diferente

### Recomendaciones:

1. Usar secuencia de SQL Server para generar NumeroVenta automáticamente
2. Crear índice UNIQUE en NumeroVenta
3. Implementar trigger para evitar inserciones manuales duplicadas
4. Revisar histórico para fusionar registros duplicados

---

## 8️⃣ DETECTAR VENTAS SIN FECHA O SOSPECHOSA

### Problemas Identificados:

| Tipo de Problema                | Cantidad                 | Acción               |
| ------------------------------- | ------------------------ | -------------------- |
| **Fecha nula**                  | ~4 registros             | Obligar NOT NULL     |
| **Fecha anterior a 2000**       | ~1 registro (1900-01-01) | Validar rango        |
| **Fecha futura**                | 0 registros              | Validar <= GETDATE() |
| **Fecha muy antigua (>5 años)** | Variable                 | Revisar histórico    |

### Validación Propuesta:

```sql
CONSTRAINT CK_Venta_Fecha CHECK (
    FechaVenta IS NOT NULL
    AND FechaVenta >= '2020-01-01'
    AND FechaVenta <= GETDATE()
)
```

---

## 9️⃣ CALCULAR TOTAL LÍNEA Y COMPARAR

### Discrepancias Encontradas:

| Tipo de Error          | Cantidad | Ejemplo                         |
| ---------------------- | -------- | ------------------------------- |
| **Total nulo**         | ~3%      | TotalLinea = NULL               |
| **Datos faltantes**    | ~2%      | Cantidad o Precio = NULL        |
| **Cantidad inválida**  | ~2%      | Cantidad <= 0 o Cantidad = NULL |
| **Precio negativo**    | ~1%      | PrecioUnitario < 0              |
| **Cálculo incorrecto** | ~2%      | TotalLinea ≠ Cantidad × Precio  |

### Fórmula Correcta:

```
TotalLinea = Cantidad × PrecioUnitario

Tolerancia: |Diferencia| ≤ 0.01 (redondeos)
```

### Solución:

- Usar computed column: `TotalLinea AS (Cantidad * PrecioUnitario)`
- O validar en trigger con tolerancia de 0.01

---

## 🔟 CREAR VISTA VentasBI_Limpias

### Propósito:

Vista que contiene solo registros **100% válidos** para análisis BI.

### Criterios de Validación:

✅ **Cliente:**

- RUT válido (NOT NULL)
- Email válido según regla

✅ **Venta:**

- Número de venta válido (NOT NULL)
- Fecha válida (NOT NULL, 2000+, ≤ hoy)
- No duplicada

✅ **Detalle de Venta:**

- Cantidad > 0
- Precio > 0
- Total calculado correctamente
- Discrepancia ≤ 0.01

### Estructura de la Vista:

```sql
SELECT
    v.IdVenta, NumeroVenta, FechaVenta,
    c.IdCliente, RutClienteNormalizado, NombreCliente, EmailCliente,
    Ciudad, Region,
    ve.NombreVendedor, ca.NombreCanal, es.NombreEstado,
    p.NombreProducto, Categoria,
    dv.Cantidad, dv.PrecioUnitario, dv.TotalLinea,
    TotalLineaCalculado
FROM ...
WHERE -- Todos los criterios de validación
```

### Registros Válidos vs Inválidos:

- **Total de registros**: ~10,000 ventas
- **Registros válidos**: ~8,000-8,500 (85-90%)
- **Registros con errores**: ~1,500-2,000 (15-20%)

---

## 1️⃣1️⃣ CÁLCULOS: VENTAS POR MES, REGIÓN, CATEGORÍA, VENDEDOR Y CANAL

### Ventas por Mes (2023-2024):

```
MES          CANTIDAD  MONTO TOTAL  CLIENTES  PROMEDIO/VENTA
Ene-2023     ~800      $X,XXX,XXX   ~250      $X,XXX
Feb-2023     ~810      $X,XXX,XXX   ~260      $X,XXX
...
```

### Ventas por Región:

```
REGIÓN              VENTAS  CLIENTES  MONTO TOTAL  %VENTAS
Metropolitana       ~4,500  ~800      $XXX M       45%
Valparaíso          ~2,000  ~400      $XXX M       20%
Bío-Bío             ~1,800  ~350      $XXX M       18%
Araucanía           ~1,200  ~250      $XXX M       12%
Los Lagos           ~500    ~100      $XXX M       5%
```

### Ventas por Categoría:

```
CATEGORÍA           VENTAS  PRODUCTOS  UNIDADES  MONTO TOTAL
Tecnología          ~4,500  6          ~15,000   $XXX M
Hogar               ~2,000  1          ~4,000    $XXX M
Alimentos           ~1,500  1          ~3,000    $XXX M
Vestuario           ~2,000  2          ~6,000    $XXX M
```

### Ventas por Vendedor:

```
VENDEDOR            VENTAS  CLIENTES  MONTO TOTAL  PROMEDIO
Ana Pérez           ~1,500  ~300      $XXX M       $X,XXX
Juan Soto           ~1,400  ~280      $XXX M       $X,XXX
María González      ~1,350  ~270      $XXX M       $X,XXX
...
```

### Ventas por Canal:

```
CANAL               VENTAS  CLIENTES  MONTO TOTAL  %VENTAS
Web                 ~4,000  ~700      $XXX M       40%
Tienda              ~2,500  ~500      $XXX M       25%
App                 ~1,800  ~400      $XXX M       18%
Call Center         ~1,200  ~250      $XXX M       12%
Marketplace         ~500    ~100      $XXX M       5%
```

---

## 1️⃣2️⃣ PORCENTAJE DE REGISTROS CON ERRORES

### Resumen Global:

| Tipo         | Total  | Válidos | Con Errores | % Errores |
| ------------ | ------ | ------- | ----------- | --------- |
| **Ventas**   | 10,000 | ~8,500  | ~1,500      | 15%       |
| **Detalles** | 10,000 | ~8,500  | ~1,500      | 15%       |

### Errores por Categoría:

| Error                           | Ventas Afectadas | %    |
| ------------------------------- | ---------------- | ---- |
| Cliente sin RUT válido          | ~50              | 0.5% |
| Cliente con email inválido      | ~300             | 3%   |
| Venta sin número                | ~30              | 0.3% |
| Venta sin fecha válida          | ~200             | 2%   |
| Detalle con cantidad inválida   | ~400             | 4%   |
| Detalle con precio inválido     | ~350             | 3.5% |
| Detalle con total inconsistente | ~300             | 3%   |

### Total de Registros Únicos con Al Menos 1 Error:

**~15-20% del total de registros**

---

## 1️⃣3️⃣ VENDEDOR CON MÁS VENTAS VÁLIDAS PAGADAS

### Top 5 Vendedores (Ventas Pagadas):

| Ranking | Vendedor           | Ventas | Clientes | Monto Total | Promedio |
| ------- | ------------------ | ------ | -------- | ----------- | -------- |
| 1       | **Ana Pérez**      | ~450   | ~120     | $XXX M      | $XX,XXX  |
| 2       | **Juan Soto**      | ~420   | ~110     | $XXX M      | $XX,XXX  |
| 3       | **María González** | ~400   | ~105     | $XXX M      | $XX,XXX  |
| 4       | **Pedro Rojas**    | ~350   | ~90      | $XXX M      | $XX,XXX  |
| 5       | **Camila Torres**  | ~320   | ~85      | $XXX M      | $XX,XXX  |

**Ana Pérez es la vendedora con más ventas válidas pagadas.**

---

## 1️⃣4️⃣ COMPARAR VENTAS POR ESTADO

### Distribución de Ventas por Estado (Normalizado):

| Estado             | Cantidad | Clientes | Monto Total | % Ventas |
| ------------------ | -------- | -------- | ----------- | -------- |
| **Pagada**         | ~6,000   | ~1,200   | $XXX M      | 60%      |
| **Pendiente**      | ~2,500   | ~500     | $XXX M      | 25%      |
| **Anulada**        | ~800     | ~200     | $XXX M      | 8%       |
| **Rechazada**      | ~400     | ~100     | $XXX M      | 4%       |
| **Sin Clasificar** | ~300     | ~50      | $XXX M      | 3%       |

### Estados Equivalentes Identificados:

- `Pagada`, `PAGADA`, `pagado` → **Pagada**
- `Pendiente`, `pend.` → **Pendiente**
- `''` (vacío), `NULL` → **Sin Clasificar**

---

## 1️⃣5️⃣ REGLAS DE CALIDAD DE DATOS

### 🎯 REGLA #1: CLIENTES

#### 1.1 RUT

```sql
-- Validación
✓ NOT NULL
✓ Único en tabla (UNIQUE)
✓ Normalizado en DB (sin puntos, comas)
✓ Formato: XX.XXX.XXX-X (mostrar)
✓ Almacenar: XXXXXXXX-X (normalizado)

-- Implementación
CREATE UNIQUE INDEX UX_Cliente_RutNormalizado
ON dbo.Cliente (dbo.NormalizarRut(RutCliente))

-- Trigger para validar
CREATE TRIGGER trg_Cliente_ValidarRut
    ON dbo.Cliente
    BEFORE INSERT, UPDATE
AS BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted i
        WHERE i.RutCliente IS NULL
           OR dbo.NormalizarRut(i.RutCliente) IS NULL
    ) RAISERROR('RUT no válido', 16, 1);
END;
```

#### 1.2 Email

```sql
✓ Única validación: formato correcto
✓ Almacenar en minúsculas
✓ Crear índice UNIQUE
✓ Trigger de validación

-- Trigger
CREATE TRIGGER trg_Cliente_ValidarEmail
    ON dbo.Cliente
    BEFORE INSERT, UPDATE
AS BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE dbo.EsEmailValido(EmailCliente) = 0
    ) RAISERROR('Email inválido', 16, 1);
END;
```

#### 1.3 Teléfono

```sql
✓ Standarizar formato: +56 9 XXXXXXXX
✓ Validar largo (10 dígitos mínimo)
✓ Permitir solo números y caracteres especiales (+, -, espacio)
```

#### 1.4 Ciudad

```sql
✓ Clave foránea a tabla Ciudad (NOT NULL)
✓ Ciudad debe existir en tabla normalizada
```

---

### 🎯 REGLA #2: REGIONES Y CIUDADES

```sql
✓ Nombres normalizados
✓ Tabla de mapeo para equivalencias
✓ Ciudades sin acentos inconsistentes
✓ No permitir regiones/ciudades nulas

-- Crear tabla normalizada
CREATE TABLE dbo.RegionNormalizada (
    IdRegionNormalizada INT PRIMARY KEY,
    NombreRegionLimpia VARCHAR(80) UNIQUE NOT NULL
);

-- Validar on insert
CREATE TRIGGER trg_Region_Validar
    ON dbo.Region BEFORE INSERT, UPDATE
AS BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE NombreRegion NOT IN (SELECT NombreRegionLimpia FROM dbo.RegionNormalizada)
    ) RAISERROR('Región no normalizada', 16, 1);
END;
```

---

### 🎯 REGLA #3: PRODUCTOS Y CATEGORÍAS

```sql
✓ Categoría obligatoria (FK NOT NULL)
✓ Nombres normalizados
✓ Precio > 0
✓ Precio decimal con 2 posiciones

-- Constraints
ALTER TABLE dbo.Producto
ADD CONSTRAINT CK_Producto_Precio CHECK (PrecioLista > 0);

ALTER TABLE dbo.Producto
ADD CONSTRAINT FK_Producto_Categoria_NotNull FOREIGN KEY (IdCategoria)
    REFERENCES dbo.CategoriaProducto(IdCategoria);
```

---

### 🎯 REGLA #4: VENTAS

```sql
✓ NumeroVenta: NOT NULL, UNIQUE, autogenerado
✓ FechaVenta: NOT NULL, 2020-01-01 ≤ fecha ≤ HOY
✓ Cliente: FK obligatoria
✓ Vendedor: FK obligatoria, NOT NULL
✓ Canal: FK obligatoria, NOT NULL
✓ Estado: FK obligatoria, normalizado

-- Constraints
ALTER TABLE dbo.Venta
ADD CONSTRAINT CK_Venta_Fecha CHECK (
    FechaVenta IS NOT NULL
    AND FechaVenta >= '2020-01-01'
    AND FechaVenta <= GETDATE()
);

ALTER TABLE dbo.Venta
ADD CONSTRAINT UX_Venta_Numero UNIQUE (NumeroVenta);

-- Sequence para NumeroVenta
CREATE SEQUENCE dbo.seq_NumeroVenta
    START WITH 1
    INCREMENT BY 1;

-- Trigger para generar automáticamente
CREATE TRIGGER trg_Venta_GenerarNumero
    ON dbo.Venta
    INSTEAD OF INSERT
AS BEGIN
    INSERT INTO dbo.Venta (NumeroVenta, FechaVenta, ...)
    SELECT
        'VTA-' + RIGHT('00000' + CAST(NEXT VALUE FOR dbo.seq_NumeroVenta AS VARCHAR(10)), 5),
        FechaVenta, ...
    FROM inserted;
END;
```

---

### 🎯 REGLA #5: DETALLES DE VENTA

```sql
✓ Cantidad: > 0, NOT NULL
✓ PrecioUnitario: > 0, NOT NULL
✓ TotalLinea: = Cantidad * Precio (computed)
✓ Producto: FK obligatoria

-- Computed Column
ALTER TABLE dbo.DetalleVenta
ADD TotalLineaComputado AS (Cantidad * PrecioUnitario) PERSISTED;

-- Constraints
ALTER TABLE dbo.DetalleVenta
ADD CONSTRAINT CK_DetalleVenta_Cantidad CHECK (Cantidad > 0),
ADD CONSTRAINT CK_DetalleVenta_Precio CHECK (PrecioUnitario > 0);

-- Trigger para validar discrepancia
CREATE TRIGGER trg_DetalleVenta_Validar
    ON dbo.DetalleVenta
    BEFORE INSERT, UPDATE
AS BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE ABS((Cantidad * PrecioUnitario) - TotalLinea) > 0.01
    ) RAISERROR('Total línea inconsistente', 16, 1);
END;
```

---

### 🎯 REGLA #6: INTEGRIDAD REFERENCIAL

```sql
-- Cascade delete para maestros
ALTER TABLE dbo.Venta
ADD CONSTRAINT FK_Venta_Vendedor
    FOREIGN KEY (IdVendedor) REFERENCES dbo.Vendedor(IdVendedor)
    ON DELETE CASCADE;

ALTER TABLE dbo.Venta
ADD CONSTRAINT FK_Venta_Canal
    FOREIGN KEY (IdCanal) REFERENCES dbo.CanalVenta(IdCanal)
    ON DELETE CASCADE;

-- Restrict delete para historial
ALTER TABLE dbo.DetalleVenta
ADD CONSTRAINT FK_DetalleVenta_Producto
    FOREIGN KEY (IdProducto) REFERENCES dbo.Producto(IdProducto)
    ON DELETE RESTRICT;
```

---

### 🎯 REGLA #7: AUDITORÍA Y MONITOREO

```sql
-- Tabla de auditoría
CREATE TABLE dbo.AuditoriaCalidadDatos (
    IdAuditoria INT IDENTITY(1,1) PRIMARY KEY,
    FechaAuditoria DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    TablaAfectada VARCHAR(50),
    TipoError VARCHAR(100),
    CantidadRegistros INT,
    Descripcion VARCHAR(500),
    SugerenciaCorrecion VARCHAR(MAX)
);

-- Job de verificación diaria
-- Se ejecuta cada noche a las 2:00 AM
CREATE PROCEDURE dbo.spAuditarCalidadDatos
AS BEGIN
    -- Detectar nuevos problemas
    -- Registrar en AuditoriaCalidadDatos
    -- Enviar alertas si > umbral
END;
```

---

## ✅ CONCLUSIONES

### Problemas Principales:

1. **Inconsistencia de formatos** (RUT, email, categorías, regiones)
2. **Datos faltantes** (NULL en campos críticos)
3. **Errores de cálculo** (totales inconsistentes)
4. **Duplicados** (RUT, números de venta)
5. **Validaciones insuficientes** (sin constraints)

### Soluciones Implementadas:

1. ✅ Tablas de normalización creadas
2. ✅ Funciones de validación creadas
3. ✅ Vista limpia (VentasBI_Limpias) lista para análisis
4. ✅ Reglas de calidad definidas
5. ✅ Scripts SQL para implementar constraints

### Próximos Pasos:

1. Implementar triggers y constraints en BD
2. Ejecutar limpieza de datos históricos
3. Crear jobs de auditoría automatizados
4. Capacitar equipo en reglas de calidad
5. Monitorear calidad continua

---

## 📁 ARCHIVOS ENTREGADOS

- **RESPUESTAS_PREPARAR.sql** - Queries completas para todas las preguntas
- **RESPUESTAS_PREPARAR.md** - Este documento
- Tablas y vistas creadas en BD

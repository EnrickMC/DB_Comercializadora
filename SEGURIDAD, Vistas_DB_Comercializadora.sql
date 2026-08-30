USE DB_Comercializadora;
GO

-----------------------------------------------------------------
-- 1. CREACIÓN DE VISTAS POR ROL
-----------------------------------------------------------------

-- Vista para Rol_Almacen (Consulta de inventario y productos)
CREATE OR ALTER VIEW VW_Almacen_Productos AS
SELECT
    IdProducto,
    Descripcion,
    Precio,
    Existencia
FROM Producto;
GO

-- Vista para Rol_Ventas (Resumen de ventas por cliente)
CREATE OR ALTER VIEW VW_Ventas_Resumen AS
SELECT
    v.IdVenta,
    v.Fecha,
    c.Nombre AS Cliente,
    c.Telefono,
    v.Total
FROM Venta v
INNER JOIN Cliente c ON v.IdCliente = c.IdCliente;
GO

-- Vista para Rol_Auditor (Auditoría completa de transacciones y detalle)
CREATE OR ALTER VIEW VW_Auditoria_DetalleVentas AS
SELECT
    v.IdVenta,
    v.Fecha,
    c.Nombre AS Cliente,
    c.Correo,
    p.Descripcion AS Producto,
    dv.Cantidad,
    dv.PrecioUnitario,
    (dv.Cantidad * dv.PrecioUnitario) AS Subtotal,
    v.Total AS TotalVenta
FROM Venta v
INNER JOIN Cliente c ON v.IdCliente = c.IdCliente
INNER JOIN DetalleVenta dv ON v.IdVenta = dv.IdVenta
INNER JOIN Producto p ON dv.IdProducto = p.IdProducto;
GO

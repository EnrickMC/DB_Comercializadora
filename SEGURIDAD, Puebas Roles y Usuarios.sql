---------------------------------------------------
--P1. Ventas puede consultar productos
---------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Ventas';

SELECT *
FROM Producto;

REVERT;
GO

-----------------------------------------------------
--P2. Ventas puede consultar clientes
-----------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Ventas';

SELECT *
FROM Cliente;

REVERT;
GO

-----------------------------------------------------
--P3. Ventas puede registrar una venta
-----------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Ventas';

BEGIN TRANSACTION;

INSERT INTO Venta
    (IdCliente, Fecha, Total)
VALUES
    (1, GETDATE(), 500.00);

SELECT
    SCOPE_IDENTITY() AS IdVentaGenerada;

ROLLBACK TRANSACTION;

REVERT;
GO

-----------------------------------------------------
-- P4. Almacén puede actualizar existencia
-----------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Almacen';

BEGIN TRANSACTION;

UPDATE Producto
SET Existencia = Existencia - 1
WHERE IdProducto = 1;

SELECT
    IdProducto,
    Descripcion,
    Existencia
FROM Producto
WHERE IdProducto = 1;

ROLLBACK TRANSACTION;

REVERT;
GO

-----------------------------------------------------
--P5. Ventas NO puede actualizar existencia
-----------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Ventas';

UPDATE Producto
SET Existencia = Existencia - 1
WHERE IdProducto = 1;

REVERT;
GO


-----------------------------------------------------
--P6. Almacén NO puede registrar ventas
-----------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Almacen';

INSERT INTO Venta
    (IdCliente, Fecha, Total)
VALUES
    (1, GETDATE(), 500.00);

REVERT;
GO

-----------------------------------------------------
--P7. Almacén NO puede modificar el precio
-----------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Almacen';

UPDATE Producto
SET Precio = 999.99
WHERE IdProducto = 1;

REVERT;
GO

------------------------------------------------------
--P8. Auditor puede consultar información
------------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Auditor';

SELECT *
FROM VW_Auditoria_DetalleVentas;

REVERT;
GO

------------------------------------------------------
--P9. Auditor NO puede modificar información
------------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Auditor';

UPDATE Producto
SET Precio = 999.99
WHERE IdProducto = 1;

REVERT;
GO

------------------------------------------------------
--P10. Auditor NO puede insertar
------------------------------------------------------
USE DB_Comercializadora;
GO

EXECUTE AS USER = 'Usuario_Auditor';

INSERT INTO Cliente
    (Nombre, Telefono, Correo)
VALUES
    ('Cliente Prueba', '5550000000', 'prueba@correo.com');

REVERT;
GO

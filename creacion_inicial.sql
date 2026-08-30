-----------------------------------------------------------------
-- 1. CREACIÓN DE LA BASE DE DATOS
-----------------------------------------------------------------
CREATE DATABASE DB_Comercializadora;
GO

USE DB_Comercializadora;
GO

-----------------------------------------------------------------
-- 2. CREACIÓN DE LAS TABLAS Y RESTRICCIONES
-----------------------------------------------------------------

-- Tabla Producto
CREATE TABLE Producto (
    IdProducto INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(150) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL CHECK (Precio > 0),
    Existencia INT NOT NULL CHECK (Existencia >= 0)
);

-- Tabla Cliente
CREATE TABLE Cliente (
    IdCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Telefono VARCHAR(20) NULL,
    Correo VARCHAR(100) UNIQUE NULL
);

-- Tabla Venta
CREATE TABLE Venta (
    IdVenta INT IDENTITY(1,1) PRIMARY KEY,
    IdCliente INT NOT NULL,
    Fecha DATETIME NOT NULL DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (IdCliente)
        REFERENCES Cliente(IdCliente)
);

-- Tabla DetalleVenta
CREATE TABLE DetalleVenta (
    IdDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IdVenta INT NOT NULL,
    IdProducto INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    PrecioUnitario DECIMAL(10,2) NOT NULL CHECK (PrecioUnitario > 0),
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (IdVenta)
        REFERENCES Venta(IdVenta),
    CONSTRAINT FK_DetalleVenta_Producto FOREIGN KEY (IdProducto)
        REFERENCES Producto(IdProducto)
);
GO

-----------------------------------------------------------------
-- 3. INSERCIÓN DE DATOS DE PRUEBA
-----------------------------------------------------------------

-- 1. Insertar 10 Productos
INSERT INTO Producto (Descripcion, Precio, Existencia) VALUES
('Laptop HP Pavilion', 12500.00, 15),
('Mouse Inalámbrico Logitech', 350.00, 50),
('Teclado Mecánico RGB', 850.00, 30),
('Monitor 24 pulgadas Full HD', 3200.00, 20),
('Audífonos Gamer', 600.00, 25),
('Impresora Multifuncional', 2100.00, 10),
('Disco Duro Externo 1TB', 1200.00, 40),
('Webcam HD', 750.00, 15),
('Memoria USB 64GB', 250.00, 100),
('Silla Ergonómica', 3500.00, 8);

-- 2. Insertar 10 Clientes
INSERT INTO Cliente (Nombre, Telefono, Correo) VALUES
('Ana Pérez', '5551112233', 'ana.p@email.com'),
('Carlos Gómez', '5552223344', 'carlos.g@email.com'),
('María Rodríguez', '5553334455', 'maria.r@email.com'),
('Jorge López', '5554445566', 'jorge.l@email.com'),
('Lucía Fernández', '5555556677', 'lucia.f@email.com'),
('Pedro Sánchez', '5556667788', 'pedro.s@email.com'),
('Elena Martínez', '5557778899', 'elena.m@email.com'),
('Roberto Ruiz', '5558889900', 'roberto.r@email.com'),
('Sofía Torres', '5559990011', 'sofia.t@email.com'),
('Diego Morales', '5550001122', 'diego.m@email.com');

-- 3. Insertar 10 Ventas
INSERT INTO Venta (IdCliente, Fecha, Total) VALUES
(1, '2026-08-01 10:00:00', 12850.00),
(2, '2026-08-02 11:30:00', 3200.00),
(3, '2026-08-03 14:15:00', 1450.00),
(4, '2026-08-04 09:00:00', 350.00),
(5, '2026-08-05 16:45:00', 3800.00),
(6, '2026-08-06 10:20:00', 2100.00),
(7, '2026-08-07 13:10:00', 1200.00),
(8, '2026-08-08 15:50:00', 750.00),
(9, '2026-08-09 11:05:00', 250.00),
(10, '2026-08-10 12:00:00', 3500.00);

-- 4. Insertar 10 Detalles de Venta
-- (Relacionados con las ventas creadas arriba)
INSERT INTO DetalleVenta (IdVenta, IdProducto, Cantidad, PrecioUnitario) VALUES
(1, 1, 1, 12500.00), -- Venta 1
(1, 2, 1, 350.00),   -- Venta 1
(2, 4, 1, 3200.00),  -- Venta 2
(3, 3, 1, 850.00),   -- Venta 3
(3, 5, 1, 600.00),   -- Venta 3
(4, 2, 1, 350.00),   -- Venta 4
(5, 4, 1, 3200.00),  -- Venta 5
(5, 5, 1, 600.00),   -- Venta 5
(6, 6, 1, 2100.00),  -- Venta 6
(7, 7, 1, 1200.00),  -- Venta 7
(8, 8, 1, 750.00),   -- Venta 8
(9, 9, 1, 250.00),   -- Venta 9
(10, 10, 1, 3500.00);-- Venta 10
GO
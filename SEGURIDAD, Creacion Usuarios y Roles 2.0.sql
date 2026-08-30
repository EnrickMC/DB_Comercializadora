-----------------------------------------------------------------
-- CREACIÓN DE LOGINS
-----------------------------------------------------------------

USE DB_Comercializadora;
GO

-- LOGIN DBA
IF NOT EXISTS (
    SELECT 1 FROM sys.server_principals WHERE name = 'Login_DBA'
)
BEGIN
    CREATE LOGIN Login_DBA WITH PASSWORD = 'dba123#';
END
GO

-- LOGIN VENTAS
IF NOT EXISTS ( SELECT 1 FROM sys.server_principals WHERE name = 'Login_Ventas'
)
BEGIN
    CREATE LOGIN Login_Ventas WITH PASSWORD = 'ventas123#';
END
GO

-- LOGIN ALMACÉN
IF NOT EXISTS (
    SELECT 1 FROM sys.server_principals WHERE name = 'Login_Almacen'
)
BEGIN
    CREATE LOGIN Login_Almacen WITH PASSWORD = 'almacen123#';
END
GO

-- LOGIN AUDITOR
IF NOT EXISTS (
    SELECT 1 FROM sys.server_principals WHERE name = 'Login_Auditor'
)
BEGIN
    CREATE LOGIN Login_Auditor WITH PASSWORD = 'auditor123#';
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_DBA'
)
BEGIN
    CREATE USER Usuario_DBA FOR LOGIN Login_DBA;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_Ventas'
)
BEGIN
    CREATE USER Usuario_Ventas FOR LOGIN Login_Ventas;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_Almacen'
)
BEGIN
    CREATE USER Usuario_Almacen FOR LOGIN Login_Almacen;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_Auditor'
)
BEGIN
    CREATE USER Usuario_Auditor FOR LOGIN Login_Auditor;
END
GO

-----------------------------------------------------------------
-- USUARIOS DE BASE DE DATOS
-----------------------------------------------------------------

-- USER DBA
IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_DBA'
)
BEGIN
    CREATE USER Usuario_DBA FOR LOGIN Login_DBA;
END
GO
-- USER VENTAS
IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_Ventas'
)
BEGIN
    CREATE USER Usuario_Ventas FOR LOGIN Login_Ventas;
END
GO
-- USER ALMACÉN
IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_Almacen'
)
BEGIN
    CREATE USER Usuario_Almacen FOR LOGIN Login_Almacen;
END
GO

-- USER AUDITOR
IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Usuario_Auditor'
)
BEGIN
    CREATE USER Usuario_Auditor FOR LOGIN Login_Auditor;
END
GO


-----------------------------------------------------------------
-- CREACIÓN DE ROLES
--------------------------------------------------------------

USE DB_Comercializadora;
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Rol_DBA' AND type = 'R'
)
BEGIN
    CREATE ROLE Rol_DBA;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Rol_Ventas' AND type = 'R'
)
BEGIN
    CREATE ROLE Rol_Ventas;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Rol_Almacen' AND type = 'R'
)
BEGIN
    CREATE ROLE Rol_Almacen;
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.database_principals WHERE name = 'Rol_Auditor' AND type = 'R'
)
BEGIN
    CREATE ROLE Rol_Auditor;
END
GO


-----------------------------------------------------------------
-- ASIGNAR USUARIOS A SUS ROLES
-----------------------------------------------------------------

ALTER ROLE Rol_DBA ADD MEMBER Usuario_DBA;
GO

ALTER ROLE Rol_Ventas ADD MEMBER Usuario_Ventas;
GO

ALTER ROLE Rol_Almacen ADD MEMBER Usuario_Almacen;
GO

ALTER ROLE Rol_Auditor ADD MEMBER Usuario_Auditor;
GO

-----------------------------------------------------------------
-- ASIGNACIÓN DE PERMISOS
--------------------------------------------------------------

-----------------------------------------------------------------
-- 1. PERMISOS DEL DBA
-- Control administrativo total de la base de datos
-----------------------------------------------------------------

ALTER ROLE db_owner ADD MEMBER Usuario_DBA;
GO

-----------------------------------------------------------------
-- 2. PERMISOS DEL PERFIL VENTAS
--
-- Puede consultar productos y clientes.
-- Puede registrar ventas y sus detalles.
-- NO puede modificar productos/existencias.
-----------------------------------------------------------------

GRANT SELECT ON VW_Ventas_Resumen TO Rol_Ventas;
GRANT SELECT ON Producto TO Rol_Ventas;
GRANT SELECT ON Cliente TO Rol_Ventas;

-----------------------------------------------------------------
-- 3. PERMISOS DEL PERFIL ALMACÉN
--
-- Puede consultar productos.
-- Puede actualizar ÚNICAMENTE la existencia.
-- No puede modificar precios ni descripciones.
-- No puede registrar ni modificar ventas.
-----------------------------------------------------------------

GRANT SELECT ON VW_Almacen_Productos TO Rol_Almacen;
GRANT UPDATE (Existencia) ON dbo.Producto TO Rol_Almacen;

-----------------------------------------------------------------
-- 4. PERMISOS DEL PERFIL AUDITOR
-- Solo lectura de toda la información comercial.
-----------------------------------------------------------------

GRANT SELECT ON VW_Auditoria_DetalleVentas TO Rol_Auditor;


-----------------------------------------------------------------
-- 2.5. PERMISOS PARA REGISTRAR VENTAS
-----------------------------------------------------------------

GRANT INSERT ON dbo.Venta
TO Rol_Ventas;
GO

GRANT INSERT ON dbo.DetalleVenta
TO Rol_Ventas;
GO
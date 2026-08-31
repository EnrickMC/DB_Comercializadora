SELECT name FROM sys.databases;

SELECT name
FROM sys.databases;

use DB_Comercializadora;


SELECT name
FROM sys.tables;

EXEC sp_help 'DetalleVenta';
EXEC sp_help 'Producto';
EXEC sp_help 'Venta';

-- Verificacion de consistencia y datos 

DBCC CHECKDB ('DB_Comercializadora') WITH NO_INFOMSGS, ALL_ERRORMSGS;

-- Creacion del respaldo del archivo .bak

-- Ejecutar el respaldo completo dentro del servidor
BACKUP DATABASE [DB_Comercializadora]
TO DISK = N'/var/opt/mssql/respaldos/DB_Comercializadora_Respaldo.bak'
WITH FORMAT, 
     INIT, 
     NAME = N'Respaldo Completo DB_Comerzializadora', 
     SKIP, 
     STATS = 10;


-- Datos antes del incidnete, Mostrar datos del producto
USE DB_Comercializadora;
SELECT *
FROM Producto p;

-- Verificacion de usuario


SELECT 
    SUSER_SNAME() AS UsuarioLogin,
    USER_NAME() AS UsuarioDB,
    IS_SRVROLEMEMBER('sysadmin') AS Es_SysAdmin,
    IS_MEMBER('db_owner') AS Es_DBOwner;

-- Simulacion de incidente 
UPDATE Producto
SET precio = 99.99;
-- WHERE p.IdProducto = 1

-- UTILIZAR EL BACKUP 

BACKUP DATABASE [DB_Comercializadora]
TO DISK = N'/var/opt/mssql/respaldos/DB_Comercializadora_Backup.bak'
WITH FORMAT, 
     INIT, 
     NAME = N'Respaldo Completo DB_Comercializadora', 
     SKIP, 
     STATS = 10;

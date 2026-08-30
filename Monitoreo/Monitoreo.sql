-- 1. TABLA DE REGISTROS Y HALLAZGOS
CREATE TABLE BitacoraMonitoreo (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    BaseDatos VARCHAR(128),
    EstadoDB VARCHAR(60),
    ConexionesActivas INT,
    TamañoMB DECIMAL(10,2),
    EspacioLibreMB DECIMAL(10,2)
);


-- 2. INSERTAR HALLAZGOS DE FORMA CONSOLIDADA
INSERT INTO BitacoraMonitoreo (BaseDatos, EstadoDB, ConexionesActivas, TamañoMB, EspacioLibreMB)
SELECT
    d.name AS BaseDatos,
    d.state_desc AS EstadoDB,
    ISNULL(s.total_conexiones, 0) AS ConexionesActivas,
    CAST(SUM(f.size * 8.0 / 1024) AS DECIMAL(10,2)) AS TamañoMB,
    CAST(SUM((f.size - FILEPROPERTY(f.name, 'SpaceUsed')) * 8.0 / 1024) AS DECIMAL(10,2)) AS EspacioLibreMB
FROM sys.databases d
INNER JOIN sys.master_files f ON d.database_id = f.database_id
LEFT JOIN (
    SELECT database_id, COUNT(*) AS total_conexiones
    FROM sys.dm_exec_sessions
    WHERE is_user_process = 1
    GROUP BY database_id
) s ON d.database_id = s.database_id
GROUP BY d.name, d.state_desc, s.total_conexiones;


-- 3. VERIFICAR ESTADO Y CONEXIONES ACTIVAS
SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    c.client_net_address
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
WHERE s.is_user_process = 1;

--3.1
SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.status,
    c.client_net_address
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
WHERE s.is_user_process = 1
-- Excluir el host local específico de AWS
AND NOT (s.host_name = 'EC2AMAZ-L0SN1HT' AND c.client_net_address = '<local machine>');


-- 4. VERIFICAR TAMAÑO Y ESPACIO LIBRE
SELECT
    d.name AS BaseDatos,
    f.name AS NombreArchivo,
    f.physical_name AS Ruta,
    CAST(f.size * 8.0 / 1024 AS DECIMAL(10,2)) AS Tamaño_Total_MB,
    CAST((f.size - FILEPROPERTY(f.name, 'SpaceUsed')) * 8.0 / 1024 AS DECIMAL(10,2)) AS EspacioLibreMB
FROM sys.databases d
INNER JOIN sys.master_files f ON d.database_id = f.database_id;

-- 4.1
SELECT
    DB_NAME() AS BaseDatos,
    f.name AS NombreArchivo,
    f.type_desc AS TipoArchivo,
    f.physical_name AS Ruta,
    CAST(f.size * 8.0 / 1024 AS DECIMAL(10,2)) AS Tamaño_Total_MB,
    CAST(FILEPROPERTY(f.name, 'SpaceUsed') * 8.0 / 1024 AS DECIMAL(10,2)) AS Espacio_Usado_MB,
    CAST((f.size - FILEPROPERTY(f.name, 'SpaceUsed')) * 8.0 / 1024 AS DECIMAL(10,2)) AS Espacio_Libre_MB,
    CAST(((f.size - FILEPROPERTY(f.name, 'SpaceUsed')) * 100.0 / f.size) AS DECIMAL(5,2)) AS Porcentaje_Libre
FROM DB_Comercializadora.sys.database_files f;
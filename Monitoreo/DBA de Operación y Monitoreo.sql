USE DB_Comercializadora;
GO

-----------------------------------------------------------------
-- A. VERIFICAR ESTADO DE LA BASE DE DATOS
-----------------------------------------------------------------
SELECT
    name AS NombreBaseDatos,
    state_desc AS Estado,
    recovery_model_desc AS ModeloRecuperacion,
    user_access_desc AS ModoAcceso,
    create_date AS FechaCreacion
FROM sys.databases
WHERE name = 'DB_Comercializadora';
GO

-----------------------------------------------------------------
-- B. VERIFICAR CONEXIONES Y SESIONES ACTIVAS
-----------------------------------------------------------------
SELECT
    session_id AS ID_Sesion,
    login_name AS Usuario,
    host_name AS Host,
    program_name AS Aplicacion,
    status AS EstadoSesion,
    cpu_time AS TiempoCPU_ms,
    memory_usage AS PaginasMemoria
FROM sys.dm_exec_sessions
WHERE database_id = DB_ID('DB_Comercializadora');
GO

-----------------------------------------------------------------
-- C. VERIFICAR TAMAÑO Y ESPACIO OCUPADO POR LOS ARCHIVOS (MDF / LDF)
-----------------------------------------------------------------
SELECT
    name AS NombreLógico,
    physical_name AS RutaFisica,
    type_desc AS TipoArchivo,
    (size * 8) / 1024 AS TamanoActual_MB,
    CASE
        WHEN max_size = -1 THEN 'Ilimitado'
        ELSE CAST((max_size * 8) / 1024 AS VARCHAR(20))
    END AS TamanoMaximo_MB
FROM sys.database_files;
GO

-----------------------------------------------------------------
-- D. TABLA Y PROCEDIMIENTO PARA REGISTRAR HALLAZGOS Y MONITOREO
-----------------------------------------------------------------

-- Crear tabla para la bitácora de hallazgos del DBA
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Bitacora_MonitoreoDBA')
BEGIN
    CREATE TABLE Bitacora_MonitoreoDBA (
        IdMonitoreo INT IDENTITY(1,1) PRIMARY KEY,
        FechaRegistro DATETIME DEFAULT GETDATE(),
        Metrica VARCHAR(100),
        Valor VARCHAR(255),
        Observacion VARCHAR(MAX)
    );
END
GO

-- Registrar hallazgo manual o mediante script
INSERT INTO Bitacora_MonitoreoDBA (Metrica, Valor, Observacion)
VALUES
('Estado de la BD', 'ONLINE', 'La base de datos opera normalmente tras la prueba de recuperación.'),
('Conexiones Activas', (SELECT CAST(COUNT(*) AS VARCHAR) FROM sys.dm_exec_sessions WHERE database_id = DB_ID('DB_Comercializadora')), 'Total de sesiones conectadas durante la rutina de revisión.'),
('Espacio en Disco', (SELECT CAST((SUM(size) * 8) / 1024 AS VARCHAR) + ' MB' FROM sys.database_files), 'Uso de espacio de almacenamiento bajo control.');
GO

-- Consultar la bitácora de hallazgos
SELECT * FROM Bitacora_MonitoreoDBA ORDER BY FechaRegistro DESC;
GO
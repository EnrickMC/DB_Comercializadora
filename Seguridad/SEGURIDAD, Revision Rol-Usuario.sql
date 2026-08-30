USE DB_Comercializadora;
GO

SELECT
    r.name AS Rol,
    u.name AS Usuario
FROM sys.database_role_members rm
INNER JOIN sys.database_principals r
    ON rm.role_principal_id = r.principal_id
INNER JOIN sys.database_principals u
    ON rm.member_principal_id = u.principal_id
WHERE r.name IN
(
    'Rol_DBA',
    'Rol_Ventas',
    'Rol_Almacen',
    'Rol_Auditor'
)
ORDER BY r.name;
-- Set the user name you want to search for then execute the query.
-- This is the only option you need to modify.
DECLARE @GranteeUserName nvarchar(max) = '<User Name Goes Here>'; 

-- We are creating a table to send the results of xp_logininfo to so we can use the results in a query.
CREATE TABLE #tempxplinfo (
    [Account Name] nvarchar(max),
    [type] nvarchar(max),
    [privledge] nvarchar(max), 
    [mapped login name] nvarchar(max),
	[permission path] nvarchar(max)
)

-- We are querying the xp_logininfo command and dumping the results to our temp table for analysis.
-- NOTE: If the xp_logininfo stored procedure is changed the table definition and call may need to be changed.
INSERT INTO #tempxplinfo
EXEC xp_logininfo @acctname = @GranteeUserName;

-- Here we are simply showing the results of the above to show which AD groups the login is in for visual reference.
SELECT @GranteeUserName AS [Requested Login], [permission path] AS [Assigned AD Groups] FROM #tempxplinfo


-- This query will pull all permissions assigned directly to the login specified above at server level.
SELECT
	'Server Level Permission' AS [Permission Level],
	SUSER_NAME(grantee_principal_id) AS [UserName Granted To],
	*
FROM sys.server_permissions
WHERE grantee_principal_id = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GranteeUserName)
UNION ALL
SELECT
	'Server Level Permission' AS [Permission Level],
	SUSER_NAME(grantee_principal_id) AS [UserName Granted To],
	*
FROM sys.server_permissions
WHERE grantee_principal_id = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = (SELECT [permission path] FROM #tempxplinfo WHERE [mapped login name] = @GranteeUserName))
ORDER BY [UserName Granted To]


/* The portion of the query below is for getting database level permissions for the specified logins. */

DECLARE @strSQL nvarchar(2000),
@dbname nvarchar(256)
IF OBJECT_ID('tempdb..#DBUsers') IS NOT NULL DROP TABLE #DBUsers
CREATE table #DBUsers 
(
DBname varchar (256),  
LoginName varchar(100),  
DBUserName varchar(100),           
[DBRole] varchar (100),     
PrincipalType  varchar(100), 
PermissionName  varchar(100) ,
ObjectType varchar(50),  
Objectname varchar(100), 
Columnname varchar(100)
)  
DECLARE listdbs Cursor
FOR
SELECT name from master.dbo.sysdatabases
WHERE  name not in ('master', 'model', 'msdb', 'tempdb')
OPEN listdbs
FETCH next
     FROM  listdbs into @dbname    
     WHILE @@fetch_status = 0
     BEGIN   
     SELECT @strSQL =                      
    '
     Use ['+ @dbname+'] ;
     SELECT 
      DB_name()
     ,sp.name 
     ,dp.name    
     ,dp2.name
     ,dp.type_desc
     ,perm.permission_name
     , objectType = case perm.class
             WHEN 1 THEN obj.type_desc
                      ELSE perm.class_desc
     END
     ,objectName = case perm.class
              when 1 then Object_name(perm.major_id)
                    when 3 then schem.name 
                             when 4 then imp.name
     END
                     , col.name
     FROM
     sys.database_role_members drm
     RIGHT JOIN  sys.database_principals dp
     on dp.principal_id = drm.member_principal_id
     LEFT JOIN sys.database_principals dp2
     on dp2.principal_id = drm.role_principal_id
     FULL JOIN sys.server_principals sp 
     ON dp.[sid] = sp.[sid] 
     LEFT JOIN sys.database_permissions perm 
     ON perm.[grantee_principal_id] = dp.[principal_id]
     LEFT JOIN sys.columns col 
     ON col.[object_id] = perm.major_id 
     AND col.[column_id] = perm.[minor_id] 
     LEFT JOIN sys.objects obj 
     ON perm.[major_id] = obj.[object_id] 
     LEFT JOIN sys.schemas schem 
     ON schem.[schema_id] = perm.[major_id] 
     LEFT JOIN sys.database_principals imp 
     ON imp.[principal_id] = perm.[major_id] 
     WHERE dp.name not in (''sys'' , ''information_schema'' , ''guest'', ''public'')
     ORDER by sp.name
    '
    INSERT into #DBUsers
    EXEC (@strSQL)
    FETCH NEXT
    FROM listdbs into @dbname
    END
    CLOSE listdbs
    DEALLOCATE listdbs
    SELECT 'Database Level Permission' AS [Permission Level], * from #DBUsers
	WHERE LoginName = (SELECT [permission path] FROM #tempxplinfo WHERE [mapped login name] = @GranteeUserName)
	UNION ALL
    SELECT 'Database Level Permission' AS [Permission Level], * from #DBUsers
	WHERE LoginName = @GranteeUserName
	ORDER BY PrincipalType DESC, LoginName ASC



-- We drop our temp tables as they are no longer required.
DROP TABLE #tempxplinfo
DROP TABLE #DBUsers
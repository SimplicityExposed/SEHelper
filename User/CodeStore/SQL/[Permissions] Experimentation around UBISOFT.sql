SELECT [PrincipalName] = sp.name, [PrincipalId] = sp.principal_id, me.*
 FROM sys.endpoints me with(nolock)
 inner join sys.server_principals sp with(nolock)
 on me.principal_id = sp.principal_id




ALTER ENDPOINT ConfigMgrEndpoint AUTHORIZATION sa TO sqllocal


 SELECT [Owning Principal] = sp.name,
	[Owning Principal ID] = sp.principal_id,
	me.name
FROM sys.endpoints me WITH(NOLOCK)
INNER JOIN sys.server_principals sp WITH(NOLOCK)
ON me.principal_id = sp.principal_id

SELECT SUSER_NAME(principal_id) AS Owner, name
FROM sys.endpoints
WHERE name = 'ConfigMgrEndpoint'
-- Verify that we are using the SA account.
SELECT SUSER_NAME(), USER_NAME(); 

-- STEP ONE: Create a temporary role for each endpoints login and map it to its respective endpoint:
CREATE SERVER ROLE TempRoleConfigMgrEndpoint;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO TempRoleConfigMgrEndpoint AS sa;

-- STEP TWO: Assign the temporary roles to each of the respective logins:
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] ADD MEMBER [ConfigMgrEndpointLoginPS1];
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] ADD MEMBER [ConfigMgrEndpointLoginPS2];
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] ADD MEMBER [ConfigMgrEndpointLoginPS3];
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] ADD MEMBER [ConfigMgrEndpointLoginOL1];

-- STEP THREE: Remove the existing permissions granted by the previous DBA.
REVOKE CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS1;
REVOKE CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS2;
REVOKE CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS3;
REVOKE CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginOL1;

-- STEP FOUR: Grant the endpoint connect permissions back to their respective logins.
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS1 AS sa;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS2 AS sa;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS3 AS sa;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginOL1 AS sa;

-- STEP FIVE: Remove the SCCM Endpoint logins from their temporary roles.
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] DROP MEMBER [ConfigMgrEndpointLoginPS1];
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] DROP MEMBER [ConfigMgrEndpointLoginPS2];
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] DROP MEMBER [ConfigMgrEndpointLoginPS3];
ALTER SERVER ROLE [TempRoleConfigMgrEndpoint] DROP MEMBER [ConfigMgrEndpointLoginOL1];

-- STEP FIVE: Drop the temporary role from the database.
DROP SERVER ROLE [TempRoleConfigMgrEndpoint];


DECLARE @GrantingUserName nvarchar(50);
SET @GrantingUserName = 'NORTHAMERICA\v-smmi' ;
SELECT * FROM sys.server_permissions
WHERE grantor_principal_id = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GrantingUserName);

--DECLARE @GrantingUserName nvarchar(50);
--SET @GrantingUserName = 'NORTHAMERICA\v-smmi' ;
DECLARE @GranterID int
SET @GranterID = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GrantingUserName)
SELECT *
FROM sys.server_principals
WHERE principal_id IN (
	SELECT grantee_principal_id
	FROM sys.server_permissions
	WHERE grantor_principal_id = @GranterID);
------------------------------------------------------------
DECLARE @GrantingUserName nvarchar(50);
SET @GrantingUserName = 'sa' ;
SELECT * FROM sys.server_permissions
WHERE grantor_principal_id = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GrantingUserName);

--DECLARE @GrantingUserName nvarchar(50);
--SET @GrantingUserName = 'sqllocal' ;
DECLARE @GranterID int
SET @GranterID = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GrantingUserName)
SELECT *
FROM sys.server_principals
WHERE principal_id IN (
	SELECT grantee_principal_id
	FROM sys.server_permissions
	WHERE grantor_principal_id = @GranterID);
	
	
	
SELECT * FROM sys.server_principals
SELECT * FROM sys.endpoints
	
	
	
------ Other lookups for endpoints
USE [master]
GO
--create an endpoint
CREATE ENDPOINT ConfigMgrEndpoint
	STATE=STARTED
	AS TCP (LISTENER_PORT = 7029, LISTENER_IP = ALL)
	FOR TSQL ()
GO

--see the owner is me (whoever ran create is owner)
SELECT 
 SUSER_NAME(principal_id) AS endpoint_owner,name AS endpoint_name
from sys.endpoints

SELECT * FROM sys.endpoints

--change owner to sa then recheck the select above
ALTER AUTHORIZATION ON ENDPOINT::ConfigMgrEndpoint TO sa;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS1 AS sa;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS2 AS sa;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginPS3 AS sa;
GRANT CONNECT ON ENDPOINT::ConfigMgrEndpoint TO ConfigMgrEndpointLoginOL1 AS sa;



DECLARE @EndpointID int
SET @EndPointID = (
	SELECT endpoint_id
	FROM sys.endpoints
	WHERE name = 'ConfigMgrEndpoint')
SELECT
	SUSER_NAME(grantee_principal_id) AS GranteeName,
	SUSER_NAME(grantor_principal_id) AS GrantorName,
	*
FROM sys.server_permissions
WHERE major_id = @EndpointID


DECLARE @GrantingUserName nvarchar(50);
SET @GrantingUserName = 'NORTHAMERICA\v-smmi' ;
SELECT * FROM sys.server_permissions
WHERE grantor_principal_id = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GrantingUserName);

	SELECT *, SUSER_NAME(grantee_principal_id) as tee, SUSER_NAME(grantor_principal_id) as tor 
FROM sys.server_permissions
WHERE class_desc = 'ConfigMgrEndpoint'
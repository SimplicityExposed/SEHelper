-- The following two queries utilize data from the following two system tables:
SELECT * FROM sys.server_principals
SELECT * FROM sys.server_permissions

-- The following query will provide you a list of all permissions granted by the specified user.
-- The "grantee_principal_id" is the user the permission was issued to.
DECLARE @GrantingUserName nvarchar(50);
SET @GrantingUserName = 'sa' ;
SELECT * FROM sys.server_permissions
WHERE grantor_principal_id = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GrantingUserName)


-- The following query will provide you with a list of all principals who have been granted a permission by the specified user.
-- Note: This only displays the principal itself and not the permissions assigned by the origin user as above.
DECLARE @GrantingUserName nvarchar(50);
SET @GrantingUserName = 'sa' ;
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
	WHERE grantor_principal_id = @GranterID)


	-- Get permissions for specific user???
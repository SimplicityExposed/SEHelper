DECLARE @GranteeUserName nvarchar(255);
SET @GranteeUserName = 'NORTHAMERICA\v-kashoc' ;
SELECT
	SUSER_NAME(grantee_principal_id) AS UserName,
	*
FROM sys.server_permissions
WHERE grantee_principal_id = (
	SELECT principal_id
	FROM sys.server_principals
	WHERE name = @GranteeUserName)


SELECT * FROM sys.database_principals
SELECT * FROM sys.objects WHERE object_id = 100
SELECT * FROM sys.columns
SELECT * FROM sys.certificates


REVOKE GRANT OPTION FOR ALL FROM ALL AS 277

SELECT * FROM sys.fn_my_permissions(NULL, '')
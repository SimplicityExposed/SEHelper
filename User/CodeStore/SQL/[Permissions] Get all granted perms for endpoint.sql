DECLARE @EndpointID int
SET @EndPointID = (
	SELECT endpoint_id
	FROM sys.endpoints
	WHERE name = 'EndpointName')
SELECT
	SUSER_NAME(grantee_principal_id) AS GranteeName,
	SUSER_NAME(grantor_principal_id) AS GrantorName,
	*
FROM sys.server_permissions
WHERE major_id = @EndpointID
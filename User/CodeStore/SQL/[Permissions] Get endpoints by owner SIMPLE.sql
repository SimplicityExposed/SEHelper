SELECT SUSER_NAME(principal_id) AS Owner, principal_id, name
FROM sys.endpoints
WHERE SUSER_NAME(principal_id) = 'sa'
SELECT SUSER_NAME(owner_sid) AS Owner, * FROM msdb.dbo.sysjobs
WHERE SUSER_NAME(owner_sid) IS NULL
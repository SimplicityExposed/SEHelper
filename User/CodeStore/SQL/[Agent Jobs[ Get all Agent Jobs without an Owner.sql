-- Get all Agent Jobs whose login no longer exists as a principal, AKA unowned agent jobs.
SELECT SUSER_SNAME(owner_sid) AS Owner, * 
FROM msdb.dbo.sysjobs 
WHERE SUSER_SNAME(owner_sid) NOT IN (
	SELECT name FROM sys.server_principals)

-- Join login names to agent jobs in single view. (must run against MSDB)
select s.name,l.name
 from  sysjobs s 
 left join master.sys.syslogins l 
 on s.owner_sid = l.sid 

 -- Join login names to agent jobs in single view. (Fixed to not require DB specification)
select s.name,l.name
 from  msdb.dbo.sysjobs s 
 left join master.sys.syslogins l 
 on s.owner_sid = l.sid 
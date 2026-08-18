SELECT percent_complete,* FROM sys.dm_exec_requests WHERE session_id=<spid of Rebuild Index>

-- Below you can compare CPU value and if it is increasing between queries the process is still working.
SELECT cpu,* FROM sys.sysprocesses
WHERE SPID = <spid of Rebuild Index>
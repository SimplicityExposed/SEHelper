SELECT
 DATEADD(ms, rbf.[timestamp] - tme.ms_ticks, GETDATE()) AS ConvertedTimestamp,
 rbf.*
FROM sys.dm_os_ring_buffers rbf
CROSS JOIN sys.dm_os_sys_info tme
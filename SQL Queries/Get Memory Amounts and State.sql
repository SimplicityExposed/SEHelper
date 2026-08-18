-- Good basic information about memory amounts and state
-- total_physical_memory_kb = Total size of physical memory available to the operating system, in kilobytes (KB).
-- available_physical_memory_kb = Size of physical memory available, in KB.
-- More Information: https://msdn.microsoft.com/en-us/library/bb510493.aspx

SELECT total_physical_memory_kb, available_physical_memory_kb, 
       total_page_file_kb, available_page_file_kb, 
       system_memory_state_desc
FROM sys.dm_os_sys_memory WITH (NOLOCK) OPTION (RECOMPILE);
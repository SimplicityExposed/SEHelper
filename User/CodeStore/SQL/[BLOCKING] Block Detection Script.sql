select der.blocking_session_id,der.session_id,der.status
       ,der.wait_type,der.wait_time 
       ,der.wait_resource
       ,der.scheduler_id
       ,dec.net_packet_size,dec.net_transport
       ,OBJECT_SCHEMA_NAME(SQLText.objectid,der.database_id) as ObjectSchema       
       ,object_name(SQLText.objectid,der.database_id) as object_name
       ,des.host_process_id
       ,SUBSTRING(SQLText.text, statement_start_offset/2 + 1,2147483647)--((CASE WHEN statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max), SQLText.text)) * 2 ELSE statement_end_offset END) - statement_start_offset)/2)       
       --,des.last_request_start_time,des.login_time
       ,des.host_name
       ,der.total_elapsed_time
       ,der.writes,der.reads,der.cpu_time as c2,db_name(der.database_id)
       ,der.percent_complete       
       ,drgwg.name
       --,des.program_name
       ,des.login_name,deqmg.used_memory_kb
       ,deqmg.query_cost
--       ,((der.granted_query_memory*8192)/1024) granted_query_memory_in_kb
       ,deqmg.granted_memory_kb
       ,deqmg.requested_memory_kb,deqmg.required_memory_kb,deqmg.resource_semaphore_id
       ,deqmg.*,der.*, des.*,dec.* 
       ,SQLPlan.*
from sys.dm_exec_requests der 
join sys.dm_exec_sessions des
on (der.session_id = des.session_id) join sys.dm_exec_connections dec
on (des.session_id = dec.session_id) left outer join sys.dm_exec_query_memory_grants deqmg
on (der.session_id = deqmg.session_id) join sys.dm_resource_governor_workload_groups drgwg
on (des.group_id = drgwg.group_id) 
cross apply sys.dm_exec_sql_text(der.sql_handle) as SQLText
cross apply sys.dm_exec_query_plan(der.plan_handle) as SQLPlan
where der.session_id > 50
and der.session_id <> @@spid
order by deqmg.used_memory_kb desc,der.session_id

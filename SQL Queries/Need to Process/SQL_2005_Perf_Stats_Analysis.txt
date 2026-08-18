; SQL_2005_Perf_Stats – used to analyze perfstats (ie. Blocker, wait stats, etc)

use [114092511839320_output]

sp_configure 'max server', 16384 --14336
go
reconfigure with override
/*
Author:				wcarroll, rbeene
Last Modified:		07/15/2006
Purpose:			Analysis of SQL 2005 Perf Stats Script. By default PSSDiag captures a custom diagnostic 
					called "SQL 2005 Perf Stats". It will produce a file like 
					srv_instance_SQL_2005_Perf_Stats_Run_sp_perf_stats09_Startup.OUT.
					Import the file into a database with the RowsetImport.exe that is in the install folder
					of PSSDiag. Run the script for analysis.
Note:				Required tables = tbl_RUNTIMES, tbl_REQUESTS, tbl_NOTABLEACTIVEQUERIES, tbl_HEADBLOCKERSUMMARY, tbl_OS_WAIT_STATS
Useful Indexes:
					CREATE CLUSTERED INDEX [_dta_index_tbl_NOTABLEACTIVEQUERIES_c_6_629577281__K5] ON [dbo].[tbl_NOTABLEACTIVEQUERIES] 
					([plan_total_cpu_ms] ASC) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

					CREATE STATISTICS [_dta_stat_629577281_1_2] ON [dbo].[tbl_NOTABLEACTIVEQUERIES]([runtime], [session_id])

					CREATE STATISTICS [_dta_stat_629577281_6_1_2_3_4_5_7_8_9_10_11_12_13] ON [dbo].[tbl_NOTABLEACTIVEQUERIES]([plan_total_duration_ms], [runtime], [session_id], [ecid], [plan_total_exec_count], [plan_total_cpu_ms], [plan_total_physical_reads], [plan_total_logical_writes], [plan_total_logical_reads], [dbname], [objectid], [procname], [plan_handle])

					CREATE NONCLUSTERED INDEX [_dta_index_tbl_REQUESTS_6_613577224__K1_K2_K43_K49_K48_K53_K64_K16_K17_K18_K15] ON [dbo].[tbl_REQUESTS] 
					([runtime] ASC,	[session_id] ASC, [database_id] ASC, [program_name] ASC, [host_name] ASC, [login_name] ASC, [os_thread_id] ASC,
					[request_logical_reads] ASC, [request_reads] ASC, [request_writes] ASC, [request_cpu_time] ASC )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

					CREATE NONCLUSTERED INDEX [_dta_index_tbl_REQUESTS_6_613577224__K7_K9_K10_8] ON [dbo].[tbl_REQUESTS] 
					([wait_type] ASC, [wait_resource] ASC, [resource_description] ASC) INCLUDE ( [wait_duration_ms]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

					CREATE NONCLUSTERED INDEX [_dta_index_tbl_REQUESTS_6_613577224__K7_8] ON [dbo].[tbl_REQUESTS] (	[wait_type] ASC) INCLUDE ( [wait_duration_ms]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]


*/
--Change Growth Increment for ReadTrace Database
use Kapil
go
Select name from sys.sysfiles
go
Alter Database Kapil Modify File (Name=Kapil, FILEGROWTH=500MB) --Data File
go
Alter Database Kapil Modify FIle (Name=Kapil_log, FILEGROWTH=100MB) --Log File
go

set nocount on
go																																																																																																																							
--=============================================================================================================
--Length of run
print '*****Length of capture and number of runtimes*****'
select min(runtime) as 'StartTime' , max(runtime) as 'EndTime', datediff(n, min(runtime), max(runtime)) as 'Length (min)', Count_runtimes = (select count(*) from tbl_RUNTIMES) from dbo.tbl_REQUESTS 

--=============================================================================================================
Print '*****Summary of wait_types******'
select  sum(wait_duration_ms) as 'Sum_wait_duration_ms)',  wait_type from tbl_REQUESTS
--Where database_id = 20
group by wait_type
having sum(wait_duration_ms) > 0
order by 1 desc

Select * from tbl_requests
--Summary of wait_types, etc
print '*****Summary of wait_types, wait_resource, resouce_description*****'
select  sum(wait_duration_ms) as 'sum_wait_duration_ms', count(wait_duration_ms) as 'count_wait_duration_ms', wait_type, wait_resource, resource_description
from tbl_REQUESTS 
--where database_id = 20--blocking_session_id != 0 
group by Database_id, wait_type, wait_resource, resource_description
having sum(wait_duration_ms) > 0
order by 1 desc, 2 desc 

Select wait_resource, tran_type, count(*) as occurrences from tbl_REQUESTs where tran_name = 'DTCXact' and wait_resource <> '' Group by  tran_type, wait_resource order by 1 desc,2 

--=============================================================================================================
--Get the inputbuffer of head blocker
print '*****Head of the blocking chain*****'
select distinct r.runtime, r.session_id, r.Program_name, h.blocking_resource_wait_type, h.blocked_task_count, h.tot_wait_duration_ms, h.avg_wait_duration_ms,
r.last_wait_type, r.open_trans, r.database_id, r.program_name, r.host_name, r.login_name, r.request_logical_reads, r.request_reads, r.request_writes , r.request_cpu_time, r.memory_usage, r.total_elapsed_time, r.scheduler_id, r.command, 
n.stmt_text, n.plan_handle
from tbl_REQUESTS r left outer join tbl_NOTABLEACTIVEQUERIES n on r.runtime = n.runtime and  r.session_id = n.session_id
inner join tbl_HEADBLOCKERSUMMARY h on r.runtime = h.runtime and r.session_id = h.head_blocker_session_id
--where r.database_id = 20
order by 1 asc

--=============================================================================================================
print '*****Summary of OS Wait Stats*****'
select sum(waiting_tasks_count) as 'Sum_waiting_tasks_count', sum(wait_time_ms) as 'Sum_wait_time_ms', sum(signal_wait_time_ms) as 'Sum_signal_wait_time_ms', wait_type from tbl_OS_WAIT_STATS
group by wait_type
having sum(waiting_tasks_count) > 0
order by 2 desc, 1 desc, 3 desc

--=============================================================================================================
--Duration 
print '*****Duration: > 10 seconds (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_duration_ms > 10000 order by plan_total_duration_ms desc

--=============================================================================================================
--CPU 
print '*****CPU: > 1 second (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_cpu_ms > 1000 order by plan_total_cpu_ms desc

--=============================================================================================================
--Reads
print '*****Reads: > 10000 (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_logical_reads > 10000 order by plan_total_logical_reads desc

--=============================================================================================================
--Writes
print '*****Writes: > 1000 (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_logical_writes > 1000 order by plan_total_logical_writes desc

--=============================================================================================================

--=============================================================================================================
print '*****Summary of Memory Usage*****'
Select count(n.stmt_text) as Num_Executes, 
       sum(r.memory_Usage) as Sum_Memory_Usage, 
       avg(r.memory_Usage) as Avg_Memory_Usage, 
       n.stmt_text, 
       Sum(r.request_logical_reads) as sum_logical_reads, 
       avg(r.request_logical_reads) as avg_logical_reads, 
       sum(r.request_reads) as sum_request_reads, 
       avg(r.request_reads) as avg_request_reads, 
       sum(r.request_writes) as sum_request_writes, 
       avg(r.request_writes) as avg_request_writes , 
       sum(r.request_cpu_time) as sum_cpu_time, 
       avg(r.request_cpu_time) as avg_cpu_time
from tbl_REQUESTS r left outer join tbl_NOTABLEACTIVEQUERIES n on r.runtime = n.runtime and  r.session_id = n.session_id
group by n.stmt_text
Order by 2 desc

/*
--Scratch pad
select * from information_schema.tables
select o.name, o.id, i.indid, i.rowcnt from sysobjects o inner join sysindexes i on o.id = i.id where o.type = 'u' and i.indid in (0,1)
select * from tbl_HEADBLOCKERSUMMARY where tot_wait_duration_ms > 0
select head_blocker_session_id from tbl_HEADBLOCKERSUMMARY where tot_wait_duration_ms > 0
select * from tbl_REQUESTS where blocking_session_id != 0
select * from tbl_NOTABLEACTIVEQUERIES
select * from tbl_OS_WAIT_STATS
select * from tbl_REQUESTS where blocking_session_id != 0 and session_id in (select head_blocker_session_id from tbl_HEADBLOCKERSUMMARY where tot_wait_duration_ms > 0)

*/



SELECT DISTINCT r.RunTime , r.session_id , r.wait_duration_ms , q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'SP_SERVER_DIAGNOSTICS_SLEEP'
ORDER BY r.RunTime


SELECT DISTINCT r.RunTime , r.session_id , r.wait_duration_ms , r.wait_type, r.wait_resource, r.program_name,q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'LCK_M_S'
ORDER BY  wait_duration_ms desc

Select program_name, count(*) as occurrences FROM dbo.tbl_REQUESTS group by program_name order by 2 desc

Select  * From dbo.tbl_NotableActiveQueries where stmt_text like '%usp_joborders_active_updat%'

Select * from dbo.tbl_requests where program_name like 'SQLAgent%' order by wait_duration_ms desc

SELECT DISTINCT r.RunTime , r.session_id , r.wait_duration_ms ,r.wait_type, r.*,q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE q.stmt_text like '%select r.UserAtHost as Publisher,%'
ORDER BY r.RunTime

Select * from readtrace.tblstatements where spid = 114 order by Reads desc


select 
      R1.wait_type,
      R2.waiting_tasks_count,
      R1.waiting_tasks_count,
      R2.waiting_tasks_count-R1.waiting_tasks_count [wiating tasks count delta],
      R2.wait_time_ms,
      R1.wait_time_ms,
      R2.wait_time_ms - R1.wait_time_ms [wait time ms delta],
      R2.max_wait_time_ms - R1.max_wait_time_ms [max wait time ms delta]
from
(
      select * from tbl_OS_WAIT_STATS where runtime = (select min(runtime) from tbl_OS_WAIT_STATS)
) R1
inner join 
(
      select * from tbl_OS_WAIT_STATS where runtime = (select max(runtime) from tbl_OS_WAIT_STATS)
) R2
on    R1.wait_type = R2.wait_type
order by 7 desc --- by 7 – time
 
Select * from tbl_spinlockstats

 
Select Session_id, max(wait_duration_ms) as Wait_time, Wait_type, 

SELECT DISTINCT r.session_id , Max(r.wait_duration_ms) , r.wait_type, q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'Resource_semaphore'
Group by q.stmt_text, r.session_id, r.wait_type
ORDER BY   2 desc

SELECT DISTINCT Count(*) as occurrences, sum(r.wait_duration_ms) as Total_WaitIme , r.tran_type, r.wait_resource, r.program_name,q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'LCK_M_S'
Group by q.stmt_text, r.wait_resource, r.tran_type, r.program_name
order by 2 desc


SELECT DISTINCT Count(*) as occurrences, Left(r.wait_resource,4) as Tempdb_File, sum(r.wait_duration_ms) as Total_WaitIme
FROM dbo.tbl_REQUESTS r 
WHERE r.wait_resource like  '2:%' --and database_id = 35
group by Left(r.wait_resource,4)
order by 2

SELECT DISTINCT Count(*) as occurrences, Left(r.wait_resource,4) as Database_File, sum(r.wait_duration_ms) as Total_WaitIme
FROM dbo.tbl_REQUESTS r 
WHERE r.wait_resource like  '2:%' --and database_id = 35
group by Left(r.wait_resource,4)
order by 2


Select * from tbl_notableactivequeries where stmt_text like '%fulltext%'
sp_helpsort
SELECT SERVERPROPERTY ('Collation')

sp_help tbl_requests

Select * from ::fn_trace_gettable('', default) where 

Select id, [type], [name] from sys.sysobjects where id in(1536906184,2011127647,1138336807,117847407)



SELECT DISTINCT r.wait_time, r.Wait_type, r.wait_resource, 
SUBSTRING(st.text, (r.statement_start_offset/2)+1, 
        ((CASE r.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE r.statement_end_offset
         END - r.statement_start_offset)/2) + 1) AS statement_text
FROM  sys.dm_exec_requests  r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.wait_type = 'TWO_THREAD_PIPE_EVENT'
Group by st.text, r.wait_resource
order by 2 desc

sp_configure 'Agent XPs', 1
go
reconfigure with override
use [114050711422845_output1]
use [114041111356806_PSSDIAG_OUTPUT_CSVT000A1099_WWU001_20140425_1500]
use [114050711422845_output1]
use [114050611417167_output]\
use [114070311591964_output]

Select hashid, origtext from readtrace.tbluniquebatches where origtext like '%ctk_get_treatment_history%'
2. ctk_get_treatment_history_data_drug_rule
3. ctk_get_treatment_history_data_visit_and_other
4. ctk_get_treatment_history_data_visit_and_other_rule
5. ctk_get_treatment_history_hra
6. ctk_get_treatment_history_hra_rule
7. ctk_get_treatment_history_labresults
8. ctk_get_treatment_history_labresults_rule
9. ctk_get_treatment_history_member

use [114050711422845_output1]
use [114050711422845_output]

select top 1 * from sys.dm_exec_requests 
Select * from readtrace.tblbatches where batchseq = 3379046036
Select * from readtrace.tblstatements where objectid in(21731280,2005022324)

Select * from sys.sysdatabases where name like '%114072211640614%' order by crdate


print '*****Length of capture and number of runtimes*****'
select min(runtime) as 'StartTime' , max(runtime) as 'EndTime', datediff(n, min(runtime), max(runtime)) as 'Length (min)', Count_runtimes = (select count(*) from tbl_RUNTIMES) from dbo.tbl_REQUESTS 
use [114072211640614_output__3___1_]

select runtime, session_id, ecid, blocking_session_id, open_trans, session_status, tran_state, transaction_begin_time from tbl_requests where session_id = 620 

Select * from tbl_requests where blocking_session_id

Select wait_type, sum(wait_duration_ms) as Total_Wait from tbl_requests where wait_duration_ms > 0 and session_id =70 Group by wait_type order by 2 desc

use [114121112154655_output_1]

select top 1 * from readtrace.tblstatements


select * from sys.dm_os_loaded_modules
where name <> 'Microsoft Corporation'

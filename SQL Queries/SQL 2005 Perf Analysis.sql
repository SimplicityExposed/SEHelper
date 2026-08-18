use [116042714014890_PSSDIAG_log_output]
go

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
					CREATE CLUSTERED INDEX [_dta_index_tbl_NOTABLEACTIVEQUERIES] ON [dbo].[tbl_NOTABLEACTIVEQUERIES] 
					([plan_total_cpu_ms] ASC) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

					CREATE STATISTICS [_dta_stat_runtime] ON [dbo].[tbl_NOTABLEACTIVEQUERIES]([runtime], [session_id])

					CREATE STATISTICS [_dta_stat_plan_total_dur] ON [dbo].[tbl_NOTABLEACTIVEQUERIES]([plan_total_duration_ms], [runtime], [session_id], [ecid], [plan_total_exec_count], [plan_total_cpu_ms], [plan_total_physical_reads], [plan_total_logical_writes], [plan_total_logical_reads], [dbname], [objectid], [procname], [plan_handle])
_6
					CREATE NONCLUSTERED INDEX [_dta_index_tbl_REQUESTS] ON [dbo].[tbl_REQUESTS] 
					([runtime] ASC,	[session_id] ASC, [database_id] ASC, [program_name] ASC, [host_name] ASC, [login_name] ASC, [os_thread_id] ASC,
					[request_logical_reads] ASC, [request_reads] ASC, [request_writes] ASC, [request_cpu_time] ASC )WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

					CREATE NONCLUSTERED INDEX [_dta_index_tbl_REQUESTS_waits] ON [dbo].[tbl_REQUESTS] 
					([wait_type] ASC, [wait_resource] ASC, [resource_description] ASC) INCLUDE ( [wait_duration_ms]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

					CREATE NONCLUSTERED INDEX [_dta_index_tbl_REQUESTS_wait_dur] ON [dbo].[tbl_REQUESTS] (	[wait_type] ASC) INCLUDE ( [wait_duration_ms]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]

					*/
																																																																																																																						
--=============================================================================================================
--Length of run
print '*****Length of capture and number of runtimes*****'
select min(runtime) as 'StartTime' , max(runtime) as 'EndTime', datediff(n, min(runtime), max(runtime)) as 'Length (min)', Count_runtimes = (select count(*) from tbl_RUNTIMES) from dbo.tbl_REQUESTS 
go
--------------------------------------------------------------------------------------------------------------------------
-- Waits ---
--------------------------------------------------------------------------------------------------------------------------

Print '*****Summary of wait_types******'
select sum(wait_duration_ms) as 'Sum_wait_duration_ms)',  wait_type from tbl_REQUESTS
group by wait_type
having sum(wait_duration_ms) > 0
order by 1 desc
go
--Summary of wait_types, etc
print '*****Summary of wait_types, wait_resource, resouce_description*****'
select sum(wait_duration_ms) as 'sum_wait_duration_ms', count(wait_duration_ms) as 'count_wait_duration_ms', wait_type, wait_resource, resource_description
from tbl_REQUESTS 
--where blocking_session_id != 0 
group by wait_type, wait_resource, resource_description
having sum(wait_duration_ms) > 0
order by 1 desc, 2 desc 
go
print '*****Sum Total of Waits Based on Type:cxpacket*****'
Select sum(a. wait_duration_ms) as Total_WaitTime,count(wait_duration_ms) as occurrences,stmt_text
from (SELECT DISTINCT r.wait_duration_ms ,  r.wait_type, r.wait_resource, r.program_name,q.stmt_text
FROM dbo.tbl_REQUESTS r left outer JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'cxpacket') a
group by stmt_text, program_name, wait_resource, wait_type
ORDER BY  Sum(wait_duration_ms) desc
go

Select wait_resource, tran_type, count(*) as occurrences from tbl_REQUESTs where tran_name = 'DTCXact' and wait_resource <> '' Group by  tran_type, wait_resource order by 1 desc,2 

print '*****Summary of OS Wait Stats*****'
select sum(waiting_tasks_count) as 'Sum_waiting_tasks_count', sum(wait_time_ms) as 'Sum_wait_time_ms', sum(signal_wait_time_ms) as 'Sum_signal_wait_time_ms', wait_type from tbl_OS_WAIT_STATS
group by wait_type
having sum(waiting_tasks_count) > 0
order by 2 desc, 1 desc, 3 desc
go
print '*****Query Compile Waits*****'
SELECT DISTINCT r.RunTime , r.session_id , r.wait_duration_ms , q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'RESOURCE_SEMAPHORE_QUERY_COMPILE'
ORDER BY r.RunTime
go
print '*****Waits Based on Wait Type*****'
SELECT DISTINCT r.RunTime , r.session_id , r.wait_duration_ms , r.wait_type, r.wait_resource, r.program_name,q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'LCK_M_IS'
ORDER BY  wait_duration_ms desc
go
print '*****Count of Waits based on Wait Type*****'
SELECT DISTINCT Count(*) as occurrences, sum(r.wait_duration_ms) as Total_WaitIme , r.tran_type, r.wait_resource, r.program_name,q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'LCK_M_IS'
Group by q.stmt_text, r.wait_resource, r.tran_type, r.program_name
order by 2 desc
go
print '*****Waits based on Resource*****'
SELECT DISTINCT r.session_id , Max(r.wait_duration_ms) , r.wait_type, q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE r.wait_type = 'Resource_semaphore'
Group by q.stmt_text, r.session_id, r.wait_type
ORDER BY   2 desc
go

print '*****Waits based on Stmt Text*****'
SELECT DISTINCT r.RunTime , r.session_id , r.blocking_session_id, r.wait_type, r.task_state, r.wait_duration_ms, r.request_total_elapsed_time, r.request_status, r.*, q.stmt_text
FROM dbo.tbl_REQUESTS r LEFT OUTER JOIN dbo.tbl_NOTABLEACTIVEQUERIES q
ON r.RunTime = q.RunTime and r.session_id = q.session_id
WHERE q.stmt_text like '%select%'
ORDER BY r.runtime

print '*****Waits based on SPID*****'
Select * from tbl_requests where wait_duration_ms > 0 and session_id > 55
go
print '***** Queries Waiting on PageIOlatch with high reads*****'
select * from dbo.tbl_REQUESTS where session_id in (select distinct session_id from dbo.tbl_REQUESTS where last_wait_type like 'PageIo%'
) order by request_logical_reads desc
go


--- Unknown--
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
go
--------------------------------------------------------------------------------------------------------------------------
print 'Reading Queries from Trace ---'
--------------------------------------------------------------------------------------------------------------------------

Select * from readtrace.tblstatements where Session = 51 order by Reads desc

Select * from readtrace.tbluniquebatches 

--Select * from readtrace.tbluniquestatements where Origtext like '%%'

select * from readtrace.tblbatches o
go

Select b.hashid, count(b.hashid) as occurrences, Sum(Duration) as Sum_Duration, u.origtext 
from readtrace.tblstatements b inner join readtrace.tbluniquestatements u on b.hashid = u.hashid
--Where b.batchseq = 100438417
--where b.batchseq = 84353850  
group by b.hashid, u.origtext order by 3 desc
go

Select b.Session
--, b.ConnId
, b.StartTime
, b.endtime
, b.Duration
, b.TextData
, u.OrigText
, u.NormText
from readtrace.tblbatches b 
inner join readtrace.tbluniquebatches u on b.hashid = u.hashid
--where duration > 100000
where b.TextData like '%prod_rm.dbo%'  
order by StartTime
--group by b.hashid, u.origtext order by 3 desc

go

311,283,295
10,017,742
4,290,683

select * from readtrace.tblBatches

Select * from readtrace.tblinterestingevents where eventid = 51
Select session, count(*) as occurrences from readtrace.tblinterestingevents where textdata like '%Error: 8114%' group by session order by 2 desc
go
--------------------------------------------------------------------------------------------------------------------------
-- Interesting Events ---
--------------------------------------------------------------------------------------------------------------------------

Select * from readtrace.tblinterestingevents where eventid = 137
go

Select session, count(*) as occurrences from readtrace.tblinterestingevents where textdata like '%Error: 8114%' group by session order by 2 desc
go
select count(*) as occurrences, Cast(textdata as varchar(50)) as t_Data from readtrace.tblinterestingevents where eventid = 69 group by session, Cast(textdata as varchar(50)) order by 1 desc
go

Print '===Lock Escalations by Object Escalated==='
--Returns the objects that received the lock escalations and how many.
Select objectid, dbid, count(objectid) as occurrences from Readtrace.tblinterestingevents where eventid = 60 group by objectid, dbid order by 3 desc
go
Print '===Lock Escalations by Spid and Object Escalated==='
--Returns the objects escalated by spid
Select session, dbid, objectid, count(objectid) as occurrences from Readtrace.tblinterestingevents where eventid = 60 group by session, dbid, objectid order by 2 desc
go
Print '===Sort Warnings by Spid==='
Select Session, count(Session) as occurrences from Readtrace.tblinterestingevents where eventid= 69 group by Session order by 2 desc
go
Print '===Sort Warnings by eventsubclass'
--If a query involving a sort operation generates a Sort Warnings event class with an Event Sub Class data column value of 2, the performance of the query can be affected because multiple passes over the data are required to sort the data. Investigate the query further to determine whether the sort operation can be eliminated.
Select eventsubclass, count(eventsubclass) as occurrences from Readtrace.tblinterestingevents where eventid= 69 group by eventsubclass order by 2 desc
go
Print '===Sort Warnings by Spid and eventsubclass==='
Select session, eventsubclass, count(Session) as occurrences from Readtrace.tblinterestingevents where eventid= 69 group by Session, eventsubclass order by 2 desc, 3 desc
go
Print '===Attention Statements Customer Ready==='
--Actual statements getting attentions
Set nocount on
Select session, Hashid,count(hashid) as Executions, avg(duration) as avg_duration into #Hash_tmpc from ReadTrace.tblbatches where Attnseq is not null group by hashid, session order by 2 desc
set nocount off
Select session, tblh.hashid, tblh.Executions, tblh.avg_duration,tblu.origtext as Stmt from #hash_tmpc tblh inner join ReadTrace.tbluniquebatches tblu on tblh.hashid = tblu.hashid order by tblh.Executions desc
drop table #hash_tmpc
go
Print '===Attentions by Spid==='
--Gives the attentions by spid.
Select Session, count(Session) as occurrences from Readtrace.tblinterestingevents where eventid = 16 group by session order by 2 desc
go
Print '===Attentions by Hashid==='
--Trying to find out which statements encountered the most Attentions
Select Hashid, count(hashid) as occurrences, sum(duration) as sum_duration, avg(duration) as avg_duration, sum(reads) as sum_Reads, avg(Reads) as avg_Reads, sum(Writes) as sum_Writes, avg(writes) as avg_writes, sum(cpu) as sum_cpu, avg(cpu) as avg_cpu from ReadTrace.tblbatches where Attnseq is not null group by hashid order by 2 desc
go


--------------------------------------------------------------------------------------------------------------------------
-- Query Analysis Scripts ---
--------------------------------------------------------------------------------------------------------------------------


Print '===Top 10 Writers==='
Select Top 10 b.hashid,Count(b.hashid) as Executes,sum(b.writes) as sum_writes, avg(b.writes) as Avg_Writes, cast(u.OrigText as char(1000)) as Stmt from readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc
go
Print '===Top 10 Writers by Hashid==='
Select Top 10 sum(b.writes) as sum_writes, b.hashid, cast(u.OrigText as char(1000)) as Stmt from readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 1 desc
go
Print '===Top 1 Writer by Spid==='
Select Top 1 sum(b.writes) as sum_writes, b.Session, cast(u.OrigText as char(1000)) as Stmt from readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, b.Session, cast(u.OrigText as char(1000)) order by 1 desc
go

Print '===Top 10 Reads==='
Select Top 10 b.hashid,Count(b.hashid) as Executes, sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc


Print '===Top 10 Sum Duration==='
Select Top 10 b.hashid, Count(b.hashid) as Executes, sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc
go
Print '===Top 10 Avg Duration==='
Select Top 10 b.hashid, Count(b.hashid) as Executes, sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 4 desc
go
Print '===Top 10 CPU==='
Select Top 10 b.hashid, Count(b.hashid) as Executes, sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc
go
Print '===Top CPU Batches==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid
group by b.hashid, cast(u.OrigText as char(1000)) order by 7 desc
go
Print '===Top READ Batches==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid
group by b.hashid, cast(u.OrigText as char(1000)) order by 5 desc
go
Print '===Top Write Batches==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid
group by b.hashid, cast(u.OrigText as char(1000)) order by 9 desc
go
Print '===Top Duration Batches==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid
group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc
go
Print '===Top CPU Statements==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquestatements u inner join readtrace.tblstatements b on u.hashid = b.hashid 
group by b.hashid, cast(u.OrigText as char(1000)) order by 7 desc
go
Print '===Top READ Statements==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquestatements u inner join readtrace.tblstatements b on u.hashid = b.hashid 
group by b.hashid, cast(u.OrigText as char(1000)) order by 5 desc
go
Print '===Top Write Statements==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquestatements u inner join readtrace.tblstatements b on u.hashid = b.hashid 
group by b.hashid, cast(u.OrigText as char(1000)) order by 9 desc
go
Print '===Top Duration Statements==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquestatements u inner join readtrace.tblstatements b on u.hashid = b.hashid 
group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc
go



Print '===Top Summary==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid 
group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc
go
Print '===Top Reads based on DatabaseID==='
select top 10 DBID,COUNT(dbid) as occurrences, SUM(reads) as sum_reads from readtrace.tblstatements group by  DBID order by 3 desc
go
--------------------------------------------------------------------------------------------------------------------------
-- Blocking Queries ---
--------------------------------------------------------------------------------------------------------------------------

--Get the inputbuffer of head blocker
print '*****Head of the blocking chain*****'
select distinct r.runtime, r.session_id, r.Program_name, h.blocking_resource_wait_type, h.blocked_task_count, h.tot_wait_duration_ms, h.avg_wait_duration_ms,
r.last_wait_type, r.open_trans, r.database_id, r.program_name, r.host_name, r.login_name, r.request_logical_reads, r.request_reads, r.request_writes , r.request_cpu_time, r.memory_usage, r.total_elapsed_time, r.scheduler_id, r.command, 
n.stmt_text, n.plan_handle
from tbl_REQUESTS r left outer join tbl_NOTABLEACTIVEQUERIES n on r.runtime = n.runtime and  r.session_id = n.session_id
inner join tbl_HEADBLOCKERSUMMARY h on r.runtime = h.runtime and r.session_id = h.head_blocker_session_id
order by 1 asc
go
--Duration 
print '*****Duration: > 10 seconds (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_duration_ms > 10000 order by plan_total_duration_ms desc
go
print '*****Head of the blocking chain - Count by Statement Text*****'
select distinct Count(r.session_id) as Occurrences, n.stmt_text
from tbl_REQUESTS r left outer join tbl_NOTABLEACTIVEQUERIES n on r.runtime = n.runtime and  r.session_id = n.session_id
inner join tbl_HEADBLOCKERSUMMARY h on r.runtime = h.runtime and r.session_id = h.head_blocker_session_id
Group by n.stmt_text
order by 1 desc
go
print '*****Head of the blocking chain - Count by Wait Type*****'
select distinct Sum(h.tot_wait_duration_ms) as wait_time_ms, r.wait_type, r.wait_resource,  Count(r.last_wait_type) as Occurrences, n.stmt_text
from tbl_REQUESTS r left outer join tbl_NOTABLEACTIVEQUERIES n on r.runtime = n.runtime and  r.session_id = n.session_id
inner join tbl_HEADBLOCKERSUMMARY h on r.runtime = h.runtime and r.session_id = h.head_blocker_session_id
Group by r.wait_resource, r.wait_type, n.stmt_text
order by 1 desc
go
--=============================================================================================================
--CPU 
print '*****CPU: > 1 second (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_cpu_ms > 1000 order by plan_total_cpu_ms desc
go
--=============================================================================================================
--Reads
print '*****Reads: > 10000 (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_logical_reads > 10000 order by plan_total_logical_reads desc
go
--=============================================================================================================
--Writes
print '*****Writes: > 1000 (top 25)*****'
select distinct top 25 * from tbl_NOTABLEACTIVEQUERIES where plan_total_logical_writes > 1000 order by plan_total_logical_writes desc
go

--------------------------------------------------------------------------------------------------------------------------
-- Memory ---
--------------------------------------------------------------------------------------------------------------------------
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
go
--------------------------------------------------------------------------------------------------------------------------
-- Data File Contention ---
--------------------------------------------------------------------------------------------------------------------------


print '*****Database File Contention*****'
SELECT DISTINCT Count(*) as Occurrences, Left(r.wait_resource,4) as Database_File, sum(r.wait_duration_ms) as Total_WaitIme, r.wait_type
FROM dbo.tbl_REQUESTS r 
group by Left(r.wait_resource,4),r.wait_type
order by 2
go
print '*****TempDB File Contention*****'
SELECT DISTINCT Count(*) as Occurrences, Left(r.wait_resource,4) as Database_File, sum(r.wait_duration_ms) as Total_WaitIme, r.wait_type
FROM dbo.tbl_REQUESTS r 
WHERE r.wait_resource like  '2:%' 
group by Left(r.wait_resource,4),r.wait_type
order by 2
go



--------------------------------------------------------------------------------------------------------------------------
-- Querying a .trc Directly ---
--------------------------------------------------------------------------------------------------------------------------
/*
Select * from ::fn_trace_gettable('', default) where 

Select Count(*) from ::fn_trace_gettable('D:\output\CCTSQL_SQLDIAG__sp_trace.trc',default) where eventclass in (37, 166)

Select cast(textdata as char(50)) as t_data, sum(reads) as sum_reads, avg(reads) as avg_reads from fn_trace_gettable('E:\Cases\Masha\Carefusion\output\Trace_files\PWIL0690PSDB21_SQLDIAG_SCOM12_sp_trace.trc',default) 
where textdata like '%exec StandardDatasetMaintenance @DatasetId=%' and eventclass=10
group by cast(textdata as char(50))
order by 2 desc
*/
--------------------------------------------------------------------------------------------------------------------------
-- Scratchpad for Blocking ---
--------------------------------------------------------------------------------------------------------------------------

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


--------------------------------------------------------------------------------------------------------------------------
-- Random ---
--------------------------------------------------------------------------------------------------------------------------

print 'List all Programs talking to SQL and show the one talking the most first'
Select program_name, count(*) as occurrences FROM dbo.tbl_REQUESTS group by program_name order by 2 desc
 go
print 'This was a scratchpad query where I was looking in the table for a specific stored procedure. '
Select  * From dbo.tbl_NotableActiveQueries where stmt_text like '%deleteexpireddocabstraction%'
 go
 print 'List all requests issued by SQL Agent and show me the longest one first'
Select * from dbo.tbl_requests where program_name like 'SQLAgent%' order by wait_duration_ms desc
 go
 print 'Show me every row in tbl_spinlockstats'
Select * from tbl_spinlockstats
go
 print 'Show me all queries where the statement had the word fulltext'
Select * from tbl_notableactivequeries where stmt_text like '%fulltext%'
go
--Show me the Sort order and Character set for the current SQL Server Instance
--exec sp_helpsort;

print 'Show me the sort order and collation'
SELECT SERVERPROPERTY ('Collation')
go 
--print 'Show me the structure of the table tbl_requests'
--sp_help tbl_requests
 go
print 'Show me specific objects in sys.sysobjects'
Select id, [type], [name] from sys.sysobjects where id in(213575799)
 
 go
 /*print 'Show me all the wait resources and the query text for all statements that had a wait type of TWO_THREAD_PIPE_EVENT'
SELECT DISTINCT r.Wait_type, r.wait_resource, 
SUBSTRING(st.text, (r.statement_start_offset/2)+1, 
        ((CASE r.statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
         ELSE r.statement_end_offset
         END - r.statement_start_offset)/2) + 1) AS statement_text
FROM  sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
WHERE r.wait_type = 'async_io_completion'
Group by st.text, r.wait_resource, r.wait_type
order by 2 desc
go
*/




--------------------------------------------------------------------------------------------------------------------------
print 'Interesting Events Script ---'
--------------------------------------------------------------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Event_Desc]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Event_Desc]
GO
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Except_Desc]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Except_Desc]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Recompile_Desc]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Recompile_Desc]
GO

Create Table Event_Desc (Eventid int, evtDescription varchar(50))
Create unique clustered Index EvtIdx on Event_Desc (Eventid)
go

CREATE TABLE dbo.Except_Desc (Except_Err char(12), errDescription varchar(1000))
CREATE  UNIQUE  CLUSTERED  INDEX [ErrIdx] ON [dbo].[Except_Desc]([Except_Err])
GO

CREATE TABLE dbo.Recompile_Desc (Reason_id int, RecDescription varchar(100))
CREATE  UNIQUE  CLUSTERED  INDEX [RecIdx] ON [dbo].[Recompile_Desc]([Reason_id])
GO

Set nocount on
--Trace Event Descriptions
Insert into Event_Desc values (16, 'Attention');
Insert into Event_Desc values (55, 'Hash Warning');
Insert into Event_Desc values (17, 'Lock:Timeout');
Insert into Event_Desc values (37, 'sp:recompile');
Insert into Event_Desc values (33, 'Exception');
Insert into Event_Desc values (58, 'Auto Update Stats');
Insert into Event_Desc values (60, 'Lock:Escalation');
Insert into Event_Desc values (61, 'OLE DB Errors');
Insert into Event_Desc values (69, 'Sort Warning');
Insert into Event_Desc values (79, 'Missing Column Statistics');
Insert into Event_Desc values (80, 'Missing Join Predicate');
Insert into Event_Desc values (81, 'Server Memory Change');
Insert into Event_Desc values (67, 'Execution Warnings');
Insert into Event_Desc values (92, 'Data File Auto Grow');
Insert into Event_Desc values (93, 'Log File Auto Grow');
Insert into Event_Desc values (166, 'SQL:StmtRecompile');
Insert into Event_Desc Values (137, 'Blocked Process Report');
Insert into Event_Desc Values (189, 'Lock:Timeout timeout > 0');
Insert into Event_Desc Values (193, 'Background Job Error');

--Exception Event Descriptions
Insert into Except_Desc values ('Error: 7969,','No active open transactions.');
Insert into Except_Desc values ('Error: 208, ','Invalid object name %.*ls.');
Insert into Except_Desc values ('Error: 1205,','Transaction (Process ID %d) was deadlocked on {%Z} resources with another process and has been chosen as the deadlock victim. Rerun the transaction.');
Insert into Except_Desc values ('Error: 207, ','Invalid column name %.*ls.');
Insert into Except_Desc values ('Error: 8115,','Arithmetic overflow error converting %ls to data type %ls.');
Insert into Except_Desc values ('Error: 2714,','There is already an object named %.*ls in the database.');
Insert into Except_Desc values ('Error: 2601,','Cannot insert duplicate key row in object %.*ls with unique index %.*ls.');
Insert into Except_Desc values ('Error: 306, ','The text, ntext, and image data types cannot be compared or sorted, except when using IS NULL or LIKE operator.');
Insert into Except_Desc values ('Error: 1222,','Lock request time out period exceeded.');
Insert into Except_Desc values ('Error: 156, ','Incorrect syntax near the keyword %.*ls.');
Insert into Except_Desc values ('Error: 3903,','The ROLLBACK TRANSACTION request has no corresponding BEGIN TRANSACTION.');
Insert into Except_Desc values ('Error: 4104,','The multi-part identifier %.*ls could not be bound.');
Insert into Except_Desc values ('Error: 2526,','Incorrect DBCC statement. Check the documentation for the correct DBCC syntax and options.');
Insert into Except_Desc values ('Error: 102, ','Incorrect syntax near %.*ls.');
Insert into Except_Desc values ('Error: 8169,','Syntax error converting from a character string to uniqueidentifier.');
Insert into Except_Desc values ('Error: 2627,','Violation of %ls constraint %.*ls. Cannot insert duplicate key in object %.*ls.');
Insert into Except_Desc values ('Error: 911, ','Could not locate entry in sysdatabases for database %.*ls. No entry found with that name. Make sure that the name is entered correctly.');
Insert into Except_Desc values ('Error: 8152,','String or binary data would be truncated.');
Insert into Except_Desc values ('Error: 2809,','The request for %S_MSG %.*ls failed because %.*ls is a %S_MSG object.');
Insert into Except_Desc values ('Error: 16917','Cursor is not open.');
Insert into Except_Desc Values ('Error: 16924','Cursorfetch: The number of variables declared in the INTO list must match that of selected columns.');
Insert into Except_Desc Values ('Error: 16945','The cursor was not declared.');
Insert into Except_Desc Values ('Error: 6106,','Process ID %d is not an active process ID.');
Insert into Except_Desc Values ('Error: 8985,','Could not locate file %.*ls in sysfiles.');
Insert into Except_Desc Values ('Error: 913, ','Could not find database ID %d. Database may not be activated yet or may be in transition.');
Insert into Except_Desc Values ('Error: 2812,','Could not find stored procedure %.*ls.');
Insert into Except_Desc Values ('Error: 7955,','Invalid SPID %d specified.');
Insert into Except_Desc Values ('Error: 602, ','Could not find row in sysindexes for database ID %d, object ID %ld, index ID %d. Run DBCC CHECKTABLE on sysindexes.');
Insert into Except_Desc Values ('Error: 7619,','The query contained only ignored words');
Insert into Except_Desc Values ('Error: 515, ','Cannot insert the value NULL into column %.*ls, table %.*ls; column does not allow nulls. %ls fails.');
Insert into Except_Desc Values ('Error: 16937','A server cursor is not allowed on a remote stored procedure or stored procedure with more than one SELECT statement. Use a default result set or client cursor.');
Insert into Except_Desc Values ('Error: 16954','Executing SQL directly; no cursor.');
Insert into Except_Desc Values ('Error: 8144,','Procedure or function %.*ls has too many arguments specified.');
Insert into Except_Desc Values ('Error: 8179,','Could not find prepared statement with handle %d.');
Insert into Except_Desc Values ('Error: 547, ','%ls statement conflicted with %ls %ls constraint %.*ls. The conflict occurred in database %.*ls, table %.*ls %ls%.*ls%ls.');
Insert into Except_Desc Values ('Error: 245, ','Syntax error converting the %ls value %.*ls to a column of data type %ls.');
Insert into Except_Desc Values ('Error: 1203,','Process ID %d attempting to unlock unowned resource %.*ls.');
Insert into Except_Desc Values ('Error: 4613,','Grantor does not have GRANT permission.');
Insert into Except_Desc Values ('Error: 5159,','Operating system error %.*ls on device %.*ls during %ls.');
Insert into Except_Desc Values ('Error: 7602,','The Full-Text Service (Microsoft Search) is not available. The system administrator must start this service.');
Insert into Except_Desc Values ('Error: 9001,','The log for database %.*ls is not available.');
Insert into Except_Desc Values ('Error: 1206,','Transaction manager has canceled the distributed transaction.');
Insert into Except_Desc Values ('Error: 8510,','Enlist of MSDTC transaction failed: %hs.');
Insert into Except_Desc Values ('Error: 3971,','');
Insert into Except_Desc Values ('Error: 3919,','Cannot enlist in the transaction because the transaction has already been committed or rolled back.');
Insert into Except_Desc Values ('Error: 701, ','There is insufficient system memory to run this query.');
Insert into Except_Desc Values ('Error: 802, ','No more buffers can be stolen.');
Insert into Except_Desc Values ('Error: 4604,','There is no such user or group %.*ls');
Insert into Except_Desc Values ('Error: 213, ','Insert Error: Column name or number of supplied values does not match table definition.');
Insert into Except_Desc Values ('Error: 8114,','Error Converting Datatype %ls to %ls.');
Insert into Except_Desc Values ('Error: 8180,','Statement(s) could not be prepared.');

--SP:Recompile Reasons for recompile
Insert into Recompile_Desc values (1,'Schema, bindings, or permissions changed between compile or execute.');
Insert into Recompile_Desc values (2,'Statistics changed.');
Insert into Recompile_Desc values (3,'Object not found at compile time, deferred check to run time.');
Insert into Recompile_Desc values (4,'Set option changed in batch.');
Insert into Recompile_Desc values (5,'Temp table schema, binding, or permission changed.');
Insert into Recompile_Desc values (6,'Remote rowset schema, binding, or permission changed');
Insert into Recompile_Desc values (7,'For browse perms changed.');
Insert into Recompile_Desc values (8,'Query notification environment changed.');
Insert into Recompile_Desc values (9,'MPI view changed.');
Insert into Recompile_Desc values (10,'Cursor options changed.');
Insert into Recompile_Desc values (11,'With recompile option.');
set nocount off


--This gives overview of events pulled out of trace:
Print '====Interesting Events===='
Select ie.eventid, count(ie.eventid) as occurrences, ed.evtdescription as 'Description' from Readtrace.tblinterestingevents ie left join event_desc ed on ie.eventid=ed.eventid group by ie.eventid, ed.evtdescription order by 2 desc
go
Print '===Exceptions Overview==='
Select cast(ie.textdata as char(50)) as text_data, count(ie.textdata) as occurrences, ed.errdescription from Readtrace.tblinterestingevents ie left join except_desc ed on ed.Except_Err = left(ie.textdata, 12) where eventid=33 group by cast(textdata as char(50)),ed.errdescription order by 2 desc
go
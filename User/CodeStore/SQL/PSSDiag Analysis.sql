
PSSDiag Analysis



Environment Info

/*PSSDiag Environment info collection
* This script should produce copy/paste-able results when output directed
* to text or to grid. It collects information about the SQL Server, OS,
* and machine including names, versions, and some configuration info.
* 
*Author: cbenkler
*Last Modified: April 2016
*/

DECLARE @tbl_IMPORTEDFILES_Exists bit;
DECLARE @tbl_PowerPlan_Exists bit;
DECLARE @tbl_REQUESTS_Exists bit;
DECLARE @tbl_ServerProperties_Exists bit;
DECLARE @tbl_StartupParameters_Exists bit;
DECLARE @tbl_SPCONFIGURE_Exists bit;
DECLARE @tbl_Sys_Configurations_Exists bit;
DECLARE @tbl_XPMSVER_Exists bit;
DECLARE @tbl_SCRIPT_ENVIRONMENT_DETAILS_Exists bit;

SET @tbl_IMPORTEDFILES_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_IMPORTEDFILES]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_PowerPlan_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_PowerPlan]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_REQUESTS_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_REQUESTS]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_ServerProperties_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_ServerProperties]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_StartupParameters_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_StartupParameters]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_SPCONFIGURE_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_SPCONFIGURE]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_Sys_Configurations_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_Sys_Configurations]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_XPMSVER_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_XPMSVER]')) IS NOT NULL THEN 1 ELSE 0 END);
SET @tbl_SCRIPT_ENVIRONMENT_DETAILS_Exists = (SELECT CASE WHEN (SELECT OBJECT_ID('[dbo].[tbl_SCRIPT_ENVIRONMENT_DETAILS]')) IS NOT NULL THEN 1 ELSE 0 END);


DECLARE @selectString NVARCHAR(MAX);

SET @selectString = '
              SELECT ''---------------------------------------------''
              UNION ALL 
              SELECT ''PSSDIAG ANALYSIS:''
              UNION ALL 
              SELECT ''---------------------------------------------'''
IF @tbl_IMPORTEDFILES_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT input_file_name
              FROM [dbo].[tbl_IMPORTEDFILES]
              '
END
IF @tbl_REQUESTS_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''''
              UNION ALL
              SELECT ''Collection duration: approximately '' + CAST(DATEDIFF(minute, MIN(runtime), MAX(runtime)) as nvarchar) + '' minutes''
              FROM [dbo].[tbl_REQUESTS]
              UNION ALL
              SELECT ''Approximate start time: '' + CAST(MIN(runtime) as nvarchar(19))
              FROM [dbo].[tbl_REQUESTS]
              UNION ALL
              SELECT ''Approximate end time: '' + CAST(MAX(runtime) as nvarchar(19))
              FROM [dbo].[tbl_REQUESTS]
       '
END
IF (@tbl_ServerProperties_Exists = 1 OR @tbl_SCRIPT_ENVIRONMENT_DETAILS_Exists = 1)
BEGIN
		SET @selectString = @selectString + '
              UNION ALL
              SELECT ''====================================================================================''
              UNION ALL 
              SELECT ''''
              UNION ALL
              SELECT ''SQL Server Info:''
              UNION ALL
              SELECT ''---------------------------------------''
              UNION ALL
              SELECT ''Server name: '' + *_PROPERTY_VALUE_COLUMN_* 
              FROM *_ENVIRONMENT_INFORMATION_TABLE_* 
              WHERE *_PROPERTY_NAME_COLUMN_* = ''SQLServerName'' OR *_PROPERTY_NAME_COLUMN_* = ''SQL Server Name''
              UNION ALL
              SELECT ''Build: '' + *_PROPERTY_VALUE_COLUMN_* 
              FROM  *_ENVIRONMENT_INFORMATION_TABLE_* 
              WHERE *_PROPERTY_NAME_COLUMN_* = ''ProductVersion'' OR *_PROPERTY_NAME_COLUMN_* = ''SQL Version (SP)''
              UNION ALL
              SELECT ''Edition: '' + *_PROPERTY_VALUE_COLUMN_* 
              FROM  *_ENVIRONMENT_INFORMATION_TABLE_* 
              WHERE *_PROPERTY_NAME_COLUMN_* = ''Edition''
              UNION ALL
              SELECT ''Last SQL Server restart: '' + *_PROPERTY_VALUE_COLUMN_*
              FROM  *_ENVIRONMENT_INFORMATION_TABLE_* 
              WHERE *_PROPERTY_NAME_COLUMN_* = ''sqlserver_start_time''
              UNION ALL
              SELECT ''''
              UNION ALL
              SELECT ''Machine Info:''
              UNION ALL
              SELECT ''---------------------------------------''
       '
END
IF @tbl_XPMSVER_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''Windows: '' + Character_Value 
              FROM [dbo].[tbl_XPMSVER]
              WHERE Name = ''WindowsVersion''
       '
END 
IF  (@tbl_ServerProperties_Exists = 1 OR @tbl_SCRIPT_ENVIRONMENT_DETAILS_Exists = 1)
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''Machine Name: '' + *_PROPERTY_VALUE_COLUMN_*
              FROM *_ENVIRONMENT_INFORMATION_TABLE_*
              WHERE *_PROPERTY_NAME_COLUMN_* = ''ComputerNamePhysicalNetBIOS'' OR *_PROPERTY_NAME_COLUMN_* = ''Machine Name''
       '
END
IF  @tbl_PowerPlan_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''Power Plan: '' + ActivePlanName
              FROM [dbo].[tbl_PowerPlan]
       '
END
IF  @tbl_ServerProperties_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''Logical CPU Count: '' + PropertyValue
              FROM [dbo].[tbl_ServerProperties]
              WHERE PropertyName = ''cpu_count''
              UNION ALL
              SELECT ''NUMA nodes: '' + PropertyValue
              FROM [dbo].[tbl_ServerProperties]
              WHERE PropertyName = ''number of visible numa nodes''
			  '
END
IF @tbl_XPMSVER_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''RAM Installed: '' + SUBSTRING(Character_Value, 1, (CHARINDEX(''('',Character_Value)-1)) + ''MB''
              FROM [dbo].[tbl_XPMSVER]
              WHERE Name = ''PhysicalMemory''
			  UNION ALL
              SELECT ''''
       '
END 
IF  @tbl_ServerProperties_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''Last Reboot: '' + PropertyValue
              FROM [dbo].[tbl_ServerProperties]
              WHERE PropertyName = ''machine start time''
              UNION ALL
              SELECT ''''
       '
END 
IF  @tbl_StartupParameters_Exists = 1
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''Startup Parameters:''
              UNION ALL
              SELECT ''------------------------------------------------''
              UNION ALL
              SELECT ArgsValue
              FROM [dbo].[tbl_StartupParameters]
              WHERE ArgsValue like ''-T%'' or ArgsValue like ''-Y%''
              UNION ALL
              SELECT ''''
       '
END
IF  (@tbl_Sys_Configurations_Exists = 1 OR @tbl_SPCONFIGURE_Exists = 1)
BEGIN
       SET @selectString = @selectString + '
              UNION ALL
              SELECT ''Configuration values commonly of interest:''
              UNION ALL
              SELECT ''---------------------------------------------------------------------''
              UNION ALL
              SELECT (name + '': '' + CAST(*_SP_CONFIG_VALUE_COLUMN_* as nvarchar))
              FROM *_SQL_CONFIGURATION_TABLE_*
              WHERE name in (''affinity mask'', ''cost threshold for parallelism'', ''max degree of parallelism'',  ''max server memory (MB)'', ''max worker threads'', ''min memory per query (KB)'', ''min server memory (MB)'', ''network packet size (B)'', ''optimize for ad hoc workloads'')
       '
END

IF @tbl_ServerProperties_Exists = 1 
BEGIN
	SET @selectString = REPLACE(@selectString, '*_ENVIRONMENT_INFORMATION_TABLE_*','[dbo].[tbl_ServerProperties]');
	SET @selectString = REPLACE(@selectString, '*_PROPERTY_NAME_COLUMN_*','PropertyName');
	SET @selectString = REPLACE(@selectString, '*_PROPERTY_VALUE_COLUMN_*','PropertyValue');
END
ELSE IF @tbl_SCRIPT_ENVIRONMENT_DETAILS_Exists = 1
BEGIN
	SET @selectString = REPLACE(@selectString, '*_ENVIRONMENT_INFORMATION_TABLE_*','[dbo].[tbl_SCRIPT_ENVIRONMENT_DETAILS]');
	SET @selectString = REPLACE(@selectString, '*_PROPERTY_NAME_COLUMN_*','Name');
	SET @selectString = REPLACE(@selectString, '*_PROPERTY_VALUE_COLUMN_*','Value');
END

IF @tbl_Sys_Configurations_Exists = 1 
BEGIN
	SET @selectString = REPLACE(@selectString, '*_SQL_CONFIGURATION_TABLE_*','[dbo].[tbl_Sys_Configurations]');
	SET @selectString = REPLACE(@selectString, '*_SP_CONFIG_VALUE_COLUMN_*','value_in_use');
END
ELSE IF @tbl_SPCONFIGURE_Exists = 1
BEGIN
	SET @selectString = REPLACE(@selectString, '*_SQL_CONFIGURATION_TABLE_*','[dbo].[tbl_SPCONFIGURE]');
	SET @selectString = REPLACE(@selectString, '*_SP_CONFIG_VALUE_COLUMN_*','run_value');
END

--SELECT @selectString

exec sp_executesql @selectString



1

SELECT '---------------------------------------------'
UNION ALL 
SELECT 'PSSDIAG ANALYSIS:'
UNION ALL 
SELECT '---------------------------------------------'
UNION ALL 
SELECT input_file_name
FROM [dbo].[tbl_IMPORTEDFILES]
UNION ALL
SELECT '===================================================================================='
UNION ALL 
SELECT ''
UNION ALL
SELECT 'SQL Server Info:'
UNION ALL
SELECT '---------------------------------------'
UNION ALL
SELECT 'Server name: ' + PropertyValue 
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'SQLServerName'
UNION ALL
SELECT 'Build: ' + PropertyValue 
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'ProductVersion'
UNION ALL
SELECT 'Edition: ' + PropertyValue 
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'Edition'
UNION ALL
SELECT 'Last SQL Server restart: ' + PropertyValue
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'sqlserver_start_time'
UNION ALL
SELECT ''
UNION ALL
SELECT 'Machine Info:'
UNION ALL
SELECT '---------------------------------------'
UNION ALL
SELECT 'Windows: ' + Character_Value 
FROM [dbo].[tbl_XPMSVER]
WHERE Name = 'WindowsVersion'
UNION ALL
SELECT 'Machine Name: ' + PropertyValue
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'ComputerNamePhysicalNetBIOS'
UNION ALL
SELECT 'Power Plan: ' + ActivePlanName
FROM [dbo].[tbl_PowerPlan]
UNION ALL
SELECT 'Logical CPU Count: ' + PropertyValue
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'cpu_count'
UNION ALL
SELECT 'NUMA nodes: ' + PropertyValue
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'number of visible numa nodes'
UNION ALL
SELECT 'Last Reboot: ' + PropertyValue
FROM [dbo].[tbl_ServerProperties]
WHERE PropertyName = 'machine start time'
UNION ALL
SELECT ''
UNION ALL
SELECT 'Startup Parameters:'
UNION ALL
SELECT '------------------------------------------------'
UNION ALL
SELECT ArgsValue
FROM [dbo].[tbl_StartupParameters]
WHERE ArgsValue like '-T%' or ArgsValue like '-Y%'
UNION ALL
SELECT ''
UNION ALL
SELECT 'Configuration values commonly of interest:'
UNION ALL
SELECT '---------------------------------------------------------------------'
UNION ALL
SELECT (name + ': ' + CAST(value_in_use as nvarchar))
FROM [dbo].[tbl_Sys_Configurations]
WHERE name in ('affinity mask', 'cost threshold for parallelism', 'max degree of parallelism',  'max server memory (MB)', 'max worker threads', 'min memory per query (KB)', 'min server memory (MB)', 'network packet size (B)', 'optimize for ad hoc workloads')



Errors/Interesting Events

SELECT	ie.EventID, te.name, tsv.subclass_name, COUNT(1) AS [#Occurrences]
FROM	[ReadTrace].[tblInterestingEvents] ie
	JOIN	sys.trace_events te ON te.trace_event_id = ie.EventID 
	JOIN	sys.trace_subclass_values tsv ON tsv.trace_event_id = ie.EventID AND tsv.subclass_value = ie.EventSubclass
GROUP BY	ie.EventID, te.name, tsv.subclass_name
ORDER BY	[#Occurrences] DESC








with tracedata as(
select eventid, count(eventid) as '# Occurrences' 
from [ReadTrace].[tblInterestingEvents] 
group by EventID)
select t.name, d.*
from tracedata d join sys.trace_events t on d.EventID = t.trace_event_id
order by 3 desc


Example output:

name                       eventid     # Occurrences 
----------------------------------------------------    
SQL:StmtRecompile          166         73                
Exception                  33          44                
SP:Recompile               37          32                
Lock:Escalation            60          4                 
Attention                  16          3                 
Auto Stats                 58          3                 
Hash Warning               55          2                 
OLEDB Errors               61          2                 
Missing Join Predicate     80          2                 





Which batches caused the events?

select hashid, count(1) '# Hash Warnings'
from readtrace.tblbatches 
where batchseq in (select batchseq from [ReadTrace].[tblInterestingEvents] where eventid = 55)
group by hashid
order by 2 desc





SELECT	 
		 bat.HashID
		,te.name
		,ie.DBID
		,MIN(CAST(ie.StartTime as datetime)) [FirstTimeEventTriggered]
		,MAX(CAST(ie.StartTime as datetime)) [LastTimeEventTriggered]
		,COUNT(1) [NumberOfTimesThisTriggeredEvent] 
		,AVG(bat.Duration) [AvgDuration]
		,AVG(bat.CPU) [AvgCPU]
		,AVG(bat.Reads) [AvgReads]
		,AVG(bat.Writes)[AvgWrites]
		,td.TextData
FROM	ReadTrace.tblInterestingEvents ie 
	JOIN ReadTrace.tblBatches bat ON ie.BatchSeq = bat.BatchSeq
	JOIN sys.trace_events te ON ie.EventID = te.trace_event_id
	CROSS APPLY (SELECT TOP 1 hashid, textdata from ReadTrace.tblBatches where HashID = bat.HashId and TextData is not null) td 
--WHERE	ie.EventID = 166 
GROUP BY	bat.HashID, te.name, ie.DBID, td.TextData
order by te.name, [NumberOfTimesThisTriggeredEvent] desc, bat.HashID, [FirstTimeEventTriggered]

===================================================================================================================

with exceptions as (
select Error, count(1) as Occurrences
from [ReadTrace].[tblInterestingEvents]
group by Error
)
select m.description, e.*
from exceptions e join sys.sysmessages m on e.Error = m.error
where m.msglangid = 1033
order by e.Occurrences desc


Example output:

description                                                                                    Error     Occurrences
--------------------------------------------------------------------------------------------------------------------
Invalid object name '%.*ls'.                                                                   208       39         
Incorrect syntax near the keyword '%.*ls'.                                                     156       3          
Incorrect DBCC statement. Check the documentation for the correct DBCC syntax and options.     2526      2          



Perf Stats


Top Reads (easily modified for duration, writes, CPU, etc)
------------------------------------------------
with data as(
select  hashid,
		DBID,
		CAST(AVG(duration/1000000.0) as DECIMAL(18,2)) as "Avg Duration (sec)",
		CAST(MAX(duration/1000000.0) as DECIMAL(18,2)) as "Max Duration (sec)",
		SUM(reads) as "Total Reads",
		count(1) as "Executions",
		sum(reads)/count(1) as "Reads/Execution",
		sum(writes) as "Total Writes",
		sum(cpu) as "Total CPU Used"	
from	readtrace.tblbatches
--where dbid = 10
group by	hashid, DBID)
select top 10  b.hashid, d."Max Duration (sec)", d."Avg Duration (sec)", CAST((8*"Total Reads"/1024.0) as DECIMAL(18,2)) as "Reads(MB)", d."Total Reads",d."Executions",d."Reads/Execution",d."Total Writes",d."Total CPU Used", d.DBID, b.origtext as "T-SQL Text"
from data d join readtrace.tbluniquebatches b on d.hashid = b.hashid
where b.origtext not like '%print ''-- top 10%'
order by "Max Duration (sec)" desc

TOP CPU Users
---------------------------------------
select 
	b.duration, dbid, batchseq, b.connseq, b.reads, b.writes, b.cpu, applicationname, loginname, hostname, b.hashid, origtext
from 
		 ReadTrace.tblBatches b 
	join ReadTrace.tblConnections c on c.ConnSeq = b.ConnSeq and c.Session = b.Session 
	join ReadTrace.tblUniqueBatches ub on ub.HashID = b.HashID
where b.CPU > 0 and b.HashID in (
	SELECT TOP 10 HashID
	FROM ReadTrace.tblBatches
	GROUP BY HashID
	ORDER BY SUM(CPU) DESC)
order by b.CPU desc


Top Reads within a time window
------------------------------------------------
Declare @StartOfTimeWindow nvarchar(23);
Declare @EndOfTimeWindow nvarchar(23);

set @StartOfTimeWindow = '2015-09-18 01:29:00.000';  /* <---Modify the start time */
set @EndOfTimeWindow = '2015-09-18 01:29:00.000';   /*  <---Modify the end time */

with data as(
select   hashid
		,[DBID]
		,CAST(AVG(duration/1000000.0) as DECIMAL(18,2)) as "Avg Duration (sec)"
		,SUM(reads) as "Total Reads"
		,count(1) as "Executions"
		,sum(reads)/count(1) as "Reads/Execution"
		,sum(writes) as "Total Writes"
		,sum(cpu) as "Total CPU Used"	
from	readtrace.tblbatches
where	(Duration > 500 or Duration is null)
	and	(StartTime < @StartOfTimeWindow and EndTime > @StartOfTimeWindow)
	or	(StartTime < @EndOfTimeWindow and EndTime is null)
	or	(StartTime is null and EndTime > @StartOfTimeWindow)
	or	(StartTime between @StartOfTimeWindow and @EndOfTimeWindow)
group by	hashid, [DBID])
select top 10  b.hashid, d.DBID, d."Avg Duration (sec)", CAST((8*"Total Reads"/1024.0) as DECIMAL(18,2)) as "Reads(MB)", d."Total Reads",d."Executions",d."Reads/Execution",d."Total Writes",d."Total CPU Used", b.origtext as "T-SQL Text"
from data d join readtrace.tbluniquebatches b on d.hashid = b.hashid
where b.origtext not like '%print ''-- top 10%'
order by "Reads/Execution" desc


WITH Exec Plan
---------------

with data as(
select  hashid, batchseq,
		AVG(duration/1000000.0) as "Avg Duration (sec)",
		SUM(reads) as "Total Reads",
		count(1) as "Executions",
		sum(reads)/count(1) as "Reads/Execution",
		sum(writes) as "Total Writes",
		sum(cpu) as "Total CPU Used"	
from	readtrace.tblbatches
group by	hashid, batchseq)
select top 10	b.hashid, 
				d."Avg Duration (sec)", 
				(8*"Total Reads"/1024.0) as "Reads(MB)", 
				d."Total Reads",d."Executions",
				d."Reads/Execution",
				d."Total Writes",
				d."Total CPU Used", 
				b.origtext as "T-SQL Text",
				up.planhashid, 
				up.normplantext
from	data d join readtrace.tbluniquebatches b on d.hashid = b.hashid
		join readtrace.tblplans p on d.batchseq = p.batchseq
		join readtrace.tbluniqueplans up on up.planhashid = p.planhashid
order by d."Total CPU Used" desc




SELECT	 tb.HashID 
		,COUNT(1) as [Executions]
		,CAST(MIN(duration/1000000.0) as DECIMAL(18,2)) as [MinDuration(sec)]
		,CAST(AVG(duration/1000000.0) as DECIMAL(18,2)) as [AvgDuration(sec)]
		,CAST(MAX(duration/1000000.0) as DECIMAL(18,2)) as [MaxDuration(sec)]
		,SUM(reads) as [TotalReads]
		,AVG(reads) as [AvgReads/Execution]
		,SUM(writes) as [TotalWrites]
		,AVG(writes) as [AvgWrites/Execution]
		,SUM(cpu) as [TotalCPU]
		,AVG(cpu) as [AvgCPU/Execution]
		,tub.OrigText
FROM	ReadTrace.tblBatches tb JOIN ReadTrace.tblUniqueBatches tub ON tb.HashID = tub.HashID
WHERE	tub.OrigText NOT LIKE '%sqldiag%' and tub.OrigText NOT LIKE '%print ''-- top%'
GROUP BY	tb.HashID, tub.OrigText
ORDER BY	[MaxDuration(sec)] DESC


Bad IO time by DB,File
----------------------------
select AVG(AvgIOTimeMS) "Avg IO Time (ms)", Avg(NumberReads) "Avg Reads", Avg(NumberWrites) "Avg Writes", [database], [file] 
from [dbo].[tbl_FileStats]
where AvgIOTimeMS > 30
group by [database], [file]
order by "Avg IO Time (ms)" desc





Wait Stats
--------------------------------
IF OBJECT_ID('tempdb.dbo.#DeltaWaits', 'U') IS NOT NULL
	DROP TABLE #DeltaWaits

SELECT 
	(MAX(waiting_tasks_count) - MIN(waiting_tasks_count)) AS "Delta Waiting Tasks" 
	,(MAX(wait_time_ms) - MIN(wait_time_ms)) AS "Delta Wait Time (ms)"
	,CAST(((MAX(wait_time_ms)-MIN(wait_time_ms))/((MAX(waiting_tasks_count)-MIN(waiting_tasks_count))+1.0)) AS NUMERIC(18,2)) AS "Delta Wait Time per Task (ms)" 
	,wait_type
INTO #DeltaWaits
FROM [dbo].[tbl_OS_WAIT_STATS]
WHERE wait_category != 'ignorable' and wait_type not like '%sleep%'
GROUP BY wait_type

SELECT	#DeltaWaits.*
		, CAST(((("Delta Wait Time (ms)"/((SELECT SUM("Delta Wait Time (ms)") FROM #DeltaWaits)+0.001)))*100)  AS NUMERIC(18,2)) [PercentOfTotalWaiting]
		, CAST(((("Delta Waiting Tasks"/((SELECT SUM("Delta Waiting Tasks") FROM #DeltaWaits)+0.001)))*100)  AS NUMERIC(18,2)) [PercentOfTotalTasks]
FROM #DeltaWaits
ORDER BY "PercentOfTotalWaiting" DESC



blocking
----------------------------------
with blockers as(
	select head_blocker_session_id, blocking_resource_wait_type, head_blocker_proc_name, max(blocked_task_count) "Max blocked tasks", max(max_wait_duration_ms/1000.0) "Max Wait Duration (sec)"
	from [dbo].[tbl_HEADBLOCKERSUMMARY]
	group by head_blocker_session_id, blocking_resource_wait_type,head_blocker_proc_name
)
select	count(1) "Occurrences", 
		CAST(AVG("Max Wait Duration (sec)") AS numeric(18,2)) "Avg Wait Duration (sec)",
		blocking_resource_wait_type, 
		CASE WHEN head_blocker_proc_name != '' THEN head_blocker_proc_name ELSE 'N/A' END "head_blocker_proc_name"
from blockers
where blocking_resource_wait_type != 'NULL'
group by head_blocker_proc_name, blocking_resource_wait_type
order by "Occurrences" desc



Formatted For Excel 

with data as(
select  hashid,
		SUM(reads) as "Total Reads",
		count(1) as "Executions",
		sum(reads)/count(1) as "Reads/Execution",
		sum(writes) as "Total Writes",
		sum(cpu) as "Total CPU Used"	
from	readtrace.tblbatches
group by	hashid)
select  (8*"Total Reads"/1024.0) as "Reads(MB)", d."Total Reads",d."Executions",d."Reads/Execution",d."Total Writes",d."Total CPU Used", left(REPLACE(REPLACE(REPLACE(b.origtext, CHAR(10), ''), CHAR(13), ''), CHAR(9), ''), 255) as "T-SQL Text"
from data d join readtrace.tbluniquebatches b on d.hashid = b.hashid
order by "Reads(MB)" desc



tbl_REQUESTS waiting

with requestData as(
select wait_type, max(wait_duration_ms) [wait_duration_ms]
from [dbo].[tbl_REQUESTS]
where	(wait_type is not null AND blocking_session_id = 0) OR
		(wait_type is null AND session_id in 
			(SELECT blocking_session_id from [dbo].[tbl_REQUESTS] where blocking_session_id <> 0)) 
group by session_id, request_id, wait_type
)SELECT wait_type, CAST(SUM(wait_duration_ms)/60000.0 as numeric(18,2)) wait_duration_minutes
FROM requestData
group by wait_type
order by 2 desc



tbl_REQUESTS 

SELECT
	  session_id
	, request_start_time
	, blocking_session_id
	, COALESCE(NULLIF(wait_type, ''), 'NULL') wait_type
	, MAX(wait_duration_ms) wait_duration_ms
	, COALESCE(NULLIF(wait_resource, ''), 'NULL') wait_resource
	, last_wait_type
	, MAX(request_cpu_time) request_cpu_time
	, MAX(request_logical_reads) request_logical_reads
	, MAX(request_reads) request_reads
	, MAX(request_writes) request_writes
	, MAX(memory_usage) memory_usage
	, MAX(request_total_elapsed_time) request_total_elapsed_time
	, database_id
	, COALESCE(NULLIF(program_name, ''), 'NULL') program_name
	, COALESCE(NULLIF(host_name, ''), 'NULL') host_name
FROM 
	dbo.tbl_REQUESTS
GROUP BY
	  session_id
	, request_start_time
	, query_hash
	, blocking_session_id
	, wait_type 
	, wait_resource
	, last_wait_type
	, database_id
	, program_name
	, host_name
ORDER BY
	  wait_duration_ms DESC
	, request_start_time
	, session_id



blocking

select	head_blocker_proc_name as "Head Blocker", 
		stmt_text,
		blocking_resource_wait_type as "Blocking Resource",
		MAX((tot_wait_duration_ms/(blocked_task_count+1)))/1000 as "Wait per Task (sec)",
		MAX(blocked_task_count) as "Blocked Tasks"		
from	[dbo].[tbl_HEADBLOCKERSUMMARY]
group by	head_blocker_proc_name, stmt_text, blocking_resource_wait_type, head_blocker_session_id
order by "Wait per Task (sec)" desc



Missing Indexes

SELECT
	ROW_NUMBER() OVER (order by improvement_measure desc, avg_user_impact desc) AS [ID]
	,avg_user_impact
	,improvement_measure
	,[database_id]
	,REPLACE(
		create_index_statement,
		SUBSTRING(create_index_statement, 
				  charindex('missing_index_',create_index_statement), 
				  charindex(' ',create_index_statement,
				  charindex('missing_index_',create_index_statement))-charindex('missing_index_',create_index_statement)
				  ),
		'<MissIdx> '
			) AS create_index_statement
	,unique_compiles
	,user_seeks
	,last_user_seek
FROM
	[dbo].[tbl_MissingIndexes]
where avg_user_impact > 90 or user_seeks > 10000 or unique_compiles > 1000

---------------------------------------------------

clean up regex:

Find what:  INCLUDE.*\)\n
Replace with: INCLUDE...\n.



SpinlockStats

with Spinlocks as(
SELECT	 [Spinlock Name]
		,[runtime]
		,(CASE WHEN (ISNUMERIC(Collisions) = 1) THEN CONVERT(bigint, Collisions) ELSE -1 END) [Collisions]
		,(CASE WHEN (ISNUMERIC(Spins) = 1) THEN CONVERT(bigint, Spins) ELSE -1 END) [Spins]
		,(CASE WHEN ((ISNUMERIC([Spins/Collision]) = 1) AND ([Spins/Collision] NOT LIKE '%E%')) THEN CONVERT(numeric(18,2), [Spins/Collision]) ELSE -1 END) [Spins/Collision]
		,(CASE WHEN (ISNUMERIC([Sleep Time (ms)]) = 1) THEN CONVERT(bigint, [Sleep Time (ms)]) ELSE -1 END) [SleepTime(ms)]
		,(CASE WHEN (ISNUMERIC(Backoffs) = 1) THEN CONVERT(bigint, Backoffs) ELSE -1 END) [Backoffs]
FROM [dbo].[tbl_SPINLOCKSTATS]
)
SELECT	 [Spinlock Name]
		,(MAX(Collisions)-MIN(Collisions)) [DeltaCollisions]
		,(MAX(Spins)-MIN(Spins)) [DeltaSpins]
		,(MAX(Spins)-MIN(Spins))/DATEDIFF(second, MIN(runtime), MAX(runtime)) [SpinsPerSec]
		,(MAX([Spins/Collision])-MIN([Spins/Collision])) [DeltaSpins/Collision]
		,(MAX([SleepTime(ms)])-MIN([SleepTime(ms)])) [DeltaSleepTime(ms)]
		,(MAX(Backoffs)-MIN(Backoffs)) [DeltaBackoffs]
FROM	Spinlocks
WHERE		Spins IS NOT NULL AND Spins > -1
		AND [Spins/Collision] IS NOT NULL AND [Spins/Collision] > -1
		AND	[SleepTime(ms)] IS NOT NULL AND	[SleepTime(ms)] > -1
		AND Backoffs IS NOT NULL AND Backoffs > -1
		--AND	runtime > '2015-08-12 08:35:00.000' AND runtime < '2015-08-12 08:45:00.000'
GROUP BY	[Spinlock Name]
ORDER BY	[DeltaSpins] DESC



File Info

select [DbId], [database], [file] 
from [dbo].[tbl_FileStats]
group by [DbId], [database], [file]
order by [DbId] 



Statistics Info

SELECT DISTINCT
	 objname
	,idxname
	,[dbid]
	,(CASE WHEN (ISNUMERIC(rowcnt) = 1) THEN CONVERT(bigint, rowcnt) ELSE -1 END) [row_count]
	,(CASE WHEN (ISNUMERIC(row_mods) = 1) THEN CONVERT(bigint, row_mods) ELSE -1 END) [row_mods]
	,(CASE WHEN (ISNUMERIC(rowcnt) = 1 AND ISNUMERIC(row_mods) = 1) THEN (CAST((CONVERT(bigint, row_mods)/(CONVERT(bigint, rowcnt)+1.0))*100 AS decimal(18,0))) ELSE -1 END) [pct_mod]
	,(CASE WHEN (stats_updated is not null) THEN CONVERT(nvarchar, stats_updated, 126) ELSE 'NEVER' END) [stats_updated]
FROM	[dbo].[tbl_SYSINDEXES]
WHERE	[dbid] > 4
ORDER BY	row_mods DESC, row_count DESC, pct_mod DESC



Memory Grants

SELECT	 [session_id]
		,[request_time]
		,(CASE WHEN (ISNUMERIC([wait_time_ms]) = 1) THEN (CONVERT(int, [wait_time_ms])/1000) ELSE NULL END) [wait_time(sec)]
		,(CASE WHEN (ISNUMERIC([requested_memory_kb]) = 1) THEN CAST((CONVERT(bigint, [requested_memory_kb])/1024.0) AS numeric(18,2)) ELSE NULL END) [requested_memory_MB]
		,(CASE WHEN (ISNUMERIC([granted_memory_kb]) = 1) THEN CAST((CONVERT(bigint, [granted_memory_kb])/1024.0) AS numeric(18,2)) ELSE NULL END) [granted_memory_MB]
		,(CASE WHEN (ISNUMERIC([required_memory_kb]) = 1) THEN CAST((CONVERT(bigint, [required_memory_kb])/1024.0) AS numeric(18,2)) ELSE NULL END) [required_memory_MB]
		,(CASE WHEN (ISNUMERIC([max_used_memory_kb]) = 1) THEN CAST((CONVERT(bigint, [max_used_memory_kb])/1024.0) AS numeric(18,2)) ELSE NULL END) [max_used_memory_MB]
		,[dop]
		,[pool_id]
		,[plan_handle]
		,[sql_handle]
		,[TextData]
FROM	[dbo].[tbl_dm_exec_query_memory_grants] mg
	LEFT OUTER JOIN [ReadTrace].[tblBatches] bat ON mg.session_id = bat.Session
WHERE	bat.StartTime <= mg.request_time
	AND	bat.EndTime >= mg.grant_time 
ORDER BY	[requested_memory_MB] DESC



Parallel executions > 8 DOP

select hashid, dop
FROM	[dbo].[tbl_dm_exec_query_memory_grants] mg
	LEFT OUTER JOIN [ReadTrace].[tblBatches] bat ON mg.session_id = bat.Session
WHERE	dop > 8 
	AND bat.StartTime <= mg.request_time
	AND	bat.EndTime >= mg.grant_time 
GROUP BY hashid, dop
ORDER BY dop DESC



OpenTransactionSearch

select te.name, trc.SPID, count(1) [StatementCount]
from temp_trc trc inner join sys.trace_events te on trc.EventClass = te.trace_event_id
where EventClass in (
	select trace_event_id
	from sys.trace_events where name like 'TM%'
	)
GROUP BY SPID, name
ORDER BY SPID, 3 DESC



LatchStats

SELECT 
	 MAX(waiting_requests_count)-MIN(waiting_requests_count) [waiting_requests_count]
	,MAX(wait_time_ms)-MIN(wait_time_ms) [wait_time_ms]
	,MAX(max_wait_time_ms) [max_wait_time_ms]
	,latch_class
FROM	[dbo].[tbl_dm_os_latch_stats]
GROUP BY latch_class
ORDER BY wait_time_ms DESC



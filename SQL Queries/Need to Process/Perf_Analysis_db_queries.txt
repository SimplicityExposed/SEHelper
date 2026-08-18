; Perf_analysis_db_queries – used to analyze Readtrace tables (ie. Profiler).

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

Print '===Exceptions Overview==='
Select cast(ie.textdata as char(50)) as text_data, count(ie.textdata) as occurrences, ed.errdescription from Readtrace.tblinterestingevents ie left join except_desc ed on ed.Except_Err = left(ie.textdata, 12) where eventid=33 group by cast(textdata as char(50)),ed.errdescription order by 2 desc

Print '---Execptions Overview ---'
select CAST(ie.textdata as CHAR(50)) as text_data,COUNT(ie.textdata) as occurrences,
ed.text 
from Readtrace.tblinterestingevents ie 
left join sys.messages ed on 
ed.message_id = substring(ie.textdata, 8, charindex (',', ie.textdata) - 8) 
and ed.language_id=1033
where eventid=33 group by cast(textdata as char(50)),
ed.text order by 2 desc

Print '===Attentions by Spid==='
--Gives the attentions by spid.
Select spid, count(spid) as occurrences from Readtrace.tblinterestingevents where eventid = 16 group by spid order by 2 desc

Print '===Attentions by Hashid==='
--Trying to find out which statements encountered the most Attentions
Select Hashid, count(hashid) as occurrences, sum(duration) as sum_duration, avg(duration) as avg_duration, sum(reads) as sum_Reads, avg(Reads) as avg_Reads, sum(Writes) as sum_Writes, avg(writes) as avg_writes, sum(cpu) as sum_cpu, avg(cpu) as avg_cpu from ReadTrace.tblbatches where Attnseq is not null group by hashid order by 2 desc

Print '===Attention Statements==='
--Actual statements getting attentions
Set nocount on
Select Hashid, count(hashid) as Executions into #Hash_tmp from Readtrace.tblbatches where Attnseq is not null group by hashid order by 2 desc
set nocount off
Select tblh.Executions, tblu.hashid, tblu.origtext from #hash_tmp tblh inner join Readtrace.tbluniquebatches tblu on tblh.hashid = tblu.hashid order by tblh.Executions desc
drop table #hash_tmp

Print '===Attention Statements Customer Ready==='
--Actual statements getting attentions
Set nocount on
Select Hashid,count(hashid) as Executions, avg(duration) as avg_duration into #Hash_tmpc from ReadTrace.tblbatches where Attnseq is not null group by hashid order by 2 desc
set nocount off
Select tblh.hashid, tblh.Executions, tblh.avg_duration,tblu.origtext as Stmt from #hash_tmpc tblh inner join ReadTrace.tbluniquebatches tblu on tblh.hashid = tblu.hashid order by tblh.Executions desc
drop table #hash_tmpc

Print '===Database and/or Log File growths===='
Select Eventid, dbid, count(dbid) as occurrences from readtrace.tblinterestingevents where eventid between 92 and 93 group by eventid, dbid order by 3 desc

Print '===Sp:Recompiles Over View of Reason for Recompile==='
--Returns an overview for the reason for Recompile.  Use kb article "308737 How to identify the cause of recompilation in an SP:Recompile event to interpret eventsubclass
Select ie.Eventsubclass, count(ie.eventsubclass) as occurrences, rec.recDescription from Readtrace.tblinterestingevents ie left join Recompile_Desc rec on ie.eventsubclass = rec.reason_id where eventid = 37 or eventid = 166 group by eventsubclass,rec.recDescription order by 2 desc

Print '===Sp:Recompiles by SPID and Reason for Recompile==='
--Returns the recompiles by spid and breaks out the reseason for the recompile 
Select Session, eventsubclass, count(eventsubclass) as occurrences from Readtrace.tblinterestingevents where eventid = 37 or eventid = 166 group by Session, eventsubclass order by  3 desc

Print '===Sp:Recompiles by objectid and Reason for Recompile==='
--Returns objectid and the reason for Recompile.  Use kb article "308737 How to identify the cause of recompilation in an SP:Recompile event to interpret eventsubclass
Select ie.Eventsubclass, count(ie.eventsubclass) as occurrences, ie.objectid, rec.recDescription from Readtrace.tblinterestingevents ie left join Recompile_Desc rec on ie.eventsubclass = rec.reason_id where eventid = 37 or eventid = 166 group by ie.objectid, eventsubclass, rec.recDescription order by 2 desc

Print '===Sp:Recompiles by textdata and Reason for Recompile==='
--Returns objectid and the reason for Recompile.  Use kb article "308737 How to identify the cause of recompilation in an SP:Recompile event to interpret eventsubclass
Select ie.Eventsubclass, count(ie.eventsubclass) as occurrences, ie.textdata, rec.recDescription from Readtrace.tblinterestingevents ie left join Recompile_Desc rec on ie.eventsubclass = rec.reason_id where eventid = 37 or eventid = 166 group by ie.textdata, eventsubclass, rec.recDescription order by 2 desc

Print '===Sp:Recompiles by trimmed textdata and Reason for Recompile==='
--Returns objectid and the reason for Recompile.  Use kb article "308737 How to identify the cause of recompilation in an SP:Recompile event to interpret eventsubclass
Select ie.Eventsubclass, count(ie.eventsubclass) as occurrences, Cast(ie.textdata as char(50)) as text_data, rec.recDescription from Readtrace.tblinterestingevents ie left join Recompile_Desc rec on ie.eventsubclass = rec.reason_id 
where eventid = 37 or eventid = 166 group by Cast(ie.textdata as char(50)), eventsubclass, rec.recDescription order by 2 desc


Print '===Lock Escalations by Object Escalated==='
--Returns the objects that received the lock escalations and how many.
Select objectid, dbid, count(objectid) as occurrences from Readtrace.tblinterestingevents where eventid = 60 group by objectid, dbid order by 3 desc

Print '===Lock Escalations by Spid and Object Escalated==='
--Returns the objects escalated by spid
Select session, dbid, objectid, count(objectid) as occurrences from Readtrace.tblinterestingevents where eventid = 60 group by session, dbid, objectid order by 2 desc

Print '===Sort Warnings by Spid==='
Select session, count(session) as occurrences from Readtrace.tblinterestingevents where eventid= 69 group by session order by 2 desc

Print '===Sort Warnings by eventsubclass'
--If a query involving a sort operation generates a Sort Warnings event class with an Event Sub Class data column value of 2, the performance of the query can be affected because multiple passes over the data are required to sort the data. Investigate the query further to determine whether the sort operation can be eliminated.
Select eventsubclass, count(eventsubclass) as occurrences from Readtrace.tblinterestingevents where eventid= 69 group by eventsubclass order by 2 desc

Print '===Sort Warnings by Spid and eventsubclass==='
Select spid, eventsubclass, count(spid) as occurrences from Readtrace.tblinterestingevents where eventid= 69 group by spid, eventsubclass order by 2 desc, 3 desc

Print '===Top 10 Writers==='
Select Top 10 b.hashid,Count(b.hashid) as Executes,sum(b.writes) as sum_writes, avg(b.writes) as Avg_Writes, cast(u.OrigText as char(1000)) as Stmt from readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc

Print '===Top 10 Writers by Hashid==='
Select Top 10 sum(b.writes) as sum_writes, b.hashid, cast(u.OrigText as char(1000)) as Stmt from readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 1 desc

Print '===Top 1 Writer by Spid==='
Select Top 1 sum(b.writes) as sum_writes, b.spid, cast(u.OrigText as char(1000)) as Stmt from readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, b.spid, cast(u.OrigText as char(1000)) order by 1 desc


Print '===Top 10 Reads==='
Select Top 10 b.hashid,Count(b.hashid) as Executes, sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc


Print '===Top 10 Sum Duration==='
Select Top 10 b.hashid, Count(b.hashid) as Executes, sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc

Print '===Top 10 Avg Duration==='
Select Top 10 b.hashid, Count(b.hashid) as Executes, sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 4 desc

Print '===Top 10 CPU==='
Select Top 10 b.hashid, Count(b.hashid) as Executes, sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid group by b.hashid, cast(u.OrigText as char(1000)) order by 3 desc

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


Print '===Summary==='
Select Top 10 b.hashid,Count(b.hashid) as Executes, sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration, sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu, cast(u.OrigText as char(1000)) as Stmt from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid
where b.hashid in(-2558338280738287641,615557425207643518)
group by b.hashid, cast(u.OrigText as char(1000)) 
order by 3 desc

--Print '===Top Index Update statements==='
--Set nocount on
--select cast(textdata as char(1000)) as Text_data into TData from ::fn_trace_gettable('C:\Traces\JackHenry\output2006-07-311000AM\LXNTVSQLB__sp_trace_56.trc',default) where eventclass=68 and textdata like '%Customer57%'
--Set nocount off
--Select count(text_data) as Occurrences, Text_data from TData group by Text_data order by 1 desc
--drop table tdata

EXECUTION PLAN:
===============
SELECT a.[StmtSeq]
--      ,ROUND(((b.[EstimateRows]*b.[EstimateExecutes]) - b.[Rows])/(b.[EstimateRows]*b.[EstimateExecutes]/100.0),2) as [delta_pc]
      ,b.[EstimateRows]
      ,ROUND(b.[Rows]/(b.[Executes]+0.000000000001),3) as [RowsPerExec]
      ,b.[Rows]
      ,b.[Executes]
      ,c.[StmtText]
      ,c.[StmtID]
      ,c.[NodeID]
      ,c.[Parent]
      ,c.[PhysicalOp]
      ,c.[LogicalOp]
      ,c.[Argument]
      ,c.[DefinedValues]
      ,b.[EstimateRows]
      ,c.[EstimateIO]
      ,c.[EstimateCPU]
      ,c.[AvgRowSize]
      ,c.[TotalSubtreeCost]
      ,c.[OutputList]
      ,c.[Warnings]
      ,c.[Type]
      ,c.[Parallel]
      ,b.[EstimateExecutes]
from readtrace.tblPlans a 
join readtrace.tblPlanRows b on a.seq = b.seq
join readtrace.tblUniquePlanRows c on a.PlanHashId = c.PlanHashId and b.RowOrder = c.RowOrder
where a.stmtseq = 64593758
order by b.roworder asc


==IMPORT DOP EVENTS===

SELECT 
EventClass,spid,integerdata,starttime,endtime,EventSubClass,DatabaseID,ApplicationName,HostName
into tblDOPEvent
FROM 
::fn_trace_gettable('D:\Cases\Gagan\output\ENT-SQL-BOP2_DWP_sp_trace.trc', default)
where EventClass in (28,29,30,32)
GO

--Drop table tblDOPEvent

select top 50 a.HashID, Count(a.HashId) as occurrences, Sum(Integerdata) as Sum_MemGrantSize, avg(Integerdata) as avg_MemGrantSize, a.origtext 
from readtrace.tblUniqueStatements a inner join readtrace.tblStatements B on a.hashid = b.hashid
inner join tblDOPEvent C on b.spid = c.spid
       	where b.starttime <= c.starttime
	and b.endtime> c.starttime and hostname <> 'PSSDiag'
--	and c.integerdata > 110000  -- You can change this to the threshold you want or ignore this conditiont otally
    group by a.hashid, a.origtext
        order by 4 desc

Print '===Sp:Recompiles by SPID and Reason for Recompile==='
--Returns the recompiles by spid and breaks out the reseason for the recompile 
Select objectid, eventsubclass, count(eventsubclass) as occurrences from Readtrace.tblinterestingevents where eventid = 37 group by objectid, eventsubclass order by 3 desc, objectid 

==========================================

Select session, count(session) as occurrences from readtrace.tblinterestingevents where textdata like 'Error: 537%' group by session order by 2 desc




Select * from readtrace.tblinterestingevents where textdata like 'Error: 8152,%'

Select * from readtrace.tblinterestingevents where eventid in(93,92) order by duration desc

Select * from readtrace.tblbatches where hashid = 6124545950179432583  --3952958488965163416       
 order by Starttime desc

Select b.hashid, count(b.hashid) as occurrences, Sum(Duration) as Sum_Duration, u.origtext 
from readtrace.tblstatements b inner join readtrace.tbluniquestatements u on b.hashid = u.hashid
Where b.batchseq = 100438417
--where b.batchseq = 84353850  
group by b.hashid, u.origtext order by 3 desc

sp_configure 'Max Server Memory', 2048
go
reconfigure with override

Select top 1 * from readtrace.tblplans where

Select b.hashid, count(*) as occurrences, cast(bu.origtext as varchar(50)) from readtrace.tblstatements s inner join readtrace.tblbatches b on s.batchseq = b.BatchSeq inner join Readtrace.tbluniquebatches bu on bu.hashid = b.hashid
where s.hashid in(Select distinct hashid from readtrace.tbluniquestatements where origtext like '%fn_Timezone_IsDaylightTime%') --where origtext like '%fn_setting_getupstreamids%')
group by b.hashid,  cast(bu.origtext as varchar(50))
order by 2 desc

Select distinct hashid,origtext from readtrace.tbluniquestatements where origtext like '%fn_Timezone_IsDaylightTime%'

Select ts.*, tu.origtext from readtrace.tblstatements ts inner join readtrace.tbluniquestatements tu on ts.hashid = tu.hashid
where tu.origtext like '%statman%' and ts.batchseq=18690762

Select ts.duration, ts.reads, ts.writes, ts.cpu, tu.Origtext 
from readtrace.tblstatements ts inner join readtrace.tbluniquestatements tu on ts.hashid = tu.hashid
where tu.origtext like '%statman%' and ts.batchseq=5091034

Select sum(Duration) as sum_Duration, sum(Reads) as sumReads, sum(writes) as sumWrites, Sum(CPU) as sumCPU
from readtrace.tblstatements ts inner join readtrace.tbluniquestatements tu on ts.hashid = tu.hashid
where tu.origtext like '%statman%' and ts.batchseq=5091034 Group by ts.batchseq



Select spid, count(spid) as occurrences from readtrace.tblinterestingevents where textdata like 'Error: 2601%' group by spid order by 2 desc
Select DBID, count(DBID) as occurrences from readtrace.tblinterestingevents where eventid = 92 group by DBID order by 2 desc

Select * from readtrace.tbluniquestatements where hashid = 3723393884916216450  
--4217237292597049095
Select * from readtrace.tbluniquestatements where origtext like '%F.Quote_ID%'
select @@version
Select * from readtrace.tblinterestingevents where eventid = 137

Select * from readtrace.tblbatches where hashid =  3841867638998520840     order by duration desc

Select * from readtrace.tblstatements where batchseq = 92422240 order by duration desc

Print '===Top Duration Statement==='
Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquestatements u inner join readtrace.tblstatements b on u.hashid = b.hashid 
--where b.hashid in(-192810577498833258,
---8988782107316453402,
---8988782107316453402,
---8988782107316453402,
---8988782107316453402,
---8988782107316453402,
--7311197710940367696,
---9167135102509061833,
---3915593982687236524,
---7371774772853101366)
where batchseq = 56520
group by b.hashid, cast(u.OrigText as char(1000)) order by 5 desc

Select session, count(*) as occurrences from readtrace.tblinterestingevents where textdata like '%Error: 8114%' group by session order by 2 desc


Select * from readtrace.tblstatements where hashid = -4616073359182877778 order by Duration desc

Select * from readtrace.tbluniquestatements where origtext like '%fn_Setting_GetUpstreamIDs%' 

Print '===Sp:Recompiles by trimmed textdata and Reason for Recompile==='
--Returns objectid and the reason for Recompile.  Use kb article "308737 How to identify the cause of recompilation in an SP:Recompile event to interpret eventsubclass
Select ie.Eventsubclass, Count(*) as occurrences, rec.recDescription from Readtrace.tblinterestingevents ie left join Recompile_Desc rec on ie.eventsubclass = rec.reason_id 
where eventid = 37 or eventid = 166 and Textdata like '%fn_Setting_GetUpstreamIDs%'
Group by ie.eventsubclass, rec.recDescription
order by 2 desc

Select * from Readtrace.tblinterestingevents where eventid = 166 and Textdata like '%fn_Setting_GetUpstreamIDs%' and eventsubclass = 4

Select Count(*) as occurrences, eventclass, eventsubclass, Cast(Textdata as varchar(100)) Text_data from ::fn_trace_gettable('D:\Cases\GregHu\PSSDiag_5\Trace_files\output\CCTSQL_SQLDIAG__sp_trace.trc',50) 
where textdata like '%fn_setting_getupstreamids%' and eventclass in (36,35, 34, 37, 166)
Group by Eventclass, eventsubclass, Cast(Textdata as varchar(100))
Order by 1 desc

Select Count(*) from ::fn_trace_gettable('D:\output\CCTSQL_SQLDIAG__sp_trace.trc',default) where eventclass in (37, 166)

Select ba
Select hashid, origtext from readtrace.tbluniquestatements where origtext like '%= s_tcv.tds_collation_28,%'

Select ie.eventid, ie.dbid, count(ie.eventid) as occurrences, ed.evtdescription as 'Description' from Readtrace.tblinterestingevents ie left join event_desc ed on ie.eventid=ed.eventid where ie.eventid = 58 group by ie.eventid, ie.dbid, ed.evtdescription order by 2 desc

set statistics profile on
go
Select ie.eventid, ie.dbid, count(ie.eventid) as occurrences, ed.evtdescription as 'Description' from Readtrace.tblinterestingevents ie left join event_desc ed on ie.eventid=ed.eventid where ie.eventid = 58 group by ie.eventid, ie.dbid, ed.evtdescription order by 2 desc
go
Set statistics profile off

use [114041111356806_PSSDIAG_OUTPUT_CSVT000A1099_WWU001_20140425_1500]

Print '===Top Summary==='
Select b.hashid,Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid 
where StartTime between '2014-04-25 15:09:00.000' and '2014-04-25 15:23:59.999'
group by b.hashid, cast(u.OrigText as char(1000)) order by 9 desc

Select Top 10 b.hashid,
Count(b.hashid) as Executes,
sum(b.duration) as sum_duration, avg(b.Duration) as avg_Duration,
sum(b.Reads) as sum_reads, avg(b.Reads) as avg_reads, 
sum(b.cpu) as sum_cpu, avg(b.cpu) as avg_cpu,
sum(b.writes) as sum_writes, avg(b.writes) as avg_writes,
cast(u.OrigText as char(1000)) as Stmt 
from Readtrace.tbluniquebatches u inner join readtrace.tblbatches b on u.hashid = b.hashid 
group by b.hashid, cast(u.OrigText as char(1000)) order by 9 desc

/*Aj Pitre - UPS */
Select * from readtrace.tblBatches where HashID = -4939063120432209183 order by writes desc  Executed 957 times between 3:10 and 3:21
Select * from readtrace.tblBatches where HashID = -7371774772853101366 order by writes desc  

Select MIN(Starttime) as First_Execution, MAX(STarttime) as Last_Execution from readtrace.tblBatches where HashID = -7371774772853101366

Select * from readtrace.tblStatements where batchseq = 4227053


Select * from readtrace.tblbatches where HashID = -4939063120432209183  order by Writes desc


declare @P0001 nvarchar(151)  set @P0001 = N'       UPDATE [APD_BLCL].USBROKERDOWNLOAD           SET SHIPMENT_OID = '''',               PROCESSED = ''0''         WHERE SHIPMENT_OID = @ShipmentOid     '  declare @P0002 nvarchar(26)  set @P0002 = N'@ShipmentOid varchar(8000)'  declare @P0003 varchar(1)  set @P0003 = ''  exec sp_executesql @P0001, @P0002, @ShipmentOid = @P0003                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                

Select * from sys.sysdatabases where name like '%114070911604331%'

use [114070911604331_output]

Select * from readtrace.tblbatches where session = 61

Select * from readtrace.tbluniquebatches where origtext like '%WHERE AppID = 656719%' 

Select @@Servername

use [114042411390243_output]

Select * from readtrace.tblbatches where hashid = 2658507128574931300  and session in(57,60,80)

Select * from readtrace.tblstatements where batchseq = 56520 order by READS desc
Select * from readtrace.tblinterestingevents where eventid = 61 and session in(57,60,80)

select getdate() AS runtime, SUM (user_object_reserved_page_count)*8 as usr_obj_kb,

SUM (internal_object_reserved_page_count)*8 as internal_obj_kb,

SUM (version_store_reserved_page_count)*8  as version_store_kb,

SUM (unallocated_extent_page_count)*8 as freespace_kb,

SUM (mixed_extent_page_count)*8 as mixedextent_kb

FROM sys.dm_db_file_space_usage
select * from sys.sysdatabases where name like '%114062311558668%'
Select * from sys.sysmessages where error = 15114 and msglangid = 1033
use [114062311558668_output]

Select * from readtrace.tbluniquebatches where origtext like '%Expr1103%'

Select * from readtrace.tblbatches where attnseq is not null and session in(57,60,80)

use [114072211640614_output__2_]

Select * from readtrace.tblinterestingevents where eventid =80 order by starttime

Select * from readtrace.tblbatches  order by duration desc where session = 56 and starttime between '2014-07-24 13:03:33.000' and '2014-07-24 13:03:33.600' order by starttime

select * from readtrace.tblbatches where hashid = -6103789880935861336 order by duration desc

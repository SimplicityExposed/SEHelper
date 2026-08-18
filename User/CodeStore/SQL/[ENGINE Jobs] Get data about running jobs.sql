SELECT
    [sJOB].[job_id] AS [JobID]
	,[sJOBACT].[session_id] AS [SPID]
    , [sJOB].[name] AS [JobName]
    , [sJSTP].[step_uid] AS [StepID]
    , [sJSTP].[step_id] AS [StepNo]
    , [sJSTP].[step_name] AS [StepName]
    , CASE [sJSTP].[subsystem]
        WHEN 'ActiveScripting' THEN 'ActiveX Script'
        WHEN 'CmdExec' THEN 'Operating system (CmdExec)'
        WHEN 'PowerShell' THEN 'PowerShell'
        WHEN 'Distribution' THEN 'Replication Distributor'
        WHEN 'Merge' THEN 'Replication Merge'
        WHEN 'QueueReader' THEN 'Replication Queue Reader'
        WHEN 'Snapshot' THEN 'Replication Snapshot'
        WHEN 'LogReader' THEN 'Replication Transaction-Log Reader'
        WHEN 'ANALYSISCOMMAND' THEN 'SQL Server Analysis Services Command'
        WHEN 'ANALYSISQUERY' THEN 'SQL Server Analysis Services Query'
        WHEN 'SSIS' THEN 'SQL Server Integration Services Package'
        WHEN 'TSQL' THEN 'Transact-SQL script (T-SQL)'
        ELSE sJSTP.subsystem
      END AS [StepType]
    , [sPROX].[name] AS [RunAs]
    , [sJSTP].[database_name] AS [Database]
    , [sJSTP].[command] AS [ExecutableCommand]
    , CASE [sJSTP].[on_success_action]
        WHEN 1 THEN 'Quit the job reporting success'
        WHEN 2 THEN 'Quit the job reporting failure'
        WHEN 3 THEN 'Go to the next step'
        WHEN 4 THEN 'Go to Step: ' 
                    + QUOTENAME(CAST([sJSTP].[on_success_step_id] AS VARCHAR(3))) 
                    + ' ' 
                    + [sOSSTP].[step_name]
      END AS [OnSuccessAction]
    , [sJSTP].[retry_attempts] AS [RetryAttempts]
    , [sJSTP].[retry_interval] AS [RetryInterval (Minutes)]
    , CASE [sJSTP].[on_fail_action]
        WHEN 1 THEN 'Quit the job reporting success'
        WHEN 2 THEN 'Quit the job reporting failure'
        WHEN 3 THEN 'Go to the next step'
        WHEN 4 THEN 'Go to Step: ' 
                    + QUOTENAME(CAST([sJSTP].[on_fail_step_id] AS VARCHAR(3))) 
                    + ' ' 
                    + [sOFSTP].[step_name]
      END AS [OnFailureAction]
FROM
    [msdb].[dbo].[sysjobsteps] AS [sJSTP]
    INNER JOIN [msdb].[dbo].[sysjobs] AS [sJOB]
        ON [sJSTP].[job_id] = [sJOB].[job_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOSSTP]
        ON [sJSTP].[job_id] = [sOSSTP].[job_id]
        AND [sJSTP].[on_success_step_id] = [sOSSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sOFSTP]
        ON [sJSTP].[job_id] = [sOFSTP].[job_id]
        AND [sJSTP].[on_fail_step_id] = [sOFSTP].[step_id]
    LEFT JOIN [msdb].[dbo].[sysproxies] AS [sPROX]
        ON [sJSTP].[proxy_id] = [sPROX].[proxy_id]
	LEFT JOIN [msdb].[dbo].[sysjobactivity] AS [sJOBACT]
		ON [sJSTP].[job_id] = [sOFSTP].[job_id]
ORDER BY [JobName], [StepNo]

/* This is the chat log for when I obtained the query.
[?10/?26/?2016 11:34 AM] William Cook: 
Do any of you have a sql query seeing who is executing a job currently
[?10/?26/?2016 11:34 AM] Tony Siders (Convergys Corporation): 
spwho2
[?10/?26/?2016 11:35 AM] William Cook: 
is the command going to tell you the job though I don't think it does
and to specify a job, not a SPID running T-SQL, but a SQL Server Agent Service job
[?10/?26/?2016 11:37 AM] Tony Siders (Convergys Corporation): 
the account running the job is available in the settings for that job
the sp_who2 will tell what login is running currently running processes
[?10/?26/?2016 11:39 AM] William Cook: 
the sp_who2 doesn't given enough information is what I am stating, just enough to manually correlate. I am looking for more verbose information 
[?10/?26/?2016 11:40 AM] Samuel Okudjeto (Convergys Corporation): 
@will.. what exactly are you looking for in the query results?
[?10/?26/?2016 11:41 AM] Paul Haefeli (Convergys Corporation): 
use sp_who2 to get SPID
plug in SPID here to see query -> DBCC INPUTBUFFER (SPID);   
[?10/?26/?2016 11:46 AM] William Cook: 
@Samuel, SPID, USER, Job name, Step, Query
that is more of what I am trying to get at
[?10/?26/?2016 11:46 AM] Samuel Okudjeto (Convergys Corporation): 
i have a query for all that except user
[?10/?26/?2016 11:46 AM] William Cook: 
@Paul, the sp_who2 and the DBCC INPUTBUFFER doesn't provide it well enough
[?10/?26/?2016 11:47 AM] Samuel Okudjeto (Convergys Corporation): 
  let me try to join some other sys tables in msdb to see if i can get the user too 
[?10/?26/?2016 11:47 AM] William Cook: 
could you send what you have right now?
[?10/?26/?2016 11:51 AM] Samuel Okudjeto (Convergys Corporation): 
yeah one sec
[?10/?26/?2016 12:01 PM] Samuel Okudjeto (Convergys Corporation): 
alright Will.. you might be in luck in with this query

-- Query was shared here --

[?10/?26/?2016 12:02 PM] 
What's that for Sam? (About to save it to my library of queries, because reference material is win.)
[?10/?26/?2016 12:04 PM] William Cook: 
@Sam, thank you
[?10/?26/?2016 12:04 PM] Samuel Okudjeto (Convergys Corporation): 
it query's the msdb database for job information... the job_id, spid, user, the job_query_command, 
yw Will
[?10/?26/?2016 12:05 PM] Robbie Bordeaux: 
The dbcc inputbuffer process helps to get what is being ran at the time though... that script only gives you the job info
i had setup a test job that delays 20 seconds and ran the sp_who to get spid and ran against inputbuffer and got that info too...
[?10/?26/?2016 12:06 PM] William Cook: 
True robbie
[?10/?26/?2016 12:06 PM] Robbie Bordeaux: 
still a very handy script to have
[?10/?26/?2016 12:06 PM] Samuel Okudjeto (Convergys Corporation): 
yup you can always edit to add more columns as required :)
*/

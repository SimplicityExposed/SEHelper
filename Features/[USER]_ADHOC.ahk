; TODO - Script automatic creation of symbolic links to networked SR folders and integrate support into SE Helper.
; TODO - Create SQL scripts and settings to allow other users to connect directly to my SR specific DB's.
; TODO - Figure out if SQL Nexus %TEMP%\RML exports on PSSDiag import organize by SR# or not and map a symbolic link to organize this data, preferably into SR Workspace folders.
; TODO - Date & Time converter with log specific format choices and server timezone selection for simplified find & replace.
; YO. FINISH MAPPING YOUR WORKFLOW RESOURCES!
LogViewerUIState = 0
Global ADOSQL_LastError, ADOSQL_LastQuery ; These super-globals are for debugging your SQL queries.
global Connection_String
Connection_String := "Driver={SQL Server};Server=V-SMMI\SQL2016DEV;DataBase=SEHelper;Uid=;Pwd=;" ; Windows Auth - Working
;query_statement := "INSERT INTO AHKTestTable (EntryField) VALUES ('AHK')"
query_statement := "SELECT SUSER_NAME(), USER_NAME();"
preventScreenSaverVar := false ; Boolean for Screen-saver prevention label (subroutine). True = running/enabled.
SetTimer, preventScreenSaver, 60000 ; Screen-saver launch prevention label (subroutine), checks every 1 minute




;MsgBox % "Admin State: " . A_Admin

global LogQuery
LogQuery := "INSERT INTO PersonalLog (LogLabel, LogEntry) VALUES ('" . Stephen . "', '" . Jiang . "');"



TEMPDB_Connection_String := "Driver={SQL Server};Server=SMMI;DataBase=tempdb;Uid=;Pwd=;"

 
TestInsert = `
(
INSERT INTO CodeTable (CodeField) VALUES (N'/****** Object:  StoredProcedure [dbo].[seh_TableMaker_SRDetails]    Script Date: 10/28/2016 1:59:35 PM ******/
CREATE PROCEDURE seh_TableMaker_SRDetails (
	@SRNum NVARCHAR(255))
	AS BEGIN
		DECLARE @TableName NVARCHAR(255)
			SET @TableName = N''SR_'' + @SRNum + ''_SRDetails''
		DECLARE @TableTemplate NVARCHAR(MAX)
			SET @TableTemplate = (
				N''CREATE TABLE '' + @TableName + '' (
					EntryNumber			INT PRIMARY KEY NOT NULL,
					ActiveComment		NVARCHAR(MAX),
					SourceFile			NVARCHAR(255),
					InternalComment		NVARCHAR(1000),
					ExternalComment		NVARCHAR(1000),
					CapturedOn			DATETIME	DEFAULT (getdate()),
					CapturedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),''''?'''')),
					UpdatedOn			DATETIME	DEFAULT (getdate()),
					UpdatedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),''''?'''')),);'');
		DECLARE @TriggerTemplate NVARCHAR(MAX)
			SET @TriggerTemplate = (
				N''CREATE TRIGGER trg_'' + @TableName + ''_ForUpdateAudit
					ON '' + @TableName + ''
				FOR UPDATE
				AS BEGIN
					IF (@@rowcount = 0)
						Return

					UPDATE d
					SET
						UpdatedOn = GETDATE(),
						UpdatedBy = (COALESCE(SUSER_SNAME(),''''?''''))
					FROM '' + @TableName + '' d JOIN inserted i
					 on d.EntryNumber = i.EntryNumber
				END;'')
		DECLARE @TriggerEnabler NVARCHAR(MAX)
			SET @TriggerEnabler = (
			N''ALTER TABLE '' + @TableName + '' ENABLE TRIGGER trg_'' + @TableName + ''_ForUpdateAudit;'')
		EXECUTE sp_executesql @TableTemplate;
		EXECUTE sp_executesql @TriggerTemplate;
		EXECUTE sp_executesql @TriggerEnabler;
	END
GO


-- Table Creation Workspace
CREATE TABLE TestSRDetailsTable (
					SRNUM				INT PRIMARY KEY NOT NULL,
					Title				NVARCHAR(255),
					Category			NVARCHAR(255),
					Workflow			NVARCHAR(255),
					Status				NVARCHAR(255),

					ActiveComment		NVARCHAR(MAX),

					CapturedOn			DATETIME	DEFAULT (getdate()),
					CapturedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),''?'')),
					UpdatedOn			DATETIME	DEFAULT (getdate()),
					UpdatedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),''?'')),);

SELECT * FROM TestSRDetailsTable')
)

;MsgBox % TestInsert


;ADOSQL(TEMPDB_connection_string,TestInsert)

Return


;OnClipboardChange:
IfWinActive, MSSolve,
	{
		ToolTip Clipboard changed with MSSolve Active.
		Sleep 1000
		ToolTip  ; Turn off the tip.
		Return
	}
	ToolTip Clipboard changed with random window open.
	Sleep 1000
	ToolTip  ; Turn off the tip.	
return














Return
;F3::
;PersonalLogViewer()
;ToggleLogViewer()
;Return


;F2::
;SQLResults = ;
;SQLResults := ADOSQL(connection_string,ViewLogQuery)
;PrintArr(SQLResults,90,"xCenter yCenter w1000 h500")
;Return


Return
Clipboard := "Last Error:`n" . ADOSQL_LastError . "`n`n`n`nLast Query:`n" . ADOSQL_LastQuery
SoundBeep
Return

F3::
SQLResults = ;
EmptyMem()
Return


Return
Run, onenote:https://microsoft.sharepoint.com/teams/bidpwiki/SQLTroubleshootingFiles/SQLClusterFailoverWorkflow/
Return

; EnvGet, Domain, USERDOMAIN
; MsgBox % Domain . "\" . A_Username
; Return

!F1::
;MsgBox, 32, Title, Text
Return

; Example of loop with cancel button
^F7::
$stop := 0
Loop, 
{ 
	Send, {!}clear 5000{ENTER}
	Sleep, 45000
	if ($stop)
	{ 
	  return
	}
}

^F8:: $stop := 1
Return


 
 
^5::
global preventScreenSaverVar := !preventScreenSaverVar
if (global preventScreenSaverVar) {
TrayTip, Screen Saver Prevention, Enabled, 2, 17
}
else { TrayTip, Screen Saver Prevention, Disabled, 2, 17 
}
return
 
;ScreenSaver launch prevention subroutine
preventScreenSaver:
if (global preventScreenSaverVar) {
    MouseMove, 1, 0, 1, R  ;Move the mouse one pixel to the right
    MouseMove, -1, 0, 1, R ;Move the mouse back one pixel
}
return
-- Create our table for inserting the sp_who2 data into.
CREATE TABLE #sp_who2 
	(SPID		INT,
	Status		VARCHAR(255),
	Login		VARCHAR(255),
	HostName	VARCHAR(255),
	BlkBy		VARCHAR(255),
	DBName		VARCHAR(255),
	Command		VARCHAR(255),
	CPUTime		INT,
	DiskIO		INT,
	LastBatch	VARCHAR(255),
	ProgramName	VARCHAR(255),
	SPID2		INT,
	REQUESTID	INT);
-- Insert the results of sp_who2 into #sp_who2
INSERT INTO #sp_who2 EXEC sp_who2;

-- Define what database we want to check
DECLARE @forDB nvarchar(max) = '<Database Name Goes Here>'; 

-- Show us the total count of sessions specified in the specified database.
SELECT COUNT(*) as [Total Sessions] FROM #sp_who2 WHERE DBName = @forDB;

-- Show us any essions that are being blocked in the specified database.
SELECT 'Block Detected!' AS [Is it blocked?], * FROM #sp_who2 
	WHERE BlkBy != '  .' AND DBName = @forDB;

-- Show us all essions in the specified database.
SELECT * FROM #sp_who2 WHERE DBName = @forDB;

-- Drop our temporary table created for this task.
DROP TABLE #sp_who2;
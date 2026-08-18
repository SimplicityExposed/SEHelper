SELECT * FROM [MergePub1]..ReplTable
SELECT * FROM [MergeSub1]..ReplTable
SELECT * FROM [MergeSub2]..ReplTable

INSERT INTO [MergePub1]..ReplTable
	(EntryNumber,ActiveComment,SourceFile,InternalComment,ExternalComment)
	VALUES
	(7,N'',N'',N'',N'')
INSERT INTO [MergeSub1]..ReplTable
	(EntryNumber,ActiveComment,SourceFile,InternalComment,ExternalComment)
	VALUES
	(7,N'',N'',N'',N'')

INSERT INTO [MergeSub2]..ReplTable
	(EntryNumber,ActiveComment,SourceFile,InternalComment,ExternalComment)
	VALUES
	(7,N'',N'',N'',N'')




CREATE TABLE ReplTable (
	EntryNumber			INT PRIMARY KEY NOT NULL,
	ActiveComment		NVARCHAR(MAX),
	SourceFile			NVARCHAR(255),
	InternalComment		NVARCHAR(1000),
	ExternalComment		NVARCHAR(1000),
	CapturedOn			DATETIME	DEFAULT (getdate()),
	CapturedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),'?')),
	UpdatedOn			DATETIME	DEFAULT (getdate()),
	UpdatedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),'?')),);
					
CREATE TRIGGER trg_ReplTable_ForUpdateAudit
	ON ReplTable
FOR UPDATE
AS BEGIN
	IF (@@rowcount = 0)
		Return

	UPDATE d
	SET
		UpdatedOn = GETDATE(),
		UpdatedBy = (COALESCE(SUSER_SNAME(),''?''))
	FROM ReplTable d JOIN inserted i
		on d.EntryNumber = i.EntryNumber
END;
				
				
ALTER TABLE ReplTable ENABLE TRIGGER trg_ReplTable_ForUpdateAudit;
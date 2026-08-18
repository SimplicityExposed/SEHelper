/****** Object:  StoredProcedure [dbo].[seh_TableMaker_RCA]    Script Date: 10/28/2016 1:59:35 PM ******/
CREATE PROCEDURE seh_TableMaker_RCA (
	@SRNum NVARCHAR(255))
	AS BEGIN
		DECLARE @TableName NVARCHAR(255)
			SET @TableName = N'SR_' + @SRNum + '_RCA'
		DECLARE @TableTemplate NVARCHAR(MAX)
			SET @TableTemplate = (
				N'CREATE TABLE ' + @TableName + ' (
					EntryNumber			INT IDENTITY(1,1),
					ParentRCA			NVARCHAR(255),
					EntryType			NVARCHAR(255),
					LogEntries			NVARCHAR(MAX),
					SourceFile			NVARCHAR(255),
					InternalComment		NVARCHAR(1000),
					ExternalComment		NVARCHAR(1000),
					CapturedOn			DATETIME	DEFAULT (getdate()),
					CapturedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),''?'')),
					UpdatedOn			DATETIME	DEFAULT (getdate()),
					UpdatedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),''?'')),);');
		DECLARE @TriggerTemplate NVARCHAR(MAX)
			SET @TriggerTemplate = (
				N'CREATE TRIGGER trg_' + @TableName + '_ForUpdateAudit
					ON ' + @TableName + '
				FOR UPDATE
				AS BEGIN
					IF (@@rowcount = 0)
						Return

					UPDATE d
					SET
						UpdatedOn = GETDATE(),
						UpdatedBy = (COALESCE(SUSER_SNAME(),''?''))
					FROM ' + @TableName + ' d JOIN inserted i
					 on d.EntryNumber = i.EntryNumber
				END;')
		DECLARE @TriggerEnabler NVARCHAR(MAX)
			SET @TriggerEnabler = (
			N'ALTER TABLE ' + @TableName + ' ENABLE TRIGGER trg_' + @TableName + '_ForUpdateAudit;')
		EXECUTE sp_executesql @TableTemplate;
		EXECUTE sp_executesql @TriggerTemplate;
		EXECUTE sp_executesql @TriggerEnabler;
	END
GO
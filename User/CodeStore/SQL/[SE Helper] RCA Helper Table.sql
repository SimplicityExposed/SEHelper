/****** Object:  StoredProcedure [dbo].[seh_TableMaker_RCA]    Script Date: 10/28/2016 1:59:35 PM ******/
CREATE PROCEDURE seh_TableMaker_RCA (
	@SRNum NVARCHAR(255))
	AS BEGIN
		DECLARE @TableName NVARCHAR(255)
			SET @TableName = N'SR_' + @SRNum + '_RCA'
		DECLARE @DynTableNameDefinition NVARCHAR(500)
			SET @DynTableNameDefinition = '@DynTableName NVARCHAR(MAX)'
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

SELECT * FROM SR_1234567890_RCA;


-- create the update trigger




create trigger trg_changed_info on dbo.dwarfs
for update
as
begin

    -- nothing to do?
    if (@@rowcount = 0)
      return;

    update d
    set 
       upd_date = getdate(),
       upd_name = (coalesce(suser_sname(),'?'))
    from
       dwarfs d join inserted i 
    on 
       d.asigned_id = i.asigned_id;

end
go




DROP TABLE SR_1234567890_RCA

, @DynTableNameDefinition,
                      @DynTableName = @TableName;



DECLARE @IntVariable INT;
DECLARE @SQLString NVARCHAR(500);
DECLARE @ParmDefinition NVARCHAR(500);

/* Build the SQL string one time. */
SET @SQLString =
     N'SELECT * FROM AdventureWorks2008R2.Sales.Store WHERE SalesPersonID = @SalesID';
/* Specify the parameter format one time. */
SET @ParmDefinition = N'@SalesID int';

/* Execute the string with the first parameter value. */
SET @IntVariable = 275;
EXECUTE sp_executesql @SQLString, @ParmDefinition,
                      @SalesID = @IntVariable;
/* Execute the same string with the second parameter value. */
SET @IntVariable = 276;
EXECUTE sp_executesql @SQLString, @ParmDefinition,
                      @SalesID = @IntVariable;









PRINT @TableTemplate

EXEC (@TableTemplate);

SELECT * FROM @TableName


-- Experimentation
SET @TableTemplate = 
	(CREATE TABLE RCA_SR



SELECT * FROM RCA_Findings_SR######

INSERT INTO RCA_Findings_SR###### (LogEntries,SourceFile,InternalComment,ExternalComment)
VALUES ('Test entry','Test Source','Test Internal Comment','Test External Comment')



-- Related: https://technet.microsoft.com/en-us/library/ms175170(v=sql.105).aspx
-- Related: https://msdn.microsoft.com/en-us/library/ms188001.aspx
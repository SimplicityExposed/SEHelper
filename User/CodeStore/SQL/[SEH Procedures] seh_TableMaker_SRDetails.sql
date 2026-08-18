/* Example of full row data from My Work in MSSolve
"IRGExpirationDateTime","UserCategory","Title","DisplayName","CommitmentEndDateFormatted","Severity","CommitmentStartDateFormatted","Number","ItemType","AvailableHour","TimeZoneName","PreferredContactMethod","NextCommitmentDate","WaitStateName","CustomerTitle","SupportTopic","CallingCountryName","SLAMetIndicatorName","DueDate","CommitmentStatusName","CommitmentTypeName","Phase","IsGlobalEnglish","IsAfterHoursSupport","SupportStartTime","SupportEndTime","ServiceLevel","OwnerDisplayNameWithAlias","PrimaryPhoneNumber","PrimaryEmail","IsAcknowledged"
"","W4 Closing Agmt","CUX | 10.50.4295/SEI/Access violation followed by DB crash - RCA","Eric Ruhnke",,"B",,"116110514897094","servicerequest","","(UTC-08:00) Pacific Time (US & Canada)","Phone","11/04/2016 21:50:34","Pending Customer","10.50.4295/SEI/Access violation followed by DB crash","Routing SQL Server v4\SQL Server Administration\Crashes or exceptions when using SQL Server Service","United States","Missed","01/01/0001 00:00:00",,"","Troubleshooting",True,True,"12:00:00 AM","11:59:59 PM","Premier","Michael Smith (v-smmi)","1 - 425-281-0494","eruhnke@oakwood.com",""*/

/****** Object:  StoredProcedure [dbo].[seh_TableMaker_SRDetails]    Script Date: 10/28/2016 1:59:35 PM ******/
CREATE PROCEDURE seh_TableMaker_SRDetails (
	@SRNum NVARCHAR(255))
	AS BEGIN
		DECLARE @TableName NVARCHAR(255)
			SET @TableName = N'SR_' + @SRNum + '_SRDetails'
		DECLARE @TableTemplate NVARCHAR(MAX)
			SET @TableTemplate = (
				N'CREATE TABLE ' + @TableName + ' (
					EntryNumber			INT PRIMARY KEY NOT NULL,
					ActiveComment		NVARCHAR(MAX),
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


-- Table Creation Workspace
CREATE TABLE TestSRDetailsTable (
					SRNUM				INT PRIMARY KEY NOT NULL,
					Title				NVARCHAR(255),
					Category			NVARCHAR(255),
					Workflow			NVARCHAR(255),
					Status				NVARCHAR(255),

					ActiveComment		NVARCHAR(MAX),

					CapturedOn			DATETIME	DEFAULT (getdate()),
					CapturedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),'?')),
					UpdatedOn			DATETIME	DEFAULT (getdate()),
					UpdatedBy			SYSNAME		DEFAULT (coalesce(suser_sname(),'?')),);

SELECT * FROM TestSRDetailsTable
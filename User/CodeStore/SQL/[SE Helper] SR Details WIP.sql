DROP TABLE seh_MySRs;
CREATE TABLE seh_MySRs (
	seh_WorkingStatus				SMALLINT			DEFAULT(1), -- SEH Working Status for open/closed SR's
	Severity						NVARCHAR(255),
	UserCategory					NVARCHAR(255),
	DisplayName						NVARCHAR(255),
	Title							NVARCHAR(255),
	NextCommitmentDate				NVARCHAR(255),
	Number							NVARCHAR(255), -- Needs to be primary key/unique not null only in primary SR table.
	ItemType						NVARCHAR(255),
	AvailableHour					NVARCHAR(255),
	TimeZoneName					NVARCHAR(255),
	IRGExpirationDateTime			NVARCHAR(255),
	WaitStateName					NVARCHAR(255),
	CommitmentStartDateFormatted	NVARCHAR(255),
	CommitmentEndDateFormatted		NVARCHAR(255),
	PreferredContactMethod			NVARCHAR(255),
	CustomerTitle					NVARCHAR(255),
	SupportTopic					NVARCHAR(255),
	CallingCountryName				NVARCHAR(255),
	SLAMetIndicatorName				NVARCHAR(255),
	DueDate							NVARCHAR(255),
	CommitmentStatusName			NVARCHAR(255),
	CommitmentTypeName				NVARCHAR(255),
	Phase							NVARCHAR(255),
	IsGlobalEnglish					NVARCHAR(255),
	IsAfterHoursSupport				NVARCHAR(255),
	SupportStartTime				NVARCHAR(255),
	SupportEndTime					NVARCHAR(255),
	ServiceLevel					NVARCHAR(255),
	OwnerDisplayNameWithAlias		NVARCHAR(255),
	PrimaryPhoneNumber				NVARCHAR(255),
	PrimaryEmail					NVARCHAR(255),
	IsAcknowledged					NVARCHAR(255),

	/* SE Helper Columns */
	seh_IsActive			SMALLINT		DEFAULT(0),
	seh_ActiveComment		NVARCHAR(MAX),
	seh_CapturedOn			DATETIME		DEFAULT (getdate()),
	seh_CapturedBy			SYSNAME			DEFAULT (coalesce(suser_sname(),'?')),
	seh_UpdatedOn			DATETIME		DEFAULT (getdate()),
	seh_UpdatedBy			SYSNAME			DEFAULT (coalesce(suser_sname(),'?')),);

SELECT * FROM seh_MySRs

/* Example of full row data from My Work in MSSolve
"IRGExpirationDateTime","UserCategory","Title","DisplayName","CommitmentEndDateFormatted","Severity","CommitmentStartDateFormatted","Number","ItemType","AvailableHour","TimeZoneName","PreferredContactMethod","NextCommitmentDate","WaitStateName","CustomerTitle","SupportTopic","CallingCountryName","SLAMetIndicatorName","DueDate","CommitmentStatusName","CommitmentTypeName","Phase","IsGlobalEnglish","IsAfterHoursSupport","SupportStartTime","SupportEndTime","ServiceLevel","OwnerDisplayNameWithAlias","PrimaryPhoneNumber","PrimaryEmail","IsAcknowledged"
"","W4 Closing Agmt","CUX | 10.50.4295/SEI/Access violation followed by DB crash - RCA","Eric Ruhnke",,"B",,"116110514897094","servicerequest","","(UTC-08:00) Pacific Time (US & Canada)","Phone","11/04/2016 21:50:34","Pending Customer","10.50.4295/SEI/Access violation followed by DB crash","Routing SQL Server v4\SQL Server Administration\Crashes or exceptions when using SQL Server Service","United States","Missed","01/01/0001 00:00:00",,"","Troubleshooting",True,True,"12:00:00 AM","11:59:59 PM","Premier","Michael Smith (v-smmi)","1 - 425-281-0494","eruhnke@oakwood.com",""*/

INSERT INTO seh_MySRs (UserCategory,Title,DisplayName,CommitmentEndDateFormatted,Severity,Number,ItemType,AvailableHour,TimeZoneName,NextCommitmentDate,WaitStateName)
VALUES ('W4 CX Response to IC','IR Met w/ No Contact | Custom error messages missing.','Dan Clark','','C','116111514942153','servicerequest','','(UTC-06:00) Central America','11/16/2016 08:39:48','Pending CTS')
SELECT * FROM seh_MySRs


INSERT INTO seh_MySRs (Severity,UserCategory,DisplayName,Title,CommitmentEndDateFormatted,Number,AvailableHour,TimeZoneName,NextCommitmentDate,WaitStateName,ItemType,IRGExpirationDateTime,PreferredContactMethod,SupportTopic,CommitmentStartDateFormatted,CallingCountryName,SLAMetIndicatorName,DueDate,CustomerTitle,CommitmentStatusName,CommitmentTypeName,Phase,IsGlobalEnglish,IsAfterHoursSupport,SupportStartTime,SupportEndTime,ServiceLevel,OwnerDisplayNameWithAlias,PrimaryPhoneNumber,PrimaryEmail,IsAcknowledged)
VALUES ('B','W4 CX Test','Jareb Barcus','CUX | Page corruption halts TDE','','116111514939481','','(UTC-06:00) Central America','11/15/2016 10:57:31','Pending Customer','servicerequest','','E-mail','Routing SQL Server v4\SQL Server Administration\Corruption or Database Consistency Checker (DBCC) checks','','United States','Missed','01/01/0001 00:00:00','Page corruption','','','Troubleshooting','True','True','12:00:00 AM','11:59:59 PM','Premier','Michael Smith (v-smmi)','1 - 314-320-2475','Jareb.G.Barcus@centene.com','')SELECT * FROM seh_MySRs
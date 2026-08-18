CREATE TABLE AppLog (
	Date			NVARCHAR(4000),
	Timestamp		NVARCHAR(4000),
	Type			NVARCHAR(4000),
	ComputerName	NVARCHAR(4000),
	EventCode		NVARCHAR(4000),
	Source			NVARCHAR(4000),
	TaskCategory	NVARCHAR(4000),
	Username		NVARCHAR(4000),
	Description		NVARCHAR(4000)
	);

DROP TABLE AppLog


bulk insert AppLog
from 'C:\Support Engineer\Cases\116112814992409\APPSENSE-DB-TKL Base Sdp\APPSENSE-DB-TKL_evt_Application.csv'
with (fieldterminator = ',', rowterminator = '\n')
go


SELECT * FROM AppLog
WHERE (DESCRIPTION LIKE '%PersonalizationServer%' OR DESCRIPTION NOT LIKE '%Unable to access availability database PersonalizationServer%')


SELECT * FROM #AppLog
WHERE CONTENT NOT LIKE '%Unable to access availability database ''PersonalizationServer'' because the database replica is not in the PRIMARY or SECONDARY role. Connections to an availability database is permitted only when the database replica is in the PRIMARY or SECONDARY role. Try the operation again later.%'


WHERE (CONTENT LIKE '% ERR %' OR CONTENT LIKE '% WARN %')
--AND (CONTENT LIKE '%2016/11/28%' OR CONTENT LIKE '%2016/11/29%')
AND CONTENT NOT LIKE '%MSMQ%'
AND CONTENT NOT LIKE '%Virtual Machine has no resources%'
12/04/2016 06:28:02 PM   Information   Appsense-DB-TKL. 983     MSSQLSERVER                         Logon              AD\appsense_svc                   Unable to access availability database 'PersonalizationServer' because the database replica is not in the PRIMARY or SECONDARY role. Connections to an availability database is permitted only when the database replica is in the PRIMARY or SECONDARY role. Try the operation again later. 
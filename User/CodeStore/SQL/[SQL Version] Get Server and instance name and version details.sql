-- Query based on article https://support.microsoft.com/en-us/kb/321185
SELECT
	@@SERVERNAME as 'Server Name',
	@@SERVICENAME as 'Instance Name',
	@@VERSION as 'Server Version',
	SERVERPROPERTY('ProductLevel') AS ProductLevel,
	SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel,
	SERVERPROPERTY('ProductBuildType') AS ProductBuildType,
	SERVERPROPERTY('ProductUpdateReference') AS ProductUpdateReference,
	SERVERPROPERTY('ProductVersion') AS ProductVersion,
	SERVERPROPERTY('ProductMajorVersion') AS ProductMajorVersion,
	SERVERPROPERTY('ProductMinorVersion') AS ProductMinorVersion,
	SERVERPROPERTY('ProductBuild') AS ProductBuild
GO
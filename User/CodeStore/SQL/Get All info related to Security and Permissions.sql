-- The following will retreive all data regarding security & permissions for troubleshooting purposes.
-- Database specific sys tables will run against the selected DB.
Select * from sys.credentials
Select * from sys.database_permissions
Select * from sys.database_principals
Select * from sys.database_role_members
Select * from sys.linked_logins
Select * from sys.login_token
Select * from sys.remote_logins
Select * from sys.routes
Select * from sys.schemas
Select * from sys.securable_classes
Select * from sys.sequences
Select * from sys.server_permissions
Select * from sys.server_principal_credentials
Select * from sys.server_principals
Select * from sys.server_role_members
Select * from sys.sql_logins
Select * from sys.sysdatabases
Select * from sys.syslogins
Select * from sys.sysmembers
Select * from sys.syspermissions
Select * from sys.sysoledbusers
Select * from sys.sysprotects
Select * from sys.sysremotelogins
Select * from sys.sysusers
Select * from sys.user_token

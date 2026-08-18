/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *  FROM [SecurityAccessAudit].[dbo].[Azure_GroupMems] --WHERE [RunDate] = '20220512_103007'
--WHERE [UserPrincipalName] = 'Bipin.Lamichhane@carnivalaustralia.com'
--AND [GivenName] = 'Joshua'
--AND [Surname] = 'mok'
WHERE [GroupName]  = 'HAG-BI_RevMgmtPCL_User'
ORDER BY [Surname]

-- SELECT  DISTINCT [GroupName] FROM [SecurityAccessAudit].[dbo].[Azure_GroupMems]
-- SELECT  DISTINCT [RunDate] FROM [SecurityAccessAudit].[dbo].[Azure_GroupMems]


SELECT *  FROM [SecurityAccessAudit].[dbo].[Flagship_GroupMems] WHERE [RunDate] = '20220512_104034'
--AND [UserPrincipalName] = 'Joshua.Mok@princesscruises.com.au'
--AND [GivenName] = 'Joshua'
--AND [Surname] = 'mok'
AND [GroupName]  = 'BI_RevMgmtPCL_User'
ORDER BY [LastName]

-- SELECT  DISTINCT [GroupName] FROM [SecurityAccessAudit].[dbo].[Flagship_GroupMems]
-- SELECT  DISTINCT [RunDate], [Application] FROM [SecurityAccessAudit].[dbo].[Flagship_GroupMems]
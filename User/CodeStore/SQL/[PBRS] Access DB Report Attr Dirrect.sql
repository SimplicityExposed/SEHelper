/****** Script for SelectTopNRows command from SSMS  ******/
SELECT * FROM [PBRS].[dbo].[reportattr]  -- SLS - Bookings Data CUN - Current Year (Monday Run at 5:00 AM)
SELECT TOP 50 * FROM [PBRS].[dbo].[destinationattr] WHERE destinationtype = 'Disk'

select r.reportname, d.destinationid, d.destinationtype, d.outputpath
from [PBRS].[dbo].[destinationattr] d, [PBRS].[dbo].[reportattr] r
where d.destinationtype = 'Disk'
AND r.reportname LIKE '%SLS - Bookings%'
--and d.ftppath like '%Published RM PCL%'
and d.reportid = r.reportid
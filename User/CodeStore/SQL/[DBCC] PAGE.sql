-- DBCC PAGE for page level details.
-- DBCC PAGE (DB Name or ID,File Number,Verbosity)
DBCC TRACEON (3604);
dbcc page (1,1,0,3);
DBCC TRACEOFF (3604);
GO
SELECT value --tempFactions.*
 FROM OPENROWSET (BULK '/home/shared/sql/stations.json', SINGLE_CLOB) johnny
 CROSS APPLY OPENJSON(BulkColumn)
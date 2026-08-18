SELECT
	OBJECT_NAME(OBJECT_ID) AS TableName, 
	A.allocation_unit_id AS AllocationID
FROM sys.allocation_units A
INNER JOIN sys.partitions B ON A.allocation_unit_id = B.partition_id
WHERE A.allocation_unit_id = 72058347670994944
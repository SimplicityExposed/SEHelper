SELECT
	ring_buffer_address,
	ring_buffer_type,
	timestamp,
	CAST(record AS xml).value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime') AS ErrorDate,
	CAST(record as xml) AS ErrorXML
FROM sys.dm_os_ring_buffers
WHERE ring_buffer_type = 'RING_BUFFER_CONNECTIVITY'
	AND CAST(record AS xml).value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime')
		BETWEEN '2016-10-28 15:20:00.000' AND '2016-10-28 15:30:00.000'
---------------------------------
SELECT
	rbf.ring_buffer_address,
	rbf.ring_buffer_type,
	DATEADD(s, (rbf.timestamp/1000) - (tme.ms_ticks/1000), GETDATE()) AS ConvertedTimestamp,
	rbf.timestamp,
	CAST(rbf.record AS xml).value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime') AS ErrorDate,
	CAST(rbf.record as xml) AS ErrorXML
FROM sys.dm_os_ring_buffers rbf
CROSS JOIN sys.dm_os_sys_info tme
WHERE ring_buffer_type = 'RING_BUFFER_CONNECTIVITY';
	AND CAST(record AS xml).value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime')
		BETWEEN '2016-10-28 15:20:00.000' AND '2016-10-28 15:30:00.000'
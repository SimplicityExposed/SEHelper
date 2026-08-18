/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [ring_buffer_address]
      ,[ring_buffer_type]
      ,[timestamp]
      ,[record]
  FROM [RingBufferTS].[dbo].[ringbuffer3]



  (//Record/Scheduler/Action)[1]

SELECT
	timestamp,
    record.value('(/Record/ConnectivityTraceRecord/Spid)[1]','bigint') AS Date
	 -- record.value('/Sqm/Metrics/Metric/@id', 'varchar(max)') AS id,
FROM ringbuffer3



SELECT
	*,
    record.value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime') AS Date
FROM ringbuffer3
WHERE record.value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime') IS NOT NULL BETWEEN '2016-10-28 15:20:00.000' AND '2016-10-28 15:30:00.000'

SELECT
	*,
	record.value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime') AS Date
FROM ringbuffer3
WHERE record.value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime') > '2016-10-28 15:25:00.000'



SELECT MIN(record.value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime'))
FROM ringbuffer3
WHERE record.value('(/Record/ConnectivityTraceRecord/RecordTime)[1]','datetime') > '2016-10-28 15:25:00.000'
ORDER BY Date DESC

> Friday October 28th @ 3:25 PM EST (exact date: 2016-10-28 15:25:03.71)
> Saturday October 29th @ 2:28 PM EST (exact date: 2016-10-29 14:27:25.680)




ORDER BY Date DESC


SELECT * FROM ringbuffer3 WHERE 




<Record id="8529756" type="RING_BUFFER_CONNECTIVITY" time="18945367423">
  <ConnectivityTraceRecord>
    <RecordType>LoginTimers</RecordType>
    <Spid>0</Spid>
    <SniConnectionId>22BF6970-70C0-4D4D-B347-7FB6EDB9CB36</SniConnectionId>
    <SniConsumerError>17830</SniConsumerError>
    <SniProvider>7</SniProvider>
    <State>11</State>
    <RemoteHost>10.101.99.77</RemoteHost>
    <RemotePort>60618</RemotePort>
    <LocalHost>10.101.100.90</LocalHost>
    <LocalPort>1452</LocalPort>
    <RecordTime>11/3/2016 20:21:8.222</RecordTime>
    <TdsBuffersInformation>
      <TdsInputBufferError>10054</TdsInputBufferError>
      <TdsOutputBufferError>0</TdsOutputBufferError>
      <TdsInputBufferBytes>0</TdsInputBufferBytes>
    </TdsBuffersInformation>
    <LoginTimers>
      <TotalLoginTimeInMilliseconds>1</TotalLoginTimeInMilliseconds>
      <LoginTaskEnqueuedInMilliseconds>1</LoginTaskEnqueuedInMilliseconds>
      <NetworkWritesInMilliseconds>0</NetworkWritesInMilliseconds>
      <NetworkReadsInMilliseconds>0</NetworkReadsInMilliseconds>
      <SslProcessingInMilliseconds>0</SslProcessingInMilliseconds>
      <SspiProcessingInMilliseconds>0</SspiProcessingInMilliseconds>
      <LoginTriggerAndResourceGovernorProcessingInMilliseconds>0</LoginTriggerAndResourceGovernorProcessingInMilliseconds>
    </LoginTimers>
  </ConnectivityTraceRecord>
  <Stack>
    <frame id="0">0X0000000002315FEB</frame>
    <frame id="1">0X0000000002312DBA</frame>
    <frame id="2">0X0000000002317A4E</frame>
    <frame id="3">0X00000000015C71A4</frame>
    <frame id="4">0X0000000000FBAD28</frame>
    <frame id="5">0X0000000000F7EF70</frame>
    <frame id="6">0X0000000000F7ED4A</frame>
    <frame id="7">0X0000000000F7EB8F</frame>
    <frame id="8">0X000000000109D706</frame>
    <frame id="9">0X000000000109D7E5</frame>
    <frame id="10">0X000000000131D869</frame>
    <frame id="11">0X000000000109E01A</frame>
    <frame id="12">0X0000000074C737D7</frame>
    <frame id="13">0X0000000074C73894</frame>
    <frame id="14">0X0000000076EAA54D</frame>
    <frame id="15">0X0000000077146861</frame>
  </Stack>
</Record>
SELECT * INTO MyTraceTemp
FROM ::fn_trace_gettable('C:\Support Engineer\Cases\116111514942153\2016-11-21\output\TraceFile.trc', default)


EXEC xp_dirtree 'C:\Support Engineer\Cases\116111514942153\2016-11-21\output', 10, 1
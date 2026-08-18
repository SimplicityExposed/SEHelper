@echo off
ECHO These commands will enable tracing:
@echo on

logman create trace "storport" -ow -o c:\perflogs\storport.etl -p "Microsoft-Windows-StorPort" 0xffffffffffffffff 0xff -nb 16 16 -bs 1024 -mode Circular -f bincirc -max 1024 -ets
@echo off
echo
ECHO Reproduce your issue and enter any key to stop tracing
@echo on
pause
logman stop "storport" -ets

@echo off
echo Tracing has been captured and saved successfully at c:\perflogs\storport.etl
pause
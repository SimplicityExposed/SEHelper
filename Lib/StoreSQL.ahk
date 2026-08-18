StoreSQL()
{
InputBox, SQLFileName, Enter Filename, Please enter the name you want used for the actual .SQL file that will be created to store your query.
if ErrorLevel
	Return
FileAppend, %Clipboard%, %AHK%\SQL Queries\%SQLFileName%.sql
MsgBox, 4, , Create a shortkey too?
IfMsgBox, No
	Return
InputBox, AutoShortkeyCMD, Enter your desired shortkey. Spaces will be removed automatically.
if ErrorLevel
	Return
IfInString, SQLFileName, %A_Space%
	StringReplace, AutoShortkeyCMD, AutoShortkeyCMD, %A_Space%, , All
AutoShortkeyMaker = `
(


:*:%AutoShortkeyCMD%::
PasteSQL("%SQLFileName%")
Return
)
FileAppend, %AutoShortkeyMaker%, %AHK%\AutoShortkeysSQL.lib
Run, C:\Program Files (x86)\Notepad++\Notepad++.exe -lsql "%AHK%\SQL Queries\%SQLFileName%.sql"
Reload
Return
}
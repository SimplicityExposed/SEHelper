; ---- Search Gooogle
MTB4:
Gui, 1:Submit
	PrimaryUIState = 0
	StringReplace, AdvancedQuery, AdvancedQuery, %A_Space%, +, All
	Run, https://www.google.com/search?q=%AdvancedQuery%
Return

; ---- Search Google Images
MTB5:
Gui, 1:Submit
PrimaryUIState = 0
StringReplace, AdvancedQuery, AdvancedQuery, %A_Space%, +, All
Run, https://www.google.com/search?tbm=isch&q=%AdvancedQuery%
Return

; ---- Search IxQuick
MTB6:
Gui, 1:Submit
PrimaryUIState = 0
StringReplace, AdvancedQuery, AdvancedQuery, %A_Space%, +, All
Run, https://ixquick.com/do/search?query=%AdvancedQuery%&cat=web&pl=ie&language=english
Return

; ---- Submit Log Entry
MTB3:
If WinExist("Personal Log.csv - Excel")
	{
		gui, 1:+0x8000000 ; 0x8000000 is WS_DISABLED
		MsgBox, 4096, Unable to write to log!, Excel currently has your personal log file open and this is preventing SE Helper from writing to it.`r`rIf you want to write to your personal log`, please close the Excel window that has it open.
		gui, 1:-0x8000000 ; 0x8000000 is WS_DISABLED
		gui, 1:show ; This is probably necessary due to a quick that needs to be ironed out.
		Return
	}
SEH_GuiSubmit()
If AdvancedQuery ; Checking to see if the advanced query field was left blank and only write the log file if it wasn't left blank.
	LogWriter()
Return


; ---- Open Personal Log in Excel
MTB8:
SEH_GuiSubmit()
Run, excel.exe "%UserSettingsDir%\Personal Log.csv"
Return

MTB1:
Return

MTB7:
Gui, Destroy
PrimaryUIState = 0
MsgBox, Restarting Multi-Tool`n`nThis will retrieve all network resources and send them to memory.`n`nThis fixes blank test member imports.`n`nThis will also apply any updates.
Reload
Return

MTB2:
;Goto, HelpMenu
Return

UserStatus:
Return

MTB9:
SEH_GuiSubmit()
Run, iexplore.exe %AdvancedQuery%
Return

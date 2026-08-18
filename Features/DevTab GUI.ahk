{
Gui, Tab, DEV ;%DevTab_Settings_TabName% ;
	Gui, Add, Edit, x2 y10 w350 h20 vAdvancedQuery,
	IniRead, AvailableLogTypes, %A_ScriptDir%\User\Settings.ini, LogCustomization, LogTypes,
	;Sort, AvailableLogTypes, D|
	Gui, Add, ComboBox, x362 y10 w180 h100 vLogLabel, %AvailableLogTypes%
	Gui, Add, Button, x626 y10 w70 h20 gMTB8, Open &Log
;	Gui, Add, Button, x572 y15 w130 h20 gMTB2, &Help Menu
	Gui, Add, Button, x552 y10 w70 h20 gMTB3 Default, &Submit Log
	Gui, Add, Button, x2 y35 w60 h20 gMTB4, &Google
	Gui, Add, Button, x72 y35 w50 h20 gMTB5, Im&ages
	Gui, Add, Button, x132 y35 w50 h20 gMTB6, Ix&Quick
	Gui, Add, Button, x192 y35 w50 h20 gMTB7, Restart
	Gui, Add, Button, x252 y35 w65 h20 gMTB9, Open in I&E
	GuiControl, Focus, AdvancedQuery
Gui, Tab
}
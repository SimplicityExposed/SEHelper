{
Gui, Tab, Features Library ;%CodeStore_Features_Settings_TabName% ;
	CodeStore_Location_Features = %A_ScriptDir%\Features
	AvailableSQL := CodeStore_GetCode(CodeStore_Location_Features,"ahk")
	Gui, Add, GroupBox, x12 y6 w443 h367 , Save Feature to Library
	Gui, Add, Text, x14 y32 w60 h20 +Right, File Name:
	Gui, Add, Edit, x76 y29 w369 h20 -Wrap vCodeStore_FileName_Features, ; Code file name entry field
	Gui, Add, Edit, x22 y57 w423 h273 -Wrap +HScroll vCodeStore_CodeContent_Features, ; Code entry field
	;Gui, Add, Edit, x22 y341 w170 h20 -Wrap vCodeStore_Hotstring_Features Disabled, ; Hotstring text entry field
	Gui, Add, CheckBox, x127 y342 w170 h20 vCodeStore_ReloadOnAppend_Features, Reload appension to memory? ; Checkbox to enable creation of a Hotstring for new text.
	Gui, Add, Button, x21 y336 w100 h30 gCodeStore_StoreCode_Features_Append, &Append Code
	Gui, Add, Button, x297 y336 w150 h30 gCodeStore_StoreCode_Features, Save to CodeStore
	
	
	Gui, Add, GroupBox, x465 y6 w320 h367 , Retreive Feature from CodeStore
	Gui, Add, ListBox, x475 y27 w300 h276 +Multi vCodeStore_SelectedCode_Features, %AvailableSQL%
	Gui, Add, Button, x474 y301 w150 h30 gCodeStore_RetrieveCode_Features_GetFirstLine Disabled, Duplicate As ; gCodeStore_FileToClipboard_Features Disabled
	Gui, Add, Button, x626 y301 w150 h30 gCodeStore_CodeToClipboard_Features, Send Code(s) to Clipboard
	Gui, Add, Button, x474 y336 w150 h30 gCodeStore_OpenFile_Features, Open File(s)
	Gui, Add, Button, x626 y336 w150 h30 gCodeStore_DeleteFile_Features, Delete File(s)
	GuiControl, Focus, CodeStoreFileName
Gui, Tab
}
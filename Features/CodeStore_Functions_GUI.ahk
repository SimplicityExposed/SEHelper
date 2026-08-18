{
Gui, Tab, Function Library ;%CodeStore_Functions_Settings_TabName% ;
	CodeStore_Location_Functions = %A_ScriptDir%\Lib
	AvailableSQL := CodeStore_GetCode(CodeStore_Location_Functions,"ahk")
	Gui, Add, GroupBox, x12 y6 w443 h367 , Save Function to Library
	Gui, Add, Text, x14 y32 w60 h20 +Right, File Name:
	Gui, Add, Edit, x76 y29 w369 h20 -Wrap vCodeStore_FileName_Functions, ; Code file name entry field
	Gui, Add, Edit, x22 y57 w423 h273 -Wrap +HScroll vCodeStore_CodeContent_Functions, ; Code entry field
	Gui, Add, Edit, x22 y341 w170 h20 -Wrap vCodeStore_Hotstring_Functions Disabled, ; Hotstring text entry field
	Gui, Add, CheckBox, x198 y342 w60 h20 vCodeStore_HotstringEnabled_Functions Disabled, Hotstring ; Checkbox to enable creation of a Hotstring for new text.
	Gui, Add, Button, x297 y336 w150 h30 gCodeStore_StoreCode_Functions, Save to CodeStore
	
	
	Gui, Add, GroupBox, x465 y6 w320 h367 , Retreive Function from CodeStore
	Gui, Add, ListBox, x475 y27 w300 h276 +Multi vCodeStore_SelectedCode_Functions, %AvailableSQL%
	Gui, Add, Button, x474 y301 w150 h30 gCodeStore_RetrieveCode_Functions_GetFirstLine, Send Call(s) to Clipboard ; gCodeStore_FileToClipboard_Functions Disabled
	Gui, Add, Button, x626 y301 w150 h30 gCodeStore_CodeToClipboard_Functions, Send Code(s) to Clipboard
	Gui, Add, Button, x474 y336 w150 h30 gCodeStore_OpenFile_Functions, Open File(s)
	Gui, Add, Button, x626 y336 w150 h30 gCodeStore_DeleteFile_Functions, Delete File(s)
	GuiControl, Focus, CodeStoreFileName
Gui, Tab
}
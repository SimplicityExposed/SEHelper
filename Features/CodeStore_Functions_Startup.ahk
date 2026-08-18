CodeStore_Functions_Settings_TabName := "Function Library"
SEH_Tabs_RegisterNew(CodeStore_Functions_Settings_TabName)
IfNotExist, %A_ScriptDir%\User\CodeStore\CodeStore_Functions_Shortkeys.ahk
	{
		FileAppend, , %A_ScriptDir%\User\CodeStore\CodeStore_Functions_Shortkeys.ahk
	}
CodeStoreFileName_Functions = ;
CodeStore_FileName_Functions = ;
CodeStore_CodeContent_Functions = ;
CodeStore_Hotstring_Functions = ;
CodeStore_SelectedCode_Functions = ;
CodeStore_HotstringEnabled_Functions = ;
CodeStore_Location_Functions = %A_ScriptDir%\Lib
AvailableSQL := CodeStore_GetCode(CodeStore_Location_Functions,"ahk")
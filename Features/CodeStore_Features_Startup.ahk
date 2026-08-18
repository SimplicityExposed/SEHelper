CodeStore_Features_Settings_TabName := "Features Library"
SEH_Tabs_RegisterNew(CodeStore_Features_Settings_TabName)
CodeStoreFileName_Features = ;
CodeStore_FileName_Features = ;
CodeStore_CodeContent_Features = ;
CodeStore_Hotstring_Features = ;
CodeStore_SelectedCode_Features = ;
CodeStore_HotstringEnabled_Features = ;
CodeStore_ReloadOnAppend_Features = ;
CodeStore_Location_Features = %A_ScriptDir%\Features
AvailableSQL := CodeStore_GetCode(CodeStore_Location_Features,"ahk")
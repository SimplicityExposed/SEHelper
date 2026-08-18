IfNotExist, %A_ScriptDir%\User\CodeStore\CodeStore_sql_Shortkeys.ahk
	{
		FileAppend, , %A_ScriptDir%\User\CodeStore\CodeStore_sql_Shortkeys.ahk
	}
CodeStoreFileName_SQL = ;
CodeStore_FileName_SQL = ;
CodeStore_CodeContent_SQL = ;
CodeStore_Hotstring_SQL = ;
CodeStore_SelectedCode_SQL = ;
CodeStore_HotstringEnabled_SQL = ;
CodeStore_Location_SQL = %A_ScriptDir%\User\CodeStore\SQL
AvailableSQL := CodeStore_GetCode(CodeStore_Location_SQL,"sql")
CodeStore_StoreCode_Append(FileName,CodeContent,Hotstring,HotstringEnabled,Location,Extension)
{
	CodeContent := "`r`n`r`n`r`n" . CodeContent
	FileAppend, %CodeContent%, %Location%\%FileName%.%Extension%
	Return
}
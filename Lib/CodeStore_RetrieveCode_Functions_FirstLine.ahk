CodeStore_RetrieveCode_Functions_FirstLine(SelectedCode,Location,Extension:="*")
{
	Output = ;
	Loop %Location%\*.%Extension%
	{
		CurrentScan = %A_LoopFileName%
		StringReplace, CurrentScan, CurrentScan, .%Extension%, , All
		IfInString, SelectedCode, %CurrentScan%
			FileReadLine, CurrentRead, %Location%\%A_LoopFileName%, 1
		If CurrentRead
			Output := CurrentRead . "`r`n" . Output
		CurrentRead = ; 
		CurrentScan = ;
	}
	Return Output
}
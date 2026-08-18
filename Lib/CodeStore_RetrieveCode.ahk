CodeStore_RetrieveCode(SelectedCode,Location,Extension:="*")
{
	Output = ;
	Loop %Location%\*.%Extension%
	{
		CurrentScan = %A_LoopFileName%
		StringReplace, CurrentScan, CurrentScan, .%Extension%, , All
		IfInString, SelectedCode, %CurrentScan%
			FileRead, CurrentRead, %Location%\%A_LoopFileName%
		If CurrentRead
			Output := "--------------------------------------------------------------------------------`r`n--------------------------------------------------------------------------------`r`n-- Library Item: " . CurrentScan . "`r`n--------------------------------------------------------------------------------`r`n--------------------------------------------------------------------------------`r`n" . CurrentRead . "`r`n`r`n`r`n" . Output
		CurrentRead = ; 
		CurrentScan = ;
	}
	Return Output
}
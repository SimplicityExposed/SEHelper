CodeStore_OpenFile(SelectedCode,Location,Extension:="*")
{
	Output = ;
	Loop %Location%\*.%Extension%
	{
		CurrentScan = %A_LoopFileName%
		StringReplace, CurrentScan, CurrentScan, .%Extension%, , All
		IfInString, SelectedCode, %CurrentScan%
			Run, %Location%\%A_LoopFileName%
		CurrentRead = ; 
		CurrentScan = ;
	}
	Return Output
}
CodeStore_GetCode(Location,Extension:="*")
{
	AvailableCode =
	Loop %Location%\*.%Extension%
	{
		AvailableCode = %A_LoopFileName%|%AvailableCode%
	}
	StringReplace, AvailableCode, AvailableCode, .%Extension%, , All
	Sort, AvailableCode, D|
	Return AvailableCode
}
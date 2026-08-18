JobClip(DataToClean)
{
	DataToClean := Clipboard
	StringReplace, DataToClean, DataToClean, `r, , All
	StringReplace, DataToClean, DataToClean, `n, , All
	StringReplace, DataToClean, DataToClean, %A_Tab%, , All
	DataToClean := CleanSpacesA(DataToClean)
	Return DataToClean
}
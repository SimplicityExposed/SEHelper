PasteVAR(PassedValue, ClearState=0)
{
	;MsgBox % VarName
	ClipStore()
	Clipboard = %PassedValue%
	ClipWait
	SendInput, ^v
	Sleep, 500
	ClipGet()
	If ClearState = 1
		Return
	Return %VARName%
}
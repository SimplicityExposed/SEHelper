PasteText(PassedValue)
{
	ClipStore()
	Clipboard = %PassedValue%
	ClipWait
	SendInput, ^v
	Sleep, 500
	ClipGet()
	Return
}
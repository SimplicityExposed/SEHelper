PasteSQL(FileName)
{
	;MsgBox % FileName
	ClipStore()
	FileRead, Clipboard, %A_ScriptDir%\User\CodeStore\SQL\%FileName%.sql
	ClipWait
	SendInput, ^v
	Sleep, 500
	ClipGet()
	Return
}
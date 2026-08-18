CodeStore_StoreCode(FileName,CodeContent,Hotstring,HotstringEnabled,Location,Extension)
{
	global NPPPLoc
	FileAppend, %CodeContent%, %Location%\%FileName%.%Extension%
	IfEqual HotstringEnabled, 1
		{
			AutoShortkeyMaker = `
(


:*:%Hotstring%::
PasteSQL("%FileName%")
Return
)
			FileAppend, %AutoShortkeyMaker%, %A_ScriptDir%\User\CodeStore\CodeStore_%Extension%_Shortkeys.ahk
		}
	Run, %NPPPLoc% -lsql "%Location%\%FileName%.%Extension%"
	IfEqual HotstringEnabled, 1
		{
			Reload
		}
Return
}
SEH_Tabs_RegisterNew(TabName)
{
	IniRead, SEH_Tabs_Menu, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames,
	IfInString, SEH_Tabs_Menu, %TabName%|
		{
			Return
		}
		
	If SEH_Tabs_Menu
		{}
	else
		{
			If SEH_Tabs_Menu
				{
				
				
				}
			else
				{
					SEH_Tabs_Menu := TabName . "|"
					IniWrite, %SEH_Tabs_Menu%, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames
					Return %SEH_Tabs_Menu%
				}
			
		}

	IfNotInString, SEH_Tabs_Menu, %TabName%|
		{
			SoundBeep
			SoundBeep
			SoundBeep
			SEH_Tabs_Menu := SEH_Tabs_Menu . TabName . "|"
			IniWrite, %SEH_Tabs_Menu%, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames
			Return %SEH_Tabs_Menu%
		}
	MsgBox % "SEH_Tabs_RegisterNew function ended without meeting a condition."
}
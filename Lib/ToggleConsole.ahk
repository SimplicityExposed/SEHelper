ToggleConsole()
{
global PrimaryUIState
IfEqual, PrimaryUIState, 1
	{
		Gui, 1:Cancel
		Gui, 1:Destroy
		PrimaryUIState = 0
		Return
	}
IfNotEqual, PrimaryUIState, 1
	{
		#Include %A_ScriptDir%\Features\SE Helper Console.ahk
		PrimaryUIState = 1
		Return 
	}
Return
}
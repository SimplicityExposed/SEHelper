; ____  _____   _   _ _____ _     ____  _____ ____    _        _    ____  _____ _     ____  
;/ ___|| ____| | | | | ____| |   |  _ \| ____|  _ \  | |      / \  | __ )| ____| |   / ___| 
;\___ \|  _|   | |_| |  _| | |   | |_) |  _| | |_) | | |     / _ \ |  _ \|  _| | |   \___ \ 
; ___) | |___  |  _  | |___| |___|  __/| |___|  _ <  | |___ / ___ \| |_) | |___| |___ ___) |
;|____/|_____| |_| |_|_____|_____|_|   |_____|_| \_\ |_____/_/   \_\____/|_____|_____|____/ 
; ------------------------------------------------------------------------------------------
; This section is for labels specific to the SE Helper tool.

; --- Close GUI Code
SEH_GuiClose() {
	global PrimaryUIState
	Gui, 1:Cancel
	Gui, 1:Destroy
	PrimaryUIState = 0
}

SEH_GuiSubmit() {
	global PrimaryUIState
	Gui, 1:Submit
	PrimaryUIState = 0
}


HideMTGui:
SEH_GuiClose()
Return

ButtonCancelIt:
SEH_GuiClose()
Return

GuiClose:
SEH_GuiClose()
Return

GuiEscape:
1GuiEscape:
SEH_GuiClose()
Return

ClearGUI:
SEH_GuiClose()
Return


!`:: ; Open Console Toggle Hotkey - Hard Coded
ToggleConsole()
Return


DoNothing: ; SE Helper File Menu bar placeholder label.
SoundBeep
Return


SEH_Tabs_Element:
; GuiControlGet, SEH_Tabs_Menu_Current, , SEH_Tabs_Element
Return

SEH_Tabs_ChangeDefault:
GuiControlGet, SEH_Tabs_Menu_Current, , SEH_Tabs_Element
IniRead, SEH_Tabs_Menu, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames,
SEH_Settings_SetDefault(SEH_Tabs_Menu,SEH_Tabs_Menu_Current,"|","TabSettings","TabNames")
;IniWrite, %CurrentString%, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames
Return


SEH_StatusBar_Element:
if A_GuiEvent = DoubleClick
{
	GuiControlGet, SEH_Tabs_Menu_Current, , SEH_Tabs_Element
	IniRead, SEH_Tabs_Menu, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames,
	SEH_Settings_SetDefault(SEH_Tabs_Menu,SEH_Tabs_Menu_Current,"|","TabSettings","TabNames")
	;SEH_GuiSubmitHalt("Your current tab is now your default tab.")
	SB_SetText("Your default tab is now " . SEH_Tabs_Menu_Current . ".")
	GuiControl, +BackgroundACE1AF, SEH_StatusBar_Element
}

Return

; _____ _____    _  _____ _   _ ____  _____   ___ _   _  ____ _    _   _ ____  _____ ____  
;|  ___| ____|  / \|_   _| | | |  _ \| ____| |_ _| \ | |/ ___| |  | | | |  _ \| ____/ ___| 
;| |_  |  _|   / _ \ | | | | | | |_) |  _|    | ||  \| | |   | |  | | | | | | |  _| \___ \ 
;|  _| | |___ / ___ \| | | |_| |  _ <| |___   | || |\  | |___| |__| |_| | |_| | |___ ___) |
;|_|   |_____/_/   \_\_|  \___/|_| \_\_____| |___|_| \_|\____|_____\___/|____/|_____|____/ 
; -----------------------------------------------------------------------------------------
; This section is where you will place your own includes to your "FeatureName Labels.ahk"
;--- These two includes will specifically include your own special Hotkey and Hotstring files.
#Include *i %A_ScriptDir%\Features\[USER]_Hotstrings.ahk
#Include *i %A_ScriptDir%\Features\[USER]_Hotkeys.ahk
;--------------------------
#Include %A_ScriptDir%\Features\SE Helper Includes Labels.ahk ; Please make your includes within this file for future plugin support features.
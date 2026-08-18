;  ___ __  __ ____   ___  ____ _____  _    _   _ _____   ____  _____    _    ____    __  __ _____ 
; |_ _|  \/  |  _ \ / _ \|  _ \_   _|/ \  | \ | |_   _| |  _ \| ____|  / \  |  _ \  |  \/  | ____|
;  | || |\/| | |_) | | | | |_) || | / _ \ |  \| | | |   | |_) |  _|   / _ \ | | | | | |\/| |  _|  
;  | || |  | |  __/| |_| |  _ < | |/ ___ \| |\  | | |   |  _ <| |___ / ___ \| |_| | | |  | | |___ 
; |___|_|  |_|_|    \___/|_| \_\|_/_/   \_\_| \_| |_|   |_| \_\_____/_/   \_\____/  |_|  |_|_____|
; ------------------------------------------------------------------------------------------------
; This is a startup actions file. It should only contain things that need to be put in place prior 
; to other code being called. You can call your startup code here with #Include or place it here
; directly, but please ensure that code called in this file does not contain any Return's or stops
; of any kind or it will break any code that follows it and prevent the ADHOC script injection
; from functioning properly. This is to ensure that ADHOC script functionality allows you to write
; your own ADHOC startup code without modifying this file directly. This lets you use the ADHOC
; functionality to develop your own scripts in a contained environment that utilizes all features
; that are already developed without making existing code and files dirty.

; You can create headers for your section of startup code with this tool:
; http://www.desmoulins.fr/index_us.php?pg=scripts!online!asciiart



; _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____  
;|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|
;|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|

; ____  _____   _   _ _____ _     ____  _____ ____     ____ ___  _   _ ____   ___  _     _____ 
;/ ___|| ____| | | | | ____| |   |  _ \| ____|  _ \   / ___/ _ \| \ | / ___| / _ \| |   | ____|
;\___ \|  _|   | |_| |  _| | |   | |_) |  _| | |_) | | |  | | | |  \| \___ \| | | | |   |  _|  
; ___) | |___  |  _  | |___| |___|  __/| |___|  _ <  | |__| |_| | |\  |___) | |_| | |___| |___ 
;|____/|_____| |_| |_|_____|_____|_|   |_____|_| \_\  \____\___/|_| \_|____/ \___/|_____|_____|

; --------------------------------------------------------------------
; Creating the file menu for the Console
; --------------------------------------------------------------------


Menu, SEH_SettingsMenu, Add, Set Current Tab as Default, SEH_Tabs_ChangeDefault
Menu, SEH_MenuBar, Add, &Settings, :SEH_SettingsMenu
SEH_StatusBar_Element = ;

; --------------------------------------------------------------------
; Defining the User Settings Directory & Ini file for use with the DEV TAB log entry tool
; --------------------------------------------------------------------
UserSettingsDir = %A_ScriptDir%\User
UserSettingsIni = %A_ScriptDir%\User\Settings.ini

; --------------------------------------------------------------------
; Create Personal Log.csv if it does not exist and preload it with header column.
; --------------------------------------------------------------------
IfNotExist, %UserSettingsDir%\Personal Log.csv
{
	LogEntryHeaderRow = Date,Time,Username,Entry Type,Log Entry
	FileAppend, %LogEntryHeaderRow%, %UserSettingsDir%\Personal Log.csv
}

; --------------------------------------------------------------------
; Create User Hotstrings and Hotkeys Include files if non-existant.
; --------------------------------------------------------------------
IfNotExist, %A_ScriptDir%\Features\[USER]_Hotkeys.ahk
{
	SEH_User_Hotkeys_Header := "; Personal Hotkey Storage for user " . Username
	FileAppend, %SEH_User_Hotkeys_Header%, %A_ScriptDir%\Features\[USER]_Hotkeys.ahk
	SEH_User_Hotkeys_Header = ;
	Reload
}
IfNotExist, %A_ScriptDir%\Features\[USER]_Hotstrings.ahk
{
	SEH_User_Hotstrings_Header := "; Personal Hotstrings Storage for user " . Username
	FileAppend, %SEH_User_Hotstrings_Header%, %A_ScriptDir%\Features\[USER]_Hotstrings.ahk
	SEH_User_Hotstrings_Header = ;
	Reload
}

; --------------------------------------------------------------------
; Create User ADHOC File if it does not exist.
; --------------------------------------------------------------------
IfNotExist, %A_ScriptDir%\Features\[USER]_ADHOC.ahk
{
	SEH_User_Hotkeys_Header := "; Personal ADHOC Code Injection for " . Username
	FileAppend, %SEH_User_Hotkeys_Header%, %A_ScriptDir%\Features\[USER]_ADHOC.ahk
	SEH_User_Hotkeys_Header = ;
	Reload
}

; --------------------------------------------------------------------
; Check if Settings.ini exists and create it if it does not.
; --------------------------------------------------------------------
IfNotExist, %UserSettingsIni%
{
	; Log Types for Dev Tab advanced query field
	SectionTitle1 = [LogCustomization]`n
	SectionKey1 = LogTypes=`n
	FileAppend, %SectionTitle1%, %UserSettingsDir%\Settings.ini
	FileAppend, %SectionKey1%, %UserSettingsDir%\Settings.ini
	
	; Tab Settings configuration option.
	SectionTitle2 = [TabSettings]`n
	SectionKey2 = TabNames=`n
	FileAppend, %SectionTitle2%, %UserSettingsDir%\Settings.ini
	FileAppend, %SectionKey2%, %UserSettingsDir%\Settings.ini
	; Tab Menu 
}

; --------------------------------------------------------------------
; Defining variables for tab selection management
; --------------------------------------------------------------------
SEH_Tabs_Menu = ;
SEH_Tabs_Menu_NewDefault = ;
SEH_Tabs_Element = ;

; --------------------------------------------------------------------
; Registering Notepad++ install directory.
; --------------------------------------------------------------------
NPPPLoc := "C:\Program Files\Notepad++\notepad++.exe"

; _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____  
;|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|
;|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|_____|

; _____ _____    _  _____ _   _ ____  _____   ___ _   _  ____ _    _   _ ____  _____ ____  
;|  ___| ____|  / \|_   _| | | |  _ \| ____| |_ _| \ | |/ ___| |  | | | |  _ \| ____/ ___| 
;| |_  |  _|   / _ \ | | | | | | |_) |  _|    | ||  \| | |   | |  | | | | | | |  _| \___ \ 
;|  _| | |___ / ___ \| | | |_| |  _ <| |___   | || |\  | |___| |__| |_| | |_| | |___ ___) |
;|_|   |_____/_/   \_\_|  \___/|_| \_\_____| |___|_| \_|\____|_____\___/|____/|_____|____/ 
; -----------------------------------------------------------------------------------------
; Please include your features startup file in SE Helper Includes Startup.ahk
#Include %A_ScriptDir%\Features\SE Helper Includes Startup.ahk

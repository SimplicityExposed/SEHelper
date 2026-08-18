; ____  _____   _   _ _____ _     ____  _____ ____     ____ ___  _   _ ____   ___  _     _____    ____ _   _ ___ 
;/ ___|| ____| | | | | ____| |   |  _ \| ____|  _ \   / ___/ _ \| \ | / ___| / _ \| |   | ____|  / ___| | | |_ _|
;\___ \|  _|   | |_| |  _| | |   | |_) |  _| | |_) | | |  | | | |  \| \___ \| | | | |   |  _|   | |  _| | | || | 
; ___) | |___  |  _  | |___| |___|  __/| |___|  _ <  | |__| |_| | |\  |___) | |_| | |___| |___  | |_| | |_| || | 
;|____/|_____| |_| |_|_____|_____|_|   |_____|_| \_\  \____\___/|_| \_|____/ \___/|_____|_____|  \____|\___/|___|
;----------------------------------------------------------------------------------------------------------------
; The below code is defining the console GUI windows primary properties.
Gui, 1:Destroy ; Destroys any previous instances of the console window to allow recreation.
Gui, 1:Default ; Sets the console as SE Helpers default window
Gui, 1:+AlwaysOnTop ;+Toolwindow 
Gui, 1:+DPIScale
Gui, Color, ,  ; Allows you to define colors to the window
Gui, Menu, SEH_MenuBar ; File bar at top of window

; ____  _____   _   _ _____ _     ____  _____ ____    _____  _    ____     ____ _   _ ___ 
;/ ___|| ____| | | | | ____| |   |  _ \| ____|  _ \  |_   _|/ \  | __ )   / ___| | | |_ _|
;\___ \|  _|   | |_| |  _| | |   | |_) |  _| | |_) |   | | / _ \ |  _ \  | |  _| | | || | 
; ___) | |___  |  _  | |___| |___|  __/| |___|  _ <    | |/ ___ \| |_) | | |_| | |_| || | 
;|____/|_____| |_| |_|_____|_____|_|   |_____|_| \_\   |_/_/   \_\____/   \____|\___/|___|
;-----------------------------------------------------------------------------------------
; This section is where additional tabs of UI elements are added to add functionality to
; the SE Helper program. Please ensure your UI elements are included within their own tabs.

; Create the tab element and define the tab names. Your tab name must exist in this element.
IniRead, SEH_Tabs_Menu, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames,
Gui, Add, Tab, x-1 y-1 w802 h403 bottom gSEH_Tabs_Element vSEH_Tabs_Element, %SEH_Tabs_Menu%

; Please include your script file includes in the following file.
; -----------------------------------------------------------------------------
#Include %A_ScriptDir%\Features\SE Helper Includes Tabs.ahk

; ____  _____   _   _ _____ _     ____  _____ ____    ____ _____  _  _____ _   _ ____    ____    _    ____  
;/ ___|| ____| | | | | ____| |   |  _ \| ____|  _ \  / ___|_   _|/ \|_   _| | | / ___|  | __ )  / \  |  _ \ 
;\___ \|  _|   | |_| |  _| | |   | |_) |  _| | |_) | \___ \ | | / _ \ | | | | | \___ \  |  _ \ / _ \ | |_) |
; ___) | |___  |  _  | |___| |___|  __/| |___|  _ <   ___) || |/ ___ \| | | |_| |___) | | |_) / ___ \|  _ < 
;|____/|_____| |_| |_|_____|_____|_|   |_____|_| \_\ |____/ |_/_/   \_\_|  \___/|____/  |____/_/   \_\_| \_\
;-----------------------------------------------------------------------------------------------------------
; This code handles the generation and modifaction of the status bar at the bottom of SE Helpers console.
Gui, Add, StatusBar, gSEH_StatusBar_Element vSEH_StatusBar_Element -Theme, 
SB_SetText("SE Helper is authored by Michael A. Smith")
Gui, Show, w800 h428, Support Engineer Helper


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
; Gui, Menu, SEH_MenuBar ; File bar at top of window

; ____  _____   _   _ _____ _     ____  _____ ____    _____  _    ____     ____ _   _ ___ 
;/ ___|| ____| | | | | ____| |   |  _ \| ____|  _ \  |_   _|/ \  | __ )   / ___| | | |_ _|
;\___ \|  _|   | |_| |  _| | |   | |_) |  _| | |_) |   | | / _ \ |  _ \  | |  _| | | || | 
; ___) | |___  |  _  | |___| |___|  __/| |___|  _ <    | |/ ___ \| |_) | | |_| | |_| || | 
;|____/|_____| |_| |_|_____|_____|_|   |_____|_| \_\   |_/_/   \_\____/   \____|\___/|___|
;-----------------------------------------------------------------------------------------
; This section is where additional tabs of UI elements are added to add functionality to
; the SE Helper program. Please ensure your UI elements are included within their own tabs.

; Create the tab element and define the tab names. Your tab name must exist in this element.
; IniRead, SEH_Tabs_Menu, %A_ScriptDir%\User\Settings.ini, TabSettings, TabNames,
Gui, Add, Tab, x-1 y-1 w802 h403 bottom, Tabs Menu Global Call|SR Manager

; Please include your script file includes in the following file.
; -----------------------------------------------------------------------------
;#Include %A_ScriptDir%\Features\SE Helper Includes Tabs.ahk
{
Gui, Tab, SR Manager
	Gui, Add, Text, x12 y9 w90 h20 +Right, Service Requests:
	Gui, Add, DropDownList, x102 y9 w290 h20 , 116101014778381|11610101477838101230123|116101014778381|116101014778381
	Gui, Add, Button, x402 y9 w70 h20 , Activate
	Gui, Add, Button, x482 y9 w50 h20 , Close
	Gui, Add, Button, x542 y9 w70 h20 , Manage All

	Gui, Add, Text, x622 y9 w170 h20 +Center, Available Routines for SR's
	Gui, Add, ListBox, x622 y29 w170 h300 , Case Folder: Create|Case Folder: Manage|Case Folder: Open|Case Folder: Purge Client Data|SQL Nexus: Create DB|SQL Nexus: Custom Query|SQL Nexus: Share Access|Compile RCA: External|Compile RCA: Internal|Compile RCA: Complete|Compile RCA: Case Notes|Compile Case Log to Notes|Generate SDP
	Gui, Add, Button, x622 y325 w170 h20 , Execute selected routine.
	Gui, Add, Button, x622 y349 w50 h20 , Create
	Gui, Add, Button, x677 y349 w50 h20 , Open
	Gui, Add, Button, x732 y349 w60 h20 , Configure
	Gui, Add, Edit, x12 y261 w530 h110 +HScroll +Wrap vSRManager_ActiveComment, Active Comment Field

	Gui, Add, GroupBox, x4 y244 w613 h132 , Active Comment for SR#
	Gui, Add, Button, x552 y259 w60 h20 , Save
	Gui, Add, Button, x552 y289 w60 h20 , Reset
	Gui, Add, Button, x552 y319 w60 h20 , Log It
	Gui, Add, Button, x552 y349 w60 h20 , View Log

	Gui, Add, GroupBox, x4 y34 w613 h205 , Service Request Details and Controls: SRNUMBER
	Gui, Add, Text, x12 y49 w20 h20 , SR:
	Gui, Add, Edit, x32 y49 w140 h20 , SRNUMBER
	Gui, Add, Text, x182 y49 w60 h20 +Right, SR TITLE:
	Gui, Add, Edit, x242 y49 w250 h20 , Edit
	Gui, Add, Text, x152 y79 w90 h20 +Right, SR CATEGORY:
	Gui, Add, ComboBox, x242 y79 w250 h20 , Failover RCA Workflow||Performance Workflow

	Gui, Add, GroupBox, x502 y49 w110 h62 , Labor Tracking
	Gui, Add, CheckBox, x512 y66 w90 h20 , Working SR
	Gui, Add, Button, x512 y86 w90 h20 , View Labor Log

	Gui, Add, GroupBox, x502 y116 w110 h118 , SR Actions
	Gui, Add, Button, x512 y134 w90 h20 , Save Details
	Gui, Add, Button, x512 y159 w90 h20 , Refresh Details
	Gui, Add, Button, x512 y184 w90 h20 , Open Workflow
	Gui, Add, Button, x512 y209 w90 h20 , SR Action 4
	GuiControl, Focus, SRManager_ActiveComment
Gui, Tab
}


; ____  _____   _   _ _____ _     ____  _____ ____    ____ _____  _  _____ _   _ ____    ____    _    ____  
;/ ___|| ____| | | | | ____| |   |  _ \| ____|  _ \  / ___|_   _|/ \|_   _| | | / ___|  | __ )  / \  |  _ \ 
;\___ \|  _|   | |_| |  _| | |   | |_) |  _| | |_) | \___ \ | | / _ \ | | | | | \___ \  |  _ \ / _ \ | |_) |
; ___) | |___  |  _  | |___| |___|  __/| |___|  _ <   ___) || |/ ___ \| | | |_| |___) | | |_) / ___ \|  _ < 
;|____/|_____| |_| |_|_____|_____|_|   |_____|_| \_\ |____/ |_/_/   \_\_|  \___/|____/  |____/_/   \_\_| \_\
;-----------------------------------------------------------------------------------------------------------
; This code handles the generation and modifaction of the status bar at the bottom of SE Helpers console.
Gui, Show, w800 h428, Support Engineer Helper


Gui, Add, Tab, x-1 y-1 w802 h403 bottom, Tabs Menu Global Call|SR Manager
Gui, Tab, SR Manager
Gui, Add, Button, x402 y9 w70 h20 , Activate
Gui, Add, Text, x2 y9 w90 h20 +Right, Service Requests:
Gui, Add, Text, x622 y9 w170 h20 +Center, Available Routines for SR's
Gui, Add, ListBox, x622 y29 w170 h300 , Routine name 1|Routine name 2|Routine name 3
Gui, Add, Button, x622 y325 w170 h20 , Execute selected routine.
Gui, Add, Button, x622 y349 w50 h20 , Create
Gui, Add, Button, x677 y349 w50 h20 , Open
Gui, Add, Button, x732 y349 w60 h20 , Configure
Gui, Add, Edit, x12 y261 w530 h110 +HScroll +Wrap, Active Comment Field
Gui, Add, DropDownList, x102 y9 w290 h20 , 116101014778381|11610101477838101230123|116101014778381|116101014778381
Gui, Tab, SR Manager
Gui, Add, Button, x482 y9 w50 h20 , Close
Gui, Add, GroupBox, x4 y244 w613 h132 , Active Comment for SR#
Gui, Add, Button, x552 y259 w60 h20 , Save
Gui, Add, Button, x552 y289 w60 h20 , Reset
Gui, Add, Button, x552 y319 w60 h20 , Log It
Gui, Add, Button, x552 y349 w60 h20 , View Log
Gui, Add, Button, x542 y9 w70 h20 , Advanced
Gui, Add, GroupBox, x4 y39 w613 h200 , Service Request Details: SRNUMBER
; Generated using SmartGUI Creator 4.0
Gui, Show, x510 y217 h432 w804, New GUI Window
Return

GuiClose:
ExitApp

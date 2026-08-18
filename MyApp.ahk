Menu, Tray, Icon, %A_ScriptDir%\Assets\1476221184_toolbox.ico ;1476219333_Admin.ico ;1476219285_user_anonymous.ico ;1476219148_search_magnifying_glass_find.ico ;1476219174_search_binoculars_find.ico ; 1475712188_database-gear.ico
;Icon, %A_ScriptDir%\Assets\1476221184_toolbox.ico, IconNumber, 1
;#NoEnv  ; Disables use of Windows Environment Variables.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input
SetWorkingDir %A_ScriptDir%
SEH_A_ScriptDir_Archive = %A_ScriptDir%
#Include %A_ScriptDir%\Features\SE Helper Startup.ahk ; This file contains any startup actions required for other code to function properly.
Goto ADHOC
Return
; BEGIN INCLUDED FUNCTIONS OF SE HELPER
; ----------------------------------------
#Include %A_ScriptDir%\Features\SE Helper Labels.ahk

; BEGIN AHK ADHOC WORKSPACE
; ----------------------------------------
ADHOC:
SoundBeep ; Simple sound so the user has confirmation of load/reload.
#Include *i %A_ScriptDir%\Features\[USER]_ADHOC.ahk
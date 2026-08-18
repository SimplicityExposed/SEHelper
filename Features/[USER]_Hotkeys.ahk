; Michael Smith's custom Hotkeys

;--------------------------------------------------------------------
;Custom CodeStore Controls
;--------------------------------------------------------------------
!F12:: Run, %A_ScriptDir%\User\CodeStore ; Opens the library of automatically created shortkeys.


;--------------------------------------------------------------------
;Job Clip Controls
;--------------------------------------------------------------------
;Special Clipboard
^+s::
JobClip := JobClip(Clipboard)
return

^+v::
SendInput, %JobClip%
Return



;--------------------------------------------------------------------
;Window Controls
;--------------------------------------------------------------------
^space::WinMinimize, A ; Ctrl+Space to minimize focused window.
!space::WinSet, AlwaysOnTop, Toggle, A ; Alt+Space to toggle active window always on top.


;--------------------------------------------------------------------
;Clipboard to TTS Functionality
;--------------------------------------------------------------------
!R::RemotelyReadMyClipboard() ; Activate ClipToTTS.exe
^!R::Process,Close,ClipToTTS.exe ; Terminate ClipToTTS.exe


; Personal Hotkeys for opening various SE Helper files
^INS::Reload ; Reloads this ADHOC script with most recent changes into memory to enable new features.
^HOME:: Run, %NPPPLoc% -lautoit "%A_ScriptDir%\Features\[USER]_ADHOC.ahk" ; Opens the ADHOC script file for code insertion.
^!+HOME:: Run, %NPPPLoc% -lautoit "%A_ScriptDir%\SE Helper.ahk" ; Opens the SE Helper.ahk engine that runs this toolkit.
!HOME:: Run "%A_ScriptDir%\"


; Open Command Prompt on Cases Folder
#c::
Run, *runas %ComSpec%
Return

; Open PowerShell on Cases Folder
#p::
Run, *runas powershell.exe,C:\Dev
Return

; Open PowerShell ISE
^#p::
Run, *runas powershell_ise.exe, C:\Dev
Return

^+D::
Run, C:\Dev
If ErrorLevel
	Run, C:\
Return



!n::
Run, Notepad
Return



;--------------------------------------------------------------------
;Screen Resolution Changer
;--------------------------------------------------------------------
^PgUp::ChangeResolution(3440, 1440)
^PgDn::ChangeResolution(1920, 1080)
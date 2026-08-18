;#SingleInstance, Force
#ErrorStdOut ; Suppresses errors caused by waiting for the Speech COM allowing the user to queue several reads. Recommended no more than 1 waiting as we can't guarantee the order waiting scritps playback in.
ClipStore()
Clipboard = ;
SendInput, {LControl Down}c{LControl Up}
ClipWait, 1, 1
TextToRead := Clipboard
Clipboard = ;
Clipboard := ClipGet()
ClipWait, 1, 1
Menu, Tray, Icon, %A_ScriptDir%\Assets\speech_red.ico
ComObjCreate("SAPI.SpVoice").Speak(TextToRead)
Menu, Tray, Icon, %A_ScriptDir%\Assets\speech_blue.ico
ExitApp
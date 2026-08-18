ReadMeMyHighlight()
{
ClipStore()
Clipboard = ;
SendInput, {LControl Down}c{LControl Up}
ClipWait, 1, 1
TextToRead := ClipboardAll
Clipboard = ;
Clipboard := ClipGet()
ClipWait, 1, 1
Menu, Tray, Icon, %A_ScriptDir%\Assets\speech_red.ico
ComObjCreate("SAPI.SpVoice").Speak(TextToRead)
Menu, Tray, Icon, %A_ScriptDir%\Assets\speech_blue.ico
Return
}
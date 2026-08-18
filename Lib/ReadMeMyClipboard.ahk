ReadMeMyClipboard()
{
TextToRead := Clipboard
Menu, Tray, Icon, %A_ScriptDir%\Assets\speech_red.ico
ComObjCreate("SAPI.SpVoice").Speak(TextToRead)
Menu, Tray, Icon, %A_ScriptDir%\Assets\speech_blue.ico
Return
}
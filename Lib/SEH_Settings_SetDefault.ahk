SEH_Settings_SetDefault(CurrentString,NewDefault,Delimeter,DestinationSection,DestinationKey)
{
	; Takes a delimited list that use double delimiters to mark the default selection and changes it.
	StringReplace, CurrentString, CurrentString, %Delimeter%%Delimeter%, %Delimeter%, UseErrorLevel
	StringReplace, CurrentString, CurrentString, %NewDefault%, %NewDefault%%Delimeter%, 1
	IniWrite, %CurrentString%, %A_ScriptDir%\User\Settings.ini, %DestinationSection%, %DestinationKey%
	Return %CurrentString%
}
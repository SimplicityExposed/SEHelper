MakeDefault(CurrentString,NewDefault,Delimeter)
{
	; Takes a delimited list that use double delimiters to mark the default selection and changes it.
	StringReplace, CurrentString, CurrentString, %Delimeter%%Delimeter%, %Delimeter%, UseErrorLevel
	StringReplace, CurrentString, CurrentString, %NewDefault%, %NewDefault%%Delimeter%, 1
	Return %CurrentString%
}
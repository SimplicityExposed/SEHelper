LogWriter()
{
	global LogQuery
	global AvailableLogTypes
	global LogLabel
	global AdvancedQuery
	IniRead, AvailableLogTypes, %A_ScriptDir%\User\Settings.ini, LogCustomization, LogTypes
	IfInString, LogLabel, |
		{
			SetDefault = 1
			StringReplace, LogLabel, LogLabel, |, , All
		}
; ---- Experimental send to SQL DB code:
LogQuery := "INSERT INTO PersonalLog (LogLabel, LogEntry) VALUES ('" . LogLabel . "', '" . AdvancedQuery . "');"
ADOSQL(connection_string,LogQuery)

; ---- End of SQL DB experiment.
FileAppend,
(

%A_MM%/%A_DD%/%A_YYYY%,%A_Hour%:%A_Min%,%A_Username%,%LogLabel%,%AdvancedQuery%
), %A_ScriptDir%\User\Personal Log.csv
	IfEqual, SetDefault, 1
		{
			Loop
				{
					StringReplace, AvailableLogTypes, AvailableLogTypes, ||, |, UseErrorLevel
					IfErrorLevel = 0
						break
				}
		}
	IfInString, AvailableLogTypes, %LogLabel%
		{
			IfEqual, SetDefault, 1
				{
					StringReplace, AvailableLogTypes, AvailableLogTypes, %LogLabel%, %LogLabel%|, 1
					IniWrite, %AvailableLogTypes%, %A_ScriptDir%\User\Settings.ini, LogCustomization, LogTypes
					Return
				}
			IfNotEqual, SetDefault, 1
				{
					Return
				}
			Return
		}
	IfNotInString, AvailableLogTypes, %LogLabel%
		{
			IfEqual, SetDefault, 1
				{
					IniWrite, %AvailableLogTypes%%LogLabel%||, %A_ScriptDir%\User\Settings.ini, LogCustomization, LogTypes
					Return
				}
			IniWrite, %AvailableLogTypes%%LogLabel%|, %A_ScriptDir%\User\Settings.ini, LogCustomization, LogTypes
			Return
		}
	Return
}
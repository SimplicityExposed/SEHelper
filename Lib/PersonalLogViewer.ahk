PersonalLogViewer(GuiNum=90, Option="xCenter yCenter w1000 h500") {
global LogViewerUIState
global SQLResults
ViewLogQuery = `
(
SELECT TOP(100) EntryNumber, LogLabel, LogEntry, LoggedOn
FROM PersonalLog
ORDER BY EntryNumber DESC
)
IfEqual, LogViewerUIState, 1
	{
		Gui, %GuiNum%:Cancel
		Gui, %GuiNum%:Destroy
		LogViewerUIState = 0
		SQLResults = ;
		Return
	}
IfNotEqual, LogViewerUIState, 1
	{
		LogViewerUIState = 1
		SQLResults = ;
		SQLResults := ADOSQL(connection_string,ViewLogQuery)
		Gui, %GuiNum%: New
		For index, obj in SQLResults {
			if ( A_Index = 1 ) {
				For key, value in obj {
					Columns .= key "|"	
					numColumn++
				}	
				Gui, Add, ListView, x2 y0 w1000 h500, %Columns%
			}
			RowNum := A_Index		
			Gui, %GuiNum%: default						;this is necessary
			LV_Add("")									;add a row
			For key, value in obj {
				LV_GetText(Header, 0, A_Index)			;check if the inserting value is in the correct column
				if (key <> Header) {	
					FoundHeader := False
					Loop % LV_GetCount("Column") {		;search the matching column
						LV_GetText(Header, 0, A_Index)
						if (key <> Header)
							continue
						else {
							FoundHeader := A_Index
							Break
						}
					}
					if !FoundHeader {
						LV_InsertCol(numColumn + 1, "", key)
						numColumn++
						ColNum := "Col" numColumn
					} else
						ColNum := "Col" FoundHeader
				} else
					ColNum := "Col" A_Index
				LV_Modify(RowNum, ColNum, (IsObject(value) ? "Object()" : value)) 	;insert the value
			}
		}
		Loop % LV_GetCount("Column") 		;the number of colums
			LV_ModifyCol(A_Index, "AutoHdr")		;adjust each column width

		Gui, %GuiNum%:+AlwaysOnTop
		Gui, %GuiNum%:+Toolwindow
		Gui, %GuiNum%: Show, %Option%, Last 100 Personal Log Entries
		
		Return 
	}
Return
}

; SOURCE: https://autohotkey.com/board/topic/70490-print-array/
PrintArrOriginal(Arr, GuiNum=90, Option="x2 y0 w400 h500") {
	For index, obj in Arr {
		if ( A_Index = 1 ) {
			For key, value in obj {
				Columns .= key "|"	
				numColumn++
			}	
			Gui, %GuiNum%: Add, ListView, %Option%, %Columns%
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
		
	Gui, %GuiNum%: Show,, Array
}
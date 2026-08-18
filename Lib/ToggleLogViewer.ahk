ToggleLogViewer()
{
global LogViewerUIState
global SQLResults
IfEqual, LogViewerUIState, 1
	{
		Gui, 90:Cancel
		Gui, 90:Destroy
		LogViewerUIState = 0
		SQLResults = ;
		Return
	}
IfNotEqual, LogViewerUIState, 1
	{
		LogViewerUIState = 1
		;SQLResults = ;
		SQLResults := ADOSQL(connection_string,ViewLogQuery)
		PrintArr(SQLResults,90,"xCenter yCenter w1000 h500")
		
		Return 
	}
Return
}
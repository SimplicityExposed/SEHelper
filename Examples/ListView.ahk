; Create the ListView with two columns, Name and Size:
Gui, Add, ListView, r20 w700 gMyListView +Multi, Name|Size (KB)

; Gather a list of file names from a folder and put them into the ListView:
Loop, C:\Support Engineer\Cases\116101814816701\Results_CHEXSQLMCSRO001_2016-10-18_15.50.33\*.*
    LV_Add("", A_LoopFileName, A_LoopFileSizeKB)

LV_ModifyCol()  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.

; Display the window and return. The script will be notified whenever the user double clicks a row.
Gui, Show
return

MyListView:
if A_GuiEvent = DoubleClick
{
    LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
    ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
}
if A_GuiEvent = RightClick
{
    LV_GetText(RowText, A_EventInfo)  ; Get the text from the row's first field.
    ToolTip You right-clicked row number %A_EventInfo%. Text: "%RowText%"
}
return

GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
ExitApp
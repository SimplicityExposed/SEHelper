#Include *i %A_ScriptDir%\User\CodeStore\CodeStore_sql_Shortkeys.ahk ; Our automatically created shortkeys.

;Variables for Code Store Entry
;CodeStore_FileName
;CodeStore_CodeContent
;CodeStore_Hotstring
;CodeStore_SelectedCode
;CodeStore_HotstringEnabled

CodeStore_StoreCode_SQL:
CodeStore_FileName_SQL = ;
	GuiControlGet, CodeStore_FileName_SQL, , CodeStore_FileName_SQL
If CodeStore_FileName_SQL
	{
		SEH_GuiSubmit()
		CodeStore_StoreCode(CodeStore_FileName_SQL,CodeStore_CodeContent_SQL,CodeStore_Hotstring_SQL,CodeStore_HotstringEnabled_SQL,CodeStore_Location_SQL,"sql")
		Return
	}
SEH_GuiSubmitHalt("You must enter a File Name to save something to your CodeStore")
Return


; CodeStore Universal labels for all tabs:
CodeStore_FileToClipboard_SQL:
SEH_GuiSubmit()
Return


CodeStore_OpenFile_SQL:
ConfirmCheck := SEH_GuiConfirm("This is going to open every selected file in their default editor. Are you sure you want to do this?")
IfEqual ConfirmCheck, 1
	Return
SEH_GuiSubmit()
CodeStore_OpenFile(CodeStore_SelectedCode_SQL,CodeStore_Location_SQL,"sql")
Return

CodeStore_CodeToClipboard_SQL:
;ConfirmCheck := SEH_GuiConfirm("This will overwrite your current clipboard contents with the selected code files.`r`rAre you sure you want to do this?")
; IfEqual ConfirmCheck, 1
	; Return
SEH_GuiSubmit()
;MsgBox % "Selected Code pre-function: " . CodeStore_SelectedCode
Clipboard := CodeStore_RetrieveCode(CodeStore_SelectedCode_SQL,CodeStore_Location_SQL,"sql")
Return

CodeStore_DeleteFile_SQL:
ConfirmCheck := SEH_GuiConfirmWarning("You have chosen to delete ALL of the selected code. Are you sure you want to do this? This can not be undone.")
IfEqual ConfirmCheck, 1
	Return
SEH_GuiSubmit()
CodeStore_DeleteFile(CodeStore_SelectedCode_SQL,CodeStore_Location_SQL,"sql")
Return


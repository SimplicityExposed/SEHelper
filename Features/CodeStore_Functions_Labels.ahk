#Include *i %A_ScriptDir%\User\CodeStore\CodeStore_Functions_Shortkeys.ahk ; Our automatically created shortkeys.

CodeStore_StoreCode_Functions:
CodeStore_FileName_Functions = ;
	GuiControlGet, CodeStore_FileName_Functions, , CodeStore_FileName_Functions
If CodeStore_FileName_Functions
	{
		SEH_GuiSubmit()
		CodeStore_StoreCode(CodeStore_FileName_Functions,CodeStore_CodeContent_Functions,CodeStore_Hotstring_Functions,CodeStore_HotstringEnabled_Functions,CodeStore_Location_Functions,"ahk")
		Return
	}
SEH_GuiSubmitHalt("You must enter a File Name to save something to your CodeStore") 
Return

CodeStore_FileToClipboard_Functions:
SEH_GuiSubmit()
Return

CodeStore_OpenFile_Functions:
SEH_GuiSubmit()
CodeStore_OpenFile(CodeStore_SelectedCode_Functions,CodeStore_Location_Functions,"ahk")
Return

CodeStore_CodeToClipboard_Functions:
SEH_GuiSubmit()
Clipboard := CodeStore_RetrieveCode_Functions(CodeStore_SelectedCode_Functions,CodeStore_Location_Functions,"ahk")
Return

CodeStore_RetrieveCode_Functions_GetFirstLine:
SEH_GuiSubmit()
Clipboard := CodeStore_RetrieveCode_Functions_FirstLine(CodeStore_SelectedCode_Functions,CodeStore_Location_Functions,"ahk")
Return

CodeStore_DeleteFile_Functions:
ConfirmCheck := SEH_GuiConfirmWarning("You have chosen to delete ALL of the selected code. Are you sure you want to do this? This can not be undone.")
IfEqual ConfirmCheck, 1
	Return
SEH_GuiSubmit()
CodeStore_DeleteFile(CodeStore_SelectedCode_Functions,CodeStore_Location_Functions,"ahk")
Return


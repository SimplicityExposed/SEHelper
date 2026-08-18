CodeStore_StoreCode_Features:
CodeStore_FileName_Features = ;
	GuiControlGet, CodeStore_FileName_Features, , CodeStore_FileName_Features
If CodeStore_FileName_Features
	{
		SEH_GuiSubmit()
		CodeStore_StoreCode(CodeStore_FileName_Features,CodeStore_CodeContent_Features,CodeStore_Hotstring_Features,CodeStore_HotstringEnabled_Features,CodeStore_Location_Features,"ahk")
		Return
	}
SEH_GuiSubmitHalt("You must enter a File Name to save something to your CodeStore")
Return

CodeStore_FileToClipboard_Features:
SEH_GuiSubmit()
Return

CodeStore_OpenFile_Features:
SEH_GuiSubmit()
CodeStore_OpenFile(CodeStore_SelectedCode_Features,CodeStore_Location_Features,"ahk")
Return

CodeStore_CodeToClipboard_Features:
SEH_GuiSubmit()
Clipboard := CodeStore_RetrieveCode(CodeStore_SelectedCode_Features,CodeStore_Location_Features,"ahk")
Return

CodeStore_RetrieveCode_Features_GetFirstLine:
Return

CodeStore_DeleteFile_Features:
ConfirmCheck := SEH_GuiConfirmWarning("You have chosen to delete ALL of the selected code. Are you sure you want to do this? This can not be undone.")
IfEqual ConfirmCheck, 1
	Return
SEH_GuiSubmit()
CodeStore_DeleteFile(CodeStore_SelectedCode_Features,CodeStore_Location_Features,"ahk")
Return


CodeStore_StoreCode_Features_Append:
GuiControlGet, CodeStore_CodeContent_Features, , CodeStore_CodeContent_Features
If CodeStore_CodeContent_Features
	{}
else
	{
		SEH_GuiSubmitHalt("You must enter code in order to append it to an existing file.")
		Return
	}
GuiControlGet, CodeStore_SelectedCode_Features, , CodeStore_SelectedCode_Features
If CodeStore_SelectedCode_Features
	{}
else
	{
		SEH_GuiSubmitHalt("You must select a target code file to append your new code to.")
		Return
	}
IfInString, CodeStore_SelectedCode_Features, |
	{
		SEH_GuiSubmitHalt("You can not perform this action with multiple CodeStore library objects selected.")
		Return
	}
ConfirmCheck := SEH_GuiConfirm("Are you sure you want to append the code to the selected feature?")
IfEqual ConfirmCheck, 1
	Return
SEH_GuiSubmit()
CodeStore_StoreCode_Append(CodeStore_SelectedCode_Features,CodeStore_CodeContent_Features,CodeStore_Hotstring_Features,CodeStore_HotstringEnabled_Features,CodeStore_Location_Features,"ahk")
If CodeStore_ReloadOnAppend_Features = 1
	{
		Reload
		Return
	}
Return

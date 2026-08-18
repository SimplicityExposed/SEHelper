SEH_GuiConfirm(Message)
{
	Result = 0
	gui, 1:+0x8000000 ; 0x8000000 is WS_DISABLED
	MsgBox, 262449, Please confirm your action!, %Message%
		IfMsgBox Cancel
			Result = 1
	gui, 1:-0x8000000 ; 0x8000000 is WS_DISABLED
	Return Result
}
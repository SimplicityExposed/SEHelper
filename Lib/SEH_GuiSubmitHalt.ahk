SEH_GuiSubmitHalt(Message)
{
	gui, 1:+0x8000000 ; 0x8000000 is WS_DISABLED
	MsgBox, 262192, Notice!, %Message%
	gui, 1:-0x8000000 ; 0x8000000 is WS_DISABLED
	Return
}
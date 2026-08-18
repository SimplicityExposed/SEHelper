DynamicVarTest()
{
	InputBox, SetVar, Name your variable!
	MsgBox % "You entered: " . DVTestEntry
	%SetVar% = Test325547
	MsgBox % "Var Called is Domino:`r" . Domino
	MsgBox % "Var Called is Pizza:`r" . Pizza
	MsgBox % "Var Called is Lazy:`r" . Lazy
}
ClipGet()
{
	global ClipSaved
	Clipboard = ;
	Clipboard := ClipSaved
	ClipWait
	Return
}
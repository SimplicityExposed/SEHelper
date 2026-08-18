PasteEmailTemplate(DocName,DocExt) {
	ClipStore()
	DocumentPath := A_ScriptDir . "\User\EmailTemplates\" . DocName . "." . DocExt
	;MsgBox % DocumentPath
	oDoc := ComObjGet(DocumentPath)
	oDoc.Range.FormattedText.Copy
	;ClipWait
	oDoc.Close(0)
	TemplateOutput := ClipboardAll
	ClipGet()
	PasteVar(TemplateOutput)
	Return
}
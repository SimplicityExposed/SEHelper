GetCSSQL() ; Legacy function
{
	files = ;
	Loop %A_ScriptDir%\User\CodeStore\SQL Queries\*.sql
	{
		files = %A_LoopFileName%|%files%
	}
	StringReplace, Files, Files, .sql, , All
	Sort, files, D|
	Return files
}
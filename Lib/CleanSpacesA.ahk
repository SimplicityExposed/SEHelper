CleanSpacesA(DataToClean)
{
DataToClean := RegExReplace(DataToClean, "(^\s*|\s*$)")
Return DataToClean
}
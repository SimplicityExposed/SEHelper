CleanSpacesR(DataToClean)
{
DataToClean := RegExReplace(DataToClean, "\s*$")
Return DataToClean
}
; %Username% - Michael Smith's custom Hotstrings

:*:xme::FLAGSHIP\msm3895
:*:xempid::106015342
:*:xmymail::MSmith@HollandAmericaGroup.com

:*:xmyfolder::
PasteText("\\dsdb\SQLSkills\v-smmi\")
Return


:*:xtt:: ; Task title for MSSolve Tasks.
SendInput, %A_YYYY%/%A_MM%/%A_DD% -  - %Username%
LeftCount := StrLen(Username)
EnvAdd, LeftCount, 3
SendInput, {Left %LeftCount%}
Return



:*:xdate:: ; Simple Date Timestamp "MM/DD/YYYY"
SendInput, %A_MM%/%A_DD%/%A_YYYY%
Return





::Template:IR::
PasteEmailTemplate("IR Email Template","docx")
Return

::Template:PSSD::
PasteEmailTemplate("PSSD Email Template","docx")
Return

::Template:Scope::
PasteEmailTemplate("Scope Email Template","docx")
Return

::Template:Resolution::
PasteEmailTemplate("Resolution Email Template","docx")
Return

::Template:ManualDataCollection::
PasteEmailTemplate("Manual Data Collection Email Template","docx")
Return







:*:xtabreturn::
TABLEAURETURN = `
(
Additions & modifications to Tableau Server are requested via ServiceNow (SNOW):

Service Catalog -> Security and Access (Global) -> HA Group - Tableau
Request Type                   Add/Modify(for existing users)
Access Level                     User (Interactor/View), SuperUser (Publish)
Group                                 <choose appropriately>

Please contact your local help desk to place this request if you don’t have access to SNOW:
Local: x44357 (4HELP)
Toll Free: (844) 584-4357
International: +1 (661) 284-4357

Let me know if you have any question.
)
TABLEAURETURN := PasteVAR(TABLEAURETURN ,1)

Return
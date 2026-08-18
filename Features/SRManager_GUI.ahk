{
Gui, Tab, SR Manager ;%SRManager_TabName% ;
	Gui, Add, Text, x12 y9 w90 h20 +Right, Service Requests:
	Gui, Add, DropDownList, x102 y9 w290 h20 r10, 116101014778381 - Failover RCA for John||11610101477838101230123 - Failover RCA for Jingleheimer|116101014778381 - Permissions\User Removal
	Gui, Add, Button, x402 y9 w70 h20 , Activate
	Gui, Add, Button, x482 y9 w50 h20 , Close
	Gui, Add, Button, x542 y9 w70 h20 , Manage All

	Gui, Add, Text, x622 y9 w170 h20 +Center, Available Routines for SR's
	Gui, Add, ListBox, x622 y29 w170 h300 , Case Folder: Create|Case Folder: Manage|Case Folder: Open|Case Folder: Purge Client Data|SQL Nexus: Create DB|SQL Nexus: Custom Query|SQL Nexus: Share Access|Compile RCA: External|Compile RCA: Internal|Compile RCA: Complete|Compile RCA: Case Notes|Compile Case Log to Notes|Generate SDP
	Gui, Add, Button, x622 y325 w170 h20 , Execute selected routine.
	Gui, Add, Button, x622 y349 w50 h20 , Create
	Gui, Add, Button, x677 y349 w50 h20 , Open
	Gui, Add, Button, x732 y349 w60 h20 , Configure

	Gui, Add, GroupBox, x4 y244 w613 h132 , Active Comment for SR#
	Gui, Add, Edit, x12 y261 w530 h110 +HScroll +Wrap vSRManager_ActiveComment, Active Comment Field
	Gui, Add, Button, x552 y259 w60 h20 , Save
	Gui, Add, Button, x552 y289 w60 h20 , Reset
	Gui, Add, Button, x552 y319 w60 h20 , Log It
	Gui, Add, Button, x552 y349 w60 h20 , View Log

	Gui, Add, GroupBox, x4 y34 w613 h205 , Service Request Details and Controls: SRNUMBER
	Gui, Add, Text, x12 y49 w20 h20 , SR:
	Gui, Add, Edit, x32 y49 w140 h20 , SRNUMBER
	Gui, Add, Text, x182 y49 w60 h20 +Right, SR TITLE:
	Gui, Add, Edit, x242 y49 w250 h20 , Edit
	Gui, Add, Text, x152 y79 w90 h20 +Right, SR CATEGORY:
	Gui, Add, ComboBox, x242 y79 w250 h20 r10, Failover RCA Workflow||Performance Workflow

	Gui, Add, GroupBox, x502 y49 w110 h62 , Labor Tracking
	Gui, Add, CheckBox, x512 y66 w90 h20 , Working SR
	Gui, Add, Button, x512 y86 w90 h20 , View Labor Log

	Gui, Add, GroupBox, x502 y116 w110 h118 , SR Actions
	Gui, Add, Button, x512 y134 w90 h20 , Save Details
	Gui, Add, Button, x512 y159 w90 h20 , Refresh Details
	Gui, Add, Button, x512 y184 w90 h20 , Open Workflow
	Gui, Add, Button, x512 y209 w90 h20 , SR# to Clipboard
	
	GuiControl, Focus, SRManager_ActiveComment
Gui, Tab
}
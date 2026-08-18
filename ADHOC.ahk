SoundBeep
preventSV := False
SetTimer preventSV, 60000
Return
^INS::Reload
^HOME:: Run C:\Users\msm3895\MyApp\ADHOC.ahk
; ======================



^5::
global preventSV := !preventSV
if (global preventSV) {
	TrayTip, SSP Active, Enabled, 2, 17
	SoundBeep
	SoundBeep
}
else {TrayTip, SSP Disabled, 2, 17
SoundBeep
}
return

preventSV:
if (global preventSV) {
	MouseMove, 1, 0, 1, R
	MouseMove, -1, 0, 1, R
}
return
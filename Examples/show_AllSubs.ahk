; SOURCE: https://autohotkey.com/boards/viewtopic.php?t=9997

#SingleInstance, Force
#NoEnv
CoordMode, ToolTip

F12:: Gosub, show_AllSubs
F11:: ToolTip ; off
Esc:: ExitApp


;-------------------------------------------------------------------------------
show_AllSubs: ; show all subs in a tooltip
;-------------------------------------------------------------------------------
    WinExist("A")
    WinGetPos, X, Y
    ControlGetFocus, myControl
    ControlGetPos, $X, $Y,,, %myControl%
    ControlGetText, CODE, %myControl%

    SUBS := ""
    Loop, Parse, CODE, `n, `r
        If RegExMatch(A_LoopField, "^\s*([\w]+:+).*$", $)
            SUBS .= $1 "`n"

    ToolTip, % SUBS, X + $X, Y + $Y

Return

TestSub1:
Return

TestSub2:
Return

TestSub3:
Return
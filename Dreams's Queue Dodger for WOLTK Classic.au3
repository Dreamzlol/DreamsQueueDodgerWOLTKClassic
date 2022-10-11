#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Dreams's Queue Dodger for WOLTK Classic.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section ###
$GUI = GUICreate("Dreams's Queue Dodger for WOLTK Classic", 436, 482, 186, 129)
$antiAfkButton = GUICtrlCreateButton("Run Queue Dodger", 124, 376, 185, 41)
GUICtrlSetState(-1, $GUI_CHECKED)
$programActiveLabel = GUICtrlCreateLabel("Queue Dodger is turned off", 143, 424, 164, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFF0000)
$maximumWaitTimeInput = GUICtrlCreateInput("600", 160, 328, 41, 21)
GUICtrlSetLimit(-1, 4)
$minimumWaitTimeInput = GUICtrlCreateInput("300", 160, 304, 41, 21)
GUICtrlSetLimit(-1, 4)
$maximumWaitTimeLabel = GUICtrlCreateLabel("Maximum wait time in seconds:", 8, 336, 149, 17)
$minimumWaitTimeLabel = GUICtrlCreateLabel("Minimum wait time in seconds:", 8, 312, 146, 17)
$introLabel1 = GUICtrlCreateLabel("This shitty programm logs you out and back in too prevent to be in the queue again.", 8, 168, 397, 17)
$introLabel2 = GUICtrlCreateLabel("in the random time between the specified values below.", 8, 200, 265, 17)
$introLabel5 = GUICtrlCreateLabel("Make sure you are ingame and in a rested area like a city or where you", 8, 256, 407, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Pic1 = GUICtrlCreatePic("assests\header.jpg", 8, 8, 420, 148)
$introLabel6 = GUICtrlCreateLabel("You can do other things in the meanwhile, it will only focus the window for a split second ", 8, 184, 421, 17)
$introLabel7 = GUICtrlCreateLabel("can set your Hearthstone!", 8, 272, 287, 17)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
$introLabel4 = GUICtrlCreateLabel("IMPORTANT!", 8, 240, 87, 17)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$timeUntilNextMoveLabel = GUICtrlCreateLabel("9999 seconds until next input", 138, 448, 174, 17)
GUICtrlSetState(-1, $GUI_HIDE)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xC0C0C0)
GUICtrlSetState(-1, $GUI_HIDE)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Opt("GUIOnEventMode", 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUICtrlSetOnEvent($antiAfkButton, "_Switch_Anti_AFK")

Global $antiAfkOn = False
Global $timeUntilNextMove = 0
Global $prevClampedTimeElapsed = 0

Global $GREEN_COLOR = 0x32CD32
Global $RED_COLOR = 0xFF0000
Global $WOW_WINDOW_NAME = "World of Warcraft"

While 1
	Sleep(10)

	If ($antiAfkOn) Then
		_Run_Anti_AFK()
	EndIf
WEnd

Func _Switch_Anti_AFK()
	if (Not WinExists($WOW_WINDOW_NAME)) Then
		MsgBox(0x0, "Error", "Make sure WoW is turned on")
		Return
	EndIf

	$antiAfkOn = Not $antiAfkOn

	if ($antiAfkOn) Then
		GUICtrlSetColor($programActiveLabel, $GREEN_COLOR)
		GUICtrlSetData($programActiveLabel, "Queue Dodger is turned on")
		GUICtrlSetData($antiAfkButton, "Stop Queue Dodger")
		GUICtrlSetState($timeUntilNextMoveLabel, $GUI_SHOW)
	Else
		GUICtrlSetColor($programActiveLabel, $RED_COLOR)
		GUICtrlSetData($programActiveLabel, "Queue Dodger is turned off")
		GUICtrlSetData($antiAfkButton, "Run Queue Dodger")
		GUICtrlSetState($timeUntilNextMoveLabel, $GUI_HIDE)
	EndIF
EndFunc ;==>__Switch_Anti_AFK


Func _Run_Anti_AFK()
	$randomWaitTime = Random(GUICtrlRead($minimumWaitTimeInput) * 100, GUICtrlRead($maximumWaitTimeInput) * 100)
	GUICtrlSetData($timeUntilNextMoveLabel, Number(($randomWaitTime) / 100, 1) & " seconds until next input")

	If (_Wait_For_Next_Move($randomWaitTime) = -1) Then
		Return
	EndIf

	WinActivate($WOW_WINDOW_NAME)

	BlockInput(1)
	Send("{Enter}")
	Send("/logout")
	Send("{Enter}")
	BlockInput(0)
EndFunc ;==>_Run_Anti_AFK


Func _Wait_For_Next_Move($randomWaitTime)
	For $i = 0 To $randomWaitTime Step 1.6666
		If (Not $antiAfkOn) Then
			Return -1
		EndIf

		$clampedTimeElapsed = $i - Mod($i, 100)

		; Necessary to stop timer text from flickering
		If ($clampedTimeElapsed <> $prevClampedTimeElapsed) Then
			GUICtrlSetData($timeUntilNextMoveLabel, Number(($randomWaitTime - $i) / 100, 1) & " seconds until next input")
		EndIf

		$prevClampedTimeElapsed = $clampedTimeElapsed

		Sleep(10)
	Next
EndFunc ;==> _Wait_For_Next_Move


Func _Exit()
	Exit
EndFunc ;==>_Exit

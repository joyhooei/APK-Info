#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=APK-Info.ico
#AutoIt3Wrapper_Outfile=APK-Info.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Shows info about Android Package Files (APK)
#AutoIt3Wrapper_Res_Description=APK-Info
#AutoIt3Wrapper_Res_Fileversion=0.4.0.0
#AutoIt3Wrapper_Res_LegalCopyright=zoster
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <Array.au3>
#include <String.au3>
#include <Constants.au3>
Opt("TrayMenuMode", 1)
Opt("TrayIconHide", 1)


Global $apk_Label, $apk_IconPath, $apk_IconName, $apk_PkgName, $apk_VersionCode, $apk_VersionName
Global $apk_Permissions, $apk_Features, $hGraphic, $hImage, $apk_MinSDK, $apk_MinSDKVer, $apk_MinSDKName
Global $apk_TargetSDK, $apk_TargetSDKVer, $apk_TargetSDKName, $apk_Screens, $apk_Densities
Global $tempPath = @TempDir & "\APK-Info"
;~ & "\APK-Info"
Dim $sMinAndroidString, $sTgtAndroidString


If $CmdLine[0] > 0 Then
	$tmp_Filename = $CmdLine[1]
Else
	$tmp_Filename = ""
EndIf

Global $fullPathAPK = _checkFileParameter($tmp_Filename)
Global $dirAPK = _SplitPath($fullPathAPK, True)
Global $fileAPK = _SplitPath($fullPathAPK, False)

$tmpArrBadge = _getBadge($fullPathAPK)
_parseLines($tmpArrBadge)
;~ FileDelete ($tempPath)

;~ ConsoleWrite($apk_Label& '2222'&$fullPathAPK & '2222'&$apk_IconPath)


_extractIcon($fullPathAPK, $apk_IconPath)

If $apk_MinSDKVer <> "" Then $sMinAndroidString = 'Android ' & $apk_MinSDKVer & ' / ' & $apk_MinSDKName
If $apk_TargetSDKVer <> "" Then $sTgtAndroidString = 'Android ' & $apk_TargetSDKVer & ' / ' & $apk_TargetSDKName
$sNewFilenameAPK = StringReplace($apk_Label, " ", " ") & "_" & StringReplace($apk_VersionName, " ", " ") & ".apk"


_convertIcon($tempPath & "\" & $apk_IconName)


;================== GUI ===========================

$hGUI = GUICreate("APK-Info v0.6", 400, 494)
$gLbl1 = GUICtrlCreateLabel("Application", 8, 12, 78, 17)
$gLbl2 = GUICtrlCreateLabel("Version", 8, 36, 78, 17)
$gLbl3 = GUICtrlCreateLabel("Version Code", 8, 60, 78, 17)
$gLbl4 = GUICtrlCreateLabel("Package", 8, 84, 78, 17)
$gLbl5 = GUICtrlCreateLabel("Min. SDK", 8, 108, 78, 17)
$gLbl6 = GUICtrlCreateLabel("Target SDK", 8, 132, 78, 17)
$gLbl7 = GUICtrlCreateLabel("Screen Sizes", 8, 156, 78, 17)
$gLbl8 = GUICtrlCreateLabel("Resolutions", 8, 180, 78, 17)
$Input1 = GUICtrlCreateInput($apk_Label, 88, 9, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input2 = GUICtrlCreateInput($apk_VersionName, 88, 33, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input3 = GUICtrlCreateInput($apk_VersionCode, 88, 57, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input4 = GUICtrlCreateInput($apk_PkgName, 88, 81, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input5 = GUICtrlCreateInput($apk_MinSDK, 88, 105, 20, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input6 = GUICtrlCreateInput($sMinAndroidString, 110, 105, 188, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input7 = GUICtrlCreateInput($apk_TargetSDK, 88, 129, 20, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input8 = GUICtrlCreateInput($sTgtAndroidString, 110, 129, 188, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input9 = GUICtrlCreateInput($apk_Screens, 88, 153, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$Input10 = GUICtrlCreateInput($apk_Densities, 88, 177, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

$Label5 = GUICtrlCreateLabel("Permissions", 8, 208, 62, 17)
$Edit1 = GUICtrlCreateEdit($apk_Permissions, 88, 205, 304, 85, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $WS_VSCROLL, $ES_WANTRETURN))
$Label6 = GUICtrlCreateLabel("Features", 8, 301, 48, 17)
$Edit2 = GUICtrlCreateEdit($apk_Features, 88, 298, 304, 85, BitOR($ES_READONLY, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $WS_VSCROLL, $ES_WANTRETURN))

$gLbl = GUICtrlCreateLabel("Current Name", 8, 404, 78, 17)
$Input11 = GUICtrlCreateInput($fileAPK, 88, 401, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
$gLbl = GUICtrlCreateLabel("New Name", 8, 428, 78, 17)
$Input11 = GUICtrlCreateInput($sNewFilenameAPK, 88, 425, 210, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_READONLY))

$gBtn_Play = GUICtrlCreateButton("Play Store", 8, 460, 80)
$gBtn_Rename = GUICtrlCreateButton("Rename File", 313, 422, 80)
$gBtn_Exit = GUICtrlCreateButton("Exit", 313, 460, 80)

; Png Workaround
; Load PNG image
_GDIPlus_Startup()
$hImage = _GDIPlus_ImageLoadFromFile($tempPath & "\" & $apk_IconName)
$type = VarGetType($hImage)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $type = ' & $type & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)

GUIRegisterMsg($WM_PAINT, "MY_WM_PAINT")

GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $gBtn_Play
			_openPlay()

		Case $gBtn_Rename
			$sNewNameInput = InputBox("Rename APK File", "New APK Filename:", $sNewFilenameAPK, "", 300, 130)
			If $sNewNameInput <> "" Then _renameAPK($sNewFilenameAPK)

		Case $gBtn_Exit
			_cleanUp()
			Exit

		Case $GUI_EVENT_CLOSE
			_cleanUp()
			Exit
	EndSwitch
WEnd

;==================== End GUI =====================================

; Draw PNG image
Func MY_WM_PAINT($hWnd, $Msg, $wParam, $lParam)
	_WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_UPDATENOW)
	_GDIPlus_GraphicsDrawImage($hGraphic, $hImage, 305, 10)
	_WinAPI_RedrawWindow($hGUI, 0, 0, $RDW_VALIDATE)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_PAINT

Func _renameAPK($prmNewFilenameAPK)
	$result = FileMove($fullPathAPK, $dirAPK & "\" & $sNewFilenameAPK)
	If $result <> 1 Then MsgBox(0, "Error!", "APK File could not be renamed.")
EndFunc   ;==>_renameAPK

Func _SplitPath($prmFullPath, $prmReturnDir = False)
	$posSlash = StringInStr($prmFullPath, "\", 0, -1)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $posSlash = ' & $posSlash & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
	Switch $prmReturnDir
		Case False
			Return StringMid($prmFullPath, $posSlash + 1)
		Case True
			Return StringLeft($prmFullPath, $posSlash - 1)
	EndSwitch
EndFunc   ;==>_SplitPath

Func _checkFileParameter($prmFilename)
	If FileExists($prmFilename) Then
		Return $prmFilename
	Else
		$f_Sel = FileOpenDialog("Select APK file", @WorkingDir, "(*.apk)", 1, "")
		If @error Then Exit
		Return $f_Sel
	EndIf
EndFunc   ;==>_checkFileParameter

Func _getBadge($prmAPK)
	Local $foo = Run('aapt.exe d badging ' & '"' & $prmAPK & '"', @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $output
	Local $line
	Local $tmp = ""
	While 1
		$line = StdoutRead($foo, False, True)
		If @error Then ExitLoop
		$tmp &= BinaryToString($line, 4)
	WEnd
	$output = $tmp
	
	$arrayLines = _StringExplode($output, @CRLF)
	Return $arrayLines
EndFunc   ;==>_getBadge

Func _parseLines($prmArrayLines)
	For $line In $prmArrayLines
		$arraySplit = _StringExplode($line, ":", 1)
		If UBound($arraySplit) > 1 Then
			$key = $arraySplit[0]
			$value = $arraySplit[1]
		Else
			ContinueLoop
		EndIf
		
		Switch $key
			Case 'application'
				$tmp_arr = _StringBetween($value, "label='", "'")
				$apk_Label = $tmp_arr[0]
				$tmp_arr = _StringBetween($value, "icon='", "'")
				$apk_IconPath = $tmp_arr[0]
				$tmp_arr = _StringExplode($apk_IconPath, "/")
				$apk_IconName = $tmp_arr[UBound($tmp_arr) - 1]

			Case 'package'
				$tmp_arr = _StringBetween($value, "name='", "'")
				$apk_PkgName = $tmp_arr[0]
				$tmp_arr = _StringBetween($value, "versionCode='", "'")
				$apk_VersionCode = $tmp_arr[0]
				$tmp_arr = _StringBetween($value, "versionName='", "'")
				$apk_VersionName = $tmp_arr[0]

			Case 'uses-permission'
				$tmp_arr = _StringBetween($value, "'", "'")
				$apk_Permissions &= StringLower(StringReplace($tmp_arr[0], "android.permission.", "") & @CRLF)

			Case 'uses-feature'
				$tmp_arr = _StringBetween($value, "'", "'")
				$apk_Features &= StringLower(StringReplace($tmp_arr[0], "android.hardware.", "") & @CRLF)

			Case 'sdkVersion'
				$tmp_arr = _StringBetween($value, "'", "'")
				$apk_MinSDK = $tmp_arr[0]
				$apk_MinSDKVer = _translateSDKLevel($apk_MinSDK)
				$apk_MinSDKName = _translateSDKLevel($apk_MinSDK, True)

			Case 'targetSdkVersion'
				$tmp_arr = _StringBetween($value, "'", "'")
				$apk_TargetSDK = $tmp_arr[0]
				$apk_TargetSDKVer = _translateSDKLevel($apk_TargetSDK)
				$apk_TargetSDKName = _translateSDKLevel($apk_TargetSDK, True)

			Case 'supports-screens'
				$apk_Screens = StringStripWS(StringReplace($value, "'", ""), 3)

			Case 'densities'
				$apk_Densities = StringStripWS(StringReplace($value, "'", ""), 3)

		EndSwitch
	Next
EndFunc   ;==>_parseLines

Func _extractIcon($prmAPK, $prmIconPath)

	
	$runCmd = "unzip.exe -o -j -q " & '"' & $prmAPK & '" ' & $prmIconPath & " -d " & '"' & $tempPath & '"'
	ConsoleWrite($runCmd)
	RunWait($runCmd, @ScriptDir, @SW_HIDE)
EndFunc   ;==>_extractIcon

Func _convertIcon($prmPNGPath)
	;not used
	$runCmd = 'convert.exe ' & '"' & $prmPNGPath & '"' & " -background #f0f0f0 -flatten -alpha off " & '"' & $tempPath & "\Icon.bmp" & '"'
	RunWait($runCmd, @ScriptDir, @SW_HIDE)
EndFunc   ;==>_convertIcon

Func _cleanUp()
	FileDelete($tempPath & "\" & $apk_IconName)
	DirRemove($tempPath)
EndFunc   ;==>_cleanUp

Func _openPlay()
	$url = 'https://play.google.com/store/apps/details?id=' & $apk_PkgName
	
	ShellExecute($url)
EndFunc   ;==>_openPlay

Func _translateSDKLevel($prmSDKLevel, $prmReturnCodeName = False)

	Switch String($prmSDKLevel)
		;You can see uses-sdk on "https://developer.android.com/guide/topics/manifest/uses-sdk-element.html"
		;and "https://developer.android.com/reference/android/os/Build.VERSION_CODES.html"
		Case "25"
			$sVersion = "7.1"
			$sCodeName = "Nougat MR1"
		Case "24"
			$sVersion = "7.0"
			$sCodeName = "Nougat"
		Case "23"
			$sVersion = "6.0"
			$sCodeName = "Marshmallow"
		Case "22"
			$sVersion = "5.1"
			$sCodeName = "Lollipop MR1"
		Case "21"
			$sVersion = "5.0"
			$sCodeName = "Lollipop"
		Case "20"
			$sVersion = "4.4W"
			$sCodeName = "Kitkat Watch"
		Case "19"
			$sVersion = "4.4"
			$sCodeName = "KitKat"
		Case "18"
			$sVersion = "4.3"
			$sCodeName = "Jelly Bean MR2"
		Case "17"
			$sVersion = "4.2.x"
			$sCodeName = "Jelly Bean MR1"
		Case "16"
			$sVersion = "4.1.x"
			$sCodeName = "Jelly Bean"
		Case "15"
			$sVersion = "4.0.3-4"
			$sCodeName = "Ice Cream Sandwich MR1"
		Case "14"
			$sVersion = "4.0.0-2"
			$sCodeName = "Ice Cream Sandwich"
		Case "13"
			$sVersion = "3.2"
			$sCodeName = "Honeycomb MR2"
		Case "12"
			$sVersion = "3.1.x"
			$sCodeName = "Honeycomb MR1"
		Case "11"
			$sVersion = "3.0.x"
			$sCodeName = "Honeycomb"
		Case "10"
			$sVersion = "2.3.3-4"
			$sCodeName = "Gingerbread MR1"
		Case "9"
			$sVersion = "2.3.0-2"
			$sCodeName = "Gingerbread"
		Case "8"
			$sVersion = "2.2.x"
			$sCodeName = "Froyo"
		Case "7"
			$sVersion = "2.1.x"
			$sCodeName = "Eclair MR1"
		Case "6"
			$sVersion = "2.0.1"
			$sCodeName = "Eclair 01"
		Case "5"
			$sVersion = "2.0"
			$sCodeName = "Eclair"
		Case "4"
			$sVersion = "1.6"
			$sCodeName = "Donut"
		Case "3"
			$sVersion = "1.5"
			$sCodeName = "Cupcake"
		Case "2"
			$sVersion = "1.1"
			$sCodeName = "Base 11"
		Case "1"
			$sVersion = "1.0"
			$sCodeName = "Base"
		Case Else
			$sVersion = "Unknown"
			$sCodeName = "Unknown"
	EndSwitch

	Switch $prmReturnCodeName
		Case True
			Return $sCodeName
		Case Else
			Return $sVersion
	EndSwitch
EndFunc   ;==>_translateSDKLevel

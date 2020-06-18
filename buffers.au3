#include <WinAPI.au3>;used to play default beep
Dim $Buffers[1];Each element will be a nested array containing all lines of a monitored window, this will be redimmed at initialisation
$WhichBuffer=0
$BufferCursor=0
$BufferKeysActive=0
Func BufferNavigate()
If IsArray($Buffers[$WhichBuffer]) then
select
case @HotkeyPressed="!{up}"
If $BufferCursor>0 then
$BufferCursor=$BufferCursor-1
If $bufferCursor>UBound(($Buffers[$WhichBuffer]))-1 then $BufferCursor=UBound(($Buffers[$WhichBuffer]))-1
;Going up in a shrunken buffer while the cursor is out of bounds.
else
_WinAPI_MessageBeep(0)
EndIf
case @HotkeyPressed="!{down}"
If $BufferCursor<UBound($Buffers[$WhichBuffer])-1 then
$bufferCursor=$BufferCursor+1
else ;Out of bounds due to reading in a larger buffer before and switching to a smaller one
_WinAPI_MessageBeep(0)
$BufferCursor=UBound(($buffers[$WhichBuffer]))-1
EndIf
Case @HotkeyPressed="!{home}"
$BufferCursor=0
Case @HotkeyPressed="!{end}"
$BufferCursor=UBound($Buffers[$WhichBuffer])-1

EndSelect
If ($Buffers[$WhichBuffer])[$BufferCursor]="" then
speak("blank")
else
speak(($Buffers[$WhichBuffer])[$BufferCursor])
EndIf
else;Buffer is not a nested array which means the buffer is empty
speak("empty")
EndIf
EndFunc
Func BufferSwitch()
Select
Case @HotkeyPressed="!{right}"
If $WhichBuffer<UBound($WindowList)-1 then
$WhichBuffer=$WhichBuffer+1
else ;Last buffer, so wrap around to the first
$WhichBuffer=0
EndIf
Case @HotkeyPressed="!{left}"
If $WhichBuffer>0 then
$WhichBuffer=$WhichBuffer-1
else ;First Buffer, so wrap around to the last
$WhichBuffer=UBound($WindowList)-1
EndIf
EndSelect
;Now do Alt+Numbers
For $i=1 to 9 step 1
If @HotkeyPressed="!"&$i then
If $i<=UBound($buffers) then
$WhichBuffer=$i-1
else;No buffer with that number
_WinAPI_MessageBeep(0)
EndIf
EndIf
next
Speak($WindowList[$WhichBuffer])
EndFunc
Func BufferCopy()
If ClipPut(($Buffers[$WhichBuffer])[$BufferCursor]) then
Speak("Copied " & (($Buffers[$WhichBuffer])[$BufferCursor]))
EndIf
EndFunc
Func RegisterBufferKeys($OnOrOff)
If $OnOrOff=1 then
HotkeySet("!{down}", "BufferNavigate")
HotkeySet("!{up}", "BufferNavigate")
HotkeySet("!{home}", "BufferNavigate")
HotkeySet("!{end}", "BufferNavigate")
HotKeySet("!{right}", "BufferSwitch")
HotKeySet("!{left}", "BufferSwitch")
For $i=1 to 9 step 1
HotKeySet("!"&$i, "BufferSwitch")
next
HotKeySet("!c", "BufferCopy")
return
else
HotkeySet("!{down}")
HotkeySet("!{up}")
HotkeySet("!{home}")
HotkeySet("!{end}")
HotKeySet("!{right}")
HotKeySet("!{left}")
For $i=1 to 9 step 1
HotKeySet("!"&$i)
next

HotKeySet("!c")
EndIf
EndFunc

func IsInGame()
For $i=0 to UBound($WindowList)-1 step 1
If WinActive($WindowList[$i]) then
Return true
ExitLoop
EndIf
next
If WinActive("Prompt") then
return true
else
return false
EndIf
EndFunc
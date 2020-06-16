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
Speak($WindowList[$WhichBuffer])
EndFunc


HotkeySet("!{down}", "BufferNavigate")
HotkeySet("!{up}", "BufferNavigate")
HotkeySet("!{home}", "BufferNavigate")
HotkeySet("!{end}", "BufferNavigate")
HotKeySet("!{right}", "BufferSwitch")
HotKeySet("!{left}", "BufferSwitch")
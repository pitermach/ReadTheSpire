Dim $Buffers[1];Each element will be a nested array containing all lines of a monitored window, this will be redimmed at initialisation
$WhichBuffer=0
$BufferCursor=0
$BufferKeysActive=0
Func BufferNavigate()
If IsArray($Buffers[$WhichBuffer]) then
select
case @HotkeyPressed="!{up}"
If $BufferCursor>0 then $BufferCursor=$BufferCursor-1
case @HotkeyPressed="!{down}"
If $BufferCursor<UBound($Buffers[$WhichBuffer])-1 then
$bufferCursor=$BufferCursor+1
else ;Out of bounds due to reading in a larger buffer before and switching to a smaller one
$BufferCursor=UBound(($buffers[$WhichBuffer]))-1
EndIf
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
HotkeySet("!{down}", "BufferNavigate")
HotkeySet("!{up}", "BufferNavigate")
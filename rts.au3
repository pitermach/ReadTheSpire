#include "tolk.au3"
#include "buffers.au3"
$WindowList=FileReadToArray("watchlist.txt")
If @error then
Msgbox(16, "Error", "Couldn't read Watchlist. The file may either be empty, inaccessible or not exist.")
exit
EndIf
dim $OldText[UBound($WindowList)]
Dim $buffers[UBound($WindowList)]
Tolk_Load()
if not Tolk_IsLoaded() then
Msgbox(16, "Error", "Tolk failed to load!")
exit
EndIf
Tolk_TrySapi(true)
func speak($text)
If $text>"" then tolk_output($text);Suppress blank lines because NVDA gets chatty
endFunc
func Quit()
Speak("Exitting")
exit
EndFunc
HotKeySet("^q", "Quit")
speak("Read The Spire ready!")
while 1
If $BufferKeysActive=0 and IsInGame() then
$BufferKeysActive=1
RegisterBufferKeys(1)
ElseIf not IsInGame() and $BufferKeysActive=1 then
$BufferKeysActive=0
RegisterBufferKeys(0)
EndIf

for $i=0 to UBound($WindowList)-1 step 1
$text=ControlGetText($WindowList[$i], "", "[CLASS:Edit]")
If $text <> $OldText[$i] then; speak the new text!
$buffers[$i]=StringSplit($text, @crlf, 3)
Speak($WindowList[$i]);announce what window the output came from
If $WindowList[$i]="Output" then ;The entire output Window should always be reread since that's generally requested by the player
Tolk_Output($text)

else ;For other windows, compare the old and newly changed text line by line to only anounce the ones that changed.
$OldArray=StringSplit($OldText[$i], @crlf, 1)
$NewArray=StringSplit($text, @crlf, 1)
For $i2=1 to $NewArray[0] step 1
If $i2<uBound($OldArray) then;line numbers that exist in both strings
If $OldArray[$i2]<>$NewArray[$i2] then Speak($NewArray[$i2]);Only speak the line if it changed
else;The new text has more lines than the old, so just speak all of them
Speak($NewArray[$i2])
EndIf
next
EndIf;Output or other windows check
EndIf;Speak if the text was different
$OldText[$i]=$text;Set the old text to the new
next

sleep(10)
Wend
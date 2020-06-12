#include "tolk.au3"
$watchlist="Output|Choices|Player|Monster|Relic|hand"

$WindowList=StringSplit($watchlist, "|")
dim $OldText[$WindowList[0]]
Tolk_Load()
if not Tolk_IsLoaded() then
Msgbox(16, "Error", "Tolk failed to load!")
exit
EndIf
func speak($text)
If $text>"" then tolk_output($text)
endFunc
func Quit()
Speak("Exitting")
exit
EndFunc
HotKeySet("^q", "Quit")
while 1
for $i=1 to $WindowList[0] step 1
$text=ControlGetText($WindowList[$i], "", "[CLASS:Edit]")
If $text <> $OldText[$i-1] then; speak the new text!
Speak($WindowList[$i]);announce what window the output came from
;Now compare the old and newly changed text line by line to only anounce the ones that changed.
$OldArray=StringSplit($OldText[$i-1], @crlf, 1)
$NewArray=StringSplit($text, @crlf, 1)
For $i2=1 to $NewArray[0] step 1
If $i2<uBound($OldArray) then;line numbers that exist in both strings
If $OldArray[$i2]<>$NewArray[$i2] then Speak($NewArray[$i2]);Only speak the line if it changed
else;The new text has more lines than the old, so just speak all of them
Speak($NewArray[$i2])
EndIf
next
EndIf;Speak if the text was different
$OldText[$i-1]=$text;Set the old text to the new
next

sleep(10)
Wend
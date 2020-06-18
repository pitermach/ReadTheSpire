#include "tolk.au3"
#include "buffers.au3"
#include <misc.au3>
#include <array.au3>
_Singleton("ReadTheSpire");exit if there's more than 1 copy running
$WindowList=FileReadToArray("watchlist.txt")

If @error then
Msgbox(16, "Error", "Couldn't read Watchlist. The file may either be empty, inaccessible or not exist.")
exit
EndIf
dim $SilentWindowList[UBound($WindowList)]
For $i=0 to UBound($WindowList)-1 step 1
If StringLeft($WindowList[$i], 1)="*" then;Silent window
$SilentWindowList[$i]=true
$WindowList[$i]=StringTrimLeft($WindowList[$i], 1)
EndIf
next
$SubstitutionList=FileReadToArray("substitutions.txt")

If @error then
Msgbox(16, "Error", "Couldn't read substitutions. The file may either be empty, inaccessible or not exist.")
exit
EndIf
Dim $Substitutions[UBound($SubstitutionList)][2]

For $i=0 to UBound($SubstitutionList)-1 step 1
$TempArray=StringSplit($SubstitutionList[$i], "=", 2)
If not @error then
$Substitutions[$i][0]=$TempArray[0]
$Substitutions[$i][1]=$TempArray[1]
EndIf
Next

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
If WinExists("Slay the Spire")=0 then;Launch the MTS launcher
$MTSDir=FileRead("MTSDir.txt")
If $MTSDir="" then ;Look for the file in the most common directories
$Dirs=StringSplit("C:\Program Files (x86)\Steam\steamapps\common\SlayTheSpire\|D:\Program Files (x86)\Steam\steamapps\common\SlayTheSpire\", "|", 2)
For $i=0 to UBound($dirs)-1 step 1
;Msgbox(0, "checking", $Dirs[$i])
If FileExists($dirs[$i] & "mts-launcher.jar") then
$MTSDir=$Dirs[$i]
;msgBox(64, "Success", $Dirs[$i])
ExitLoop
EndIf
Next
If $MTSDir="" then $MTSDir=FileSelectFolder("Browse to Slay the Spire installation folder", "")
If @error then
$NoLaunch=Msgbox(32+4, "Question", "Would you like to make ReadTheSpire not start MTS-launcher at startup?")
If $NoLaunch=6 then ;yes
$MTSDir="none"
MsgBox(64, "Done", "If you later want to specify the location of MTS-launcher, delete MTSDir.txt located in the ReadTheSpire folder.")
else ;no
exit
EndIf
EndIf;Looks for MTS-launcher.jar
FileWrite("MTSDir.txt", $MTSDir)
EndIf

If $MTSDir <>"none" then
FileChangeDir($MTSDir)
If FileExists("moddespire.jar") then
ShellExecute("moddespire.jar");For Gog version
else
ShellExecute("mts-launcher.jar")
EndIf
speak("MTS Launcher started, waiting for game to start")
else
speak("ReadTheSpire ready, waiting for you to start the game.")
EndIf

do
sleep(250)
until WinExists("Slay the Spire")
EndIf;Look if the game is open, otherwise launch it.
$STSHandle=WinGetHandle("Slay the Spire")
while WinExists($STSHandle)=1
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
$buffers[$i]=StringSplit($text, @crlf, 3);update the buffers
If $SilentWindowList[$i]=false then
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
EndIf ;Silent window or not check
$OldText[$i]=$text;Set the old text to the new
next

sleep(10)
Wend
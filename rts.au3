#pragma compile(CompanyName, 'Piotr Machacz')
#pragma compile (FileDescription, ReadTheSpire)
#pragma compile(ProductName, ReadTheSpire)
#Pragma compile (ProductVersion, 3.22)

#include "tolk.au3"
#include "buffers.au3"
#include <misc.au3>
#include <array.au3>
AutoItSetOption("WinTextMatchMode", -1)
_Singleton("ReadTheSpire");exit if there's more than 1 copy running
$WindowList=FileReadToArray("watchlist.txt")
Dim $HandleList[UBound($WindowList)][2]
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
If Not StringIsSpace($text) then tolk_output($text);Suppress blank lines because NVDA gets chatty
;_ArrayDisplay(StringToASCIIArray($text))
endFunc
func Quit()
Speak("Exitting")
exit
EndFunc
HotKeySet("^q", "Quit")
If WinExists("Modded Slay the Spire")=0 then;Launch the MTS launcher
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
If FileExists("modthespire.jar") then
ShellExecute("modthespire.jar");For Gog version
else
ShellExecute("mts-launcher.jar")
EndIf
If @error then
    msgbox(16, "Error", "MTSLauncher was found but didn't start correctly. Please make sure you have Java installed and that it's set to open .jar files.")
    Exit
EndIf

speak("MTS Launcher started, waiting for game to start")
else
speak("ReadTheSpire ready, waiting for you to start the game.")
EndIf

do
sleep(250)
until WinExists("Modded Slay the Spire")
EndIf;Look if the game is open, otherwise launch it.
$STSHandle=WinGetHandle("Modded Slay the Spire")
while WinExists($STSHandle)=1
If $BufferKeysActive=0 and IsInGame() then
$BufferKeysActive=1
RegisterBufferKeys(1)
ElseIf not IsInGame() and $BufferKeysActive=1 then
$BufferKeysActive=0
RegisterBufferKeys(0)
EndIf

for $i=0 to UBound($WindowList)-1 step 1
If $HandleList[$i][0]=0 then
$HandleList[$i][0]=WinGetHandle($WindowList[$i])
;If not @error then speak($WindowList[$i] & " opened.")
EndIf
If $HandleList[$i][0] <>0 then
If $HandleList[$i][1]=0 then $HandleList[$i][1]=ControlGetHandle($HandleList[$i][0], "", "[CLASS:Edit]")
    $text=ControlGetText($HandleList[$i][0], "", $HandleList[$i][1])
If @error then
;speak($WindowList[$i] & " closed.")
$HandleList[$i][0]=0
$HandleList[$i][1]=0
else
If $text <> $OldText[$i] then; speak the new text!
$buffers[$i]=StringSplit($text, @crlf, 3);update the buffers
If $SilentWindowList[$i]=false then
$TextToSpeak=$Text;The RegExp substitutions will happen on this variable instead of the original text as to not break the comparisons.
For $i3=0 to UBound($Substitutions)-1 step 1
$TextToSpeak=StringRegExpReplace($TextToSpeak, $Substitutions[$i3][0], $Substitutions[$i3][1])
If @error then
MsgBox(16, "Regexp Error", "error in expression " & $Substitutions[$i3])
exit
EndIf
;If @extended>0 then MsgBox(0, "matched", "replaced " & $Substitutions[$i3][0] & " with " & $Substitutions[$i3][1] & " text is now " & $TextToSpeak)
next
$SpokeWindowName=0

If $WindowList[$i]="Output" then ;The entire output Window should always be reread since that's generally requested by the player
Speak($textToSpeak)

else ;For other windows, compare the old and newly changed text line by line to only anounce the ones that changed.
$OldArray=StringSplit($OldText[$i], @crlf, 1)
$NewArray=StringSplit($TextToSpeak, @crlf, 1)
For $i2=1 to $NewArray[0] step 1
If $i2<uBound($OldArray) then;line numbers that exist in both strings
If $OldArray[$i2]<>$NewArray[$i2] then 
If $SpokeWindowName=0 then
$NewArray[$i2]=$WindowList[$i] & ": " & $NewArray[$i2]
$SpokeWindowName=1
EndIf
Speak($NewArray[$i2]);Only speak the line if it changed
endIf ;If $OldArray[$i2]<>$NewArray[$i2]
else;The new text has more lines than the old, so just speak all of them
If $SpokeWindowName=0 then
$NewArray[$i2]=$WindowList[$i] & ": " & $NewArray[$i2]
$SpokeWindowName=1
EndIf

Speak($NewArray[$i2])
EndIf
next
EndIf;Output or other windows check
EndIf;Speak if the text was different
EndIf ;Silent window or not checks
$OldText[$i]=$text;Set the old text to the new
EndIf
EndIf

next

sleep(30)
Wend
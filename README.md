# ReadTheSpire

ReadTheSpire is a little program I threw together in an hour that automatically reads changed text from [TextTheSpire](https://github.com/Wensber/TextTheSpire) which is a mod making the SlayTheSpire game playable by blind people using screen readers. It does so by displaying a number of windows all displaying different pieces of information. I found having to Alt+Tab between them to figure out what's going on tedious, which is why this program exists.
## Downloading

You can find the latest release with all required files on the releases tab. If you want to run from source, you will have to supply the DLL for Tolk as well as the DLL's for the screen readers it supports.

## Usage

First, download TextTheSpire from the link above, following its readme to setup everything.

Then, instead of running the MTS-Launcher, start ReadTheSpire. It will look for MTS-Launcher in the most common installation directories for the Steam version of the game for MTS-Launcher.jar and start it for you. If it can't be found, you will be asked to select the folder where you installed the game. This directory will be remembered so you should have to do this only once. You can also run ReadTheSpire after the game is loaded, in which case starting MTS-Launcher will be skipped.

ReadTheSpire will monitor all Windows for changes, and speak the lines that changed using either your screen reader or SAPI if a supported one is not running. In the case of the output window, ReadTheSpire will always read the entire window after it changes.

You can also review all of the windows without having to switch to them. The review keys below will work in the Prompt as well as all other TextTheSpire windows.

- Alt+Down - next line
- Alt+Up - previous line
- Alt+Home - first line
- Alt+End - last line
- Alt+C - copy current line to clipboard
- Alt+Right - next window
- Alt+Left - previous window
- Alt+1-9 - switch to the window with that number

When you're done playing the game, ReadTheSpire will close automatically. If you want to quit it sooner, you can do so by pressing CTRL+Q.

You can also customise which windows get monitored by editing watchlist.txt. The file format is one window title per line. By default, ReadTheSpire monitors the Output, Choices, player, monster and relic windows. You can add or remove them simply by changing this file. You can also add a window to appear as a buffer accessible with the review keys, but not spoken automatically, by putting an asterisk (*) before the window name. The hand and map windows are configured like this by default.

Finally, you can also add text substitutions to change how certain text is spoken or silence it all together. By default, a substitution is included to silence the debug intents for monsters and clean up things like relic and potion displays that don't include a space after the number. 
To do this, edit substitutions.txt. The format for this file is pattern=replacement, where pattern and replacement are regular expressions.

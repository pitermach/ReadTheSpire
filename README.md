# ReadTheSpire

ReadTheSpire is a little program I threw together in an hour that automatically reads changed text from [TextTheSpire](https://github.com/Wensber/TextTheSpire) which is a mod making the SlayTheSpire game playable by blind people using screen readers. It does so by displaying a number of windows all displaying different pieces of information. I found having to Alt+Tab between them to figure out what's going on tedious, which is why this program exists.
## Downloading

You can find the latest release with all required files on the releases tab. If you want to run from source, you will have to supply the DLL for Tolk as well as the DLL's for the screen readers it supports.

## Usage

First, download TextTheSpire from the link above, following its readme to setup everything. Then, either before or after you launch the game, start ReadTheSpire. And that's it! It will monitor most of the more important windows and automatically read any changed lines. Sometimes, this may not give you all of the information, but because there are commands to direct just about every window to output, you should be able to fill in anything missing without too many keystrokes. When you're done playing the game, pressing CTRL+Q will quit ReadTheSpire.


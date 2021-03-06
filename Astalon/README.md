## Astalon Autosplitter
 
Auto Splitter for Astalon  (PC)

- [LiveSplit](http://livesplit.github.io/) - Here you can find out more about and download LiveSplit. It is a popular timer program typically used for speedruns.
- [ASL](https://github.com/LiveSplit/LiveSplit/blob/master/Documentation/Auto-Splitters.md) - Here you can find more information about ASL (basically C#) and autosplitters in general.

## Features

Time is sync'd with ingame timer. This timer automatically removes loads and stops when the final boss is killed.

- Automatically start the timer when you start a run. Timer starts after initial load on a new save file
- Automatically split on a multitude of events - check Settings!
- Automatically reset when you are in the main menu

- By default the script will cause the game to run in the background. This prevents IGT from freezing when focus is lost. It currently does not allow background input, though. This option should be left on.

## Installation 

- Go to "Edit Splits.." in LiveSplit
- Enter the name of the game in "Game Name"
  - This must be entered correctly for LiveSplit to know which script to load
- Click the "Activate" button to download and enable the autosplitter script
  - If you ever want to stop using the autosplitter altogether, just click "Deactivate"

## Manual Installation (skip if you used the 'Activate' Button)

- Download https://raw.githubusercontent.com/Coltaho/Autosplitters/master/Astalon/Astalonautosplit.asl
- Edit Layout
- Add Other /Scriptable Componment / Script Path: Browse to the "Astalonautosplit.asl" file you downloaded previously
- Enable Start/Split feature here
  
## Set-up (if auto-installed)

- Go to "Edit Splits..." in LiveSplit
- Click "Settings" to configure the autosplitter
  - **Note:** If for some reason LiveSplit does not automatically load the script, click "Browse...", navigate to "\LiveSplit\Components\" and select the appropriate script.
- Enable Start/Split feature here
  
Here you can enable/disable the options for auto start and auto splitting.

## Bugs

- Let me know of any bugs

## Thanks

- Thanks to JonLepage a dev for the game who changed some things for better splitting!
- Thanks to [Voxelse](http://twitch.tv/Voxelse) for help with advanced ASL coding practices.

## Contact

If you encounter any issues or have feature requests, please let me know! 

- [Coltaho](http://twitch.tv/Coltaho) or Coltaho#2016 on Discord

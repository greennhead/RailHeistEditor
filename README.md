## A Level Editor for UFO 50's Rail Heist. 
### Made in Godot 4.4
It can generate code that you can put in your rail heist mod, or alternatively you can save a json and play it with the rail heist level loader mod.

I in no way own UFO 50 or any of these assets.

## Controls:
- WASD - Navigation
- Shift (hold) - Faster navigation
- Mouse
- Plus - Zoom in
- Minus - Zoom out

## Usage:

### Of Patch:
- Patch your UFO 50 data.win using XDelta patcher. Rail heist should now have a "custom levels" tab. This will load all levels from AppData/Local/ufo50/RailHeistLevels
### Of Editor:
- Launch RailHeistEditor.exe
- Left click to place tiles, right click to erase them.


## Known jank/bugs:
- Moving your mouse too fast will create gaps in tiles
- Some objects are in wrong places ingame (if found, please report which ones and how far off they are)
- Rarely you can put 2 tiles in one spot which can weird up the level data
- Having both no casualties and all lawmen killed will have a weird string at the end of the level.
- Barebones enough levels can sometimes crash from rail heist not knowing how to put the background tiles
- In the level loader mod selecting custom levels and restarting game will prevent you from loading (as custom levels options disables saving/loading like a cheat code)

## Credits:
- Mossmouth - UFO 50
- Phil - Rail Heist tile sheet

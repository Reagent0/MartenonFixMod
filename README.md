# MartenonFixMod
UE4SS Mod for Clair Obscur: Expedition 33 that fixes both level 4 and 10 passives of the Martenon weapon.  
Currently, level 4 and 10 passives do NOT trigger unless Sciel can play the turn she enters Twilight right after the current turn. This mod fixes that.

## Installation  
This mod is based on the [UE4SS Scripting System](https://github.com/UE4SS-RE/RE-UE4SS), as such, you need to install that first.

#### Installing UE4SS  
Step 1: Download UE4SS ([UE4SS_v3.0.1-599-g1a6cdbc.zip](https://github.com/UE4SS-RE/RE-UE4SS/releases/download/experimental/UE4SS_v3.0.1-599-g1a6cdbc.zip)). Keep in mind the mod was only tested with this specific version of UE4SS (the current experimental-latest at the time of this writing).  
Step 2: Locate the directory containing the E33 **actual** executable, aka the install directory. **IMPORTANT:** The executable you're looking for should be called `SandFall-Win64-Shipping.exe`. If you've installed the game from Steam, the directory should be `C:\Program Files (x86)\Steam\steamapps\common\Expedition 33\Sandfall\Binaries\Win64`.  
Step 3: Once you have located the install directory, extract the contents of the zip you downloaded in Step 1 in there. The install directory should now have a new ue4ss folder and a dwmapi.dll file. If you did everything correctly, good! UE4SS is installed.

#### Installing MartenonFixMod  
For clarity purposes, I'll refer to the path to the directory you located in the previous phase as `InstallDirectory`.  
Step 1: Download the [latest release of MartenonFixMod](https://github.com/Reagent0/MartenonFixMod/releases/latest/download/MartenonFixMod.zip).  
Step 2: Open the zip folder you just downloaded and extract its content (a MartenonFixMod folder) to `InstallDirectory\ue4ss\Mods`.  
Step 3: Open the file `InstallDirectory\ue4ss\Mods\mods.txt` and add in a new line `MartenonFixMod : 1`. This will tell UE4SS to load the mod.

##### All done. If you did everything correctly and UE4SS is injected, a log file should generate in path `InstallDirectory\ue4ss\UE4SS.log` after launching the game. Look for `[Lua] MartenonFixMod loaded!` to ensure the mod is loaded.

### For those who come after.

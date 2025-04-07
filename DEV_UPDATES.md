
# 0.4.0
## UPDATE NOTES:
 * DEV_UPDATES.md added
 * Z axis
   - Z layering
 * Reworked item system
 * General optimization
 * Bug fixes
 * Modified global save state system
 * Remade player physics
   - Remade player collision
     - 2 Collision types
       - Double-Axis Collision
       - Triple-Axis Collision
 * Asset re-orgianization
    - rfl's storing level assets

# 0.4.1
## UPDATE NOTES:
 * added a mods menu to the main menu, accessible in both modded builds, and developer builds.
 * added a new filetype (.RFM) for relocation failed mods.
 * started work on an new API for modding support and how to make mods.
 * fixed a bug where main menu music would restart after exiting either level editor or mod menu.
 * updated TODO.md
 * updated Bugs.md
 * added small framework testing for mods affecting gameplay.
 * added code to create a mods folder when starting the game if the build has mods support and the folder doesnt exist.
 * replaced all uses of FlxSquareButton with normal FlxButton since i made normal buttons square properly.
 * started trying to add startup dialouge to hud, file work in progress.
 * updated grammar on nightmare difficulty text.
 * started trying to fix the game freezing when opening notepad from crash screen

## UPCOMING FEATURES AT TIME OF WRITING:
 ### 0.4.2:
  * Dialogue
  * Working saves
    - Items dissapearing from the level after saving and reloading if you already have them
  * Rework main menu
  * New inventory system
    - Save files expanded
  * Proper pause menu
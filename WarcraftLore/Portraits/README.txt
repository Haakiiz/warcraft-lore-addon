Put your own portrait images here (they are not shipped with the addon).

Format WoW can read:
  - .tga (32-bit, uncompressed) or .blp
  - width and height must be powers of two; 128x128 or 256x256 works well
  - a square image: the addon crops it to a circle

Then add the file name without extension to the NPC's entry in Data.lua:
  portrait = "Thrall",      -- uses Portraits/Thrall.tga

Restart the game (not just /reload) after adding a new file.
Run tests/validate_db.py to check that every portrait file exists.

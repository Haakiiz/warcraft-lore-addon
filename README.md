# Warcraft Lore – an addon for World of Warcraft: Forever (beta)

Ever run into a random level-15 quest giver and later found out they were in a Warcraft II mission? This addon tells you. It flags NPCs who also appear in the real-time strategy games:

- Warcraft: Orcs & Humans
- Warcraft II: Tides of Darkness and Beyond the Dark Portal
- Warcraft III: Reign of Chaos and The Frozen Throne
- Warcraft III Reforged: Forsaken Kingdom

What you get:

- **Tooltip line:** NPCs in the database get one extra line, e.g. "Warcraft Veteran: WC3 · TFT", with each game in its own color. Other NPCs get no line, so ordinary tooltips stay clean.
- **Lore window:** targeting a known NPC opens a small window with a round portrait that glows in the game's color. It shows the games, campaigns, missions, the NPC's role there, a short story of what happened between the RTS games and WoW, related WoW items with item IDs, and sources. You can drag the window, close it with X or Esc, and it remembers where you put it.

All lore ships inside the addon (addons cannot reach the internet in game), in `WarcraftLore/Data.lua`.

## Installation

1. Find your WoW Forever beta folder. According to [wowforeverguides.com](https://wowforeverguides.com/addons/developers), beta addons live in
   `World of Warcraft\_classic_beta_\Interface\AddOns\`
   Create `Interface\AddOns` if it does not exist.
2. Copy the whole `WarcraftLore` folder (the one containing `WarcraftLore.toc`) there, so that you get
   `...\_classic_beta_\Interface\AddOns\WarcraftLore\WarcraftLore.toc`
3. Start the game. New files such as textures need a full restart, not just `/reload`. Make sure "Warcraft Lore" is ticked in the AddOns list on the character screen.

The client is interface 16001 (build 1.60.1). It is built on the modern Mainline/Midnight API, not the Classic API.

## Commands

| Command | What it does |
|---|---|
| `/wcl` | Opens the window for your target. NPCs not in the database show "No known Warcraft history recorded for … (NPC ID …) yet." |
| `/wcl id` | Prints your target's NPC ID and name in chat, and whether it is in the database |
| `/wcl auto` | Turns auto-open on target on or off |
| `/wcl reset` | Moves the window back to the center |
| `/wcl debug` | Shows build, interface and which APIs the client has |

## Test NPCs

Coordinates come from Wowhead Classic. Forever may have moved NPCs or changed IDs, so run `/wcl id` on each one.
FK = Warcraft III Reforged: Forsaken Kingdom. "Reforged only" means Reforged added the character to an old mission.

| NPC | NPC ID | Zone | Coords | Games |
|---|---|---|---|---|
| Grunt Maug | 15460 | Orgrimmar | 31.0, 65.2 | TFT |
| Nazgrel | 3230 | Orgrimmar | 32.4, 36.0 | TFT |
| Thrall | 4949 | Orgrimmar | 32.0, 37.8 | WC3, TFT |
| Vol'jin | 10540 | Orgrimmar | 34.2, 36.4 | TFT |
| Gar'Thok | 3139 | Durotar | 52.0, 43.4 | TFT |
| Apothecary Helbrim | 3390 | The Barrens | 51.4, 30.2 | TFT, *uncertain* |
| Gazlowe | 3391 | The Barrens | 62.6, 36.2 | TFT |
| Baine Bloodhoof | 2993 | Mulgore | 47.4, 60.2 | TFT |
| Cairne Bloodhoof | 3057 | Thunder Bluff | 59.4, 51.4 | WC3, TFT |
| Misha | 10204 | Stonetalon Mountains | 30.2, 76.0 | TFT |
| Rexxar | 10182 | Stonetalon Mountains | 30.2, 76.0 | TFT |
| Witch Doctor Jin'Zil | 3995 | Stonetalon Mountains | 74.4, 97.8 | TFT, *uncertain* |
| Athrikus Narassin | 3660 | Darkshore | 56.0, 26.0 | TFT |
| Shandris Feathermoon | 3936 | Feralas | 30.2, 46.0 | WC3 |
| Archmage Tervosh | 4967 | Dustwallow Marsh | 66.4, 49.2 | WC3, *uncertain* |
| Brother Karman | 8140 | Dustwallow Marsh | 67.4, 47.4 | WC3, *uncertain* |
| Do'gol | 5087 | Dustwallow Marsh | 36.4, 30.8 | TFT |
| Draz'Zilb | 4501 | Dustwallow Marsh | 37.0, 33.0 | TFT |
| Lady Jaina Proudmoore | 4968 | Dustwallow Marsh | 66.2, 49.0 | WC3, TFT |
| Ogg'marr | 4879 | Dustwallow Marsh | 36.6, 31.0 | TFT |
| Tharg | 4502 | Dustwallow Marsh | 37.2, 31.4 | TFT |
| Torq Ironblast | 4889 | Dustwallow Marsh | 67.4, 48.0 | WC3, *uncertain* |
| Apothecary Keever | 5734 | Undercity | 52.6, 73.4 | FK |
| Lady Sylvanas Windrunner | 10181 | Undercity | 57.8, 91.4 | WC3, TFT, FK |
| Lexington Mortaim | 2492 | Undercity | 84.2, 16.0 | FK, *uncertain* |
| Sharlindra | 2227 | Undercity | 57.4, 93.4 | TFT |
| Varimathras | 2425 | Undercity | 56.4, 92.4 | TFT, FK |
| Gordo | 10666 | Tirisfal Glades | 39.8, 51.2 | FK |
| Dalar Dawnweaver | 1938 | Silverpine Forest | 44.2, 39.8 | WC3, *uncertain* |
| Snarlmane | 1948 | Silverpine Forest | 65.2, 24.0 | TFT, *uncertain* |
| Archmage Ansirem Runeweaver | 2543 | Alterac Mountains | 18.8, 78.4 | WC3, *uncertain* |
| Mug'thol | 2257 | Alterac Mountains | 35.2, 54.0 | TFT |
| Araj the Summoner | 1852 | Western Plaguelands | 45.4, 69.2 | WC3, *uncertain* |
| Gregory | 231500 | Western Plaguelands | 69.4, 79.6 | WC3 |
| Gregory | 232932 | Western Plaguelands | 39.4, 67.2 | WC3 |
| Uther | 232920 | Western Plaguelands | 47.0, 69.4 | WC2, WC3 |

Uncertain links show "Warcraft Veteran?" in the tooltip. Some Western Plaguelands NPCs use Season of Discovery NPC IDs and may not exist in Forever.

**Negative check:** hover over an Orgrimmar Grunt. The tooltip should get no extra line, and `/wcl` should show the "No known Warcraft history" text.

## Adding an NPC yourself

1. **Find the NPC ID.** Target the NPC in game and type `/wcl id`. Chat shows the name and NPC ID, and whether it is already in the database.
2. **Check that it is the same character.** Many NPCs share a name with an RTS character without being the same person. Look the NPC up on [warcraft.wiki.gg](https://warcraft.wiki.gg) and only add it if a source says the WoW NPC and the RTS character are the same. If the wiki only speculates, add it with `confidence = "uncertain"` and write where you looked in `searched`.
3. **Add an entry** to `WarcraftLore/Data.lua`, inside `ns.NPCS = { … }`, under the right zone heading:

   ```lua
   [3391] = {
       name = "Gazlowe",
       zone = "The Barrens",
       coords = "62.6, 36.2",
       appearances = {
           {
               game = "TFT",                -- WC1, WC2, BTDP, WC3, TFT or FK
               campaign = "The Founding of Durotar (Orc bonus campaign)",
               missions = { "To Tame a Land" },
               role = "Quest giver (Engineer)",
           },
       },
       story = "Three to six sentences on what happened between the RTS game and WoW.",
       items = {
           { id = 5080, name = "Gazlowe's Ledger", note = "Quest item in \"The Missing Shipment\"" },
       },
       sources = { "https://warcraft.wiki.gg/wiki/Monte_Gazlowe" },
       confidence = "confirmed",    -- or "uncertain" (then also add searched = "…")
   },
   ```

   Every field is described at the top of `Data.lua`. Never guess mission names, item IDs or NPC IDs. If you don't know something, leave it empty (`""` or `{}`).
4. **Run the test script** (below). It catches typos in field names, wrong game codes, duplicate NPC IDs, bad links and stories that are not 3–6 sentences.
5. **Restart the game** or type `/reload`, then target the NPC.

### Your own portraits

The round frame shows the NPC's normal WoW portrait. For the RTS-era portrait, put a 128×128 `.tga` file in `WarcraftLore/Portraits/` and add `portrait = "FileName"` to the entry. See `WarcraftLore/Portraits/README.txt`. Portrait images are not shipped with the addon.

## Test script (outside the game)

```bash
python tests/validate_db.py
```

The script checks that every entry in `WarcraftLore/Data.lua` has valid fields and values, that no NPC ID appears twice, and that every portrait file exists. It needs Python 3 but no Lua interpreter.
`tests/fixtures/bad_data.lua` is broken on purpose, so you can see the test fail:

```bash
python tests/validate_db.py tests/fixtures/bad_data.lua
```

## Files

- `WarcraftLore/Compat.lua`: **every client-version-dependent API call**. Fix this file if a beta patch breaks something.
- `WarcraftLore/Data.lua`: the database. The format is described at the top of the file.
- `WarcraftLore/Core.lua`: lookup, tooltip line, events and `/wcl`.
- `WarcraftLore/UI.lua`: the window.
- `WarcraftLore/Textures/`: frame, vines and rings. Regenerate them with `python tools/make_textures.py` (needs Pillow).
- `WarcraftLore/Portraits/`: your own portrait images (optional).

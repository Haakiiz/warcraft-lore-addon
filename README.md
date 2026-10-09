# Warcraft Lore – an addon for World of Warcraft: Forever (beta)

Ever run into a random level-15 quest giver and later found out they were in a Warcraft II mission? This addon tells you. It flags NPCs who also appear in the real-time strategy games:

- Warcraft: Orcs & Humans
- Warcraft II: Tides of Darkness and Beyond the Dark Portal
- Warcraft III: Reign of Chaos and The Frozen Throne
- Warcraft III Reforged: Forsaken Kingdom
- Warcraft novels and books (labelled "Book", never presented as a game appearance)

What you get:

- **Tooltip line:** NPCs in the database get one extra line, e.g. "Warcraft Veteran: WC3 · TFT", with each game in its own color. Other NPCs get no line, so ordinary tooltips stay clean.
- **Lore window:** `/wcl` (or clicking the alert pill, a row in the list, or the minimap button's right-click) opens a small window with a round portrait that glows in the game's color. It shows the games, campaigns, missions, the NPC's role there, a short story of what happened between the RTS games and WoW, related WoW items with item IDs, and sources. You can drag the window, close it with X or Esc, and it remembers where you put it.
- **Veterans list and met counter:** `/wcl list` (or a left-click on the minimap button) opens a browse window with every veteran in the database. The addon remembers, per character, which veterans you have met (targeted or moused over), shows "Veterans met 13 of 127" with a progress bar and a chip per game ("WC3 3/15"), and prints a chat line the first time you meet one. Search by name, filter by game, zone, campaign or met status, and tick "Hide book-only" to leave out NPCs who only appear in novels. Hover a row for the full name, zone and games; click it to open the lore window next to the list. The lore window shows a green MET badge for veterans you have met.
- **Small glowing alert:** when you target a veteran, or one is close by (nameplate or map position), a small pill with a portrait, the name and the game codes pulses at the top of the screen. Nearby alerts also print one chat line and play a sound. Click the pill for the story, right-click to dismiss, shift-drag to move.
- **Minimap button:** left-click opens the Veterans list, right-click opens the story of your target, drag moves it around the minimap. Hover it to see your met count.

All lore ships inside the addon (addons cannot reach the internet in game), in `WarcraftLore/Data.lua`.

## Screenshots

Preview renders of the real addon code (made offline with substitute fonts and a placeholder portrait, so the in-game look differs slightly):

![The Veterans list and the lore window docked side by side](media/screenshots/veterans-and-lore.png)

| | |
|---|---|
| ![Hover a row for the full name, games and met status](media/screenshots/veterans-tooltip.png) | ![Filter by campaign](media/screenshots/campaign-filter.png) |
| Hover a row for the full name, games and met status | Filter by campaign, zone, game or met status |
| ![Small glowing alert when a veteran is nearby](media/screenshots/nearby-alert.png) | ![Minimap button with tooltip](media/screenshots/minimap-button.png) |
| A small glowing alert when a veteran is nearby; click it for the story | Minimap button: left-click for the list, right-click for your target |

## What's new in 0.3

- New: the Warcraft Veterans list (`/wcl list`) with search, filters for game, zone, campaign and met status, "Hide book-only", hover tooltips with full names, and the lore window docking next to it.
- New: met tracking per character, with a "Veterans met" counter, a chip per game and a chat line the first time you meet a veteran. The lore window shows a green MET badge.
- New: the small glowing alert pill replaces the big toast and the center-screen text. Targeting a veteran now shows the pill instead of opening the window.
- New: a minimap button and `/wcl minimap`.

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
| `/wcl list` (or `/wcl browse`) | Opens or closes the Warcraft Veterans window: every veteran with a met marker, a counter per game, name search, zone, campaign and met filters, and a "Hide book-only" switch (saved). Click a game chip to filter by that game, hover a row for full names, click a row to read the story |
| `/wcl minimap` | Shows or hides the minimap button |
| `/wcl id` | Prints your target's NPC ID and name in chat, and whether it is in the database |
| `/wcl auto` | Turns the small alert when you target a veteran on or off (if the lore window is already open, it just follows your target) |
| `/wcl alert` | Turns the "veteran nearby" alert (pill, chat line, sound) on or off. It fires once per NPC per session when the NPC's nameplate appears, or when you come within a few percent of the NPC's known map coordinates (not in instances). Nameplate alerts need friendly NPC nameplates enabled; the coordinate alert works without them |
| `/wcl test` (or `/wcl alert test`) | Shows a test alert for the database NPC with the lowest ID: the small pill, chat line and sound. Click the pill to open the NPC's window, right-click to dismiss, shift-drag to move |
| `/wcl reset` | Moves the windows back to the center |
| `/wcl debug` | Shows build, interface and which APIs the client has |

## Test NPCs

Coordinates come from Wowhead Classic. Forever may have moved NPCs or changed IDs, so run `/wcl id` on each one.
FK = Warcraft III Reforged: Forsaken Kingdom. "Reforged only" means Reforged added the character to an old mission.

| NPC | NPC ID | Zone | Coords | Games |
|---|---|---|---|---|
| Grunt Maug | 15460 | Orgrimmar | 31.0, 65.2 | TFT |
| Nazgrel | 3230 | Orgrimmar | 32.4, 36.0 | TFT, BOOK |
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
| Arch Druid Fandral Staghelm | 3516 | Darnassus | 34.4, 8.4 | BOOK |
| Tyrande Whisperwind | 7999 | Darnassus | 38.4, 80.6 | WC3, TFT, BOOK |
| Athrikus Narassin | 3660 | Darkshore | 56.0, 26.0 | TFT |
| Shandris Feathermoon | 3936 | Feralas | 30.2, 46.0 | WC3 |
| Archmage Tervosh | 4967 | Dustwallow Marsh | 66.4, 49.2 | WC3, *uncertain* |
| Brother Karman | 8140 | Dustwallow Marsh | 67.4, 47.4 | WC3, *uncertain* |
| Do'gol | 5087 | Dustwallow Marsh | 36.4, 30.8 | TFT |
| Draz'Zilb | 4501 | Dustwallow Marsh | 37.0, 33.0 | TFT |
| Lady Jaina Proudmoore | 4968 | Dustwallow Marsh | 66.2, 49.0 | WC3, TFT |
| Ogg'marr | 4879 | Dustwallow Marsh | 36.6, 31.0 | TFT |
| Overlord Mok'Morokk | 4500 | Dustwallow Marsh | 36.2, 31.4 | BOOK |
| Pained | 4965 | Dustwallow Marsh | 66.2, 49.0 | BOOK |
| Tharg | 4502 | Dustwallow Marsh | 37.2, 31.4 | TFT |
| Torq Ironblast | 4889 | Dustwallow Marsh | 67.4, 48.0 | WC3, *uncertain* |
| Marshal Redpath | 2263 | Hillsbrad Foothills | 49.6, 58.6 | BOOK |
| Apothecary Keever | 5734 | Undercity | 52.6, 73.4 | FK |
| Lady Sylvanas Windrunner | 10181 | Undercity | 57.8, 91.4 | WC3, TFT, FK |
| Lexington Mortaim | 2492 | Undercity | 84.2, 16.0 | FK, *uncertain* |
| Sharlindra | 2227 | Undercity | 57.4, 93.4 | TFT |
| Varimathras | 2425 | Undercity | 56.4, 92.4 | TFT, FK |
| Gordo | 10666 | Tirisfal Glades | 39.8, 51.2 | FK |
| Dalar Dawnweaver | 1938 | Silverpine Forest | 44.2, 39.8 | WC3, *uncertain* |
| Snarlmane | 1948 | Silverpine Forest | 65.2, 24.0 | TFT, *uncertain* |
| Archmage Ansirem Runeweaver | 2543 | Alterac Mountains | 18.8, 78.4 | WC3, *uncertain* |
| Lord Aliden Perenolde | 2423 | Alterac Mountains | 39.4, 15.2 | BOOK |
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
- `WarcraftLore/Toast.lua`: the small glowing alert pills.
- `WarcraftLore/Minimap.lua`: the minimap button.
- `WarcraftLore/Core.lua`: lookup, tooltip line, events and `/wcl`.
- `WarcraftLore/Style.lua`: the palette, small widget builders and the vine frame shared by both windows.
- `WarcraftLore/UI.lua`: the lore window.
- `WarcraftLore/Browser.lua`: the veterans list window (`/wcl list`).
- `WarcraftLore/Textures/`: frame, vines and rings. Regenerate them with `python tools/make_textures.py` (needs Pillow).
- `WarcraftLore/Portraits/`: your own portrait images (optional).

## Releasing to CurseForge

Releases are built by [BigWigs Packager](https://github.com/BigWigsMods/packager) in GitHub Actions (`.github/workflows/release.yml`). Interface 16001 maps to the "Forever" game type on CurseForge.

One-time setup:

1. Create the project on [CurseForge](https://authors.curseforge.com) (game: World of Warcraft) and wait for moderation approval.
2. Add `## X-Curse-Project-ID: <id>` to `WarcraftLore/WarcraftLore.toc` (the ID is under "About Project" on the project page).
3. Create an API token at <https://legacy.curseforge.com/account/api-tokens> and add it as the repository secret `CF_API_KEY`.

To release, tag and push: `git tag v0.1.0 && git push origin v0.1.0`. The tag becomes the version in the TOC. Tags with `alpha` or `beta` in the name are uploaded as alpha or beta files.

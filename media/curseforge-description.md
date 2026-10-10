Ever run into a random level-15 quest giver and later found out they were in a Warcraft II mission? This addon tells you.

It flags NPCs who also appear in the real-time strategy games:

- Warcraft: Orcs & Humans
- Warcraft II: Tides of Darkness and Beyond the Dark Portal
- Warcraft III: Reign of Chaos and The Frozen Throne
- Warcraft III Reforged: Forsaken Kingdom
- Warcraft novels and books (labelled "Book", never presented as a game appearance)

Every veteran is checked against a source: 112 confirmed so far, with more as new zones open.

## What you get

- **Tooltip line:** NPCs in the database get one extra line, e.g. "Warcraft Veteran: WC3 · TFT", with each game in its own color. Other NPCs get no line, so ordinary tooltips stay clean.
- **Lore window:** `/wcl` (or clicking the alert pill, a row in the list, or the minimap button's right-click) opens a small window with a round portrait that glows in the game's color. It shows the games, campaigns, missions, the NPC's role there, a short story of what happened between the RTS games and WoW, related WoW items, and sources. A "Related" section links family, allies and rivals: click a name to follow the thread from Thrall to Cairne to Baine.
- **Veterans list:** `/wcl list` (or the minimap button) shows every veteran in the database. Search by name or zone, filter by game, zone, campaign or met status, hide NPCs who only appear in books, hover a row for full names, and click one to read their story.
- **Met counter:** the addon remembers which veterans you have met on each character: "Veterans met 13 of 112" with a progress bar and a chip per game. Target or mouse over a veteran to tick them off; the lore window shows a green MET badge.
- **Small glowing alert:** a small pill with a portrait, the name and game codes when you target a veteran or one is close by. Nearby alerts also print a chat line and play a sound. Click for the story, right-click to dismiss.
- **Minimap button:** left-click for the Veterans list, right-click for the story of your target, drag to move.

## Commands

- `/wcl` – open the window for your target
- `/wcl list` – browse all veterans, with search, filters and your met counter
- `/wcl id` – print your target's NPC ID
- `/wcl auto` – toggle the small alert when you target a veteran
- `/wcl minimap` – show or hide the minimap button
- `/wcl alert` – toggle the "veteran nearby" alert
- `/wcl test` – show a test alert for the lowest-ID veteran
- `/wcl reset` – move the windows back to the center
- `/wcl debug` – show which APIs the client has

Built for WoW: Forever (interface 16001). All lore ships inside the addon.

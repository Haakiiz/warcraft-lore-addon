# Warcraft Lore – changelog

## v0.8.0

- **New look: Warcraft II.** Every window now looks like a remaster of the Warcraft II menus: a stone
  frame, cracked leather, dark inset panels, red buttons and gold text. This is the new standard look.
- **Prefer the old look?** Click the **Classic** button next to the close X in any window, use the
  button in the settings, or type `/wcl theme`. You get a short confirmation, and the interface
  reloads with the violet "classic" look. The same button (**WC2**) switches back. Your choice is
  saved for the whole account.
- `/wcl theme classic` and `/wcl theme wc2` pick a look directly.

## v0.7.0

- **Memorials:** tombs, plaques and monuments for Warcraft heroes you can't meet in person – Uther's Tomb, the plaques in Stormwind's Valley of Heroes, Trollbane's Tomb, Grom Hellscream's monument and more. Hover or read them to tick them off.
  Open them from the new Memorials button in the Veterans list or on the world map (stone-colored square pins).
  Two new achievements, "Pay Your Respects" and "Heroes of the Second War", have their own Memorials chip in the Journal.
- **Lore Journal with achievements:** 41 achievements made from the addon's own data – milestones
  (1 to 100 veterans), one per Warcraft game (with extra steps for the novels and books), one per zone,
  one "Circle" per well-connected character, two for the memorials and "Across the Ages". 31 can be earned now; the rest
  (the ones that need zones above level 30) are marked "later" and open up when the level cap rises.
  Achievements are stored for the whole account.
- **Open it your way:** `/wcl journal`, the new Journal button in the Veterans list, or Shift-click
  on the minimap button. Filter by category, see progress bars and the date you earned each one.
- **Achievement banner:** a small gold banner when you earn one, with one chat line and one sound (no
  sound when alerts are off). Left-click opens the Journal, right-click closes it. It stays on screen.
- **Existing players** get the achievements they already deserve silently on first login, with one line
  pointing to `/wcl journal`.
- **German and French interface.** The stories, names and zones stay in English. Dates show the month
  in your language.
- **"This zone"** now also works in German and French clients.
- `/wcl reset` also resets the Journal window.

## v0.6.1

- Lore fixes: corrected roles and stories for 15 of the new veterans and removed 3 whose link to the books could not be confirmed (130 confirmed veterans).

## v0.6.0

- **33 new veterans** in Tanaris, Winterspring, Moonglade, Felwood, Eastern Plaguelands, The Hinterlands,
  Arathi Highlands, Stranglethorn Vale, Zul'Farrak, the Sunken Temple and the Temple of Ahn'Qiraj –
  among them Tirion Fordring, Nathanos Blightcaller, Falstad Wildhammer and Keeper Remulos. 133 in total.
- **Veterans on the world map:** small pins show where veterans stand, green once you've met them.
  Hover for details, click for the story. Can be turned off in the settings.
- **Zone atlas:** the zone picker in the Veterans list shows how many you've met in each zone, and
  "This zone" jumps to where you are.
- **Polish:** empty "Items" sections are gone, book rows highlight on hover, and clicks can never throw errors.
- **Export and import:** `/wcl export` shows your met list as a short text you can copy, and `/wcl import` merges such a text into this account. The earliest first meeting and the higher count are kept, and nothing is ever deleted.

## v0.5.0

- **Live 3D portraits:** the lore window shows the veteran as they look in WoW today, framed inside the
  round ring. If the model can't load, you get the classic portrait instead.
- **Story first, then "Through the ages":** the story now opens the window. Below it, every game
  appearance in release order with its year and role, and the books as compact one-line rows.
- **Met counter for your whole account:** a veteran you meet on one character counts on all of them.
  Your existing progress from every character is merged automatically. Hover a met veteran to see how
  often you met them, and when and with which character you met them first.
- **Calmer alerts in cities:** the first veteran is announced right away; anyone else nearby is named in
  one follow-up line ("Also nearby: …") without extra sounds. Click the pill for the story, or "+N more" for the veterans in this zone.
- **Settings page:** find Warcraft Lore in the game's AddOns settings, or type `/wcl options`.
- **`/wcl why`:** explains in plain words why your target is or isn't recognised.
- **Safer after game patches:** if a patch changes something the addon relies on, only that feature
  switches off, with one chat line, instead of throwing errors.
- **Cleaner lore:** every entry was reviewed. Roles and stories read as proper text, and characters you
  can't actually meet in this version of the game were removed. 100 confirmed veterans and 42 related links.

## v0.4.0

- **Related veterans:** the lore window has a new "Related" section. Click a name to follow the thread,
  e.g. Thrall → Cairne Bloodhoof → Baine, or Tyrande → Shandris Feathermoon. 13 links so far
  (family, allies and rivals), with more to come as zones are added.
- **Search by name or zone:** the search box in the Veterans list now also matches zones, and ignores
  apostrophes, dashes and spaces ("mugthol" finds Mug'thol, "needles" finds everyone in Thousand Needles).
- **Only confirmed veterans:** 16 entries whose link to the RTS games or books could not be confirmed
  have been removed. The list now holds 112 veterans you can trust.
- Your saved settings and met list now carry a version number, so future updates can change how
  data is stored without losing anything. Nothing to do on your side.

## v0.3.0

- **Veterans list** (`/wcl list`): every veteran in the database, with search, filters for game, zone,
  campaign and met status, and an option to hide NPCs who only appear in books.
- **Met counter:** target or mouse over a veteran to tick them off ("Veterans met 13 of 127"),
  with a green MET badge in the lore window. Tracked per character.
- **Glowing alert:** a small pill with portrait, name and games when you target a veteran or one is
  nearby. Click it for the story.
- **Minimap button:** left-click for the Veterans list, right-click for your target's story, drag to move.
  `/wcl minimap` shows or hides it.

## v0.2.0

- 21 new veterans and 28 new book appearances across 24 zones and dungeons up to level 30.

## v0.1.0

- First release: tooltip line for NPCs from the Warcraft RTS games and books, lore window (`/wcl`),
  nearby alert and `/wcl test`.

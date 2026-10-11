# Warcraft Lore – changelog

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

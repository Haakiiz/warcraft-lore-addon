# Group C verdict (critic)

Group C: Undercity 1497, Tirisfal Glades 85, Silverpine Forest 130, Shadowfang Keep 209, Scarlet Monastery 796.

## Entries in C.lua

- FIX 3887 Baron Silverlaine (Shadowfang Keep, Arthas: Rise of the Lich King, Mentioned). Identity holds. Wowhead 3887 is 'Baron Silverlaine' in Shadowfang Keep (location 209, Classic). The Arthas Characters table (Mentioned column) links the retail-era article 'Baron Silverlaine'. The Classic article 'Baron Silverlaine (Classic)' has a 'For the retail version' hatnote to it, so the wiki treats them as one character. Changed: added the Classic wiki page to sources and made the 'searched' text state this chain and that the novel text in the cache has no passage with him. Still uncertain. No coordinates on Wowhead, so coords stay "".
- FIX 242499 Highlord Mograine (Scarlet Monastery, We Ride Forth, Mentioned). Checked and not a duplicate: Data.lua has no other Highlord Mograine entry. Scarlet Commander Mograine (3976) is Renault, a separate NPC; his story correctly says Renault killed Alexandros. Wowhead 242499 is 'Highlord Mograine', Classic, location Scarlet Monastery (796). The Alexandros Mograine article's Classic section (Corrupted Ashbringer Scarlet Monastery event, Npclocations Crusader's Chapel, Scarlet Monastery Cathedral) identifies that Classic Highlord as Alexandros. We Ride Forth is a Blizzard short story (Robert Brooks, 2020), and its Characters table lists Alexandros under Mentioned. Changed: 'searched' text now gives this evidence. The article does not cite 242499 by ID, so it stays uncertain. Story "" is allowed. Items empty.

Coordinates: Wowhead g_mapperData is absent for 242499, 3887 and 3976, so "" is correct for both.

## REJECT spot checks (brief item 7)

- High Inquisitor Fairbanks (4542): REJECT stands. The wiki page's only book material is the comic section (World of Warcraft: Ashbringer). Comics are excluded. The Classic event is not a book.
- Arcanist Doan (6487): REJECT stands. Only the comic (Ashbringer) and a Knights of the Silver Hand RPG reference.
- Thule Ravenclaw (1947, open question 4 in the report): REJECT stands. The wiki page cites no novel or short story (only 'Return the Book' via a Kirin Tor ref, not a Blizzard novel appearance). The cached book pages contain him only in the Scourge faction page.
- Also checked: Commander Springvale (4278): no book material on the wiki page. REJECT stands.

No REJECT was changed to ACCEPT.

## Additions to existing entries (report 'Additions' list)

Checked against each book's Characters section (cached wiki text, column = header of the table cell group). Only books that are real Blizzard novels, novellas or short stories count. Format is taken from each book's bookbox or intro.

Lady Sylvanas Windrunner (10181):
- A Good War: CONFIRMED, Major. Novella by Robert Brooks (2018).
- Elegy: CONFIRMED, Mentioned. Novella by Christie Golden (2018).
- Before the Storm: CONFIRMED, Major (table column 'Main'). Novel by Christie Golden (2018).
- Beyond the Dark Portal: CONFIRMED, Mentioned. Novel by Aaron Rosenberg and Christie Golden (2008). Role taken from the 7th data cell of a table with colspan headers; the column count is the only basis, so the role is less certain.
- Blood Ties: CONFIRMED, Mentioned. Novel by Christie Golden (released 18 Nov 2025).
- Blood of the Highborne: CONFIRMED, Minor. Novella by Micky Neilson (digital release 2014, World of Warcraft: Paragons).
- In the Shadow of the Sun: CONFIRMED, Supporting. Short story by Sarah Pine (official 2012).
- A Thousand Years of War: REJECT as a BOOK appearance. It is an audio drama (Robert Brooks, 2017), not a novel, novella or short story. The brief's rule excludes it.

Varimathras (2425):
- Before the Storm: CONFIRMED, Mentioned (second table, 'Mentioned' column). Novel by Christie Golden (2018).

Archmage Arugal (4275):
- In the Shadow of the Sun: CONFIRMED, Mentioned. Short story by Sarah Pine (2012).
- Wolfheart: CONFIRMED, Mentioned. Novel by Richard A. Knaak (2011).

Not added to Data.lua by me: the existing entries are not part of group C. Orchestrator decides.

## Summary

- C.lua: 2 entries, 2 FIX, 0 PASS as written, 0 REJECT. C_checked.lua contains both.
- Extra: 0 duplicates found for Mograine. 3 rejects spot-checked, 0 changed.
- Book additions: 8 Sylvanas hits claimed, 7 CONFIRMED, 1 REJECTED (A Thousand Years of War, audio drama). Varimathras 1 CONFIRMED. Arugal 2 CONFIRMED. Total 10 CONFIRMED with roles above.

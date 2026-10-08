# Critic brief: verify proposed Warcraft Lore entries

Work dir: C:\Users\HKON~1\AppData\Local\Temp\claude\C--Users-H-kon-PycharmProjects-WoW-WC-Addon\0c11506a-9505-4172-81c5-170b49e06496\scratchpad\haiku
Repo (READ ONLY): C:\Users\Håkon\PycharmProjects\WoW-WC-Addon — see WarcraftLore/Data.lua (format + approved examples) and .kritikk/referanse/malestokk.md (quality bar, Norwegian).

You are a strict, independent checker. Another worker wrote the entries you get. Assume nothing is right until you have seen it in a source.

For EACH entry, fetch the sources yourself (warcraft.wiki.gg raw wikitext: `https://warcraft.wiki.gg/index.php?title=<Page>&action=raw`,
wait ≥0.8 s between wiki requests; Python is `py -3 -I` with urllib and a User-Agent header) and check:
1. Identity: the source says the WoW NPC (this NPC ID / this name and location) is the same person as the book/RTS character.
2. game code + campaign: BOOK only for novels/novellas/short stories by Blizzard; real RTS games use WC1/WC2/BTDP/WC3/TFT/FK with exact mission page names.
   A guide (Exploring Azeroth etc.), comic, or a canceled game is NOT enough.
3. role: matches what the source says (chapter numbers if given).
4. story: every sentence is in the sources. Story must not present events from after Classic (Cataclysm, Legion, BfA…) as WoW history;
   such events are allowed only when they are clearly the book's plot. Cut unsupported or off-topic sentences.
5. NPC ID and coords: the ID exists on https://www.wowhead.com/classic/npc=<id> with that name and zone (coords within ~1 of g_mapperData).
6. items: empty unless a real, linked item.

Output (in the work dir):
- `<group>_verdict.md`: one line per entry: `PASS`, `FIX` (what you changed and why) or `REJECT` (why), then a short summary with counts.
- `<group>_checked.lua`: the PASS and FIXED entries only, final text, exact Data.lua syntax.
Final reply: 3 lines max (counts + file names).

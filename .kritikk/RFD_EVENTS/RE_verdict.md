# RE verdict (Razorfen Downs + classic world events)

| ID | Name | Verdict |
|---|---|---|
| 7358 | Amnennar the Coldbringer | REJECT. Traveler: The Spiral Path has him only in the Characters table ("the undead Blackthorn plans to summon through Drella's sacrifice") and in the ch. 19 plot line ("whose plan is to sacrifice Drella to Amnennar"). He never appears or acts (trivia even notes no phylactery was mentioned). Name only = rejected by the v4 rule. Charlga (4421) is different: the book states what she did. No RTS unit either (the Hyjal line is WoW Adventure Guide text). |
| 15077 | Riggle Bassbait | PASS with FIX: dropped the "(short story)" role tag (v4 rule); softened "appears only during" to "appears for the weekly ... held on Sunday afternoons" (the event page says turn-in NPCs stay until 5 pm, so "only" was too strong); removed the clock times. Story sentences traced to the short-story text and the event page. Coords 27.4, 76.8 = Wowhead Classic g_mapperData (uiMapId 1434). |
| 2496 | Baron Revilgaz | PASS with FIX: story dropped "After the Third War" (not in the story text); role without "(short story)". Coords 27.2, 76.8 = Wowhead Classic. Not yet in Data.lua (grep confirmed). Quest for Pandaria lists "Revilgaz" in a table only, not used. |

Short story status: "Stranglethorn Fishing Extravaganza (short story)" is official Blizzard fiction (copy of "Stranglethorn Fishing Extravaganza Preview" from worldofwarcraft.com/info/underdev), not a comic. Honest caveat: it was published as a web "preview" article, but it is narrative prose, categorised as Short stories, and Revilgaz, Seahorn and Riggle all speak and act in it. Accepted as BOOK on the same footing as official-site short stories like The War of the Shifting Sands. If you want strictly archive-published stories only, drop 15077, 2496 and the Seahorn addition.

Event timing: Riggle's story says when he appears (weekly Fishing Extravaganza, Sunday afternoons). No other event NPC has a book/RTS tie.

## Additions to existing entries (verified)

### 3516 Arch Druid Fandral Staghelm: PASS with FIX
Source: "The War of the Shifting Sands" (short story by Micky Neilson, official site, Nov 2005; a real short story). Verified: "Fandral Staghelm led the charge, his son Valstann at his side"; the Qiraji general pulls Valstann apart while Fandral "could not reach" him; Fandral and Anachronos create the barrier at the gates of Ahn'Qiraj. Fixes: removed "(short story)" tag, added the sealing. Story: existing 5 sentences + 1 = 6 (max OK). Pre-Classic events.

Add to appearances (after the Stormrage block):
```
            {
                game = "BOOK",
                campaign = "The War of the Shifting Sands",
                missions = {},
                role = "Leads the night elf armies against the qiraji in Silithus, cannot reach his son Valstann before the Qiraji general kills him, and later helps the bronze dragon Anachronos seal the gates of Ahn'Qiraj",
            },
```
Story: replace the last line of the existing story with these two lines:
```
             .. "In World of Warcraft he leads the Cenarion Circle from the Cenarion Enclave in Darnassus. "
             .. "In the short story The War of the Shifting Sands, he leads the night elves against the qiraji in Silithus, sees his son Valstann killed by the Qiraji general, and then helps the dragons seal Ahn'Qiraj behind a magical barrier.",
```
Add to sources: `"https://warcraft.wiki.gg/wiki/The_War_of_the_Shifting_Sands_(short_story)",`

### 2487 Fleet Master Seahorn: PASS with FIX
Verified: "'There's some nutty goblin rowing into the harbor,' Seahorn rumbled. 'He's shouting your name over and over.'" Role tag "(short story)" removed.

Add to appearances:
```
            {
                game = "BOOK",
                campaign = "Stranglethorn Fishing Extravaganza",
                missions = {},
                role = "Warns Baron Revilgaz that a goblin is rowing into the harbor shouting his name, which brings Riggle Bassbait to the Baron",
            },
```
Story (now 3 sentences, becomes 4): the last existing line ends with `Adashe Flintwill.",`; change it to end `Adashe Flintwill. "` and add:
```
             .. "In the short story Stranglethorn Fishing Extravaganza, he warns Baron Revilgaz that a goblin is rowing into the harbor shouting his name.",
```
Add to sources: `"https://warcraft.wiki.gg/wiki/Stranglethorn_Fishing_Extravaganza_(short_story)",`

## Spot-check of rejects (closest 3 plus extras)
- Greatfather Winter 13444/13445: REJECT stands (actor; the book mention is a simile).
- Headless Horseman / Shade of the Horseman 23543: REJECT stands (Scarlet Crusade page text and a Hearthstone card only; no novel scene).
- Silas Darkmoon, Sayge, Valadar, Fariel, Omen, Kwee, Orphan Matron, Wulmort re-run through the books lookup: only table lines or unrelated word hits ("moment"); Jinglepockets are comic only. All REJECT stand. ADDED: 0.

## Summary
3 entries checked: 1 REJECT (Amnennar), 2 PASS with fixes (Riggle, Revilgaz). 2 additions verified with fixes (Fandral, Seahorn). ADDED 0. Validator not run (not merged). `related` on 15077 points to existing 2487 and new 2496 (one side only).

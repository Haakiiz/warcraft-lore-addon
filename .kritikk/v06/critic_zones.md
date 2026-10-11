# v0.6 lore critic: 33 zone and dungeon entries (b08da32 + fixes on origin/main)

I checked the text in `git show origin/main:WarcraftLore/Data.lua` against warcraft.wiki.gg (WebFetch; curl gets a block page) and Wowhead Classic.
Rules used: Håkon's rules from the brief (explicit identity, classic-era state, concrete roles, 3–6 sentences, no Cataclysm-era facts presented as current, no speculation).

## Scores
| Point | Score | Why |
|---|---|---|
| 2 Player-facing text | 6/10 | Several stories describe the NPC vaguely ("an elite", "located in") or describe its Cataclysm-era state (Trenton, Aurora, Ironpatch). |
| 3 Nothing uncertain | 4/10 | Three entries rest only on a shared name. Several role lines say things the source does not say (Tick, Sprinkle, Arygos, Eranikus). |
| 6 Lore accuracy | 5/10 | There are factual errors: Sprinkle's direction of travel, Tick's book role, Trenton's classic race and location, Eranikus's death, and Ukorz's chapter. |

**Verdict: AVVIST** (3 REMOVE, 14 FIX). It can be approved after the changes below.

## Answers to the brief's specific questions
- **"The War of the Shifting Sands"** is an official short story by Micky Neilson. Blizzard posted it on the official WoW site in November 2005, before the Gates of Ahn'Qiraj event. It is prose fiction by Blizzard's story team, not a guide or RPG, so it is allowed as a BOOK source. It was a tie-in for patch 1.9; flag it if Håkon counts patch tie-ins as promotional.
- **Merithra, Caelestrasz and Arygos (15378–15380)** use the same IDs as the Temple of Ahn'Qiraj quest NPCs (quest 8789 → Arygos 15380, quest 8790 → Merithra 15378). They are not event-only.
- **Keeper Remulos** is not in any Warcraft III mission. The Remulos page does not mention WC3 at all, so a BOOK-only entry is correct.
- **Malfurion 15362**: RoC missions are correct. In TFT he is a hero only in Balancing the Scales, The Ruins of Dalaran and The Brothers Stormrage. He appears only in cutscenes or interludes in Unfinished Business, Shards of the Alliance and Malfurion's Vision.
- **Nathanos**: all 5 books are confirmed. The Dark Mirror line puts the sacrifice on the wrong actor: the Val'kyr sacrifice Stephon, not Nathanos.

---

## Per entry

### REMOVE
**2607 Prince Galen Trollbane: REMOVE.** Before the Storm only mentions his death in passing, and its account contradicts the classic NPC. Wiki: "*Before the Storm* instead states that he died where Galen's Fall would later be built" (Galen's Fall is a Cataclysm-era place). The book role "Is slain by the Forsaken, who then claim the sword Trol'kalar" is not sourced to the book: the wiki gives a separate citation for the sword claim. In classic he is a living human whom Horde players kill, so the BOOK appearance does not describe this NPC.
*Fallback if Håkon keeps it:* role → "Mentioned as having been slain by the Forsaken (chapter 29)". Story sentence 3 → "In the book Before the Storm (chapter 29) he is remembered as slain by the Forsaken."

**9501 Innkeeper Adegwa: REMOVE.** The only link is the name. Wiki: "During the trial of Garrosh Hellscream, Adegwa informed Shokia that there was a letter for her." No location (Hammerfall) or other detail ties the book character to the Hammerfall innkeeper. The page never states that they are the same person.

**5718 Rothos: REMOVE.** The only link is the name. Wiki (ch. 19): "Rothos made brief appearance being nervous when Nozdormu and his bronze dragons were not present". The novel does not give a colour, flight or place that ties him to the green drake in Seradane. That fails the "explicitly the same character" rule. (Arei, by contrast, keeps his species and the Zaetar link, see below.)

### FIX
**7583 Sprinkle: FIX** (she brings the group *into* Gadgetzan, not out of it; the source does not mention Valorwind Lake)
- role: "Takes Aramar Thorne and his companions out of Gadgetzan in her caravan, hides the children inside, and suggests Winifred's home as a safe house" → "Smuggles Aramar Thorne's companions into Gadgetzan hidden in her caravan during a staged picnic, and suggests Winifred's home as a safe house"
- story: "…the Violet Tragan mushroom from Valorwind Lake." → "…the Violet Tragan mushroom from the Hinterlands."
- story: "In Traveler: The Spiral Path, she gets Gazlowe, Aramar Thorne and his companions out of the city in her caravan on a picnic." → "In Traveler: The Spiral Path, she meets Gazlowe and Aramar Thorne on a staged picnic and hides the children in her caravan to bring them into Gadgetzan unseen."

**7804 Trenton Lighthammer: FIX** (Sandsorrow Watch and Sul'thraze are Cataclysm-era. In classic he is a night elf near Gadgetzan's south gate, made a high elf in 4.0.3a.)
- story: "In World of Warcraft, Trenton Lighthammer is a high elf blacksmith at Sandsorrow Watch in Tanaris, searching for the sword Sul'thraze." → "In World of Warcraft, Trenton Lighthammer is a night elf blacksmith of the Mithril Order near Gadgetzan's southern gate, where he trains armorsmiths and asks adventurers for troll temper from Zul'Farrak."

**8198 Tick: FIX** (the wiki does not mention Desolace, the Life-Binder or Aggra. Tick is female.)
- role: "Escorts Thrall to Desolace to confront the Life-Binder, and later takes him back to Aggra's side" → "Takes Thrall to meet the other dragonflights and carries him in the battle to retake Wyrmrest Temple, then returns him to the Maelstrom"
- story sentences 2–3: "In Thrall: Twilight of the Aspects, Thrall and Tick set out to confront the bereaved Life-Binder in Desolace. Tick later takes Thrall back to Aggra's side, where the two orcs overcome their past differences." → "In Thrall: Twilight of the Aspects, she takes Thrall to meet the other dragonflights. She later carries him in the battle to retake Wyrmrest Temple from the Twilight's Hammer and returns him to the Maelstrom."

**15380 Arygos: FIX** (he does not grant an audience: "Arygos told his guards to simply kill him", and Kalecgos intervened)
- role: "Grants Thrall an audience at the Nexus, alongside Kalecgos" → "Orders his guards to kill Thrall when he arrives at the Nexus, until Kalecgos intervenes"
- story: "In Thrall: Twilight of the Aspects, Thrall travels to the Nexus and is admitted to an audience with Arygos and Kalecgos." → "In Thrall: Twilight of the Aspects, he orders his guards to kill Thrall when Thrall comes to the Nexus, until Kalecgos intervenes."

**15378 Merithra of the Dream: FIX** (vague player-facing line)
- story: "In World of Warcraft, Merithra is an elite in the Temple of Ahn'Qiraj." → "In World of Warcraft, Merithra waits in the Temple of Ahn'Qiraj, where adventurers bring her Imperial Qiraji Regalia and Elementium Ore."

**15379 Caelestrasz: FIX** (minor, makes the text concrete)
- story: "In World of Warcraft, Caelestrasz is a quest giver in the Temple of Ahn'Qiraj." → "In World of Warcraft, Caelestrasz waits in the Temple of Ahn'Qiraj and gives the quest The Savior of Kalimdor."

**5709 Shade of Eranikus: FIX** (the wiki says he takes them to Bough Shadow, not the heart of the Dream, and that he dies so Ysera can escape)
- role: "Despondent green dragon who is reluctant to help Tyrande and Broll, but later helps them reach the heart of the Emerald Dream" → "Refuses at first to help for fear of being corrupted again, then carries Tyrande and Broll to Bough Shadow and later sacrifices himself so Ysera can escape"
- story: "…but he later helps Tyrande and Broll reach the heart of the Emerald Dream, and he dies in the heroes' defense." → "…but he later carries Tyrande and Broll to Bough Shadow, and he sacrifices himself so that Ysera can escape."
- Note: the book character is Eranikus himself. The Shade is his spirit, so I accept the identity. A cleaner home for this BOOK appearance would be the redeemed Eranikus NPC in Moonglade.

**7267 Chief Ukorz Sandscalp: FIX** (the summoning is in chapter 34. The source does not say he leads it; he takes part.)
- role: "Leads the sand trolls who summon the loa Kimbul, Shadra and Mueh'zala with the blood of captured prisoners (chapter 33)" → "Joins the sand trolls in summoning the loa Kimbul, Shadra and Mueh'zala with the blood of his prisoners (chapters 33–34)"

**2547 Ironpatch: FIX** (the Bloodsail infiltration and Venture oil-drill cannon quest is Cataclysm-era. In classic he is a plain Bloodsail target.)
- story: "When an adventurer infiltrates the Bloodsails, he tells them to use the cannons on the Venture Company goblins drilling for oil to the north." → "Killing him earns reputation with Booty Bay and costs reputation with the Bloodsail Buccaneers."

**10304 Aurora Skycaller: FIX** (patch 1.12.0 moved her to outside Northpass Tower. The move below Quel'Lithien Lodge is not classic-era.)
- story: "When the tower became a battlefield she moved to the area below Quel'Lithien Lodge, where she gives quests in the Eastern Plaguelands." → "When the tower became a battlefield she moved just outside Northpass Tower, where she still gives quests in the Eastern Plaguelands."

**11036 Leonid Barthalomew: FIX** (the source names no mission for the Brill defence, does not support "to save the Undercity", and does not support "during the Third War")
- role: "Joins Garek Bandarion and Dark Ranger Anya to defend Brill, then helps them bring down Naxxramas's central crystal to save the Undercity" → "Helps Garek Bandarion and Dark Ranger Anya take Dawn's Watch from the Crushridge clan, then destroys the central crystal of Naxxramas with them"
- story: "…raised as a mindless thrall of the Scourge during the Third War before Sylvanas Windrunner freed him." → "…raised as a mindless thrall of the Scourge before Sylvanas Windrunner freed him."
- story: "…he fights alongside Garek Bandarion and Dark Ranger Anya to save the Undercity." → "…he helps Garek Bandarion and Dark Ranger Anya destroy the central crystal of Naxxramas."

**11878 Nathanos Blightcaller: FIX** (Dark Mirror: the Val'kyr do the sacrificing)
- role (Dark Mirror): "Undergoes a ritual with the Val'kyr that transforms him at Sylvanas's command, sacrificing his cousin Stephon Marris" → "Agrees to a ritual Sylvanas calls him to, in which the Val'kyr sacrifice his cousin Stephon Marris to make him stronger"
- role (Shadows Rising): "Sent by Sylvanas to kill the loa Bwonsamdi, a failed gambit after which he returns to Marris Stead" → "Sent by Sylvanas to kill the loa Bwonsamdi, fails, and returns to the Marris Stead to await orders"

**15362 Malfurion Stormrage: FIX** (the TFT role claims he is a hero in missions where he only appears in a cutscene)
- TFT role: "Archdruid hero who joins Tyrande and Maiev against Illidan and his naga" → "Archdruid hero in Balancing the Scales, The Ruins of Dalaran and The Brothers Stormrage; appears in cutscenes in the other listed missions as he joins Maiev against Illidan and his naga"

**11186 Lunnix Sprocketslip: FIX** (Before the Storm is set after Legion, so "still" puts the timeline the wrong way round)
- story: "In World of Warcraft she still sells mining supplies in Everlook." → "In World of Warcraft she sells mining supplies in Everlook."

**11832 Keeper Remulos: FIX** (minor: the Remulos and Moonglade pages do not contain the phrase "sacred center of all druidic studies")
- story: "Keeper Remulos is one of the sons of Cenarius and a keeper of the grove who maintains Moonglade, the sacred center of all druidic studies." → "Keeper Remulos is a keeper of the grove and one of the sons of Cenarius."

### OK
- **7564 Marin Noggenfogger**: OK. The mine inspection and the tip forcing Malus out of Gadgetzan are confirmed. The Goblin Way is an official Blizzard short story (Andrew Robinson, 2024).
- **8197 Chronalis**: OK.
- **15192 Anachronos**: OK. The short story establishes him as Nozdormu's heir. Twilight of the Aspects: "Anachronos and the other bronze dragons were present for the return of their Aspect."
- **11753 Gogo**: OK. The Everlook location ties her to the book (BtS prologue). The player-facing text is thin, but the source gives nothing more.
- **9598 Arei**: OK, with a note. The wiki treats the Ancient of War in Felwood and the Arei in Stormrage as one character, and the Zaetar link fits. The wiki itself notes the physical-vs-spirit discrepancy.
- **1855 Tirion Fordring**: OK. He attended Arthas's induction at the Cathedral of Light, and the Thondroril cottage is confirmed.
- **10824 Ranger Lord Hawkspear**: OK. The wiki explicitly identifies the classic rare as Renthar Hawkspear.
- **11034 Lord Maxwell Tyrosus**: OK. The Blood Ties and A Scarlet Flame roles match.
- **11710 Mirador**: OK. "Mirador is the faithful stallion of Tirion Fordring". He carries Tirion to Mardenholde and to Stratholme, and stands at the exile cottage.
- **16376 Craftsman Wilhelm**: OK. He was added in 1.11.0, so he is classic-era. Dwarf, Brotherhood of the Light, and the Blood Ties ch. 1 forge/Thunderbrew scene are all confirmed.
- **2487 Fleet Master Seahorn**: OK. "His most trusted advisor is Fleet Master Seahorn" (Baron Revilgaz page). Ch. 32 Sea King is confirmed.
- **2542 Catelyn the Blade**: OK.
- **6807 Innkeeper Skindle**: OK.
- **2707 Shadra**: OK. The classic Horde quests Summoning Shadra and Venom to the Undercity are confirmed, as is the "Shortly after the Landfall" vision.
- **5635 Falstad Wildhammer**: OK. His Aerie Peak quest giver role remains in Classic, and the Hasic, Khaz Modan and barley-welcome scenes are confirmed.

## General note
Three REMOVEs come from the same cause. The worker accepts one shared wiki article as proof of identity. A shared article is not enough when the book gives only a name. Require a second tie: place, faction, species or an explicit statement.

# Lessons learned: sonegjennomgang med Haiku-arbeidere (les før neste runde)

Sist oppdatert: 2026-10-08 (kveld). Bygger på `MODELLVALG.md` (modelltesten samme morgen).
Hvordan selve promptene skal skrives står i `HVORDAN_INSTRUERE_HAIKU.md`.

## Runde 3 (2026-10-08 kveld): 24 soner gjort om igjen med brief v3

Soner: Ironforge, Orgrimmar, Durotar, Undercity, Tirisfal, Silverpine, Thunder Bluff, Mulgore, The Barrens, Duskwood,
Thousand Needles, Loch Modan, Wetlands, Ashenvale, Stonetalon + dungeonene Ragefire, Wailing Caverns, Deadmines,
Shadowfang Keep, Stockade, Blackfathom Deeps, Gnomeregan, Razorfen Kraul, Scarlet Monastery. Alle var «ferdige» fra før.

| Steg | Resultat |
|---|---|
| Orkestrator (Opus): NPC-lister, wikisider, kandidatskanning | 3 549 NPC-er → 3 215 wikisider → 231 kandidater (≈200 nye) |
| 6 Haiku-arbeidere (A–F) | 19 forslag, alle kandidater avgjort med sitat |
| 6 Haiku-kritikere | 0 avvist, 15 rettet, 2 lagt til (Krasus, Korialstrasz), koordinater fylt inn |
| Orkestrator, siste kontroll | 4 tidslinjefeil, 8 for korte historier, 2 «uncertain» → «confirmed» (samme kilde som Narm Skychaser) |
| **Resultat** | **21 nye NPC-er + 28 nye bokopptredener i 12 eksisterende oppføringer** |

Det tidligere arbeidet hadde altså gått glipp av mye, nesten bare bokkoblinger (romaner/noveller), ikke RTS. Alle RTS-treff
(mission-backlinks) var allerede med.

## Det som virket

1. **Orkestratoren gjør det mekaniske, Haiku gjør skjønnet.** `tools/research/prep_candidates.py` henter alle wikisider
   én gang (50 per kall) og flagger kandidater. Haiku slipper å skrive egne skannere, og kan ikke miste NPC-er med `head`/`tail`
   (feilen som kostet mest i runde 1).
2. **Hjelpeskript i stedet for frie skall-kommandoer.** `tools/research/lookup.py page|books|book` gir hele siden eller alle
   boklinjer med et navn. Haiku leste hele sider i stedet for regex-utdrag.
3. **«Avgjør HVER kandidat, med sitert linje».** Ingen arbeider hoppet over noe. Rapportene ble etterprøvbare, og kritikeren
   kunne stikkprøve avvisninger på minutter.
4. **Baklengs boksjekk (Characters-seksjoner).** Fant blant annet Ratchet-NPC-ene (Wiley, Jazzik, kanonerne) og flere
   Ironforge-NPC-er som ikke har `{{Novel-section}}` på sin egen side.
5. **Kritiker med konkrete ekstraoppdrag i prompten** (fyll koordinater, sjekk denne grensesaken, verifiser tilleggene).
   Kritiker A fant Krasus/Korialstrasz fordi prompten ba den åpne Wowhead-sidene; arbeideren hadde bare sett på wikien.
6. **«Tillegg til eksisterende oppføringer» som egen seksjon.** Ga 28 nye bokopptredener uten at noen omskrev godkjente oppføringer.
7. **Start kritikeren straks hver arbeider er ferdig** (ikke vent på alle). Hele runden tok ca. 25 minutter.

## Feil som fortsatt skjer (og hvem som fanger dem)

| Feil | Eksempel | Fanget av |
|---|---|---|
| Hendelser etter Classic skrevet som WoW-nåtid | Pozzik og «Speedbarge» (igjen!), Beram velsigner Cairnes spyd, Belgrum/«Tablets of the Earth» | Orkestrator (kritikerne slapp dem gjennom) |
| For korte historier (1–2 setninger) | 8 oppføringer | `tests/validate_db.py` – kritikerne sjekker ikke dette |
| Cataclysm-stedsnavn | «Northern Barrens» om Ratchet | Orkestrator |
| Meta-setninger i story | «Wowhead lists NPCs named Krasus…» | Orkestrator |
| Wowhead «ingen koordinater» | Arbeider A og B fikk ingen `g_mapperData` | Kritikerne fikk det til med `User-Agent: Mozilla/5.0` |
| Uenighet om «confirmed» | Siln/Tigor «uncertain» mens Narm (samme kilde) var «confirmed» | Orkestrator, for konsistens |

→ Ta disse inn i neste brief: kritikeren må sjekke tidslinje setning for setning, telle setninger og bruke `Mozilla/5.0` mot Wowhead.

## Feller i kildene

- **Navnebror ≠ samme person.** Orgrimmar-selgeren Kiro ≠ vulpera-lederen Kiro (*Shadows Rising*). Greatfather Winter (NPC) er en
  skuespiller, ikke figuren. Thorvald Deepforge ≠ «Thorvald (dwarf)» i *Night of the Dragon*.
- **Disambiguasjonssider.** «High Explorer Magellas» peker på både Muninn (NPC) og Tomli (RPG).
- **Season of Discovery-NPC-er** (ID > 200 000) kan være ekte (Krasus/Korialstrasz ved Grim Batol: tittelen «Consort to the
  Dragon Queen» binder dem til boka) eller bare navnelikhet (de 8 tilfeldige WC3-heltene i Ashenvale). Avgjør med Wowhead-tittel/-beskrivelse.
- **Ikke bøker:** tegneserier (*Dark Riders*, *Ashbringer*, *Warrior: Divided*), RPG-bøker (*Lands of Conflict*, *Dark Factions*),
  guider (*Exploring Azeroth*, *Ultimate Visual Guide*), lydspill (*A Thousand Years of War*), «inspirert av» (Stalvan/*Lolita*).
- **Generiske skapninger** (Rat, Doomguard, Voidwalker, Thunder Lizard, Spirit Healer) treffer RTS-ord, men er enhetstyper.
- **Characters-tabeller med colspan**: rollen (Major/Supporting/Minor/Mentioned) må leses ut fra kolonneposisjon. Kritiker B
  oppdaget at en parser ga feil nivå; les tabellen manuelt når rollen betyr noe.

## Feil i orkestratorens eget verktøy (fikset eller kjent)

- Første kandidatskanning flagget **alle** sider med `[[Category:… characters]]`, også rase-/klassekategorier (2 280 falske treff).
  Løst med en stoppliste (`GENERIC` i `prep_candidates.py`).
- Bokcachen tok med alle sider lenket fra «Novels»/«Short stories», også fraksjons-/rasesider («Defias», «tauren»). Arbeiderne
  merket dette selv. Neste gang: filtrer på `{{Bookbox`/`{{Novel` i sideteksten før en side regnes som bok.
- Baklengs indeks matchet bare eksakte lenkenavn; lenker med alias (`[[Advisor Belgrum|Belgrum]]`) blir fanget fordi vi
  indekserer lenkemålet, men NPC-er med tittel i navnet (`Cannoneer Smythe`) kan ha en annen sidetittel. `lookup.py books "<etternavn>"` dekker det.

## Åpne spørsmål til neste runde

- Master Gadrin: siden siterer *The Judgment* for barndommen med Vol'jin og Zalazane. Sjekk om det er en offisiell novelle (da er det en BOOK-opptreden til).
- Sylvanas i *Beyond the Dark Portal*: «Mentioned» ifølge kolonneposisjon, men usikkert. Ikke lagt inn.
- Krasus/Korialstrasz og Mograine (242499) er Season of Discovery-NPC-er. Sjekk i spillet om de finnes i Forever.

# Hvordan instruere Haiku-subagenter (for orkestratoren)

Erfaring fra 2026-10-08 (tre runder, se `MODELLVALG.md` og `LESSONS_LEARNED.md`). Gjelder research-oppgaver der Haiku
skal lese kilder og skrive strukturerte oppføringer. Selve arbeidsbriefen er `BRIEF_zone_worker.md` (v3), kritikerens er `BRIEF_critic.md`.

## 1. Gjør det mekaniske selv før du starter Haiku
- Hent rådata én gang (NPC-lister, wikisider, boksider) med `tools/research/fetch_npcs.py`, `backlinks.py` og `prep_candidates.py`.
- Gi Haiku en ferdig kandidatliste og et oppslagsskript (`lookup.py`). Haiku er god til å lese og vurdere, men skriver
  skjøre pipelines (`head -400`, regex som ikke finner tittelen) og mister data der.
- Pris: prep-skriptet tar ~5 minutter og ~70 API-kall; det sparer seks arbeidere for å gjøre det samme hver for seg.

## 2. Hvordan selve prompten bør se ut
- **Kort startprompt, alt annet i briefen.** «Les briefen og følg den nøyaktig» + gruppe, soner med ID, arbeidsmappe,
  repo som READ ONLY, hvilke to filer som skal skrives, `py -3 -I`, «Git Bash på Windows».
- **Navngi grensesakene du allerede kjenner** i én linje hver («Krasus/Korialstrasz ble avvist før; vurder på nytt og siter linjen»).
  Haiku tar dem seriøst når de står eksplisitt; ellers glir de forbi.
- **Krev en sitert linje for hver avgjørelse**, også avvisninger. Det tvinger fram lesing og gjør kritikken billig.
- **Si hva som IKKE teller**, med eksempler (tegneserier, RPG, guider, lydspill, generiske skapninger, navnebrødre). Haiku
  generaliserer bra fra konkrete eksempler, dårlig fra abstrakte regler.
- **Skill mellom «nytt» og «tillegg til eksisterende».** Be om en egen rapportseksjon i stedet for å la Haiku endre godkjente data.
- **Be om filer, ikke svar i chatten**, og et svar på maks 3 linjer. Ellers havner funnene i svaret og ikke i filene.
- **Gi Haiku et faktisk oppslagsverktøy, ikke bare en regel.** «Ikke bruk head» virket bare halvveis; `lookup.py` virket helt.

## 3. Kritikeren
- Én Haiku-kritiker per arbeider, startet så snart arbeideren er ferdig.
- Gi kritikeren **konkrete ekstraoppdrag** fra arbeiderens rapport: fylle koordinater, avgjøre åpne spørsmål, verifisere
  «tillegg», stikkprøve de 3 nærmeste avvisningene. En kritiker uten oppdrag bare nikker.
- Kritikeren kan legge til oppføringer (`ADDED`). Det ga 2 av 21 funn i runde 3.
- Kritikeren slipper fortsatt gjennom tidslinjefeil og for korte historier. Derfor siste punkt:

## 4. Orkestratorens siste kontroll (ikke hopp over)
1. Kjør `py -3 -I tests/validate_db.py` (fanger for korte historier, duplikater, format).
2. Les hver `story` og se etter: senere titler/steder som WoW-nåtid (Speedbarge, High King, «Northern Barrens»), meta-setninger
   («Wowhead lists…»), «Shortly before the Cataclysm» uten bokreferanse.
3. Gjør «confirmed/uncertain» konsistent med eksisterende oppføringer som hviler på samme kilde.
4. Slå sammen med et skript (sjekk ID-kollisjoner), legg tillegg inn i eksisterende `appearances` uten å røre resten.

## 5. Kostnad og tid (runde 3)
- 12 Haiku-agenter (6 arbeidere + 6 kritikere), ~2,1 M Haiku-tokens totalt, ~25 minutter veggtid.
- Arbeidere 170–255 k tokens hver, kritikere 90–160 k.

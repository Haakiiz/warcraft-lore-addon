# Modellvalg for sonegjennomgang (les dette før neste runde)

Sist oppdatert: 2026-10-08. Gjelder arbeidere/kritikere som går gjennom soner og skriver oppføringer til Data.lua.

## Anbefaling (kort)
- **Arbeider: Claude Haiku 5.5 med `.kritikk/BRIEF_zone_worker.md` (v2).**
- **Kritiker: Claude Haiku 5.5** med `.kritikk/BRIEF_critic.md`.
- **Orkestrator: Opus** – fordeler soner, henter NPC-lister og tilbakelenker selv (billig, mekanisk), slår sammen, kjører
  `tests/validate_db.py` og tar en siste stikkprøve på tidslinje og «bare nevnt»-roller.
- Bytt arbeider til **Sonnet 5.5** hvis en sone er ekstra viktig (hovedsteder) eller Haiku v2 begynner å bomme igjen.
- **Ikke bruk Opus som arbeider**: bare 2 svake funn mer enn Sonnet/Haiku v2, ~5–10× prisen.

## Testen (blind, samme sone, samme kilder)
Sone: Elwynn Forest + Stormwind City (561 NPC-er). «Fasit» = unionen av alle funn = 21 NPC-er.
Alle fikk Data.lua fra før Haiku-arbeidet, så ingen kunne se svarene.

| Kjøring | Funn | Av 21 | Riktig uten innholdsretting* | Koordinater | Kvote (5-timers) |
|---|---|---|---|---|---|
| Haiku 5.5, brief v1 | 14 | 67 % | ~46 % (alle soner samlet) | ja | ~1 % |
| **Haiku 5.5, brief v2** | **19** | **90 %** | **17/19 (89 %)** | ja | ~2 % |
| Sonnet 5.5, brief v1 | 19 | 90 % | 15/19 (79 %) | nei (Wowhead 403) | ~9–10 %** |
| Opus 5.5, brief v1 | 21 | 100 % | ikke kritikersjekket; stikkprøver gode | ja | ~9–10 %** |

\* Rene rolleendringer («Mentioned» → «Minor character») og manglende koordinater er ikke regnet som innholdsfeil.
\** Sonnet og Opus kjørte samtidig; de to brukte til sammen ~18–20 prosentpoeng.

Haiku v2 manglet bare Lady Katrana Prestor (wikisiden er bare en omdirigering til Onyxia) og Lord Gregor Lescovar
(bare *nevnt* i en novelle). Begge er grensetilfeller som den selv listet som åpne.

## Hvorfor Haiku v1 bommet (fra loggene)
Alle tre modellene brukte bare warcraft.wiki.gg og Wowhead. Forskjellen var søkemetoden, ikke kildene:
1. Søkte etter «novel» med store/små bokstaver → `{{Novel-section}}` ble ikke alltid fanget.
2. Kuttet egen skanneutskrift med `head -400` og viste bare 4 treff per side.
3. Så `{{Novel-section}}` på Archmage Malin og Baros Alexston, men tittel-parseren fant ingen boktittel –
   og Haiku avviste dem som «ingen kilde» i stedet for å lese avsnittet.
4. Skrev senere hendelser som nåværende WoW-tilstand (Anduin «High King», Speedbarge, Magni som diamant).

Sonnet gjorde det smarteste: slo opp bøkenes «Characters»-seksjoner og lette etter sonens NPC-navn der (baklengs).
Brief v2 lærer Haiku dette (★-reglene), og det løftet Haiku fra 14 til 19 funn og fra ~46 % til ~89 % riktige oppføringer.

## Kjente svakheter som fortsatt gjelder
- Haiku kan fortsatt legge til en påstand som ikke står i kilden (v2: Anduin «i bryllupet» i *Blood Ties*). Kritikeren fanget den.
- Haiku-kritikere bommer av og til på tidslinje og på for korte historier (2 setninger). Orkestratoren må kjøre
  `tests/validate_db.py` og lese historiene raskt før sammenslåing.
- Wowhead gir av og til 403 til arbeidere. Orkestratoren kan hente NPC-lister og koordinater selv (`tools/research/fetch_npcs.py <soneId…>` og
  `tools/research/backlinks.py <soneId…>`, kjør med `py -3 -I`), eller la kritikeren fylle inn koordinater.
- «Bare nevnt»-roller (Lescovar) og omdirigerte NPC-er (Katrana → Onyxia) må avgjøres av orkestratoren.

## Oppskrift for neste runde (oppdatert etter runde 3, 2026-10-08 kveld)
Les `LESSONS_LEARNED.md` og `HVORDAN_INSTRUERE_HAIKU.md` først. Kort:
1. Orkestrator: `fetch_npcs.py <soneId…>`, `backlinks.py <soneId…>`, kopier `npcs_*.json` til en arbeidsmappe i scratchpad og kjør
   `prep_candidates.py <arbeidsmappe> WarcraftLore/Data.lua` (alt med `py -3 -I`). Gir `candidates_<soneId>.json`, `_pages.json`, `_books.json`.
2. 5–6 Haiku-arbeidere parallelt med brief v3 (3–5 soner hver, balansert på antall kandidater). Arbeidsmappen oppgis i prompten.
3. Én Haiku-kritiker per arbeider, startet straks arbeideren er ferdig, med konkrete ekstraoppdrag fra rapporten.
4. Orkestrator: rett tidslinje og korte historier, slå sammen med skript, legg tillegg inn i eksisterende oppføringer,
   kjør `tests/validate_db.py`, commit + PR.
5. Runde 3 brukte ~2,1 M Haiku-tokens for 24 soner.

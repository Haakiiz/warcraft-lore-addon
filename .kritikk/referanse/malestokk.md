# Målestokk for nye NPC-oppføringer (Warcraft Lore)

Referanse: godkjente oppføringer i WarcraftLore/Data.lua.

## Kriterier (hvert punkt får 1–10)
1. **Samme karakter:** minst én kilde (helst warcraft.wiki.gg) sier eksplisitt at WoW-NPC-en og RTS-karakteren er samme person. Spekulasjon → confidence = "uncertain" + searched.
2. **Riktig spill/kampanje/oppdrag:** game-koden (WC1, WC2, BTDP, WC3, TFT, FK) og oppdragsnavnene står ordrett i kildene. Reforged-tillegg i gamle oppdrag er merket «Reforged only» i role.
3. **Riktig rolle:** rollen (helt, enhet, questgiver, nevnt …) stemmer med oppdragssiden.
4. **Historien er kildebelagt:** hver påstand i story står i kildene; 3–6 setninger på engelsk; tom hvis ukjent.
5. **NPC-ID og koordinater:** stemmer med Wowhead Classic (g_mapperData) for riktig sone.
6. **Items:** bare items som finnes på Wowhead med riktig ID og en riktig kobling; ellers tom liste.
7. **Format:** passer formatet i Data.lua og passerer tests/validate_db.py.
8. **Avvisningene er begrunnet:** bortvalgte kandidater har en konkret, riktig grunn.

## Unngå (feil som gir AVVIST)
- Navnelikhet uten kilde som binder dem sammen
- Oppdiktede oppdragsnavn, item-ID-er, NPC-ID-er eller koordinater
- Lore-veteraner fra krigene som ikke er med i spillene, tatt med som om de var det
- Generiske enhetstyper (Grunt, Peon, Deathguard, Footman …) som oppføringer
- Påstander i story som ikke står i kildene, eller som er fra etter Classic presentert som før
- Romanhendelser presentert som spillopptredener (bok-/romankoblinger SKAL tas med fra 2026-10-03, men tydelig merket som bok)
- Norsk tekst i Data.lua

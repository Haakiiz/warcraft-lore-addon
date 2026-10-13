# Kritikk D3 runde 1 – Warcraft Lore detaljvindu (Thrall)

Identifisering: B er originalen (WC2 Battle.net Edition, lavoppløst og forstørret, spillskjerm med Menu/Pause, minikart, enhetsinfo og kommandokort). A er mockupet (560x680, detaljvindu for én NPC).

## 1. Blindtest

Målt mot målestokken som WC2-grensesnitt kaller jeg A og B **likeverdige**, med en svak fordel til A (sikkerhet 60 %). B er kilden og har hele WC2-strukturen (knapperad øverst, kommandokort). A tar med seg alle stilmarkørene som veier tyngst: sprukket brun lærtekstur, tykk avfaset steinramme, mørke innfelte paneler med lys kant nede/høyre, mørkerøde avfasede knapper med gulltekst, sentrert gul tittel og «Label: verdi»-linjer, og en grønn «helselinje» under portrettet som i enhetsinfoen. I tillegg har A den moderne finishen målestokken ber om. Det ser ut som en remaster av en WC2-meny/dialog.

## 2. Poeng

| # | Punkt | A (mockup) | B (original) |
|---|-------|-----------|--------------|
| 1 | Underlag (brun sprukken tekstur) | 8 | 9 |
| 2 | Ytre ramme (stein, avfasing) | 9 | 9 |
| 3 | Innfelte paneler | 8 | 9 |
| 4 | Knapper | 8 | 8 |
| 5 | Typografi | 9 | 6 |
| 6 | Palett | 9 | 8 |
| 7 | Moderne finish | 9 | 3 |
| 8 | Struktur fra WC2 | 8 | 10 |
| 9 | Lesbarhet | 8 | 6 |
| 10 | Helhet | 9 | 9 |

Begrunnelse for A:
1. Tekstur #4b2f12/#3b240d med mørke sprekker, i riktig område. Sprekkene er litt grove og jevnt fordelt (prosedyrisk preg), men flaten er rolig nok.
2. Steinramme ca. 10 px: lys kant oppe/venstre (#a1967b), mørkere nede/høyre (#84795d / #8c7f60), med kornet steinstruktur. Meget god.
3. Headerpanelet og seksjonspanelene er mørke (#1a0f05 / #180e04), gjennomskinnelige over teksturen, mørk kant oppe/venstre (#020100) og lys beige linje nede/høyre. Scrollfeltet er et innfelt panel med seksjonspaneler inni seg. Det blir to lag innfelling, noe tungt, men korrekt bevel.
4. Related/Close: mørkerød flate (#75170e, nedre del #5b0e08), lys bevel oppe/venstre (#b2483a), mørk nede/høyre (#460d07), gull small-caps-tekst sentrert. Lukkeknappen (rød kvadrat, gull X) og scrollpilene følger samme system. Ingen trykket tilstand vises, men det kan ikke vurderes fra et statisk bilde. Ingen kommandoknapper.
5. Alegreya SC til titler og etiketter i gull, Alegreya til brødtekst i lys beige. Ren og klassisk, ingen pikselfont.
6. Brunt, mørkerødt, gull, beige, steingrått, svart. Grønt bare for «Met» (linje og merke). Spillfargene finnes bare som små merker (WC3 oransje, TFT blå, BOOK beige).
7. Skarpe kanter, subtile skygger under knappene, jevn spacing. Ikke flatt.
8. Sentrert gul tittel, sentrerte stat-linjer, paneler stablet vertikalt, portrett med grønn linje under (direkte fra enhetsinfoen). Knapperaden ligger nederst i stedet for øverst, men det passer for et dialogvindu.
9. Høy kontrast for brødteksten (beige på nesten svart). Ingen tekst står direkte på sprekker. Den nederste seksjonen er avkuttet (se merknader).
10. Leses som én helhet og et tydelig WC2-inspirert system.

## 3. Avvisningsfeil

Ingen.

## 4. Mindre merknader

- **Avkuttet seksjon nederst i scrollfeltet** (y ca. 550–592): «BOOK – Warcraft novels and books» viser overskrift og skillelinje. Panelet kuttes så rett under linjen, med sidekantene løpende inn i scrollfeltets nedre kant. Det fungerer som scroll-hint, men ser bare halvveis tilsiktet ut. Forslag: 8–10 px innvendig luft i bunnen av scrollfeltet, og/eller en 12–16 px mørk overgang (#0e0904 mot transparent) over nedre kant, slik at kuttet ser bevisst ut.
- **Scroll-tommelen** (x ca. 504–516, y ca. 254–460) dekker rundt 60 % av sporet. Det stemmer dårlig med at minst én hel seksjon gjenstår. Sjekk at høyden beregnes fra faktisk innholdshøyde.
- **Dobbel innfelling**: scrollfeltets ytre ramme (lys linje ca. x=42 og x=495) og seksjonspanelenes egne rammer gir to parallelle lyse linjer med 4–6 px mellomrom. Det blir litt urolig. Vurder å fjerne den lyse kanten på scrollfeltet og bare beholde mørk innfelling, eller å la seksjonene skilles med en enkel delelinje.
- **Tittellinjen** («Warcraft Lore», y ca. 30–70) er et mørkt bånd uten tydelig bevel nede. Et 1 px lyst beige skille (#b8ad94 med lav opasitet) under båndet ville knyttet det tettere til panelsystemet.
- Lukkeknappens «X»: kontroller at den er laget i CSS/SVG og ikke er Unicode-tegnet ✕. Fra bildet ser den riktig ut.
- «chapters 4-5» bør ha en tankestrek (4–5) for typografisk finish.
- Ingen kvadratiske kommandoknapper. Det er greit her, men Related/Close kunne fått små ikonknapper ved siden av for et sterkere WC2-ekko (valgfritt).

## 5. Konklusjon

**GODKJENT.** Ingen punkter under 8 for mockupet, ingen avvisningsfeil, og mockupet er likeverdig med originalen i blindtesten. De mindre merknadene, særlig avkuttingen i bunnen av scrollfeltet, bør tas med i neste justering.

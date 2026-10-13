# Kritikk D2 runde 1 (Warcraft Veterans-vinduet)

Metode: begge bildene er vurdert i full størrelse med Read. Zoom-utsnitt var ikke mulig fordi PIL mangler i miljøet. Hex-verdiene nedenfor er derfor anslått med øyet, ikke målt med pipette.

## 1. Blindtest
**A treffer målestokken best som WC2-grensesnitt.** Sikkerhet: 95 %.
A er den originale skjermdumpen fra WC2: lavoppløst, med pikselfont og spillkart. B er mockupet. B er et overbevisende WC2-aktig menyvindu, men står ikke på linje med A. Det er tre grunner til det:
- Underlaget er langt mørkere og kaldere enn originalens varme lær/jord.
- Rammen er tynnere.
- Det synlige underlaget er bare noen smale striper mellom panelene.
Jeg kaller dem derfor ikke likeverdige.

## 2. Poeng

| # | Punkt | A | B |
|---|-------|---|---|
| 1 | Underlag (varm brun, sprukken tekstur) | 10 | 6 |
| 2 | Ytre ramme (8–12 px stein, avfaset) | 10 | 7 |
| 3 | Innfelte paneler | 9 | 9 |
| 4 | Knapper (mørkerød bevel, gull tekst, ikonknapper) | 9 | 8 |
| 5 | Typografi (gull serif, beige brødtekst) | 7 | 9 |
| 6 | Palett | 9 | 8 |
| 7 | Moderne finish | 3 | 9 |
| 8 | Struktur fra WC2 | 10 | 8 |
| 9 | Lesbarhet | 6 | 7 |
| 10 | Helhet (remaster av WC2-menyene) | 10 | 8 |

## 3. Avvisningsfeil (mockup B)
1. **Underlaget er for mørkt, og for lite av det synes.** Gjelder de synlige teksturstripene: tittelområdet, rommet rundt søk og filter, og stripen ved «Showing all 127 veterans».
   - Tonen ser ut som ca. #2e1d0e–#3a2512. Målestokken krever #6b4423/#4a2e16 med sprekker i #2a180a.
   - Sprekkene skimtes, men den varme oransjebrune lærfølelsen fra originalen (venstre kolonne i A) mangler. Vinduet leses mer som «mørk brun app» enn som WC2-skinn.
   - **Tiltak:** Løft grunntonen til #5a3a1e–#6b4423, behold sprekkene på #2a180a og la teksturen få mer kontrast.
   - **Tiltak:** Øk avstanden mellom panelene (10–14 px) og ha en tydelig teksturkant rundt hver panelgruppe, så underlaget faktisk synes, slik som rundt minikartet og enhetsinfoen i A.
2. **Tekst står direkte på sprukket tekstur uten mørkt panel bak.** Dette bryter punkt 9.
   - Det gjelder «Showing all 127 veterans» (venstre, ca. y=306) og «Hide book-only» med avkrysningsboksen (høyre, samme linje).
   - Med lysere underlag (feil 1) blir dette verre.
   - **Tiltak:** Legg linjen i et eget innfelt mørkt bånd, for eksempel rgba(10,6,2,0.6) med innfelt bevel. Alternativt kan den slås sammen med filterpanelet over.
3. **Ytterrammen er for tynn.** Den grå-beige steinrammen ser ut til å være ca. 5–6 px, mens målestokken krever 8–12 px.
   - Avfasingen (lys oppe/venstre, mørk nede/høyre) er for svak, og rammen har ingen stein- eller kornstruktur. Originalen har en tykk, kornete ramme rundt hele skjermen.
   - **Tiltak:** Gjør rammen 10 px, legg til lys kant #d8cfb8 oppe/venstre og mørk kant #5c5446 nede/høyre, og gi den en subtil prosedyrisk korntekstur.

## 4. Mindre merknader
- **Symboler må sjekkes i koden.** Rombene foran navnene, trekantene i nedtrekksknappene og pilene i rullefeltet må være laget med CSS eller SVG, ikke Unicode (◆ ▼ ▲). Det lar seg ikke avgjøre uten zoom. Hvis de er Unicode, er det en avvisningsfeil.
- **«uncertain»-merket kan kollidere med Zone-kolonnen.** Merket er liten kursiv i mørk gull. På «Archmage Ansirem Runeweaver uncertain» nærmer det seg Zone-kolonnen (et par piksler unna). Med tyske og franske navn vil det kollidere. Gi navnekolonnen ellipsis eller bryt «uncertain» på egen linje eller som en ikon-tag. Teksten er også svært liten (ca. 10 px) og bør være minst 11 px.
- **Kommandoknapper mangler.** Kvadratiske ikonknapper som i WC2 brukes ikke noe sted. Spillmerkene (WC2/WC3/TFT/FK/BOOK) i telleraden kunne vært kvadratiske kommandokort med grønn ramme (#4cb84c) for aktivt filter. Det ville styrket punkt 4 og 8.
- **Trykket tilstand er ikke vist** på Journal- og Memorials-knappene (innfelt bevel, tekst flyttet 1 px). Det bør demonstreres i en tilstandsvariant.
- **Fargede spillmerker.** TFT (blå) og FK (grønn) i telleraden og listen er akseptable som små merker. Den mettede blåfargen bør likevel dempes litt mot palettens tone.
- **Lukkeknappen** (X oppe til høyre) er grå og flat sammenlignet med de røde knappene. Gi den samme mørkerøde bevel, eller en tydelig steinbevel.
- **Linje i telleraden.** Minilinjene under tellerne nesten forsvinner når verdien er 0. Det er greit, men sporet kan gjerne ha en tydeligere innfelt kant.
- **Typografien er sterk.** Small-caps serif i gull for titler og etiketter og beige brødtekst treffer godt. Ingen pikselfont, ingen avrundede hjørner og ingen glød.

## 5. Konklusjon
**AVVIST**

Punkt 1 (6), 2 (7) og 9 (7) ligger under 8, og det er tre avvisningsfeil. Mockupet velges heller ikke i blindtesten. Struktur, knapper, paneler og typografi er nær målet, så neste runde bør konsentrere seg om et lysere og varmere underlag som faktisk synes, mørke bånd bak frittstående tekst og en tykkere, avfaset steinramme.

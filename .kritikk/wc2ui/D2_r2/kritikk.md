# Kritikk D2 runde 2 (Warcraft Veterans-vinduet)

**Bildene:** A (560x680) er mockupet, B er WC2-originalen (lavoppløst og forstørret).

## 1. Blindtest
B treffer målestokken best som ekte WC2-grensesnitt. Sikkerhet: 65 %. A ligger tett opp mot B. Teksturen (#73491c / #613e18 med mørke sprekker) og steinrammen med avfasing er nesten like, og det samme gjelder de mørkerøde knappene og de innfelte svarte panelene med lys kant nede og til høyre. Tittelen er sentrert og i gull, og den aktive flisen har grønn ramme. Det som gjør at A ikke ser helt like ekte ut, er listedelen med tabellhoder og fargede merker. Den ser ut som et WoW-addon og ikke som en WC2-meny. Jeg vil kalle dem **nesten likeverdige**, med et lite forsprang til B.

## 2. Poeng

| # | Punkt | A (mockup) | B (original) |
|---|-------|-----------|--------------|
| 1 | Underlag (brun, sprukken tekstur) | 9 | 10 |
| 2 | Ytre ramme (stein, avfasing) | 8 | 9 |
| 3 | Innfelte paneler | 9 | 9 |
| 4 | Knapper | 8 | 9 |
| 5 | Typografi | 9 | 7 |
| 6 | Palett | 9 | 10 |
| 7 | Moderne finish | 9 | 3 |
| 8 | Struktur fra WC2 | 8 | 10 |
| 9 | Lesbarhet | 7 | 7 |
| 10 | Helhet | 8 | 10 |

## 3. Avvisningsfeil
1. **Avkuttet tekst i listen.** Raden «Archmage Ansirem Runew…» (ca. y=536, x=73–250 i A) er kuttet med ellipse fordi «uncertain»-merket står inne i navnekolonnen. Det bryter direkte med punkt 9 («ingen avkuttet tekst»), og det er grunnen til at punkt 9 får 7. Tiltak: Flytt «uncertain» ut av navnecellen. Bruk en egen liten markør etter navnet på en ny linje, et ikon med tooltip, eller del bredden på nytt (navn ca. 230 px, sone ca. 120 px, «Appears in» ca. 95 px). Alternativt kan navnet få bryte til to linjer. Sjekk deretter det lengste navnet i datasettet.

## 4. Mindre merknader
- **Knappene «Journal» og «Memorials»** (y≈80–106): Bevelen er svak. Toppkanten er #78180f, bunnen #601009 og den mørke underkanten #3a0905. Det mangler en tydelig lys toppkant på 1 px (for eksempel #a8402a) og en mørk høyrekant, slik WC2 har på «Menu» og «Pause». Mockupet viser heller ingen trykket tilstand.
- **Ytre ramme:** Rammen er ca. 10 px med lys kant oppe og til venstre (#9d9379 / #a1977c) og mørk kant nede og til høyre (#5c5446). Det er riktig, men rammeflaten er nesten ensfarget. En svak steinstruktur eller nagler i hjørnene ville gjort den mer lik WC2.
- **Tittelbåndet** (y≈30–68) er et mørkt, flatt bånd med en hårfin linje under. Det kan med fordel få samme innfelte bevel som de andre panelene.
- **Fargede merker** (WC2 rød, WC3 oransje, TFT blå, FK grønn): Merkene er små og dermed innenfor målestokken. Blå TFT er likevel den eneste kalde fargen i vinduet. Vurder å dempe den mot grå-blå.
- **Listen** (y≈362–635) har tabellhoder og radstriper som gir et moderne regneark-preg. Det fungerer, men det er det minst WC2-aktige elementet.
- **Grønne ruter for «møtt» og de grå rutene i listen, nedtrekkspilene og lukkeknappen:** Bekreft at de er laget med CSS eller SVG og ikke som Unicode-tegn (◆ ▼ ×). Det kan ikke avgjøres sikkert fra bildet.
- **Fremdriftsstripene i spillflisene** er svært tynne (ca. 3 px), og den tomme stripen leses nesten som en linje. De kan godt være 1–2 px høyere.
- **Tekstkontrast:** «uncertain» i liten gull kursiv mot den mørke raden er akkurat lesbar. Hold størrelsen på minst 11 px.

## 5. Konklusjon
**AVVIST.** Det eneste som stopper godkjenningen er den avkuttede navneteksten (punkt 9 = 7 og en avvisningsfeil). Alle andre punkter er 8 eller høyere, og mockupet er nesten likeverdig i blindtesten. Rett avkuttingen og styrk gjerne bevelen på knappene, så bør neste runde kunne godkjennes.

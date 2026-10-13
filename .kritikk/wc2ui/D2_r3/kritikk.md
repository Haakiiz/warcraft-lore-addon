# Kritikk D2 runde 3 – Warcraft Veterans (WC2-stil)

**1. Blindtest**
A er den originale WC2-skjermdumpen: lav oppløsning, spillkart og orkisk sidepanel. B er mockupet. Jeg er 100 % sikker på hvilket som er hvilket, men det skyldes innholdet (spillkart mot listevindu), ikke stilbrudd. Målt bare som WC2-grensesnitt eller -meny vurderer jeg B som **likeverdig** med A. B har alle de bærende elementene i referansen:
- sprukket brunt underlag
- steinramme med avfasing
- mørke innfelte paneler med lys kant nede/høyre
- mørkerøde knapper med gulltekst
- sentrert gul tittel i serif
- kvadratiske flis-knapper der den aktive har grønn ramme

Sikkerhet for likeverdig: 75 %.

**2. Poeng**

| # | Punkt | A (original) | B (mockup) |
|---|---|---|---|
| 1 | Underlag | 10 | 8 |
| 2 | Ytre ramme | 10 | 8 |
| 3 | Innfelte paneler | 10 | 9 |
| 4 | Knapper | 10 | 8 |
| 5 | Typografi | 9 | 9 |
| 6 | Palett | 10 | 8 |
| 7 | Moderne finish | 3 | 9 |
| 8 | Struktur fra WC2 | 10 | 8 |
| 9 | Lesbarhet | 7 | 8 |
| 10 | Helhet | 10 | 9 |

Det jeg målte i B:
- **Ytre ramme:** venstre side er 10 px (x=20–29). Den har en 2 px lys kant (#d8cfb8) ytterst oppe og til venstre, og steinflaten er ca. #85795c. Høyre og nedre kant ender i en 2 px mørk kant (#5c5446). Avfasingen er altså riktig vei.
- **Underlag:** ca. #6b441b, med mørke sprekker.
- **Knapper:** #6b140c, med lys øvre kant. Det er ingen avrundede hjørner.
- **Paneler:** #0b0703 til #211407. Den lyse kanten nede (#b8ad94) er på plass.

**3. Avvisningsfeil**
Ingen.

**4. Mindre merknader**
1. **Rammen ser flat ut.** Steinrammen (10 px, #85795c) har bare finkornet støy. I referansen har stein/metall-rammen mer struktur. Legg på en svak lys/mørk variasjon eller noen få innrisset linjer i steinen. Vurder også å øke rammen til 12 px, så den bærer like mye som i A.
2. **Sprekkene er for regelmessige.** Store, jevne celler gjør at underlaget minner litt om et «voronoi-mønster». Bryt opp med litt mer variasjon i cellestørrelse og noen korte, frie sprekker. Det samme gjelder flatene bak listen og tittelstripen.
3. **FK-merket er grønt.** Merket i Appears in-kolonnen og på FK-flisen har grønn kant og tekst (ca. #7cb85c). Det kolliderer med regelen om at grønt betyr valgt/møtt. Bruk en annen ikke-grønn tone, for eksempel en dempet oliven/bronse som er tydelig ulik #4cb84c.
4. **Diamantene for ikke-møtte er nesten usynlige.** De sitter til venstre i hver rad og er mørke på mørk bakgrunn. Gi dem en tynn kontur i #b8ad94 med cirka 50 % styrke, så tilstanden kan leses.
5. **Grønn radbakgrunn er tvetydig.** Raden til Baine Bloodhoof nederst i listen har grønn bakgrunn (#1d230d). Anduin Wrynn er også møtt, men raden hans har ikke det. Gjør det tydelig om grønn rad betyr «valgt» eller «møtt», og vær konsekvent.
6. **Lukkeknappen (X øverst til høyre)** må tegnes med CSS eller SVG, ikke med en Unicode-glyf som ✕. Det samme gjelder trekantene i nedtrekksmenyene og på rullefeltet. Herfra kan jeg ikke se hvordan de er laget, så det må kontrolleres i koden.
7. **Ingen trykket tilstand vises.** Ingen knapp eller flis står i trykket tilstand, så den innfelte bevelen og forskyvningen på 1 px kan ikke kontrolleres. Den bør vises i neste runde eller dokumenteres.
8. **Liten tekst i spillmerkene.** Merketekstene (BOOK, WC3, TFT) er ca. 9 px høye. Det er lesbart, men i nedre grense. Ikke gå lavere.
9. **Plassholderteksten i søkefeltet** (ca. #8d8c6c på #0b0703) holder kontrastkravet. Den grå-grønne tonen bryter likevel litt med paletten. Bruk heller en dempet beige, for eksempel #9c917a.

**5. Konklusjon**
**GODKJENT.** Alle punktene for mockupet scorer 8 eller mer, jeg fant ingen avvisningsfeil, og mockupet er vurdert som likeverdig i blindtesten. Merknadene over bør tas med i finpussen, særlig punkt 1, 3 og 4.

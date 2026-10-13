# Kritikk D1 runde 2 (komponentark / stilkit)

## 1. Blindtest
A er åpenbart den originale WC2-skjermdumpen: lav oppløsning, pikselfont og spillkart. B er mockupet, et komponentark med tre vinduer.
Målt mot målestokken treffer **B best**, eller er i det minste **likeverdig** med A. A vinner på autentisk underlag og struktur, men taper på punkt 5 (pikselfont), 7 og 9, mens B oppfyller alle ti punktene på et akseptabelt nivå.
Sikkerhet: 65 % for at B skårer høyest totalt. At B gjenkjennes som en WC2-remaster: 90 %.

## 2. Poeng

| # | Punkt | A | B |
|---|-------|---|---|
| 1 | Underlag (sprukket lær) | 10 | 8 |
| 2 | Ytre ramme | 9 | 8 |
| 3 | Innfelte paneler | 9 | 8 |
| 4 | Knapper (meny + kommando) | 9 | 9 |
| 5 | Typografi | 5 | 9 |
| 6 | Palett | 9 | 8 |
| 7 | Moderne finish | 3 | 8 |
| 8 | Struktur fra WC2 | 10 | 9 |
| 9 | Lesbarhet | 6 | 8 |
| 10 | Helhet | 10 | 8 |
| | **Sum** | **80** | **83** |

Begrunnelse for B, kort:
- **1:** Fargen stemmer (#613f18–#6b451b, sprekker nær #2a180a), og flakene har noe relieff. Sprekkene er tynnere og mer jevne enn i WC2, og teksturen gjentas tydelig (se merknad 1).
- **2:** Steinrammen er 10 px (#8c8062/#998b69 med kornstøy). Lys kant oppe og til venstre er #d8cfb8 (2 px), mørk kant nede og til høyre er #5c5446 (2 px), og det er en mørk innerkant (#231608). Riktig, men avfasingen er smalere og flatere enn i originalen.
- **3:** Minikart (#000) og enhetsinfo/lore-panel (#1d1206–#2d1c0a) er mørke og gjennomskinnelige. De har lys kant nede og til høyre (#a69c86) og mørk kant oppe og til venstre, slik målestokken krever.
- **4:** Knappene er mørkerøde (#6b140c, nede #470a05) med hevet bevel. Pressed-tilstanden er innfelt, og teksten flyttes 1 px (Menu/Pause og Normal/Pressed er kontrollert). Disabled er tydelig dempet. Kommandoknappene er kvadratiske med mørk bunn og grå bevel, og den aktive har grønn ramme. Ikonene er egne SVG-er, ikke kopier.
- **5:** Titler og knapper er satt i Cinzel-lignende kapitéler med gull #e8c547. Brødteksten er Alegreya i lys beige. Enhetsinfoen har sentrerte overskrifter og «Label: verdi»-linjer.
- **6:** Paletten holder seg innenfor brunt, rødt, gull, beige, stein og svart. Blått og oransje brukes bare i små merker.
- **8:** Venstre panel er nær 1:1 med WC2: Menu/Pause øverst, minikart, enhetsinfo med portrett og grønn HP-stolpe, 3×2 kommandoknapper.
- **9:** Beige tekst på cirka #2e1d0b gir godt over 4.5:1. Ingen tekst står direkte på sprekkene, og ingenting er avkuttet.
- **10:** Spill-menyen, lore-vinduet og venstrepanelet er tydelig samme system.

## 3. Avvisningsfeil
Ingen.

## 4. Mindre merknader
1. **Synlig flisgjentakelse i læret.** Jeg målte en horisontal periode på nøyaktig 256 px (avvik 7 mot cirka 40 ellers). Den sees godt i den nederste stripen (y 530–640) og bak lore-vinduet. Gi teksturen en større flis (512 px eller mer), forskyv eller speil annenhver rad, eller legg et ikke-gjentakende støy- eller lysmørkt lag (cirka 6–10 % opasitet) over.
2. **Sprekkene er for jevne og tynne** (cirka 1–2 px overalt). I WC2 er sprekkene brede, mørke kløfter, og flakene er hevet med lys kant. La bredden variere mellom 1 og 4 px, og legg en 1 px høylyskant (cirka #8a5a2a) på flakkanten oppe og til venstre for hver sprekk.
3. **Rammens avfasing** er bare en lys linje på 2 px pluss flat stein. Gi den en myk gradient på 3–4 px innover (lys til mid til mørk), slik at steinen ser avrundet ut som i originalen.
4. **Tittelbåndene** («Game Menu», «Warcraft Lore») er et mørkt bånd på #2d1c0a med tynne linjer. Dette finnes ikke i WC2. Det er greit, men båndet kan med fordel få samme innfelte bevel som de andre panelene, så det ikke leses som en flat stripe.
5. **Hurtigtaster vises med understreking** (S i «Save» osv.). Det er moderne og greit. WC2 markerer heller bokstaven i en annen farge, så vurder å vise bokstaven i lysere gull (#f2d36b) uten understreking.
6. **FK- og MET-merkene har nesten samme grønnfarge.** Siden grønt er reservert for møtt/valgt, bør FK få en annen tone, for eksempel oliven eller dempet gulgrønn (cirka #9aa04a), så den ikke forveksles med MET (#4cb84c).
7. **Subpiksel-fargekanter (ClearType)** sees på den gule teksten i forstørrelse. Dette er en artefakt fra skjermdumpen, ikke en designfeil, men bruk gråtone-antialiasing i fremtidige mockup-skjermdumper.
8. **«Stone»- og «Inset»-knappene** er ikke WC2-elementer. De er akseptable som sekundære knapper, men bruk dem sparsomt så de røde menyknappene forblir det dominerende.
9. Jeg kunne ikke verifisere fra bildet om «×» og haken er SVG/CSS eller Unicode-tegn. De ser tegnet ut. Sjekk i kildekoden at det ikke er Unicode (✓/×), som er forbudt i målestokken.

## 5. Konklusjon
**GODKJENT.** Alle punktene for mockupet ligger på 8 eller høyere, det er ingen avvisningsfeil, og mockupet skårer høyest i blindtesten (likeverdig med eller bedre enn originalen mot målestokken). Merknad 1 og 2 om læret bør rettes før vinduene bygges, siden underlaget ligger rett på grensen.

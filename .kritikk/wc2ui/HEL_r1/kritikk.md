# Kritikk HEL_r1: Veterans og Lore side om side (WC2-stil)

Bilder: A.png (1120x680, to addon-vinduer) og B.png (WC2-skjermdump, orkisk grensesnitt). Målinger er gjort med pikselprøver (System.Drawing) og forstørrede utsnitt.

## 1. Blindtest

**A** er mockupet og **B** originalen. Målt mot målestokken treffer **A** best. Det har underlag, ramme, innfelte paneler, røde knapper og gull-typografi fra B, og i tillegg moderne finish og to vinduer i samme system (punkt 7 og 10), som B ikke kan oppfylle. Som ren WC2-gjenkjennelse er de **likeverdige**: A leses umiddelbart som et remaster av B-panelet til venstre.
Sikkerhet: **75 %** for at A treffer målestokken best (95 % for hvilket bilde som er mockupet).

## 2. Poeng

| # | Punkt | A (mockup) | B (original) |
|---|-------|-----------|--------------|
| 1 | Underlag (brun sprukken tekstur) | 8 | 10 |
| 2 | Ytre ramme (stein, bevel) | 8 | 10 |
| 3 | Innfelte paneler | 9 | 9 |
| 4 | Knapper | 8 | 9 |
| 5 | Typografi | 9 | 6 |
| 6 | Palett | 9 | 9 |
| 7 | Moderne finish | 9 | 3 |
| 8 | Struktur fra WC2 | 8 | 10 |
| 9 | Lesbarhet | 9 | 6 |
| 10 | Helhet / samme system | 8 | 9 |
| | **Sum** | **85** | **81** |

Begrunnelse for A, kort:
- **1:** Varm brun (#644019 til #754b1e målt) med mørke sprekker. Sprekkene er tynne, jevne linjer som ligner krakelering. I B er sprekkene bredere, med lys kant og «klumpete» jordflak. Teksturen er rolig nok, men litt for uniform og flat.
- **2:** Rammen er 10 px: lys topp/venstre #d8cfb8 (2 px), steinflate #73684f til #9d9379 og mørk bunn #5c5446. Den er identisk på begge vinduene, og avfasingen er riktig. Steinflaten er nesten ensfarget. B har marmorert stein med tydeligere flekker.
- **3:** De mørke, gjennomskinnelige panelene har mørk topp/venstre og lys bunn/høyre. Dette er riktig og konsekvent: Veterans met, filterpanel, liste, Lore-hode og seksjonene.
- **4:** Knappene er røde (#7a1910 til #5c0f09 i gradient) med lys bevel oppe (#b2483a/#c0553c), mørk bunn (#2a0503) og gull småkaps-tekst. Filterflisene med aktiv grønn ramme («ALL») treffer kommandokort-idéen godt. Ingen trykket tilstand er vist, og flisene er rektangler (ca. 70x52), ikke kvadrater.
- **5:** Titlene er serif med kapitéler i gull (#e8c547/#f2d36b), og brødteksten er #e6dcc4. Overskriftene er sentrerte. Dette er riktig.
- **6:** Paletten holder seg til brunt, rødt, gull, beige, stein og svart. Blått og oransje finnes bare i små spillmerker. Grønt brukes bare for møtt/valgt.
- **7:** Skarpt, med jevne bevels og subtile skygger under knappene. Ikke flatt.
- **8:** Knapperaden øverst finnes i Veterans, men Lore har knappene nederst. Sentrert gul tittel og «Label: verdi»-linjer finnes i Lore-hodet.
- **9:** Kontrasten er god: sone-kolonnen #b4ab8e mot ca. #1a1006 gir ca. 8:1. Ingen tekst står rett på sprekkene uten panel bak, ingenting er avkuttet, og ingenting stikker ut av rammen.
- **10:** Det er klart samme system: identisk ramme, tekstur, knapper og merker. Men det er målbare avvik (se under).

## 3. Avvisningsfeil

1. **Tittelbåndet har ulik høyde i de to vinduene.**
   - *Hvor:* øverst i begge vinduene.
   - *Hva:* Målt i x=280 og x=840: tittelbåndet går fra y=31 til y=66 (36 px) i Veterans, men fra y=31 til y=70 (40 px) i Lore. Følgen er at lukkeknappen [X] sitter 2 px lavere i Lore (y=38–63 mot y=36–61), og titteltekstens grunnlinje er forskjøvet. Side om side, med like toppkanter, ser dette ut som to ulike komponenter. Det bryter direkte med punkt 10.
   - *Tiltak:* Bruk én felles klasse/konstant for tittelbåndet (f.eks. 36 px innvendig høyde) og lukkeknappen (26x26 px, 10 px fra høyre innerkant, vertikalt sentrert) i begge vinduene.

2. **De røde tekstknappene har to ulike varianter.**
   - *Hvor:* Journal/Memorials øverst i Veterans, og Related/Close nederst i Lore.
   - *Hva:*
     - Høyden er 31 px (y=77–107) i Veterans, men 35 px (y=604–638) i Lore.
     - Øvre bevel-lys er #c0553c i Veterans, men #b2483a i Lore (og på lukkeknappene).
     - Teksten i Lore-knappene er synlig større enn i Journal/Memorials.
   - *Tiltak:* Bruk én knappekomponent: én høyde (f.eks. 32 px), samme bevel-farger (velg #b2483a, slik at det matcher [X]) og samme skriftstørrelse. Hvis Journal/Memorials skal ha hover-tilstand, må den ikke vises som standard.

## 4. Mindre merknader

- **Spillmerker (tags) har tre størrelser og to stiler:**
  - I listen er de ca. 40x16 px.
  - I Lore-hodet er de ca. 44x18 px.
  - I seksjonsoverskriftene er de ca. 46x22 px.
  - BOOK-merket i seksjonen «Warcraft novels and books» har en kantlinje i gradient (lys til grå fra venstre mot høyre). WC3- og TFT-merkene i seksjonsoverskriftene har ensfarget kant.

  Gjør alle merkene ensfargede, og bruk helst to faste størrelser.
- **Knapperaden:** Veterans har knapperaden øverst (WC2-mønsteret Menu/Pause), mens Lore har den nederst. Det er forsvarlig for et detaljvindu, men en smal knapperad øverst i Lore (f.eks. «Related» og «Back») ville gitt mer samme struktur. «Close»-knappen dupliserer [X].
- **«Met»-etiketten** under portrettet er dempet gull (#c9a64a), mens alle andre etiketter er #e8c547 eller lysere. Bruk samme etikettfarge.
- **Møtt-status vises tre ganger i Lore-hodet:** grønn stolpe, «Met» og MET-merket. Ett av dem kan fjernes.
- **Underlaget:** Sprekkene bør variere mer i bredde og ha en svak lys kant på den ene siden (ca. #8a5a2a), slik at teksturen får jordflak-dybde som i B. Nå ligner den krakelert lakk.
- **Steinrammen** er nesten ensfarget. Legg på svak flekket støy (±6 % lyshet) for å nærme seg B.
- **Filterflisene** (ALL/WC2/...) er ikke kvadratiske. Det er akseptabelt, men nærmere 1:1 ville likne mer på kommandokortene.
- **Ingen trykket tilstand vises.** Det er ikke et krav i et statisk eksempelbilde, men i koden bør aktiv/trykket være en innfelt bevel med teksten flyttet 1 px.
- **Kontroller i koden:** [X], nedtrekkspilene, rullefeltpilene og rutertegnene i listen (◇ / grønn ◆) må være CSS-former eller SVG, ikke Unicode-glyfer (✕ ▼ ◇ ◆), jf. «Unngå»-listen. På bildet ser de tegnet ut (rutertegnene har gradient), men det kan ikke bekreftes ut fra pikslene.
- **Small caps for «Showing all 127 veterans»** i gull ved siden av kursiv grå «uncertain» blander to typografiske registre på én linje. Det er akseptabelt, men «uncertain» kunne vært beige (#e6dcc4), ikke grå (#b3ab89).

## 5. Konklusjon

**AVVIST.**

Mockupet ligger svært nær: ingen punkter er under 8, og det er likeverdig med eller bedre enn originalen målt mot målestokken. Men de to vinduene skal vises side om side som ett system, og det har to konkrete konsistensfeil: tittelbåndet er 36 px mot 40 px (med forskjøvet [X]), og det finnes to knappevarianter (31 px mot 35 px, ulik bevel-farge og tekststørrelse). Begge er billige å rette med felles komponenter. Etter retting og harmonisering av merkene forventes GODKJENT.

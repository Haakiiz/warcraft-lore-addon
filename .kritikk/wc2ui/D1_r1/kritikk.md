# Kritikk D1 runde 1: komponentark (stilsett)

Identifisering: B er den lavoppløste originalen (spillkart, enhetsportrett, ressurslinje). A er mockupet, et komponentark med tre vinduer: venstrepanel, Game Menu og Warcraft Lore.

## 1. Blindtest

**B** treffer målestokken best som WC2-grensesnitt. Sikkerhet: **75 %**.
A er nær og har riktig grammatikk: ramme, lær, innfelte paneler, røde knapper og gull serif. To ting avslører likevel A som en tolkning og ikke en remaster. Kommandokortene er nesten tomme linjeikoner, mens B har fullflate, malte ikoner. Lærunderlaget er et jevnt «tørket gjørme»-mønster, mens B har uregelmessige, dype sprekker. A er derfor ikke likeverdig ennå.

## 2. Poeng

| # | Punkt | A (mockup) | B (original) |
|---|-------|-----------:|-------------:|
| 1 | Underlag (lær/jord) | 8 | 9 |
| 2 | Ytre ramme | 8 | 9 |
| 3 | Innfelte paneler | 9 | 9 |
| 4 | Knapper (meny + kommandokort) | 7 | 9 |
| 5 | Typografi | 8 | 6 |
| 6 | Palett | 8 | 9 |
| 7 | Moderne finish | 9 | 3 |
| 8 | Struktur fra WC2 | 8 | 10 |
| 9 | Lesbarhet | 9 | 6 |
| 10 | Helhet | 8 | 10 |

Begrunnelse i korte trekk (A):
- **1:** Fargene stemmer (#3d260e–#5b3a16, sprekker rundt #1b1006). Mønsteret er likevel et nesten regelmessig Voronoi-nett med celler av lik størrelse og tynne sprekker. Referansen har bredere og mer uregelmessige sprekker med varierende dybde. Det ser mer ut som tørr jord enn som lær.
- **2:** Rammen er 11 px med riktig avfasing: lys #e4dcc7 oppe og til venstre, mørk #221c14/#0e0904 nede og til høyre, og en innfelt rille (#443d2f). Rammeflaten (#8a806b–#a89d88) er likevel helt jevn og nøytralt grå. Referansen (#7f6d48) er varmere og olivengull, med flekkete steintekstur.
- **3:** Panelene er riktige. Kanten er mørk #060302 oppe og til venstre og lys #b8ad94 nede og til høyre, og fyllet er #1a0f05 med svakt synlig tekstur. Bra.
- **4:** Menyknappene er gode. Flaten er #6b140c–#7a1a10, høylyset #b2483a oppe, skyggen #2a0503 nede, og teksten er gull. Trykket tilstand er innfelt, og teksten flytter seg 1 px. Kommandokortene er svake, se avvisningsfeil 1.
- **5:** Alegreya SC og Alegreya, sentrerte titler i gull #d9c547. Riktig valg. Sifrene er derimot gammeldagse (old-style), så «WC3» og «WC2» ser ut som senket skrift, se avvisningsfeil 2.
- **6:** Paletten holder seg innenfor brunt, rødt, gull, beige, stein, svart og grønt for valgt. Spillmerkene er små. Stoppskiltet (rød åttekant med hvit strek) er nær en ren primærfarge.
- **8:** Menu/Pause øverst, minikart, enhetsinfo og et 3x2 kommandogitter stemmer med WC2. Game Menu-vinduet med brede røde knapper og ressurspanel stemmer også.

## 3. Avvisningsfeil

1. **Kommandokortene er nesten tomme og ser ut som web-ikoner (venstre vindu, nederst, 3x2-gitteret ved y ≈ 405–510).**
   Hvert kort er ca. 56x48 px. Ikonet er en tynn, flat strektegning (bue med pil, skjold, hakke, piler, hammer, stoppskilt) som dekker bare 35–45 % av flaten, og resten er tom #1a0f05. I WC2 (B, nede til venstre) fyller et malt motiv med lys og skygge hele kortet, kant til kant. Hurtigtastbokstaven i gull nede til høyre (M, D, A, P, B, S) finnes heller ikke i WC2 og gjør at kortene ser ut som verktøylinjeknapper.
   **Tiltak:** Gjør ikonene 80–90 % av den indre flaten, med fylte former, egne høylys og skygger og en svak radial bakgrunn bak motivet (for eksempel #3a2814 → #1a0f05) i stedet for flatt svart. Bruk tykkere former (2,5–3 px konturer) og flere toner per ikon. Fjern hurtigtastbokstaven eller gjør den langt svakere (beige #e6dcc4 på 60 % opasitet, 9 px). Bytt stoppskiltet til mørkerødt #7c1a10 med beige symbol i stedet for ren rød og hvit.

2. **Gammeldagse sifre gjør at spillmerkene leses som senket skrift (alle merker og statlinjer).**
   «WC₃», «WC₂» i merkene (Lore-vinduet, øverst til høyre og i merkeraden ved y ≈ 306), «2 of 127» og «WC3, TFT» i enhetsinfoen, og «(S)» og ressurstallene i Game Menu. Med Alegreya SC synker 3-tallet under grunnlinjen, så «WC3» ser ut som «WC₃». Merkene er nettopp der spillnavnet skal leses raskt.
   **Tiltak:** Sett `font-variant-numeric: lining-nums tabular-nums;` på merker, statlinjer og ressurstall, eventuelt globalt.

## 4. Mindre merknader

- **Rammetekstur:** Rammeflaten er helt jevn. Legg på en svak, prosedyrisk flekkete steinstøy (±6 % lysstyrke) og trekk tonen mot varmere beige-oliven, omtrent #8f8466 → #9a8b68, så den ligner WC2-rammen mer.
- **Lærtekstur:** Variér cellestørrelsen mer (faktor 3–4 i stedet for omtrent 1,5), og gjør noen sprekker bredere (3–5 px) og mørkere (#120a03), så mønsteret blir mindre regelmessig.
- **Minikartet** (venstre vindu, øverst) har en rød kantlinje på omtrent 2 px (#8a1a10-aktig) innenfor den innfelte kanten. WC2 har bare den innfelte steinkanten. Fjern den røde linjen.
- **Stone- og Inset-knappene og lukkeknappen (X)** har lys grå-beige flate (#807761–#a89d88) med mørk tekst. De kommer ikke fra WC2 (orkiske knapper er røde) og ligger nær forbudet mot lyse grå flater. Begrens dem til X-knappen, eller gjør flaten mørkere (#5e5644) med gull tekst.
- **Unicode:** Kontroller at X-en i lukkeknappen, haken i «Hide book-only» og trekantene i rullefeltet er CSS eller SVG og ikke tegnene × ✓ ▲ ▼. Det kan ikke avgjøres fra bildet.
- **Disabled-knappen** har så lav tekstkontrast (omtrent #8a5a4a på #5c130c) at den nesten ikke leses. Det er akseptabelt for deaktivert tilstand, men hold kontrasten rundt 3:1.
- **Tittellinjene** («Game Menu», «Warcraft Lore») ligger i et eget mørkt bånd med en tynn rille under. Det fungerer, men WC2 sentrerer tittelen rett i panelet uten eget bånd. Vurder å gjøre båndet mindre markert.
- **Den valgte raden** i listen (Thrall) med grønn venstrestripe og grønnlig tone er bra og i tråd med regelen om grønt for valgt.
- **Portrettet** (hornhjelm) er et lite, flatt ikon i en tom ramme, med samme svakhet som kommandokortene. Det bør fylle rammen.

## 5. Konklusjon

**AVVIST.**
Punkt 4 (knapper) får 7, under kravet på 8. Det finnes to avvisningsfeil: tomme kommandokort og gammeldagse sifre i merkene. Mockupet ble heller ikke valgt i blindtesten. Grunnlaget er likevel sterkt: rammen, de innfelte panelene, de røde menyknappene og typografien er nær godkjent. Neste runde bør konsentrere seg om kommandokortene og portrettet (fylte, malte SVG-ikoner), sifrene og noe mer uregelmessighet i lær- og rammeteksturen.

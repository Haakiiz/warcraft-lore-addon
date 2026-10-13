# Målestokk: Warcraft II-stil for addonens vinduer (eksempelbilde)

Referanse: `.kritikk/referanse/wc2/ui01.png` (WC2 Battle.net Edition, orkisk grensesnitt; forstørret: `ui01_left_x3.png`).
Mål: Veterans- og Lore-vinduet skal se nesten identiske ut med WC2s grensesnitt og menyer, men med moderne finish
(skarp oppløsning, ren typografi, subtile skygger). Orkisk variant (addonen starter i Orgrimmar).
Dagens UI (det som skal erstattes): `media/screenshots/veterans-and-lore.png`. Innholdet og feltene beholdes.

## Kjennetegn ved referansen (punkter som scores 1–10)
1. **Underlag:** varm brun, sprukken lær-/jordtekstur (ca. #6b4423 / #4a2e16, mørkere sprekker #2a180a) fyller hele panelflaten. Synlig struktur, men rolig nok til at tekst i paneler leses lett.
2. **Ytre ramme:** tykk ramme (8–12 px) av grå-beige stein/metall med tydelig avfasing: lys kant oppe/venstre, mørk nede/høyre. Rammen skiller vinduet fra omgivelsene som i WC2.
3. **Innfelte paneler:** info-felter (minikart, enhetsinfo) er mørke flater (nær svart eller mørk brun, gjennomskinnelig over teksturen) med innfelt skrå kant: mørk oppe/venstre, lys grå-beige (#b8ad94-aktig) nede/høyre, 1–2 px.
4. **Knapper:** WC2-menyknapper: rektangulære, mørkerøde (#5a0e08–#7c1a10) med hevet bevel, gul/gull tekst sentrert ("Menu", "Pause"). Trykket/aktiv = innfelt bevel og tekst flyttet 1 px. Ikonknapper (kommandokort) = kvadratiske, mørk bunn, tynn grå bevel, aktiv = grønn ramme (#4cb84c) som i referansen.
5. **Typografi:** gul-gull tekst (#e8c547–#f2d36b) for titler, etiketter og knapper; lys beige (#e6dcc4) for lengre brødtekst. Klassisk serif (f.eks. Google Fonts «Cinzel» / «Alegreya SC» til titler, «Alegreya» eller «Spectral» til brødtekst), sentrerte overskrifter som i enhetsinfoen. Ingen pikselfont.
6. **Palett:** bare brunt, mørkerødt, gull/gul, beige, stein-grå, svart, + grønn kun for valgt/møtt. Spillfargene (WC2/WC3/TFT/FK/Book) bare som små merker.
7. **Moderne finish:** skarpe kanter i høy oppløsning, subtile skygger og lys på bevel, jevn spacing. Ikke en pikselkopi, men heller ikke «flat design».
8. **Struktur fra WC2:** knapperad øverst (som Menu/Pause), innfelte paneler stablet vertikalt, sentrert gul tittel, statlinjer «Label: verdi» sentrert, kvadratiske kommandoknapper nederst der det passer.
9. **Lesbarhet:** brødtekst har kontrast ≥ 4.5:1 mot sin bakgrunn; ingen tekst direkte over sprekker uten mørkt panel bak; ingen avkuttet tekst, ingenting stikker ut av rammen.
10. **Helhet:** ser ut som en remaster av WC2-menyene; begge vinduene er åpenbart samme system.

## Unngå (konkrete forbud)
- Den gamle stilen: fiolett/lilla, turkis, bladranker, rosetter.
- Avrundede hjørner over 2 px, piller, glassmorphism, neon/glød, gradient-vask over hele flater.
- Flate knapper eller paneler uten bevel.
- Hvite eller lyse grå flater; rene primærfarger; Inter/Roboto/Arial/system-ui.
- Emoji og Unicode-symboler (✓ ▼ ●). Bruk CSS-former eller inline SVG.
- Kopiert Blizzard-grafikk: ingen ekte WC2-teksturer, ikoner, portretter, logoer eller font. Alt lages selv (prosedyrisk tekstur, CSS, egen SVG).
- Pikselfont eller kunstig pikselering.

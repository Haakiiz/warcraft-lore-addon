# Målestokk: StarCraft 1-inspirert design system

Referansebilder (fra Håkon): `.kritikk/referanse/sc1/`
- `ref_mainmenu.png` – hovedmeny (glue screen) med oppgraderingsdialog. **De røde håndtegnede understrekene og kamera-ikonet nede til venstre er påtegninger fra skjermbildet, IKKE en del av designet.**
- `ref_terran_console.png` – Terran-konsollen i spillet (minimap, wireframe, portrett, kommandokort, ressurser oppe til høyre)
- `ref_gamemenu.png` – «Game Menu»-dialog i spillet + Terran-konsoll med statustekst
- `ref_battlenet.png` – Battle.net-innlogging (rustbrun metallramme, grønn LED-tekst)

## Kjennetegn (kritikeren gir 1–10 på hvert punkt)

1. **Palett og kontrast.** Nesten helt svarte flater (#000–#0a0a0a) med sterkt lysende tekst. Menytekst i gulgrønn (ca. #b8d84a / #c4e05a), statustall i klar grønn (ca. #30e030), dialog-knapper i blek gul/krem (ca. #f0e6a0), titler i lys grå/hvit. Aksentrammer: mørk rød/vinrød (#8a1010–#c02020) i hovedmenyen, kongeblå (#2030c0–#3848ff) i spillmenyen.
2. **Typografi.** Tynn, bred, geometrisk sans-serif i menyer (store bokstaver litt større enn små, «Single Player»-stil), svak glød/antialias, aldri fet. I konsollen: liten, ren, lys grå/hvit sans (enhetsnavn) og små grønne tall. Ingen serif utenom Battle.net-skjemaets små etiketter.
3. **Metallkonsoll (Terran).** Bunnpanel av mørk gråbrun/blågrå skrudd metall med skrå (45°) kanter, nagler, rør/ribber, gul-svarte fareskilt-striper, små røde/gule indikatorlys. Formen er en buet «dashbord»-silhuett, ikke et rektangel: minimap i en egen ramme til venstre, en senket svart skjerm i midten, et forhøyet portrett med «MENU»-skilt, og kommandokortet til høyre.
4. **Svarte innfelte skjermer.** Senkede, svarte «CRT»-flater med svakt avrundede/fasede hjørner (bare her), tydelig innfelt med mørk kant. Grønn trådmodell (wireframe) av enheten med HP «886/1000» i grønt under.
5. **Kommandokort 3×3.** Svarte firkantede ruter i en mørk ramme. Ikoner er enkle, tykke, lysende gule (#f0e020) eller grønne former (piler, kryss, verktøy) på svart, ofte innenfor en sirkel. Tomme ruter er svarte med en svak grønn «skanne»-tekstur.
6. **Ressurslinje.** Øverst til høyre: lite blått krystallikon + grønt tall, lite grønt gassbeholder-ikon + grønt tall, forsyningsikon + «94/94». Ingen bakgrunnsboks; teksten svever over kartet.
7. **Dialoger.** (a) Hovedmeny-dialog: svart flate, dobbel tynn ramme i grå + rød, knapper som rektangler med tynn rød kant og avrundede småhjørner, gulgrønn tekst. (b) Spillmeny: halvgjennomsiktig blå flate med fint rutemønster/skanlinjer, tynn blå kant, knapper som blå konturrektangler med blek gul tekst, tittel i hvit/lys grå.
8. **Glue screen.** Hovedmeny: mørkt verdensrom med stjerner og røde/lilla tåker, en stor planet nederst til venstre, menypunkter spredt fritt rundt (ikke i en liste i midten), en metallarm/ramme rundt et bildepanel oppe til høyre, versjonstekst nede til høyre.
9. **Battle.net-stil.** Rustbrun/kobberfarget, skitten metallplate med fasede kanter, smale innfelte svarte felt, grønn punktmatrise-/LED-tekst («Welcome to …»).
10. **Pikselfølelse og stemning.** 640×480-aktig skala: små detaljer, 1–2 px linjer, ingen myke, store uskarpe skygger. Litt slitt, industrielt, militært sci-fi.

## Forbudt (avvis hvis noe av dette finnes)

- Runde hjørner over 4 px (unntak: de innfelte CRT-skjermene og sirkelikonene)
- Moderne flat design, «glassmorphism», store myke box-shadows/blur, gradienter i neon-pastell
- Fete eller moderne UI-fonter (Inter, Roboto, system-ui) i menyer
- Emoji, Font Awesome, Material-ikoner
- Blizzard-/StarCraft-logoer, ordet «StarCraft» som merkevare, originalgrafikk, originalfonter, originallyd, portretter som kopierer kjente figurer
- Hvite eller lyse bakgrunnsflater
- Tekst som ikke lyser (matt grå tekst på svart der referansen har gulgrønt/grønt)
- Horisontal scrolling eller oppsett som brekker på 1280×720

## «Ferdig» betyr

Siden rendres uten konsollfeil i Chromium. Skjermbilde på 1280×720 legges ved. Kritikeren gir minst 8 på alle relevante punkter og velger resultatet (eller kaller det likeverdig) i blindtesten mot referansebildet.

## Tillegg: flere referanser (fra Håkon)
- `ref_mainmenu_clean.png` – hovedmeny uten dialog: rød tåke oppe til høyre, stor jordlignende planet nede til venstre med bylys, satellitt/romstasjon, blått ormehull ved «Exit», metallarm som holder et nyhetspanel (svart med tynn rød/grå ramme, grønne overskrifter). Menypunktene er i gulgrønn med svak skygge.
- `ref_briefing_room.png` – Terran-briefingrom: skittent flislagt rundt rom med rustrenner, små gule lamper i bur langs veggen, rør, en sentral maskin med flere svarte monitorer med grønn terminaltekst.
- `ref_protoss_console.png` – Protoss-konsoll: mørk, marmorert blåsvart plate, lysende cyan rørlinjer som rammer, gulltrim langs toppkanten, buet silhuett. Konsollteksten er som hos Terran («Psi Used: 42», grønt «750/750»), og tooltipen «Build Probe» viser mineral-/forsyningskostnad i en liten svart boks med blå kant.

11. **Briefing.** Mørkt industrirom (laget selv med CSS/canvas): monitor(er) med grønn terminaltekst som skrives ut tegn for tegn, portrettruter med statisk støy og en «Start»-knapp i samme stil som dialogknappene.

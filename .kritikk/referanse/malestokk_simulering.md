# Målestokk: «Sagaen om Warcraft Lore» (simulert suksess-tidslinje, scrollytelling)

Referanser:
- Struktur: `scrolly_pudding.jpg` (The Pudding, «Life After Death on Wikipedia»): sticky graf som fyller skjermen,
  tekstkort som scroller over, én hendelse annotert om gangen, graf som reagerer på scroll.
- Identitet: addonens egen stil (`media/logo.png`, `WarcraftLore/Style.lua`): natt-lilla grunn #120f1c/#100d18,
  fiolett #8b6cd6, turkis #2a6f68 (logo-ring lysere #3fb8a6), lavendel tittel #d4c6f7, tekst #d9d2c3, dempet #a79d8a,
  pergament #e8dcb5, spillfarger WC1 c9a46a · WC2 e0533f · BTDP b07cf0 · WC3 f0a24a · TFT 7cc7ef · FK 9bd46a · BOOK e8dcb5.

## Kriterier (1–10 hver)
1. **Første skjermbilde (hero):** slår an tonen med én gang: tittel, tese og et levende bilde av addonen/sagaen.
   Ser ut som noe et redaksjonelt studio har laget, ikke en mal. Hele heroen er synlig og komplett uten scroll-trigger.
2. **Scrollytelling-mekanikk:** sticky graf + kapittelkort som scroller, slik som i referansen. Grafen tegnes fram
   til kapittelets dato, aktiv versjon/milepæl annoteres, overgangene er myke. Fungerer også med musehjul raskt og på mobil.
3. **Graf-håndverk:** riktig skala, aksetekster som tilsvarer verdier grafen faktisk når, versjonsmarkører på tidsaksen,
   område-fyll, svakt rutenett, uthevet endepunkt, levende teller (downloads) som stemmer med grafen.
4. **Typografi:** karakterfull display-font brukt med måte, lesbar brødtekst (~65 tegn), tydelig skala, tall i tabular-nums.
5. **Farger og stemning:** bare paletten over. Turkis/fiolett som aksent, spillfarger som små aksenter. Mørk, rik,
   magisk, men behersket. God kontrast.
6. **Innhold:** troverdig og konkret: ekte startpunkt (første commit 2026-10-04, v0.1.0 2026-10-07, v0.2.0 2026-10-08),
   realistiske versjoner og tall for en vellykket WoW-addon, spillerkommentarer som høres ekte ut, både oppturer og en nedtur.
   Tydelig merket som simulering. Ingen lorem ipsum.
7. **Detaljer fra emnet:** ting bare dette emnet har (NPC-tellere, spillkoder WC1/WC2/WC3/TFT/FK/BOOK, sonenavn, /wcl-kommandoer, CurseForge-mekanikk).
8. **Polish og robusthet:** ingen overlapp, ingen tekst som klippes, ingen horisontal scroll ved 400 px, respekterer
   prefers-reduced-motion, ingen konsollfeil, synlig fokus.
9. **Helhet:** én sammenhengende visuell identitet fra topp til bunn; slutten lander (oppsummering/epilog).

## Unngå
- Generisk AI-look: krem+terrakotta, lilla→blå gradient-hero, Inter/Space Grotesk, alt sentrert, rounded-lg+skygge på alt, emoji som markører.
- Fantasy-klisjé: Cinzel/«Papyrus»-aktige fonter, falsk pergament-tekstur over hele siden, gull-glitter overalt.
- Blizzard-logoer, -ikoner, -grafikk eller -fonter (Morpheus/Friz). Lag egne former.
- Store neonglød-effekter, mer enn én animert «wow»-effekt samtidig.
- Graf som går ut av skala, uleselige akser, tall som ikke stemmer mellom teller og kort.
- Tekst over grafen som gjør begge uleselige.

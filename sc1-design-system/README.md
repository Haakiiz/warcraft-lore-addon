# STELLAR COMMAND – et designsystem i StarCraft 1-stil

Et lite designsystem i ren HTML, CSS og JavaScript som ser ut og føles som brukergrensesnittet i StarCraft 1 (1998). Det lager **stilen** på nytt fra bunnen av. Det inneholder ingen grafikk, logoer, fonter eller lyder fra originalspillet.

## Slik åpner du det (ingen installasjon trengs)

1. Åpne mappen `sc1-design-system` i filutforskeren (Windows) eller Finder (Mac).
2. Dobbeltklikk på **`index.html`**. Siden åpnes i nettleseren.
3. Klikk deg videre fra forsiden.

> Fontene lastes fra Google Fonts, så du må være på nett første gang. Uten nett ser teksten litt annerledes ut.

## Hva finnes her?

| Fil | Hva det er |
|---|---|
| `index.html` | Forsiden: hovedmeny med farger, typografi og rase-temaer |
| `components.html` | Katalog over alle byggeklossene: knapper, dialoger, metallpaneler, kommandokort, ressurslinje, tooltip |
| `patterns/main-menu.html` | Hovedmenyen (verdensrom, planet, ormehull, nyhetspanel). Klikk «Multiplayer» for å se en dialog |
| `patterns/ingame.html` | Spillskjerm med konsoll. Prøv `?race=protoss` eller `?race=zerg` på slutten av adressen. Trykk **F10** for spillmenyen og **Esc** for å lukke den |
| `patterns/battlenet.html` | Innloggingsskjerm med rustplate og LED-skilt |
| `patterns/briefing.html` | Briefingrom med tekst som skrives ut. Trykk **Enter** for å starte og **Esc** for å hoppe over |

## Bruke det i ditt eget prosjekt

Legg til disse linjene i `<head>` på HTML-siden din. Stien må peke dit du har lagt mappen.

```html
<link rel="stylesheet" href="sc1-design-system/css/tokens.css">
<link rel="stylesheet" href="sc1-design-system/css/components.css">
<script src="sc1-design-system/js/sc-audio.js"></script>  <!-- valgfritt: lydeffekter -->
```

Eksempel på en rød dialog med to knapper:

```html
<div class="sc-dialog sc-dialog--red">
  <div class="sc-dialog__body">A field update is ready!</div>
  <div class="sc-dialog__actions">
    <button class="sc-btn sc-btn--red">Upgrade</button>
    <button class="sc-btn sc-btn--red">Cancel</button>
  </div>
</div>
```

Du bytter rase ved å sette `data-race` på `<html>`: `terran` (standard), `protoss` eller `zerg`.

## Mappestruktur

- `css/tokens.css`: alle farger, fonter og størrelser som variabler (`--sc-…`). Det er her du endrer fargene.
- `css/components.css`: komponentene.
- `css/patterns.css`, `css/briefing.css`, `css/battlenet.css`, `css/index.css`: stilene for hver av sidene.
- `js/scene.js`: tegner verdensrommet, konsollene og terrenget.
- `js/sc-audio.js`: syntetiserte lydeffekter. Lydene lages i nettleseren, så det finnes ingen lydfiler.
- `MALESTOKK.md`, `TASKS.md`, `BRIEF_*.md`: notater fra arbeidsprosessen, med kriteriene og status per del.

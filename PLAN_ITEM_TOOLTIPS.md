# Plan – lore-tekst i item-tooltips

**Mål:** Når du holder musa over et item som hører til en veteran (f.eks. *Abominable Head* fra The Baron /
Othmar Garithos), får du en kort tekst om hvem det tilhører og hvorfor det er spesielt.
Det må aldri bli plagsomt, særlig ikke for gear du har på deg hele tiden.

## Slik ser det ut

Nederst i den vanlige item-tooltipen, i dempet farge, maks to linjer:

```
Abominable Head
Quest Item
...
Warcraft Lore: The Baron – var Othmar Garithos (TFT, Forsaken Kingdom)
Starter "Unending Torment". Faranell avslører hvem han egentlig var.
```

Ingen egen popup-rute: en ekstra boks som dukker opp ved siden av tooltipen er det som oftest oppleves som støy.
Det går i den tooltipen som allerede vises.

## Regler som hindrer at det blir plagsomt

1. **Gear vs. quest-items.** Er itemet utstyr (våpen/rustning, sjekkes med `C_Item.GetItemInfoInstant` / equipLoc),
   vises bare **én kort linje**: `Warcraft Lore: Thrall`. Hele teksten kommer bare når du holder **Shift**.
   Quest-items og hoder viser hele teksten (to linjer) som standard.
2. **Nytt først, kort etterpå.** De første 3 gangene du ser et item per karakter, vises full tekst; deretter bare
   én linje (Shift utvider). Telles i SavedVariables per item-ID.
3. **Bare hovedtooltipen.** `GameTooltip` og `ItemRefTooltip` (chat-lenker). Aldri i sammenligningstooltipene
   (`ShoppingTooltip1/2`), i tradeskill-lister eller i auksjonshuset sin rad-hover.
4. **Innstilling** i Options: *Item-lore i tooltips:* Full / Kort / Av. Standard: Full (med regel 1 og 2).
5. **Lengde:** `blurb` maks ~120 tegn, sjekkes av `tests/validate_db.py` (som NPC-tekstene sjekkes i dag).

## Data

- Nytt valgfritt felt per item i `Data.lua`: `blurb` = den korte tooltip-teksten. Uten `blurb` brukes første
  setning av `note`.
- Ved innlasting bygges en omvendt indeks `ns.ITEM_INDEX[itemID] = npcID` (ett item kan i teorien høre til to
  NPC-er; da vises begge navnene på én linje).
- **Innholdsrunde for items:** i dag har bare 6 av 168 veteraner items (7 items totalt). Kjør en runde over «Drops»- og
  «Quest»-seksjonene på warcraft.wiki.gg for alle veteraner, særlig Forever-NPC-er (de har nye drops).
  Samme oppsett som tidligere soner: Haiku-lesere + Haiku-kritiker + Opus-sjekk. Regelen gjelder fortsatt:
  ingen oppdiktede item-ID-er.

## Kode

| Fil | Endring |
|-----|---------|
| `Compat.lua` | `C.HookItemTooltip(callback)`: `TooltipDataProcessor` med `Enum.TooltipDataType.Item` (data.id); reserve `OnTooltipSetItem` + `GetItem()` for Classic Era-klienten. Alt i `pcall`, samme mønster som `HookUnitTooltip`. |
| `Core.lua` | Bygger `ITEM_INDEX`, legger til linjene, teller visninger, sjekker Shift (`IsShiftKeyDown`). |
| `Options.lua` / `SavedData.lua` | Innstillingen Full/Kort/Av og visningstelleren. |
| `Locales/*` | «Warcraft Lore: %s» og innstillingstekstene (en/de/fr). Selve `blurb`-tekstene er engelske, som `note` i dag. |
| `tests/` | `test_item_tooltip.py` (indeks, gear = én linje, telleren, Shift, av-bryter); `validate_db.py` sjekker `blurb`-lengde. |
| `tools/uishots` | Skjermbilde av en quest-item-tooltip og en gear-tooltip; sjekk PNG-ene. |

## Mulig utvidelse (senere)

- Shift-klikk på et slikt item åpner lore-vinduet til veteranen.
- Å loote et veteran-item teller som et «møte» i Journalen (eget lite achievement for f.eks. 10 items).

## Rekkefølge

1. [x] Compat-hook + indeks + én linje (Kort) – raskt å teste i spillet. (`tests/test_item_tooltip.py`,
   skjermbilde `item_tip`)
2. [x] Full tekst, gear-regel, teller, Shift, innstilling (2026-11-28; innstillingen er to avkrysningsbokser).
3. [x] Tester og skjermbilder.
4. [x] Item-innholdsrunden (2026-11-28): 363 nye items for 97 veteraner, se `.kritikk/ITEMS/REVIEW.md`.

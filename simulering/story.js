/* Sagaen om Warcraft Lore: data for den simulerte tidslinjen.
   Alt t.o.m. 2026-10-09 er ekte (commit-logg, v0.1.0, v0.2.0). Alt etter er simulert.
   Ren data, ingen DOM. Månedstall er skrevet inn for hånd; total og active er avledet
   (total = kumulativ sum, active = 0.88 * forrige + 0.30 * downloads, rundet til tiere). */
(function () {
  "use strict";

  // [måned, downloads, veteraner ved månedsslutt, snittvurdering]
  var RAW = [
    ["2026-10",    640, 128, null],
    ["2026-11",   1850, 151, 4.6],
    ["2026-12",   3100, 174, 4.7],
    ["2027-01",   4300, 198, 4.7],
    ["2027-02",  19800, 212, 4.7],
    ["2027-03",  27500, 226, 4.7],
    ["2027-04",  22600, 262, 4.8],
    ["2027-05",  21400, 268, 4.8],
    ["2027-06",  30800, 331, 4.8],
    ["2027-07",  26900, 340, 4.8],
    ["2027-08",  23700, 347, 4.8],
    ["2027-09",  41200, 392, 4.8],
    ["2027-10",  47800, 399, 4.8],
    ["2027-11",  52600, 431, 4.8],
    ["2027-12",  57400, 438, 4.8],
    ["2028-01",  64800, 482, 4.8],
    ["2028-02",  72100, 489, 4.8],
    ["2028-03",  42000, 493, 4.6],
    ["2028-04",  12800, 493, 4.4],
    ["2028-05",  31700, 497, 4.4],
    ["2028-06",  60100, 561, 4.6],
    ["2028-07",  69000, 568, 4.7],
    ["2028-08",  64100, 574, 4.7],
    ["2028-09",  80600, 603, 4.7],
    ["2028-10",  86600, 609, 4.8],
    ["2028-11",  91700, 615, 4.8],
    ["2028-12",  96900, 644, 4.8],
    ["2029-01", 100800, 648, 4.8],
    ["2029-02", 103300, 652, 4.8],
    ["2029-03", 107800, 668, 4.8],
    ["2029-04", 104200, 672, 4.8],
    ["2029-05", 100800, 676, 4.8],
    ["2029-06",  94500, 679, 4.8],
    ["2029-07",  92700, 691, 4.8],
    ["2029-08", 103800, 694, 4.8],
    ["2029-09", 111500, 712, 4.9],
    ["2029-10", 116400, 716, 4.9]
  ];

  // EKTE tall fra CurseForge (https://www.curseforge.com/wow/addons/rts-veterans), «Total Downloads».
  // Legg til én linje hver gang du sjekker: ["dato", totalt antall nedlastinger].
  // Siste linje bestemmer «i dag» i grafen. Første linje er startpunktet før v0.1.0 ble lastet opp.
  var ACTUAL = [
    ["2026-10-06",  0],
    ["2026-10-15", 59],
    ["2026-10-20", 69],
    ["2026-10-25", 73]
  ];
  // Filene på CurseForge: [versjon, opplastet, nedlastinger per fil (sist sjekket), kort navn].
  var ACTUAL_FILES = [
    ["0.1.0",       "2026-10-07",  2, "Første slipp"],
    ["0.2.0",       "2026-10-08",  2, "Soner til level 30"],
    ["0.3.0",       "2026-10-09",  6, "Veteranlisten og minikartknapp"],
    ["0.4.0-beta1", "2026-10-10",  3, "Relaterte veteraner (beta)"],
    ["0.4.0-beta2", "2026-10-10",  6, "Relaterte veteraner (beta)"],
    ["0.6.0-beta1", "2026-10-11",  4, "Kartnåler og sone-atlas (beta)"],
    ["0.6.0",       "2026-10-11",  5, "33 nye veteraner, kartnåler, sone-atlas"],
    ["0.6.1",       "2026-10-11",  9, "Lore-rettelser"],
    ["0.7.0-beta1", "2026-10-12",  4, "Lore Journal (beta)"],
    ["0.7.0-beta2", "2026-10-12",  6, "Lore Journal (beta)"],
    ["0.7.0",       "2026-10-12",  9, "Lore Journal, achievements, tysk og fransk"],
    ["0.8.0",       "2026-10-13",  6, "Warcraft II-utseendet"],
    ["0.8.1",       "2026-10-16", 11, "Filtre for minnesmerker, Ansirem"]
  ];

  function dayText(d) {
    var m = ["januar", "februar", "mars", "april", "mai", "juni", "juli", "august", "september", "oktober", "november", "desember"];
    return (+d.slice(8, 10)) + ". " + m[+d.slice(5, 7) - 1] + " " + d.slice(0, 4);
  }

  var total = 0, active = 0;
  var months = RAW.map(function (r) {
    total += r[1];
    active = Math.round((active * 0.88 + r[1] * 0.30) / 10) * 10;
    return { m: r[0], downloads: r[1], total: total, active: active, npcs: r[2], rating: r[3] };
  });

  window.STORY = {
    title: "Sagaen om Warcraft Lore",
    subtitle: "En simulert tidslinje over tre år: fra første commit til to millioner nedlastinger, hvis alt går riktig vei for en liten addon om Warcrafts gamle navn.",
    today: ACTUAL[ACTUAL.length - 1][0],

    // Ekte tall, tegnet som egen strek oppå den simulerte kurven (se CONTRACT.md, «STORY.actual»).
    actual: {
      source: "CurseForge",
      checked: ACTUAL[ACTUAL.length - 1][0],
      points: ACTUAL.map(function (r, i) { return { date: r[0], total: r[1], measured: i > 0 }; }),
      releases: ACTUAL_FILES.map(function (r) {
        return { v: r[0], date: r[1], downloads: r[2], name: r[3], beta: /-beta/.test(r[0]) };
      }),
      // Funksjoner planen hadde langt fram i tid, og når de faktisk kom (versjon i planen → ekte versjon).
      features: [
        { label: "Veteranlisten (/wcl list)", plan: "0.3.0", real: "0.3.0" },
        { label: "Kartnåler for veteraner", plan: "0.4.0", real: "0.6.0" },
        { label: "Tysk og fransk", plan: "0.5.0", real: "0.7.0" },
        { label: "Achievements", plan: "0.6.0", real: "0.7.0" },
        { label: "Lore Journal", plan: "1.0.0", real: "0.7.0" },
        { label: "Sone-atlas", plan: "1.1.0", real: "0.6.0" },
        { label: "Eksport og import av møtt-listen", plan: "1.3.0", real: "0.6.0" }
      ]
    },

    months: months,
    // Ekte målepunkter før første månedsslutt (se CONTRACT.md, «Verdi på en vilkårlig dato»).
    anchors: [
      { date: "2026-10-04", total: 0, active: 0, npcs: 36 },
      { date: "2026-10-07", total: 0, active: 0, npcs: 43 },
      { date: "2026-10-08", total: 165, active: 120, npcs: 128 }
    ],

    releases: [
      { v: "0.1.0", date: "2026-10-07", name: "Første slipp", major: false,
        highlights: [
          "Tooltip-linje på kjente NPC-er, én farge per spill",
          "Lore-vindu med rundt portrett som gløder i spillets farge",
          "Nærhetsvarsel via navneskilt og kartkoordinater, med toast og /wcl test",
          "Bok- og romankoblinger merket BOOK, aldri utgitt som spillopptreden"
        ] },
      { v: "0.2.0", date: "2026-10-08", name: "Soner til level 30", major: false,
        highlights: [
          "24 soner og dungeons opp til level 30",
          "Mange nye bokkoblinger, blant annet Rexxar og Misha",
          "Nye oppføringer i Orgrimmar, Durotar, Ashenvale, Hillsbrad og Stormwind",
          "Databasen passerer 120 veteraner"
        ] },
      { v: "0.3.0", date: "2026-11-03", name: "Veteranlisten", major: false,
        highlights: [
          "/wcl list: bla gjennom alle veteraner, søk på navn, filtrer på spill, sone og kampanje",
          "Møtt-teller per karakter, for eksempel WC3 12/40",
          "Relaterte NPC-er: følg tråden Thrall, Grom, Nazgrel",
          "Mount Hyjal (Renewed) dekket"
        ] },
      { v: "0.4.0", date: "2026-12-06", name: "Veteraner på kartet", major: false,
        highlights: [
          "Kartnåler for veteraner på verdenskartet, farget etter spill",
          "Shen'dralas og Riverglades",
          "Minikartknapp som åpner veteranlisten"
        ] },
      { v: "0.5.0", date: "2027-01-18", name: "Første oversettelser", major: false,
        highlights: [
          "Tysk (deDE) og fransk (frFR), levert av to bidragsytere",
          "Språkvalg i innstillingene, uten omstart",
          "Lore-tekster lastes per språk for å spare minne"
        ] },
      { v: "0.6.0", date: "2027-02-09", name: "Veteranjegeren", major: false,
        highlights: [
          "Achievements for å møte veteraner: per spill, per sone og totalt",
          "Toast når du fullfører et spill, for eksempel alle WC2-veteraner",
          "Fikset krasj ved målvalg i dungeons"
        ] },
      { v: "0.7.0", date: "2027-04-13", name: "Zephras Isle og Dalaran", major: false,
        highlights: [
          "Zephras Isle og Dalaran åpnet i databasen",
          "Spansk (esES) og russisk (ruRU)",
          "Kampanjefilter viser mission-navn fra WC2 og WC3"
        ] },
      { v: "1.0.0", date: "2027-06-15", name: "Level 40 og Lore Journal", major: true,
        highlights: [
          "Dekker alle soner til level 40",
          "Lore Journal: egen fane med sider du låser opp ved å møte veteraner",
          "Ny innstillingsside og /wcl reset for vinduer",
          "Rundt 300 veteraner"
        ] },
      { v: "1.1.0", date: "2027-09-07", name: "Sone-atlas", major: false,
        highlights: [
          "Sone-atlas: sjekkliste over veteraner per sone",
          "Høyreklikk på en nål for å spore en veteran med pil",
          "Raskere åpning av veteranlisten med over 350 oppføringer"
        ] },
      { v: "1.2.0", date: "2027-11-16", name: "Flere klienter", major: false,
        highlights: [
          "Egne bygg for Classic Era og Retail ved siden av Forever",
          "Delt kjerne, slik at lore-tekstene er like overalt",
          "Varsler samles til ett når mange veteraner står i samme by, så skjermen henger mindre"
        ] },
      { v: "1.3.0", date: "2028-01-25", name: "Konto-teller", major: false,
        highlights: [
          "Kontodekkende møtt-teller delt mellom alle karakterer",
          "Eksport og import av møtt-listen som tekststreng",
          "Forbedret søk med delvis treff på navn med apostrof, som Mug'thol og Mok'Morokk"
        ] },
      { v: "1.3.1", date: "2028-05-02", name: "Tilbake på beina", major: false,
        highlights: [
          "Tilpasset ny Forever-API etter at patchen i mars brøt navneskilt-varslene",
          "Fiks for Lua-feil i veteranlisten og nærhetsvarselet",
          "Manglende lore-sider fra 1.3.0 gjenopprettet"
        ] },
      { v: "2.0.0", date: "2028-06-20", name: "Omskrevet for level 50", major: true,
        highlights: [
          "Hele UI-et er skrevet om på ny Forever-API",
          "Dekker alle soner til level 50, rundt 540 veteraner",
          "Portrettene lastes i sanntid fra spillet",
          "Ryddigere veteranliste med fast topplinje og møtt-teller per spill"
        ] },
      { v: "2.1.0", date: "2028-09-12", name: "Lore-stier", major: false,
        highlights: [
          "Lore-stier: guidede tråder som Thrall til Orgrimmar, Arthas til Northrend",
          "Hver sti gir en kort fortelling mellom kapitlene i RTS-kampanjene",
          "Nytt filter for BOOK-oppføringer"
        ] },
      { v: "2.2.0", date: "2028-12-05", name: "Tre nye språk", major: false,
        highlights: [
          "Portugisisk (ptBR), koreansk (koKR) og forenklet kinesisk (zhCN)",
          "Fontstøtte for CJK i lore-vinduet",
          "Alle åtte språk (engelsk og sju oversettelser) valgbare fra minikartknappen"
        ] },
      { v: "3.0.0", date: "2029-03-20", name: "Lore Journal 2", major: true,
        highlights: [
          "Ny Lore Journal: fulltekstsøk på tvers av alle veteraner og kilder",
          "Dekker alle soner til level 60",
          "Over 660 veteraner",
          "Eget bidragsformat, slik at fellesskapet kan sende inn rettelser"
        ] },
      { v: "3.1.0", date: "2029-07-10", name: "Lore Week", major: false,
        highlights: [
          "Ny hendelse, Lore Week: dobbel møtt-teller og egne achievements",
          "Delbare veterankort som lim-inn-tekst i chatten",
          "Bedre ytelse i Dalaran"
        ] },
      { v: "3.2.0", date: "2029-09-25", name: "Treårsutgaven", major: false,
        highlights: [
          "Rundt 710 veteraner",
          "Mest møtte veteraner vises som statistikk i Lore Journal",
          "Rydding av gamle innstillinger fra 0.x-versjonene"
        ] }
    ],

    events: [
      { date: "2026-10-04", label: "Første commit: tooltip-linje og lore-vindu for 36 NPC-er", kind: "milestone" },
      { date: "2026-10-07", label: "v0.1.0 slippes på CurseForge", kind: "milestone" },
      { date: "2027-02-02", label: "Featured på CurseForge, og fire dager senere viser en lore-YouTuber med 400 000 abonnenter den", kind: "press" },
      { date: "2027-04-06", label: "Forever-patch åpner Zephras Isle og Dalaran", kind: "expansion" },
      { date: "2027-05-30", label: "100 000 nedlastinger", kind: "milestone" },
      { date: "2027-06-08", label: "Forever hever level cap til 40", kind: "expansion" },
      { date: "2027-09-04", label: "Streamer starter ukelangt maraton for å møte alle veteraner, og skolestart samler spillerne igjen", kind: "press" },
      { date: "2028-03-14", label: "Forever-patch bryter navneskilt-API-et, addonen kaster Lua-feil", kind: "dip" },
      { date: "2028-04-20", label: "Utvikleren tar pause etter fem uker med feilrapporter", kind: "dip" },
      { date: "2028-06-13", label: "Forever hever level cap til 50", kind: "expansion" },
      { date: "2028-11-12", label: "1 000 000 nedlastinger", kind: "milestone" },
      { date: "2029-03-06", label: "Forever hever level cap til 60 med nye soner", kind: "expansion" },
      { date: "2029-07-10", label: "Første Lore Week, over 60 bidragsytere totalt", kind: "community" },
      { date: "2029-09-11", label: "2 000 000 nedlastinger", kind: "milestone" }
    ],

    chapters: [
      {
        id: "forge", date: "2026-10-04",
        kicker: "Oktober 2026 · Første commit",
        title: "Én kveld, 36 veteraner",
        body: "Fjerde oktober legger utvikleren inn første commit: en tooltip-linje og et lite lore-vindu for 36 NPC-er som også finnes i Warcraft-spillene. Samme dag kommer bokkoblinger for Mok'Morokk og Nazgrel, og et varsel som slår til når en veteran dukker opp på navneskiltet. Ideen er enkel: du møter en tilfeldig quest-giver på level 15 og får vite at han sto i et WC2-oppdrag.",
        stat: { label: "veteraner ved første commit", value: 36 },
        quotes: [],
        release: null, tone: "spark"
      },
      {
        id: "slipp", date: "2026-10-08",
        kicker: "Oktober 2026 · v0.1.0 og v0.2.0",
        title: "Ut på CurseForge",
        body: "7. oktober tagges v0.1.0 og pakkes automatisk til CurseForge. Dagen etter kommer v0.2.0 med 24 soner opp til level 30 og bokkoblinger for Rexxar og Misha. De første dagene gir bare et par hundre nedlastinger, nesten alle fra en Reddit-tråd om Forever-betaen.",
        stat: { label: "nedlastinger totalt", value: 165 },
        quotes: [
          { who: "Thraxx_gaming", src: "CurseForge", text: "Walked past Gazlowe in Ratchet and the tooltip said WC3. Tiny addon, big grin." }
        ],
        release: "0.2.0", tone: "spark"
      },
      {
        // dato og tall følger siste linje i ACTUAL
        id: "fasit", date: ACTUAL[ACTUAL.length - 1][0],
        kicker: dayText(ACTUAL[ACTUAL.length - 1][0]) + " · ekte tall",
        title: "Virkeligheten så langt",
        body: "Her slutter fiksjonen et øyeblikk. Den lyse streken i grafen er de ekte tallene fra CurseForge: " +
          ACTUAL[ACTUAL.length - 1][1] + " nedlastinger fordelt på " + ACTUAL_FILES.length + " filer, mot flere hundre i planen. " +
          "Nedlastingene går altså mye tregere enn modellen. Utviklingen går derimot mye fortere: Lore Journal, achievements, " +
          "kartnåler og tysk og fransk lå i planen for 2027, men kom alle før 13. oktober 2026.",
        stat: { label: "ekte nedlastinger på CurseForge", value: ACTUAL[ACTUAL.length - 1][1] },
        quotes: [],
        release: null, tone: "crown"
      },
      {
        id: "kjeder", date: "2026-11-03",
        kicker: "November 2026 · v0.3.0",
        title: "Veteranlisten åpner",
        body: "Med /wcl list får spillerne en komplett liste over veteraner, med søk og filtre. Møtt-telleren husker hvem du har truffet per karakter, og kjeden Thrall, Grom og Nazgrel lar deg følge en lore-tråd fra NPC til NPC. Mount Hyjal (Renewed) er dekket fra første dag.",
        stat: { label: "nedlastinger totalt", value: 825 },
        quotes: [
          { who: "lorewarden_kjell", src: "Reddit", text: "Small correction: Cairne is in RoC and TFT, not only TFT. Otherwise this is exactly what I wanted." },
          { who: "Bluebell_Hunts", src: "CurseForge", text: "Window pops up every time I target something. Annoying until I found /wcl auto. Maybe say that on the page?" }
        ],
        release: "0.3.0", tone: "rise"
      },
      {
        id: "kart", date: "2026-12-06",
        kicker: "Desember 2026 · v0.4.0",
        title: "Veteraner på kartet",
        body: "Kartnåler markerer hvor hver veteran står, farget etter spillet de kommer fra. Shen'dralas og Riverglades får egne oppføringer, og en minikartknapp åpner listen. Desember ser ut til å passere 3 000 nedlastinger, og på WoWInterface ligger snittvurderingen på 4,7 etter de første vurderingene i november.",
        stat: { label: "nedlastinger totalt", value: 3090 },
        quotes: [
          { who: "ShenDralasEnjoyer", src: "Discord", text: "Pins on the world map are a massive upgrade. Could you add a filter so I only see WC2 guys?" }
        ],
        release: "0.4.0", tone: "rise"
      },
      {
        id: "sprak", date: "2027-01-18",
        kicker: "Januar 2027 · v0.5.0",
        title: "Tysk og fransk",
        body: "To bidragsytere sender inn deDE og frFR, og lore-tekstene lastes per språk. Det er første gang addonen får pull requests fra folk utvikleren aldri har møtt. På GitHub ligger fire åpne issues fra spillere som ber om flere veteraner i Dalaran.",
        stat: { label: "nedlastinger totalt", value: 8087 },
        quotes: [
          { who: "Brunhild_77", src: "GitHub", text: "Added deDE. Pls check the umlauts in Thrall's page, my keyboard fought me." }
        ],
        release: "0.5.0", tone: "rise"
      },
      {
        id: "featured", date: "2027-02-09",
        kicker: "Februar 2027 · v0.6.0",
        title: "Forsiden på CurseForge",
        body: "2. februar velger CurseForge addonen som Featured, og fire dager senere viser en lore-YouTuber med 400 000 abonnenter den i en video om «Warcraft-karakterer du går forbi». v0.6.0 med achievements for å møte veteraner kommer midt i flommen. Februar ser ut til å ende på nesten fem ganger så mange nedlastinger som januar.",
        stat: { label: "nedlastinger i februar", value: 19800 },
        quotes: [
          { who: "Archivist_Moa", src: "Twitch", text: "Chat, look, it says Sylvanas was in WC3 and in a book. I need all the achievements." },
          { who: "gnomeengineer42", src: "CurseForge", text: "Found this from a video. Installed in 10 seconds, already met 14 vets." }
        ],
        release: "0.6.0", tone: "storm"
      },
      {
        id: "oyer", date: "2027-04-13",
        kicker: "April 2027 · v0.7.0",
        title: "Zephras Isle og Dalaran",
        body: "Forever-patchen 6. april åpner Zephras Isle og Dalaran, og v0.7.0 har veteranene klare, med esES og ruRU. Uther og Antonidas får sider fra Reign of Chaos, Sylvanas fra begge Warcraft III-spillene. Månedstallene flater ut, men anslagsvis 17 700 installasjoner er aktive.",
        stat: { label: "aktive installasjoner", value: 17672 },
        quotes: [
          { who: "ruslan_orc", src: "Reddit", text: "Russian translation reads great. Please keep Thrall's title as Warchief, not the literal one." }
        ],
        release: "0.7.0", tone: "rise"
      },
      {
        id: "versjon-en", date: "2027-06-15",
        kicker: "Juni 2027 · v1.0.0",
        title: "1.0 med level 40",
        body: "8. juni hever Forever level cap til 40, og 15. juni kommer v1.0.0 med alle nye soner og Lore Journal, en egen fane med sider som låses opp når du møter veteraner. Databasen når 300 veteraner. Beta-merkelappen forsvinner fra CurseForge-siden, etter at 100 000-merket falt i slutten av mai.",
        stat: { label: "nedlastinger totalt", value: 116590 },
        quotes: [
          { who: "Orgrim_Doomer", src: "Wowhead", text: "1.0 and it finally shows Mug'thol in the journal. Took you long enough, but it's perfect." },
          { who: "bugsnuffler", src: "GitHub", text: "Journal tab doesn't scroll with the mouse wheel when the list is long. Using 1.0.0 on Forever." }
        ],
        release: "1.0.0", tone: "storm"
      },
      {
        id: "atlas", date: "2027-09-07",
        kicker: "September 2027 · v1.1.0",
        title: "Etter sommerstillheten",
        body: "Juli og august er rolige: halve fellesskapet er på ferie, og utvikleren også. Så starter en streamer et ukelangt maraton for å møte alle veteraner, skolen begynner, og september havner 74 prosent over august. 7. september kommer v1.1.0 med sone-atlas, en sjekkliste per sone med en pil mot den du jakter på.",
        stat: { label: "nedlastinger i september", value: 41200 },
        quotes: [
          { who: "dalaran_dave", src: "Discord", text: "3 left in hillsbrad and cant find any, r they bugged?? otherwise gr8" },
          { who: "Mara_of_Elwynn", src: "CurseForge", text: "Atlas freezes for a second when I open it. Fine on my desktop, bad on my laptop." }
        ],
        release: "1.1.0", tone: "rise"
      },
      {
        id: "plattformer", date: "2027-11-16",
        kicker: "November 2027 · v1.2.0",
        title: "Classic og Retail",
        body: "En delt kjerne gjør at addonen nå bygges for Classic Era og Retail ved siden av Forever. Lore-tekstene er de samme overalt, og Cairne, Gazlowe og Rexxar følger deg uansett klient. Databasen har rundt 416 veteraner.",
        stat: { label: "veteraner i databasen", value: 416 },
        quotes: [
          { who: "mulgore_mike", src: "Reddit", text: "Works on Classic Era too now. Spotted Cairne in Thunder Bluff, got the WC3 line, felt like 2002." }
        ],
        release: "1.2.0", tone: "rise"
      },
      {
        id: "konto", date: "2028-01-25",
        kicker: "Januar 2028 · v1.3.0",
        title: "Telleren følger kontoen",
        body: "Den kontodekkende møtt-telleren gjør at alt du har møtt på hovedkarakteren teller på alle alts. Møtt-listen kan eksporteres som tekststreng og deles. Over 430 000 har nå lastet ned addonen, og køen av oversettelses-PR-er venter på gjennomgang.",
        stat: { label: "nedlastinger totalt", value: 433848 },
        quotes: [
          { who: "Sylvie_Windrunner", src: "WoWInterface", text: "Account-wide counter was the one thing missing. 5 stars, now go sleep." }
        ],
        release: "1.3.0", tone: "rise"
      },
      {
        id: "brudd", date: "2028-03-14",
        kicker: "Mars 2028 · patch",
        title: "Patchen som knakk navneskiltene",
        body: "14. mars endrer Forever hvordan navneskilt og GUID-er eksponeres. Nærhetsvarselet kaster Lua-feil for alle som har det slått på, og feilrapportene hoper seg opp på CurseForge og GitHub. De første 13 dagene av mars gir rundt 33 000 nedlastinger, resten av måneden knapt 9 000, og snittvurderingen på WoWInterface synker fra 4,8 til 4,6.",
        stat: { label: "nedlastinger i mars", value: 42000 },
        quotes: [
          { who: "taintedtauren", src: "GitHub", text: "Lua error on every nameplate event since the patch. attempt to index a secret value. Please fix." },
          { who: "elune_help", src: "CurseForge", text: "Broke my UI after the patch, had to disable it. Loved it before though." }
        ],
        release: null, tone: "fall"
      },
      {
        id: "pause", date: "2028-04-20",
        kicker: "April 2028",
        title: "Utvikleren går tom",
        body: "Fem uker med feilrapporter midt i en eksamensperiode som ikke lar seg flytte ender i en pause. Det blir ingen commit på tre uker. April stopper på 12 800 nedlastinger, vurderingen er nede på 4,4, og en Reddit-tråd spør om addonen er død.",
        stat: { label: "nedlastinger i april", value: 12800 },
        quotes: [
          { who: "Anduin_fan_92", src: "Reddit", text: "Is Warcraft Lore abandoned? Last update was Jan and it breaks on 3 of my 5 chars." }
        ],
        release: null, tone: "fall"
      },
      {
        id: "gjenreisning", date: "2028-05-02",
        kicker: "Mai 2028 · v1.3.1",
        title: "Tre bidragsytere tar over",
        body: "Tre fellesskapsutviklere som har fulgt GitHub-repoet sender inn fiksene før utvikleren er tilbake. 2. mai kommer v1.3.1 med ny navneskilt-logikk og gjenopprettede lore-sider. Anslagsvis aktive installasjoner har sunket fra rundt 96 000 midt i mars til 89 000, fordi mange slo addonen av i stedet for å avinstallere den, og de slår den på igjen når feilen er borte.",
        stat: { label: "aktive installasjoner", value: 88885 },
        quotes: [
          { who: "Brunhild_77", src: "GitHub", text: "Opened a PR for the secret GUID thing. It is ugly but it works, merge it if you want." },
          { who: "taintedtauren", src: "GitHub", text: "1.3.1 fixed it. No more errors. Thanks to everyone who stayed around." }
        ],
        release: "1.3.1", tone: "rise"
      },
      {
        id: "omskrevet", date: "2028-06-20",
        kicker: "Juni 2028 · v2.0.0",
        title: "Skrevet om for level 50",
        body: "Forever setter level cap til 50 13. juni, og 20. juni kommer v2.0.0: hele UI-et er skrevet om for det nye API-et, med rundt 540 veteraner og portretter som lastes direkte fra spillet. Juni blir nesten dobbelt så stor som mai.",
        stat: { label: "nedlastinger i juni", value: 60100 },
        quotes: [
          { who: "NerubianNick", src: "Wowhead", text: "2.0 is smooth. Veteran list opens instantly and the new portraits look way better." }
        ],
        release: "2.0.0", tone: "storm"
      },
      {
        id: "stier", date: "2028-09-12",
        kicker: "September 2028 · v2.1.0",
        title: "Lore-stier",
        body: "v2.1.0 introduserer guidede lore-stier: følg Thrall til Orgrimmar, eller Arthas fra Lordaeron til Northrend, med en kort fortelling for hvert stopp mellom RTS-kampanjene. Hver sti ender med en achievement. Databasen har rundt 586 veteraner.",
        stat: { label: "veteraner i databasen", value: 586 },
        quotes: [
          { who: "lore_nerd_og", src: "Reddit", text: "The Arthas trail has one wrong date: Frostmourne scene is Reign of Chaos, not TFT. Great otherwise." }
        ],
        release: "2.1.0", tone: "rise"
      },
      {
        id: "tre", date: "2029-03-20",
        kicker: "Mars 2029 · v3.0.0",
        title: "Lore Journal 2",
        body: "Level cap 60 kommer 6. mars, men mars gir bare fire prosent flere nedlastinger enn februar, mot nesten en dobling ved cap 50. De fleste Forever-spillere har addonen allerede, så veksten kommer nå fra nye spillere og oppdateringer. 20. mars kommer v3.0.0 med fulltekstsøk og et bidragsformat for rettelser, og over 40 mennesker har levert kode, oversettelser eller lore-rettelser.",
        stat: { label: "veteraner i databasen", value: 662 },
        quotes: [
          { who: "mug_thol_main", src: "Discord", text: "Searched 'goblin' and got every vet from Gazlowe to the book ones. This is wiki-level stuff now." },
          { who: "Brunhild_77", src: "GitHub", text: "Sent in a lore fix via the new format. It got merged in an hour. Love it." }
        ],
        release: "3.0.0", tone: "rise"
      },
      {
        id: "crown", date: "2029-10-09",
        kicker: "Oktober 2029 · v3.2.0",
        title: "Tre år senere",
        body: "Tre år etter første commit har Warcraft Lore over 2,1 millioner nedlastinger, anslagsvis 227 000 aktive installasjoner, 713 veteraner og 4,9 på WoWInterface. Våren og sommeren 2029 går litt ned når sesongen er over og folk reiser bort, men høsten er tilbake på rekordnivå. Første Lore Week i juli gir mer liv i Discord enn nye nedlastinger, og /wcl test viser fortsatt en gammel kjenning i hjørnet av skjermen.",
        stat: { label: "nedlastinger totalt", value: 2107184 },
        quotes: [
          { who: "Thraxx_gaming", src: "CurseForge", text: "Been here since 0.1.0. Still the first addon I install on a new character." }
        ],
        release: "3.2.0", tone: "crown"
      }
    ],

    epilogue: {
      title: "Tallene etter tre år",
      body: "Alt over er en simulering, bygget på det som faktisk ligger i repoet i dag: en tooltip-linje, et lore-vindu, et nærhetsvarsel og en veteranliste som ennå ikke er sluppet. Nedlastingstallene følger en modell med konkrete utløsere: Featured-plassering, streamere, level cap-patcher og én kraftig nedtur. Den første ekte datoen er 4. oktober 2026.",
      facts: [
        { label: "Nedlastinger totalt", value: "2 107 184" },
        { label: "Aktive installasjoner (anslag)", value: "226 770" },
        { label: "Veteraner i databasen", value: "713" },
        { label: "Språk", value: "8 (engelsk og sju oversettelser)" },
        { label: "Bidragsytere", value: "61" },
        { label: "Mest møtte veteran", value: "Thrall, møtt av 9 av 10" }
      ]
    }
  };
})();

/* Sagaen om Warcraft Lore: sticky graf (T2).
 * Definerer window.SagaChart etter simulering/CONTRACT.md.
 * Ren vanilla JS + SVG. Ingen avhengigheter.
 *
 *   const chart = SagaChart.create(el, STORY, { reducedMotion });
 *   chart.setDate("2027-03-01"); chart.setMetric("active"); chart.resize();
 *   chart.on("tick", ({ date, total, downloads, active, npcs, version }) => {});
 *
 * Datosemantikk: følger CONTRACT.md «Verdi på en vilkårlig dato». total, active og
 * npcs er lineære innen måneden (f = dag / antall dager), downloads er månedens tall
 * uten interpolering (trappekurve). tick-verdiene på en kapitteldato er derfor de
 * samme som kapittelkortets stat (rundet). STORY.anchors (ekte målepunkter) inngår.
 *
 * Valgfrie opts (utover kontrakten): safeLeft (andel av bredden som tekstkort kan
 * dekke på desktop, standard 0.40), safeBottom (andel av høyden kortene dekker på
 * mobil < 760 px, standard 0.42). Ekstra metoder: off(), getState(), destroy().
 */
(function (root) {
  "use strict";

  var NS = "http://www.w3.org/2000/svg";
  var DAY = 864e5;
  var FALLBACK = {
    night: "#0d0b15", "night-2": "#120f1c", panel: "#181226", line: "#2d2347", "line-strong": "#3d2a78",
    violet: "#8b6cd6", teal: "#3fb8a6", "teal-deep": "#2a6f68", title: "#d4c6f7", text: "#d9d2c3",
    muted: "#a79d8a", parchment: "#e8dcb5", wc2: "#e0533f", tft: "#7cc7ef", warn: "#e0b04a"
  };
  var MONO = "'Spline Sans Mono', ui-monospace, Menlo, Consolas, monospace";
  var SANS = "'Alegreya Sans', 'Segoe UI', system-ui, sans-serif";
  var MONTHS_LONG = ["januar", "februar", "mars", "april", "mai", "juni", "juli", "august", "september", "oktober", "november", "desember"];
  var MONTHS_SHORT = ["jan", "feb", "mar", "apr", "mai", "jun", "jul", "aug", "sep", "okt", "nov", "des"];
  var METRIC_LABEL = { total: "nedlastinger totalt", downloads: "nedlastinger per måned", active: "aktive installasjoner" };
  var KIND_TOKEN = { press: "teal", milestone: "violet", expansion: "parchment", dip: "wc2", community: "tft" };
  var KIND_NAME = { press: "presse", milestone: "milepæl", expansion: "utvidelse", dip: "nedtur", community: "fellesskap" };
  var uid = 0;

  /* ---------- små hjelpere ---------- */
  function toMs(d) {
    if (d instanceof Date) return d.getTime();
    if (typeof d === "number") return d;
    var m = /^(\d{4})-(\d{1,2})(?:-(\d{1,2}))?/.exec(String(d || ""));
    return m ? Date.UTC(+m[1], +m[2] - 1, m[3] ? +m[3] : 1) : NaN;
  }
  function pad(n) { return n < 10 ? "0" + n : "" + n; }
  // En dato «d» regnes som slutten av dagen d (dag 1 i måneden gir f = 1/n, siste dag
  // gir f = 1 = månedsslutt), slik kontraktens regel f = dag / n krever.
  function dayEnd(d) { var ms = toMs(d); return isNaN(ms) ? ms : ms + DAY; }
  function isoDate(ms) { var d = new Date(ms); return d.getUTCFullYear() + "-" + pad(d.getUTCMonth() + 1) + "-" + pad(d.getUTCDate()); }
  function isoMonth(ms) { var d = new Date(ms); return d.getUTCFullYear() + "-" + pad(d.getUTCMonth() + 1); }
  function monthEnd(ms) { var d = new Date(ms); return Date.UTC(d.getUTCFullYear(), d.getUTCMonth() + 1, 1); }
  function clamp(v, a, b) { return v < a ? a : v > b ? b : v; }
  function lerp(a, b, t) { return a + (b - a) * t; }
  function easeInOut(t) { return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2; }
  function fmtInt(n) { return String(Math.round(n)).replace(/\B(?=(\d{3})+(?!\d))/g, " "); }
  function trimDec(x) {
    var s = (Math.round(x * 10) / 10).toFixed(1);
    if (s.slice(-2) === ".0") s = s.slice(0, -2);
    return s.replace(".", ",");
  }
  function fmtTick(v) {
    if (v >= 1e6) return trimDec(v / 1e6) + "M";
    if (v >= 1e3) return trimDec(v / 1e3) + "k";
    return String(Math.round(v));
  }
  function niceStep(maxV, maxTicks) {
    var raw = maxV / Math.max(1, maxTicks);
    var mag = Math.pow(10, Math.floor(Math.log10(raw)));
    var steps = [1, 2, 2.5, 5, 10];
    for (var i = 0; i < steps.length; i++) if (steps[i] * mag >= raw) return steps[i] * mag;
    return 10 * mag;
  }
  function el(tag, attrs, parent) {
    var n = document.createElementNS(NS, tag);
    if (attrs) for (var k in attrs) if (attrs[k] != null) n.setAttribute(k, attrs[k]);
    if (parent) parent.appendChild(n);
    return n;
  }
  function setText(node, s) { if (node.__t !== s) { node.textContent = s; node.__t = s; } }
  function setAttr(node, k, v) {
    var key = "__" + k;
    if (node[key] !== v) { node.setAttribute(k, v); node[key] = v; }
  }

  /* Tekstmåling via canvas (ingen layout i DOM). */
  var measureCtx = null;
  function textWidth(s, px, family, weight) {
    if (!measureCtx) { try { measureCtx = document.createElement("canvas").getContext("2d"); } catch (e) { measureCtx = null; } }
    if (!measureCtx) return s.length * px * 0.58;
    measureCtx.font = (weight || 400) + " " + px + "px " + family;
    return measureCtx.measureText(s).width;
  }
  function wrapWords(s, px, family, maxW) {
    var words = String(s).split(/\s+/), lines = [], cur = "";
    for (var i = 0; i < words.length; i++) {
      var t = cur ? cur + " " + words[i] : words[i];
      if (cur && textWidth(t, px, family) > maxW) { lines.push(cur); cur = words[i]; } else cur = t;
    }
    if (cur) lines.push(cur);
    return lines;
  }
  function overlaps(a, b, pad) {
    pad = pad || 0;
    return !(a.x + a.w + pad <= b.x || b.x + b.w + pad <= a.x || a.y + a.h + pad <= b.y || b.y + b.h + pad <= a.y);
  }

  /* Stykkevis lineær (kontraktens regel «lineær innen måneden»), x i dager. */
  function Linear(xs, ys) {
    var n = xs.length;
    return {
      at: function (x) {
        if (x <= xs[0]) return ys[0];
        if (x >= xs[n - 1]) return ys[n - 1];
        var lo = 0, hi = n - 1;
        while (hi - lo > 1) { var mid = (lo + hi) >> 1; if (xs[mid] <= x) lo = mid; else hi = mid; }
        return lerp(ys[lo], ys[lo + 1], (x - xs[lo]) / ((xs[lo + 1] - xs[lo]) || 1));
      },
      maxUpTo: function (x) {
        var mx = 0;
        for (var j = 0; j < n && xs[j] <= x; j++) if (ys[j] > mx) mx = ys[j];
        var v = this.at(x);
        return v > mx ? v : mx;
      }
    };
  }
  /* Trapp: én verdi per måned (downloads per måned, uten interpolering). starts i dager. */
  function Step(starts, ys) {
    var n = starts.length;
    function idx(x) {
      var lo = 0, hi = n - 1;
      if (x >= starts[hi]) return hi;
      while (hi - lo > 1) { var mid = (lo + hi) >> 1; if (starts[mid] <= x) lo = mid; else hi = mid; }
      return lo;
    }
    return {
      at: function (x) { return ys[idx(x - 1e-4)]; },
      maxUpTo: function (x) {
        var k = idx(x - 1e-4), mx = 0;
        for (var j = 0; j <= k; j++) if (ys[j] > mx) mx = ys[j];
        return mx;
      }
    };
  }

  /* ================================================================== */
  function create(container, story, opts) {
    if (!container) throw new Error("SagaChart.create: mangler container-element");
    story = story || {};
    opts = opts || {};
    var id = "sc" + (++uid);
    var reduced = opts.reducedMotion != null ? !!opts.reducedMotion
      : !!(root.matchMedia && root.matchMedia("(prefers-reduced-motion: reduce)").matches);

    /* ---------- data ---------- */
    var months = (story.months || []).slice().sort(function (a, b) { return a.m < b.m ? -1 : 1; });
    if (!months.length) months = [{ m: "2026-10", downloads: 0, total: 0, active: 0, npcs: 0 }];
    // CONTRACT.md «Verdi på en vilkårlig dato»: stykkevis lineær mellom alle kjente
    // punkter sortert på tid: STORY.anchors (ekte målepunkter) + månedsslutt-punkter
    // (månedsslutt M = dag 1 i neste måned kl. 00; før første måned 0/0/0).
    // downloads (per måned) er månedens tall uten interpolering. Grafen starter ved
    // første anchor (2026-10-04), eller ved første måned hvis anchors mangler.
    var anchors = (story.anchors || []).map(function (a) {
      return { ms: dayEnd(a.date), total: +a.total || 0, active: +a.active || 0, npcs: +a.npcs || 0 };
    }).filter(function (a) { return !isNaN(a.ms); });
    var M0 = toMs(months[0].m);
    var pointsAll = [{ ms: M0, total: 0, active: 0, npcs: 0 }];
    months.forEach(function (m) {
      pointsAll.push({ ms: monthEnd(toMs(m.m)), total: +m.total || 0, active: +m.active || 0, npcs: +m.npcs || 0 });
    });
    anchors.forEach(function (a) {
      for (var j = pointsAll.length - 1; j >= 0; j--) if (pointsAll[j].ms === a.ms) pointsAll.splice(j, 1);
      pointsAll.push(a);
    });
    pointsAll.sort(function (a, b) { return a.ms - b.ms; });
    var D0 = anchors.length ? Math.min.apply(null, anchors.map(function (a) { return a.ms; })) : M0;
    var D1 = monthEnd(toMs(months[months.length - 1].m));        // slutten av siste måned
    function dayOf(ms) { return (ms - D0) / DAY; }
    var series = {}, i;
    var px = pointsAll.map(function (p) { return dayOf(p.ms); });
    ["total", "active", "npcs"].forEach(function (k) {
      series[k] = Linear(px, pointsAll.map(function (p) { return p[k]; }));
    });
    var starts = months.map(function (m) { return dayOf(toMs(m.m)); });
    series.downloads = Step(starts, months.map(function (m) { return +m.downloads || 0; }));
    var knots = [D0];
    pointsAll.forEach(function (p) { if (p.ms > D0) knots.push(p.ms); });
    for (i = 1; i < months.length; i++) knots.push(toMs(months[i].m) + 6e4);  // trappetrinn rett etter månedsskiftet
    knots.sort(function (a, b) { return a - b; });
    var todayMs = dayEnd(story.today || "2026-10-09");
    var releases = (story.releases || []).map(function (r) {
      return { v: String(r.v), name: r.name || "", major: !!r.major, ms: dayEnd(r.date) };
    }).filter(function (r) { return !isNaN(r.ms); }).sort(function (a, b) { return a.ms - b.ms; });
    var events = (story.events || []).map(function (e, k) {
      return { label: e.label || "", kind: KIND_TOKEN[e.kind] ? e.kind : "press", ms: dayEnd(e.date), key: k };
    }).filter(function (e) { return !isNaN(e.ms); }).sort(function (a, b) { return a.ms - b.ms; });
    // STORY.actual: ekte totaltall (egen strek oppå kurven, bare for «total») og ekte versjoner.
    var act = story.actual || {};
    var actPts = (act.points || []).map(function (p) {
      return { ms: dayEnd(p.date), total: +p.total || 0, measured: p.measured !== false };
    }).filter(function (p) { return !isNaN(p.ms); }).sort(function (a, b) { return a.ms - b.ms; });
    var hasActual = actPts.length > 1;
    var actSeries = hasActual ? Linear(actPts.map(function (p) { return dayOf(p.ms); }), actPts.map(function (p) { return p.total; })) : null;
    var actStart = hasActual ? actPts[0].ms : 0, actEnd = hasActual ? actPts[actPts.length - 1].ms : 0;
    var actRels = (act.releases || []).filter(function (r) { return !r.beta; }).map(function (r) {
      return { v: String(r.v), ms: dayEnd(r.date) };
    }).filter(function (r) { return !isNaN(r.ms); }).sort(function (a, b) { return a.ms - b.ms; });
    function actualAt(ms) { return hasActual ? actSeries.at(dayOf(clamp(ms, actStart, actEnd))) : 0; }

    /* ---------- farger ---------- */
    var C = {};
    function readTokens() {
      var cs = root.getComputedStyle ? root.getComputedStyle(container) : null;
      for (var k in FALLBACK) {
        var v = cs ? cs.getPropertyValue("--" + k).trim() : "";
        C[k] = v || FALLBACK[k];
      }
    }
    readTokens();

    /* ---------- tilstand ---------- */
    var metric = "total", prevMetric = "total", mixStart = 0, mixDur = 700, mix = 1;
    var reqMs = clamp(isNaN(todayMs) ? D0 : todayMs, D0, D1);
    var targetMs = snapMs(reqMs);
    var animMs = targetMs;
    var yMax = 0, yMaxTarget = 0, xEnd = D1, xEndTarget = D1, vDate = 0, vY = 0, vX = 0;
    var W = 0, H = 0, L = 0, R = 0, T = 0, B = 0, mobile = false;
    var raf = 0, lastT = 0, destroyed = false;
    var listeners = { tick: [] };
    var pulse = null;              // { t0 }
    var pendingShow = [];
    var lastEmit = "";

    function snapMs(ms) { return clamp(ms, D0, D1); }
    function valueOf(k, ms) { return series[k].at(dayOf(ms)); }
    function displayValue(ms) {
      var a = valueOf(prevMetric, ms), b = valueOf(metric, ms);
      return lerp(a, b, easeInOut(mix));
    }
    function displayMax(ms) {
      var x = dayOf(ms);
      return lerp(series[prevMetric].maxUpTo(x), series[metric].maxUpTo(x), easeInOut(mix));
    }
    function xEndFor(ms) {
      // Tidsaksen «zoomer ut» med historien: litt luft foran endepunktet, hele
      // perioden synlig mot slutten.
      var span = ms - D0;
      return clamp(ms + Math.max(50 * DAY, span * 0.34), Math.min(D1, D0 + 140 * DAY), D1);
    }
    // Hvor synlig den ekte streken er: 1 for «total», 0 for de andre, myk overgang mellom.
    function actualWeight() {
      if (!hasActual) return 0;
      var e = easeInOut(mix);
      return (prevMetric === "total" ? 1 - e : 0) + (metric === "total" ? e : 0);
    }
    function yMaxFor(ms) {
      // Topp = største synlige verdi + luft, så kurven aldri går ut av skala.
      var a = hasActual && ms >= actStart ? actSeries.maxUpTo(dayOf(Math.min(ms, actEnd))) * actualWeight() : 0;
      return Math.max(100, Math.max(displayMax(ms), a) * 1.16);
    }

    /* ---------- SVG-oppsett ---------- */
    var svg = el("svg", {
      class: "saga-chart", role: "img", "aria-label": "Graf over nedlastinger",
      style: "position:absolute;inset:0;width:100%;height:100%;display:block;overflow:visible;"
    });
    if (root.getComputedStyle && root.getComputedStyle(container).position === "static") container.style.position = "relative";
    container.appendChild(svg);
    var title = el("title", null, svg);

    var defs = el("defs", null, svg);
    var gradArea = el("linearGradient", { id: id + "-area", x1: 0, y1: 0, x2: 0, y2: 1 }, defs);
    var gs1 = el("stop", { offset: "0" }, gradArea), gs2 = el("stop", { offset: "0.55" }, gradArea), gs3 = el("stop", { offset: "1" }, gradArea);
    var gradHalo = el("radialGradient", { id: id + "-halo" }, defs);
    var hs1 = el("stop", { offset: "0" }, gradHalo), hs2 = el("stop", { offset: "1" }, gradHalo);
    var hatch = el("pattern", { id: id + "-hatch", width: 7, height: 7, patternUnits: "userSpaceOnUse", patternTransform: "rotate(45)" }, defs);
    var hatchLine = el("line", { x1: 0, y1: 0, x2: 0, y2: 7, "stroke-width": 1 }, hatch);
    var clipReal = el("clipPath", { id: id + "-real" }, defs), clipRealRect = el("rect", null, clipReal);
    var clipSim = el("clipPath", { id: id + "-sim" }, defs), clipSimRect = el("rect", null, clipSim);

    var gYears = el("g", null, svg);
    var gGrid = el("g", null, svg);
    var gExp = el("g", null, svg);
    var areaReal = el("path", { fill: "url(#" + id + "-area)", "clip-path": "url(#" + id + "-real)" }, svg);
    var areaSim = el("path", { fill: "url(#" + id + "-area)", "clip-path": "url(#" + id + "-sim)", opacity: 0.72 }, svg);
    var areaHatch = el("path", { fill: "url(#" + id + "-hatch)", "clip-path": "url(#" + id + "-sim)" }, svg);
    var relGuide = el("line", { "stroke-width": 1, "stroke-dasharray": "1 3", opacity: 0 }, svg);
    var lineReal = el("path", { fill: "none", "stroke-width": 2.5, "stroke-linejoin": "round", "stroke-linecap": "round", "clip-path": "url(#" + id + "-real)" }, svg);
    var lineSim = el("path", { fill: "none", "stroke-width": 2, "stroke-linejoin": "round", "stroke-linecap": "round", "clip-path": "url(#" + id + "-sim)", opacity: 0.92 }, svg);
    var gActual = el("g", { "pointer-events": "none" }, svg);
    var lineActual = el("path", { fill: "none", "stroke-width": 2.25, "stroke-linejoin": "round", "stroke-linecap": "round" }, gActual);
    var gActRel = el("g", null, gActual), gActDots = el("g", null, gActual);
    var gToday = el("g", null, svg);
    var todayLine = el("line", { "stroke-width": 1, "stroke-dasharray": "1 3" }, gToday);
    var todayText = el("text", { "font-size": 10.5, "letter-spacing": "0.06em" }, gToday);
    var gAxis = el("g", null, svg);
    var baseline = el("line", { "stroke-width": 1 }, gAxis);
    var gMonthTicks = el("g", null, gAxis);
    var gAxisLabels = el("g", null, gAxis);
    var gRel = el("g", null, svg);
    var gRelLabels = el("g", null, svg);
    var gDots = el("g", null, svg);
    var gAnn = el("g", null, svg);
    var gEnd = el("g", { "pointer-events": "none" }, svg);
    var endHalo = el("circle", { r: 34, fill: "url(#" + id + "-halo)" }, gEnd);
    var endPulse = el("circle", { r: 13, fill: "none", "stroke-width": 1.5, opacity: 0 }, gEnd);
    var endOuter = el("circle", { r: 12.5, "stroke-width": 3 }, gEnd);
    var endInner = el("circle", { r: 7, fill: "none", "stroke-width": 1.25 }, gEnd);
    var gActEnd = el("g", { "pointer-events": "none" }, svg);
    var actDot = el("circle", { r: 4.5, "stroke-width": 2 }, gActEnd);
    var actNum = el("text", { "font-weight": 500 }, gActEnd);
    var actSub = el("text", null, gActEnd);
    var actVer = el("text", null, gActEnd);
    var gValue = el("g", { "pointer-events": "none" }, svg);
    var valNum = el("text", { "font-weight": 500 }, gValue);
    var valLabel = el("text", null, gValue);
    var valDate = el("text", { "letter-spacing": "0.04em" }, gValue);
    var metricTitle = el("text", { "font-size": 10.5, "letter-spacing": "0.14em" }, svg);
    // forklaring: ekte strek og planens kurve
    var gLegend = el("g", { "pointer-events": "none" }, svg);
    var legActLine = el("line", { "stroke-width": 2.25, "stroke-linecap": "round" }, gLegend);
    var legActText = el("text", { "font-size": 10.5, "letter-spacing": "0.14em" }, gLegend);
    var legSimLine = el("line", { "stroke-width": 2, "stroke-linecap": "round" }, gLegend);
    var legSimText = el("text", { "font-size": 10.5, "letter-spacing": "0.14em" }, gLegend);

    var HALO_STYLE = "paint-order:stroke;stroke-linejoin:round;";
    function styleText(t, family) {
      t.setAttribute("font-family", family);
      t.setAttribute("style", HALO_STYLE + "font-variant-numeric:tabular-nums;");
    }
    [todayText, valNum, valDate, metricTitle, actNum, actSub, actVer, legActText, legSimText].forEach(function (t) { styleText(t, MONO); });
    styleText(valLabel, SANS);

    function applyColors() {
      gs1.setAttribute("stop-color", C.teal); gs1.setAttribute("stop-opacity", 0.34);
      gs2.setAttribute("stop-color", C.teal); gs2.setAttribute("stop-opacity", 0.1);
      gs3.setAttribute("stop-color", C.teal); gs3.setAttribute("stop-opacity", 0);
      hs1.setAttribute("stop-color", C.teal); hs1.setAttribute("stop-opacity", 0.16);
      hs2.setAttribute("stop-color", C.teal); hs2.setAttribute("stop-opacity", 0);
      hatchLine.setAttribute("stroke", C.violet); hatchLine.setAttribute("stroke-opacity", 0.16);
      lineReal.setAttribute("stroke", C.teal); lineSim.setAttribute("stroke", C.teal);
      relGuide.setAttribute("stroke", C.violet);
      todayLine.setAttribute("stroke", C.muted); todayText.setAttribute("fill", C.muted);
      baseline.setAttribute("stroke", C["line-strong"]);
      endPulse.setAttribute("stroke", C.teal);
      endOuter.setAttribute("stroke", C.teal); endOuter.setAttribute("fill", C.night);
      endInner.setAttribute("stroke", C.violet);
      valNum.setAttribute("fill", C.title); valLabel.setAttribute("fill", C.muted); valDate.setAttribute("fill", C.muted);
      metricTitle.setAttribute("fill", C.muted);
      lineActual.setAttribute("stroke", C.parchment);
      actDot.setAttribute("fill", C.night); actDot.setAttribute("stroke", C.parchment);
      actNum.setAttribute("fill", C.parchment); actSub.setAttribute("fill", C.muted); actVer.setAttribute("fill", C.muted);
      legActLine.setAttribute("stroke", C.parchment); legActText.setAttribute("fill", C.parchment);
      legSimLine.setAttribute("stroke", C.teal); legSimText.setAttribute("fill", C.muted);
      [todayText, valNum, valLabel, valDate, metricTitle, actNum, actSub, actVer, legActText, legSimText].forEach(function (t) {
        t.style.stroke = C.night; t.style.strokeWidth = "4px";
      });
    }
    applyColors();

    /* ---------- skala ---------- */
    function x(ms) { return L + (ms - D0) / (xEnd - D0) * (R - L); }
    function y(v) { return B - (v / (yMax || 1)) * (B - T); }

    /* ---------- statisk lag (bygges ved resize) ---------- */
    var relNodes = [], relLabelNodes = {}, dotNodes = [], annNodes = {}, expNodes = [];
    var fsSmall = 11;

    function layout() {
      var rect = container.getBoundingClientRect();
      W = Math.max(200, rect.width); H = Math.max(200, rect.height);
      mobile = W < 540;
      var safeLeft = mobile ? (opts.safeLeftMobile || 0) : (opts.safeLeft != null ? opts.safeLeft : 0.40);
      var safeBottom = mobile ? (opts.safeBottom != null ? opts.safeBottom : 0.42) : (opts.safeBottomDesktop || 0);
      var gut = mobile ? 18 : 48;
      L = Math.round(W * safeLeft + gut + (mobile ? 0 : 8));
      R = Math.round(W - gut - (mobile ? 0 : 12));
      T = Math.round(mobile ? 70 : 92);
      B = Math.round(H * (1 - safeBottom) - (mobile ? 54 : 64));
      if (B - T < 120) B = T + 120;
      fsSmall = mobile ? 11 : 12.5;
      svg.setAttribute("viewBox", "0 0 " + W + " " + H);
    }

    var monthNodes = [];
    function buildStatic() {
      // måneder og år (posisjoneres per frame i placeX, siden tidsaksen zoomer)
      gYears.textContent = ""; gMonthTicks.textContent = ""; gAxisLabels.textContent = ""; monthNodes = [];
      setAttr(baseline, "x1", L); setAttr(baseline, "x2", R); setAttr(baseline, "y1", B); setAttr(baseline, "y2", B);
      var d = new Date(D0), ms;
      var y0 = d.getUTCFullYear(), m0 = d.getUTCMonth();
      for (var k = 0; ; k++) {
        ms = Date.UTC(y0, m0 + k, 1);
        if (k === 0) ms = D0;
        if (ms > D1) break;
        var mo = new Date(ms).getUTCMonth(), jan = mo === 0, first = k === 0;
        var tick = el("line", { y1: B, y2: B + (jan ? 9 : 4), stroke: jan ? C.muted : C["line-strong"], "stroke-width": 1 }, gMonthTicks);
        var vline = jan ? el("line", { y1: T - 4, y2: B, stroke: C.line, "stroke-width": 1, opacity: 0.55 }, gYears) : null;
        var lab = el("text", { y: B + 24, "text-anchor": first ? "start" : "middle", "font-size": jan ? fsSmall + 1 : fsSmall, fill: C.muted }, gAxisLabels);
        styleText(lab, MONO); lab.style.stroke = C.night; lab.style.strokeWidth = "4px";
        lab.textContent = jan ? String(new Date(ms).getUTCFullYear()) : first ? MONTHS_SHORT[mo] + " " + new Date(ms).getUTCFullYear() : MONTHS_SHORT[mo];
        monthNodes.push({ ms: ms, mid: ms + 15 * DAY, jan: jan, first: first, idx: k, tick: tick, vline: vline, lab: lab });
      }

      setText(todayText, "i dag \u00B7 simulert herfra \u2192");
      setAttr(todayLine, "y1", T - 22); setAttr(todayLine, "y2", B); setAttr(todayText, "y", T - 14);
      setAttr(clipRealRect, "y", 0); setAttr(clipRealRect, "height", H);
      setAttr(clipSimRect, "y", 0); setAttr(clipSimRect, "height", H);
      setAttr(metricTitle, "x", L); setAttr(metricTitle, "y", T - 36);

      // versjonsmarkører
      gRel.textContent = ""; gRelLabels.textContent = ""; relNodes = []; relLabelNodes = {};
      releases.forEach(function (r) {
        var g = el("g", null, gRel), shape;
        if (r.major) shape = el("rect", { x: -4.5, y: -4.5, width: 9, height: 9, transform: "rotate(45)", "stroke-width": 1.25 }, g);
        else shape = el("circle", { r: 3, "stroke-width": 1.25 }, g);
        var ring = el("circle", { r: r.major ? 10 : 7.5, fill: "none", "stroke-width": 1, opacity: 0 }, g);
        ring.setAttribute("stroke", C.title);
        if (!reduced) { shape.style.transition = "fill .5s, stroke .5s"; ring.style.transition = "opacity .4s"; }
        relNodes.push({ r: r, g: g, shape: shape, ring: ring, lit: null, active: null });
      });

      // hendelser: prikker + utvidelseslinjer
      gDots.textContent = ""; gExp.textContent = ""; dotNodes = []; expNodes = [];
      gAnn.textContent = ""; annNodes = {};
      events.forEach(function (e) {
        var col = C[KIND_TOKEN[e.kind]];
        var dot = el("circle", { r: mobile ? 3 : 3.4, fill: col, stroke: C.night, "stroke-width": 1.5, opacity: 0 }, gDots);
        dotNodes.push({ e: e, node: dot });
        if (e.kind === "expansion") {
          var ln = el("line", { y1: T, y2: B, stroke: C.parchment, "stroke-width": 1, "stroke-dasharray": "2 5", opacity: 0 }, gExp);
          if (!reduced) ln.style.transition = "opacity .6s";
          expNodes.push({ e: e, node: ln, on: null });
        }
      });

      gGrid.textContent = ""; ticks = {};

      // ekte tall: prikker på målepunktene, små streker på ekte versjoner
      gActDots.textContent = ""; gActRel.textContent = ""; actDotNodes = []; actRelNodes = [];
      actPts.forEach(function (p) {
        if (!p.measured) return;
        actDotNodes.push({ p: p, node: el("circle", { r: mobile ? 2.4 : 2.8, fill: C.parchment, stroke: C.night, "stroke-width": 1.25 }, gActDots) });
      });
      actRels.forEach(function (r) {
        actRelNodes.push({ r: r, node: el("line", { stroke: C.parchment, "stroke-width": 1.25, opacity: 0.75 }, gActRel) });
      });

      // forklaring øverst til høyre, på samme linje som metrikk-tittelen
      var fsLg = 10.5, ly = T - 36;
      function lw(s) { return textWidth(s, fsLg, MONO) + s.length * fsLg * 0.14; }
      var simS = mobile ? "PLAN" : "PLAN (SIMULERT)", actS = "EKTE";
      setText(legSimText, simS); setText(legActText, actS);
      var xr = R, sw = 16;
      setAttr(legSimText, "x", xr); setAttr(legSimText, "y", ly); setAttr(legSimText, "text-anchor", "end");
      xr -= lw(simS) + 6;
      setAttr(legSimLine, "x1", xr - sw); setAttr(legSimLine, "x2", xr); setAttr(legSimLine, "y1", ly - 4); setAttr(legSimLine, "y2", ly - 4);
      xr -= sw + 16;
      setAttr(legActText, "x", xr); setAttr(legActText, "y", ly); setAttr(legActText, "text-anchor", "end");
      xr -= lw(actS) + 6;
      setAttr(legActLine, "x1", xr - sw); setAttr(legActLine, "x2", xr); setAttr(legActLine, "y1", ly - 4); setAttr(legActLine, "y2", ly - 4);
      legendLeft = xr - sw;
    }
    var actDotNodes = [], actRelNodes = [], legendLeft = 0;

    /* Alt som avhenger av tidsaksens zoom. */
    function placeX() {
      var span = xEnd - D0;
      var pxPerMonth = (R - L) / (span / (30.44 * DAY));
      var every = pxPerMonth >= 44 ? 1 : pxPerMonth >= 15 ? 3 : 0;
      var lastLabelRight = -1e9;
      monthNodes.forEach(function (n) {
        var xx = x(n.ms), vis = xx <= R + 0.5;
        setAttr(n.tick, "x1", xx.toFixed(1)); setAttr(n.tick, "x2", xx.toFixed(1));
        setAttr(n.tick, "opacity", vis ? 1 : 0);
        if (n.vline) { setAttr(n.vline, "x1", xx.toFixed(1)); setAttr(n.vline, "x2", xx.toFixed(1)); setAttr(n.vline, "opacity", vis ? 0.55 : 0); }
        var showLab = vis && (n.jan || n.first || (every && n.idx % every === 0));
        var lx = n.first ? L : xx;
        var w = textWidth(n.lab.__t || n.lab.textContent, fsSmall, MONO);
        var left = n.first ? lx : lx - w / 2;
        if (showLab && (left < lastLabelRight + 10 || left + w > R + 2)) showLab = false;
        if (showLab) lastLabelRight = left + w;
        setAttr(n.lab, "x", lx.toFixed(1));
        setAttr(n.lab, "opacity", showLab ? (n.jan || n.first ? 1 : 0.7) : 0);
      });
      var tx = x(clamp(todayMs, D0, D1)), bigPad = 40;
      setAttr(todayLine, "x1", tx.toFixed(1)); setAttr(todayLine, "x2", tx.toFixed(1));
      setAttr(todayText, "x", (tx + 6).toFixed(1));
      setAttr(clipRealRect, "x", L - bigPad); setAttr(clipRealRect, "width", Math.max(0, tx - L + bigPad).toFixed(1));
      setAttr(clipSimRect, "x", tx.toFixed(1)); setAttr(clipSimRect, "width", Math.max(0, R - tx + bigPad).toFixed(1));
      relNodes.forEach(function (n) {
        var rx = x(n.r.ms);
        n.x = rx;
        setAttr(n.g, "transform", "translate(" + rx.toFixed(1) + "," + B + ")");
        // planlagte versjoner etter i dag tones ned når ekte tall finnes
        setAttr(n.g, "opacity", rx <= R + 0.5 ? (hasActual && n.r.ms > todayMs ? 0.55 : 1) : 0);
      });
      dotNodes.forEach(function (d) { d.x = x(d.e.ms); });
      expNodes.forEach(function (n) { var ex = x(n.e.ms).toFixed(1); setAttr(n.node, "x1", ex); setAttr(n.node, "x2", ex); });
    }

    /* ---------- rutenett med animerte ticks ---------- */
    var ticks = {};
    function updateTicks() {
      var maxTicks = clamp(Math.round((B - T) / 85), 3, 6);
      var step = niceStep(yMax / 1.05, maxTicks);
      var want = {};
      if (displayMax(animMs) < 10) maxTicks = 0;   // ingen tomme akseverdier før kurven har noe å vise
      for (var v = step; maxTicks && v <= yMax * 0.985; v += step) want[String(+v.toPrecision(6))] = +v.toPrecision(6);
      var k, t;
      for (k in want) {
        t = ticks[k];
        if (!t) {
          var g = el("g", null, gGrid);
          var ln = el("line", { x1: L, x2: R, y1: 0, y2: 0, stroke: C.line, "stroke-width": 1 }, g);
          var tx = el("text", { x: L, y: -6, "font-size": fsSmall, fill: C.muted }, g);
          styleText(tx, MONO); tx.style.stroke = C.night; tx.style.strokeWidth = "4px";
          tx.textContent = fmtTick(want[k]);
          t = ticks[k] = { g: g, ln: ln, tx: tx, v: want[k], leaving: 0 };
          if (!reduced) { g.style.transition = "opacity .5s ease"; g.style.opacity = "0"; pendingShow.push(g); }
        } else if (t.leaving) {
          clearTimeout(t.leaving); t.leaving = 0; t.g.style.opacity = "1";
        }
        setAttr(t.g, "transform", "translate(0," + y(t.v).toFixed(1) + ")");
      }
      for (k in ticks) {
        t = ticks[k];
        if (!(k in want)) {
          setAttr(t.g, "transform", "translate(0," + y(t.v).toFixed(1) + ")");
          if (!t.leaving) {
            if (reduced) { t.g.remove(); delete ticks[k]; continue; }
            t.g.style.opacity = "0";
            t.leaving = setTimeout((function (kk, tt) { return function () { tt.g.remove(); if (ticks[kk] === tt) delete ticks[kk]; }; })(k, t), 520);
          }
        }
      }
    }

    /* ---------- hendelsesetikett ---------- */
    function annFor(e) {
      var a = annNodes[e.key];
      if (a) return a;
      var col = C[KIND_TOKEN[e.kind]];
      var g = el("g", { opacity: 0, "pointer-events": "none" }, gAnn);
      if (!reduced) g.style.transition = "opacity .45s ease";
      var lead = el("line", { stroke: col, "stroke-width": 1, opacity: 0.7 }, g);
      var box = el("rect", { rx: 2, fill: C["night-2"], "fill-opacity": 0.92, stroke: col, "stroke-opacity": 0.55, "stroke-width": 1 }, g);
      var bar = el("rect", { width: 2, fill: col }, g);
      var fsL = mobile ? 12.5 : 13.5, fsD = mobile ? 9.5 : 10;
      var d = new Date(e.ms - DAY);
      var head = (d.getUTCDate() + ". " + MONTHS_SHORT[d.getUTCMonth()] + " " + d.getUTCFullYear() + " · " + KIND_NAME[e.kind]).toUpperCase();
      var maxW = mobile ? 180 : 230;
      var lines = wrapWords(e.label, fsL, SANS, maxW);
      var w = Math.max(textWidth(head, fsD, MONO) * 1.06, 0);
      lines.forEach(function (ln) { w = Math.max(w, textWidth(ln, fsL, SANS)); });
      var padX = 11, padY = 8, lh = fsL * 1.25;
      var bw = Math.ceil(w + padX * 2 + 2), bh = Math.ceil(padY * 2 + fsD + 6 + lines.length * lh);
      var th = el("text", { x: padX + 2, y: padY + fsD, "font-size": fsD, fill: col, "letter-spacing": "0.08em", "font-family": MONO }, g);
      th.textContent = head;
      lines.forEach(function (ln, k) {
        var t = el("text", { x: padX + 2, y: padY + fsD + 6 + lh * (k + 1) - 3, "font-size": fsL, fill: C.text, "font-family": SANS }, g);
        t.textContent = ln;
      });
      setAttr(box, "width", bw); setAttr(box, "height", bh); setAttr(bar, "height", bh);
      a = annNodes[e.key] = { g: g, box: box, lead: lead, w: bw, h: bh, shown: false };
      return a;
    }
    function hitsCurve(b) {
      var hits = 0;
      for (var sx = b.x; sx <= b.x + b.w; sx += 6) {
        var ms = D0 + (sx - L) / (R - L) * (xEnd - D0);
        if (ms < D0 || ms > animMs) continue;
        var cy = y(displayValue(ms));
        if (cy >= b.y - 5 && cy <= b.y + b.h + 5) hits++;
      }
      return hits;
    }
    // Prøver faste plasseringer rundt punktet; streng = må verken treffe kurven eller
    // andre etiketter. Ikke-streng = færrest kurvetreff blant de som ikke kolliderer.
    function placeAnn(a, px, py, avoid, strict) {
      var gap = 14, rise = 26;
      var cands = [
        { x: px - gap - a.w, y: py - rise - a.h, lx: px - gap, ly: py - rise },             // over til venstre
        { x: px - a.w * 0.5, y: py - rise - 10 - a.h, lx: px, ly: py - rise - 10 },           // rett over
        { x: px + gap, y: py - rise - a.h, lx: px + gap, ly: py - rise },                     // over til høyre
        { x: px - gap - a.w, y: py - a.h * 0.5 - 30, lx: px - gap, ly: py - 30 + a.h * 0.5 }, // venstre
        { x: px - 3 * gap - a.w, y: py - 3 * rise - a.h, lx: px - 3 * gap, ly: py - 3 * rise }, // langt over til venstre
        { x: px + gap, y: py + rise, lx: px + gap, ly: py + rise },                           // under til høyre
        { x: px - gap - a.w, y: py + rise, lx: px - gap, ly: py + rise },                     // under til venstre
        { x: px - 2 * gap - a.w * 0.5, y: py + 3 * rise, lx: px - 2 * gap, ly: py + 3 * rise } // langt under
      ];
      var best = null, bestHits = Infinity;
      for (var k = 0; k < cands.length; k++) {
        var c = cands[k], b = { x: c.x, y: c.y, w: a.w, h: a.h };
        if (b.x < L - 4 || b.x + b.w > R + 4 || b.y < T - 30 || b.y + b.h > B - 6) continue;
        var bad = false;
        for (var j = 0; j < avoid.length; j++) if (overlaps(b, avoid[j], 6)) { bad = true; break; }
        if (bad) continue;
        var h = hitsCurve(b);
        if (h === 0) return { box: b, lx: c.lx, ly: c.ly };
        if (!strict && h < bestHits) { bestHits = h; best = { box: b, lx: c.lx, ly: c.ly }; }
      }
      return best;
    }

    /* ---------- render ---------- */
    var lastValStr = "", lastAria = "";
    function render(now) {
      placeX();
      // kurve
      var x0 = L, xe = x(animMs);
      // Kurvene er stykkevis lineære (og trapper), så knekkpunktene gir eksakt form.
      var pts = [], ms;
      for (var q = 0; q < knots.length && knots[q] < animMs; q++) {
        ms = knots[q];
        pts.push(x(ms).toFixed(2) + "," + y(displayValue(ms)).toFixed(1));
      }
      var vEnd = displayValue(animMs), yEnd = y(vEnd);
      pts.push(xe.toFixed(1) + "," + yEnd.toFixed(1));
      var line = "M" + pts.join("L");
      var area = line + "L" + xe.toFixed(1) + "," + B + "L" + x0 + "," + B + "Z";
      lineReal.setAttribute("d", line); lineSim.setAttribute("d", line);
      areaReal.setAttribute("d", area); areaSim.setAttribute("d", area); areaHatch.setAttribute("d", area);

      updateTicks();
      setText(metricTitle, METRIC_LABEL[metric].toUpperCase());

      // endepunkt
      setAttr(gEnd, "transform", "translate(" + xe.toFixed(1) + "," + yEnd.toFixed(1) + ")");
      if (pulse) {
        var p = (now - pulse.t0) / 1700;
        if (p >= 1) { pulse = null; endPulse.setAttribute("opacity", 0); endInner.setAttribute("stroke-width", 1.25); }
        else {
          var e1 = 1 - Math.pow(1 - p, 3);
          endPulse.setAttribute("r", (13 + e1 * 34).toFixed(1));
          endPulse.setAttribute("opacity", (0.6 * (1 - p)).toFixed(3));
          endInner.setAttribute("stroke-width", (1.25 + 1.2 * (1 - p)).toFixed(2));
        }
      }

      // verdietikett
      var capMs = Math.min(animMs, reqMs);
      var rounded = Math.round(vEnd);
      var fsNum = mobile ? 20 : 26, fsLab = mobile ? 13 : 14.5, fsDate = mobile ? 10 : 10.5;
      var valStr = fmtInt(rounded);
      if (valStr !== lastValStr) { setText(valNum, valStr); lastValStr = valStr; }
      setAttr(valNum, "font-size", fsNum); setAttr(valLabel, "font-size", fsLab); setAttr(valDate, "font-size", fsDate);
      setText(valLabel, METRIC_LABEL[metric]);
      var dm = new Date(Math.ceil(animMs / DAY - 1e-6) * DAY - DAY);
      var simulated = animMs > todayMs;
      setText(valDate, (dm.getUTCDate() + ". " + MONTHS_LONG[dm.getUTCMonth()] + " " + dm.getUTCFullYear() + (simulated ? " · simulert" : "")).toUpperCase());
      var vw = Math.max(textWidth(valStr, fsNum, MONO, 500), textWidth(METRIC_LABEL[metric], fsLab, SANS), textWidth(valDate.__t, fsDate, MONO) * 1.05);
      var vh = fsNum + fsLab + fsDate + 14;
      var right = xe + 20 + vw <= R + 8;
      var vbx = right ? xe + 20 : xe - 20 - vw;
      var vby = right ? yEnd - fsNum * 0.75 : yEnd - 18 - vh;
      if (!right) {
        // løft etiketten over kurven hvis en tidligere topp ligger under den
        var minCy = Infinity;
        for (var sx = vbx - 6; sx <= vbx + vw + 6; sx += 5) {
          var sms = D0 + (sx - L) / (R - L) * (xEnd - D0);
          if (sms < D0 || sms > animMs) continue;
          var cy = y(displayValue(sms));
          if (cy < minCy) minCy = cy;
        }
        if (minCy < Infinity) vby = Math.min(vby, minCy - 12 - vh);
      }
      vby = clamp(vby, T - 34, B - vh - 4);
      var anchor = right ? "start" : "end", ax = right ? vbx : vbx + vw;
      setAttr(valNum, "text-anchor", anchor); setAttr(valLabel, "text-anchor", anchor); setAttr(valDate, "text-anchor", anchor);
      setAttr(valNum, "x", ax.toFixed(1)); setAttr(valLabel, "x", ax.toFixed(1)); setAttr(valDate, "x", ax.toFixed(1));
      setAttr(valNum, "y", (vby + fsNum * 0.8).toFixed(1));
      setAttr(valLabel, "y", (vby + fsNum * 0.8 + fsLab + 4).toFixed(1));
      setAttr(valDate, "y", (vby + fsNum * 0.8 + fsLab + 4 + fsDate + 7).toFixed(1));
      var valBox = { x: vbx, y: vby, w: vw, h: vh };
      // «i dag»-etiketten viker for verdietiketten (kortform, ev. skjult)
      var tdx = x(clamp(todayMs, D0, D1)) + 6, fsT = 10.5;
      var longT = "I DAG · SIMULERT HERFRA →", shortT = "I DAG";
      var tBox = function (s) { return { x: tdx, y: T - 26, w: textWidth(s, fsT, MONO) * 1.08, h: 16 }; };
      if (!overlaps(tBox(longT), valBox, 4)) { setText(todayText, longT); setAttr(todayText, "opacity", 1); }
      else if (!overlaps(tBox(shortT), valBox, 4)) { setText(todayText, shortT); setAttr(todayText, "opacity", 1); }
      else setAttr(todayText, "opacity", 0);
      var endBox = { x: xe - 12, y: yEnd - 12, w: 24, h: 24 };

      // ekte tall: strek fram til datoen (eller siste måling), endepunkt og sammenligning med planen
      var aw = actualWeight(), actBox = null;
      var aEnd = Math.min(animMs, actEnd);
      var showAct = aw > 0.01 && aEnd >= actStart;
      setAttr(gActual, "opacity", showAct ? aw.toFixed(3) : 0);
      setAttr(gActEnd, "opacity", showAct ? aw.toFixed(3) : 0);
      setAttr(gLegend, "opacity", hasActual && L + textWidth(METRIC_LABEL[metric], 10.5, MONO) * 1.3 + 16 < legendLeft ? aw.toFixed(3) : 0);
      if (showAct) {
        var ap = [];
        for (var a = 0; a < actPts.length && actPts[a].ms < aEnd; a++) ap.push(x(actPts[a].ms).toFixed(2) + "," + y(actPts[a].total).toFixed(1));
        var aV = actualAt(aEnd), ax = x(aEnd), ay = y(aV);
        ap.push(ax.toFixed(1) + "," + ay.toFixed(1));
        lineActual.setAttribute("d", "M" + ap.join("L"));
        var exact = aEnd >= actEnd - DAY / 2;
        actDotNodes.forEach(function (d) {
          var on = d.p.ms <= aEnd;
          if (Math.abs(d.p.ms - aEnd) < DAY / 2) exact = true;
          setAttr(d.node, "opacity", on ? 1 : 0);
          if (on) { setAttr(d.node, "cx", x(d.p.ms).toFixed(1)); setAttr(d.node, "cy", y(d.p.total).toFixed(1)); }
        });
        var realV = null;
        actRelNodes.forEach(function (n) {
          var on = n.r.ms <= aEnd;
          if (on) realV = n.r.v;
          setAttr(n.node, "opacity", on ? 0.75 : 0);
          if (on) {
            var rx = x(n.r.ms).toFixed(1), ry = y(actualAt(n.r.ms));
            setAttr(n.node, "x1", rx); setAttr(n.node, "x2", rx);
            setAttr(n.node, "y1", (ry - 5).toFixed(1)); setAttr(n.node, "y2", (ry + 5).toFixed(1));
          }
        });
        setAttr(actDot, "cx", ax.toFixed(1)); setAttr(actDot, "cy", ay.toFixed(1));

        var plan = valueOf("total", aEnd), planV = null;
        for (var pr = 0; pr < releases.length; pr++) if (releases[pr].ms <= aEnd) planV = releases[pr].v;
        var pct = plan >= 1 ? Math.round((aV / plan - 1) * 100) : null;
        var numS = "EKTE " + (exact ? "" : "≈") + fmtInt(aV);
        var subS = "plan " + fmtInt(plan) + (pct != null ? " · " + (pct < 0 ? "−" : "+") + Math.abs(pct) + " %" : "");
        var verS = realV ? "v" + realV + (planV && planV !== realV ? " · plan v" + planV : "") : "";
        var fsA = mobile ? 12.5 : 14, fsB = mobile ? 10 : 10.5;
        setText(actNum, numS); setText(actSub, subS); setText(actVer, verS);
        setAttr(actNum, "font-size", fsA); setAttr(actSub, "font-size", fsB); setAttr(actVer, "font-size", fsB);
        var aw2 = Math.max(textWidth(numS, fsA, MONO, 500), textWidth(subS, fsB, MONO), verS ? textWidth(verS, fsB, MONO) : 0);
        var ah = fsA + 6 + fsB + (verS ? 4 + fsB : 0);
        var aCands = [
          { x: ax + 12, y: ay + 10 }, { x: ax + 12, y: ay - 10 - ah },
          { x: ax - 12 - aw2, y: ay - 10 - ah }, { x: ax - 12 - aw2, y: ay + 10 }
        ];
        var firstFit = null;
        for (var ac = 0; ac < aCands.length; ac++) {
          var bx = { x: aCands[ac].x, y: aCands[ac].y, w: aw2, h: ah };
          if (bx.x < L - 4 || bx.x + bx.w > R + 4 || bx.y < T - 30 || bx.y + bx.h > B - 4) continue;
          if (overlaps(bx, valBox, 6) || overlaps(bx, endBox, 6)) continue;
          if (!firstFit) firstFit = bx;
          if (hitsCurve(bx) === 0) { actBox = bx; break; }
        }
        actBox = actBox || firstFit;
        var showLab = !!actBox;
        [actNum, actSub, actVer].forEach(function (t) { setAttr(t, "opacity", showLab ? 1 : 0); });
        if (showLab) {
          var tx0 = actBox.x.toFixed(1);
          setAttr(actNum, "x", tx0); setAttr(actNum, "y", (actBox.y + fsA * 0.85).toFixed(1));
          setAttr(actSub, "x", tx0); setAttr(actSub, "y", (actBox.y + fsA + 6 + fsB * 0.8).toFixed(1));
          setAttr(actVer, "x", tx0); setAttr(actVer, "y", (actBox.y + fsA + 10 + fsB * 1.8).toFixed(1));
        }
      }

      // versjoner
      var activeRel = null;
      for (var r = 0; r < releases.length; r++) if (releases[r].ms <= capMs) activeRel = releases[r];
      var relBoxes = [];
      relNodes.forEach(function (n) {
        var lit = n.r.ms <= animMs, act = n.r === activeRel;
        if (n.lit !== lit) {
          n.lit = lit;
          var col = n.r.major ? C.teal : C.violet;
          n.shape.setAttribute("fill", lit ? col : C.night);
          n.shape.setAttribute("stroke", lit ? col : C["line-strong"]);
        }
        if (n.active !== act) { n.active = act; n.ring.setAttribute("opacity", act ? 0.85 : 0); }
      });
      // versjonsetiketter: aktiv først, deretter passerte major-versjoner, uten kollisjon
      var labelOrder = [];
      if (activeRel) labelOrder.push(activeRel);
      for (r = releases.length - 1; r >= 0; r--) if (releases[r].major && releases[r] !== activeRel && releases[r].ms <= animMs) labelOrder.push(releases[r]);
      var shownRel = {};
      labelOrder.forEach(function (rel, idx) {
        var isAct = idx === 0 && rel === activeRel;
        var fsV = mobile ? 11 : 11.5, fsN = mobile ? 12 : 13;
        var vtxt = "v" + rel.v, ntxt = isAct && rel.name ? rel.name : "";
        var w = textWidth(vtxt, fsV, MONO, 500) + (ntxt ? 7 + textWidth(ntxt, fsN, SANS) : 0);
        var cx = x(rel.ms), bx = clamp(cx - w / 2, L, R - w);
        var box = { x: bx, y: B + 31, w: w, h: 16 };
        for (var j = 0; j < relBoxes.length; j++) if (overlaps(box, relBoxes[j], 10)) return;
        relBoxes.push(box);
        var key = rel.v + (isAct ? "*" : "");
        shownRel[key] = true;
        var n = relLabelNodes[key];
        if (!n) {
          var g = el("g", { opacity: 0 }, gRelLabels);
          if (!reduced) { g.style.transition = "opacity .4s ease"; }
          var tv = el("text", { "font-size": fsV, "font-weight": 500, fill: isAct ? (rel.major ? C.teal : C.title) : C.muted, "font-family": MONO }, g);
          tv.setAttribute("style", "font-variant-numeric:tabular-nums;");
          tv.textContent = vtxt;
          var tn = null;
          if (ntxt) { tn = el("text", { "font-size": fsN, fill: C.text, "font-family": SANS }, g); tn.textContent = ntxt; }
          n = relLabelNodes[key] = { g: g, tv: tv, tn: tn, vw: textWidth(vtxt, fsV, MONO, 500), born: true };
          if (!reduced) pendingShow.push(g); else g.setAttribute("opacity", 1);
        }
        n.leaving = false;
        if (n.g.style.opacity === "0") n.g.style.opacity = "1";
        setAttr(n.tv, "x", bx.toFixed(1)); setAttr(n.tv, "y", (B + 44).toFixed(1));
        if (n.tn) { setAttr(n.tn, "x", (bx + n.vw + 7).toFixed(1)); setAttr(n.tn, "y", (B + 44).toFixed(1)); }
      });
      Object.keys(relLabelNodes).forEach(function (k) {
        if (shownRel[k]) return;
        var n = relLabelNodes[k];
        n.g.remove(); delete relLabelNodes[k];
      });
      // stiplet hjelpelinje fra aktiv versjon opp til kurven
      if (activeRel && activeRel.ms <= animMs) {
        var gx = x(activeRel.ms), gy = y(displayValue(activeRel.ms));
        setAttr(relGuide, "x1", gx.toFixed(1)); setAttr(relGuide, "x2", gx.toFixed(1));
        setAttr(relGuide, "y1", (gy + 6).toFixed(1)); setAttr(relGuide, "y2", (B - 8).toFixed(1));
        setAttr(relGuide, "opacity", B - gy > 20 ? 0.55 : 0);
      } else setAttr(relGuide, "opacity", 0);

      // hendelser
      var avoid = [valBox, endBox];
      if (actBox) avoid.push(actBox);
      var recent = [];
      for (var k = events.length - 1; k >= 0 && recent.length < 1; k--) {
        var ev = events[k];
        if (ev.ms <= capMs && capMs - ev.ms < 110 * DAY) recent.push(ev);
      }
      var showAnn = {};
      dotNodes.forEach(function (d) {
        var vis = d.e.ms <= animMs;
        setAttr(d.node, "opacity", vis ? 1 : 0);
        if (vis) { setAttr(d.node, "cx", d.x.toFixed(1)); setAttr(d.node, "cy", y(displayValue(d.e.ms)).toFixed(1)); }
      });
      recent.forEach(function (ev, idx) {
        var a = annFor(ev);
        var px = x(ev.ms), py = y(displayValue(ev.ms));
        var pl = placeAnn(a, px, py, avoid, true) || (idx === 0 ? placeAnn(a, px, py, avoid, false) : null);
        if (!pl) return;
        avoid.push(pl.box);
        showAnn[ev.key] = idx === 0 ? 1 : 0.5;
        setAttr(a.g, "transform", "translate(" + pl.box.x.toFixed(1) + "," + pl.box.y.toFixed(1) + ")");
        var lx = pl.lx - pl.box.x, ly = pl.ly - pl.box.y;
        // ledelinje fra kanten av boksen til prikken
        setAttr(a.lead, "x1", lx.toFixed(1)); setAttr(a.lead, "y1", ly.toFixed(1));
        setAttr(a.lead, "x2", (px - pl.box.x).toFixed(1)); setAttr(a.lead, "y2", (py - pl.box.y - 4).toFixed(1));
      });
      Object.keys(annNodes).forEach(function (key) {
        var a = annNodes[key], o = showAnn[key] || 0;
        if (reduced) setAttr(a.g, "opacity", o);
        else { setAttr(a.g, "opacity", 1); var s = String(o); if (a.g.style.opacity !== s) a.g.style.opacity = s; }
      });
      expNodes.forEach(function (n) {
        var on = n.e.ms <= animMs;
        if (n.on !== on) { n.on = on; n.node.setAttribute("opacity", on ? 0.3 : 0); }
      });

      var aria = METRIC_LABEL[metric] + ": " + valStr + ", " + valDate.__t.toLowerCase() + (activeRel ? ", versjon " + activeRel.v : "") +
        (showAct ? ", ekte nedlastinger " + fmtInt(actualAt(aEnd)) : "");
      if (aria !== lastAria) { lastAria = aria; svg.setAttribute("aria-label", aria); title.textContent = aria; }

      return { capMs: capMs, activeRel: activeRel };
    }

    /* ---------- tick-hendelse ---------- */
    function emit(info) {
      var ms = animMs;
      var payload = {
        date: isoDate(Math.ceil(Math.min(ms, reqMs) / DAY - 1e-6) * DAY - DAY),
        month: isoMonth(ms - 1),
        total: Math.round(valueOf("total", ms)),
        downloads: Math.round(valueOf("downloads", ms)),
        active: Math.round(valueOf("active", ms)),
        npcs: Math.round(series.npcs.at(dayOf(ms))),
        version: info.activeRel ? info.activeRel.v : null,
        metric: metric,
        value: Math.round(displayValue(ms)),
        simulated: ms > todayMs,
        // ekte totaltall på datoen (siste måling hvis datoen er etter den), null før første opplasting
        actual: hasActual && ms >= actStart ? Math.round(actualAt(ms)) : null,
        settled: !raf
      };
      var sig = payload.date + payload.total + payload.downloads + payload.active + payload.npcs + payload.version + payload.metric + payload.value + payload.actual + payload.settled;
      if (sig === lastEmit) return;
      lastEmit = sig;
      listeners.tick.slice().forEach(function (fn) { try { fn(payload); } catch (err) { if (root.console) console.error(err); } });
    }

    /* ---------- milepæls-puls ---------- */
    var PULSE_THRESHOLDS = [1e3, 1e4, 1e5, 1e6];
    function checkPulse(prevMs, nextMs, now) {
      if (reduced || nextMs <= prevMs) return;
      var hit = false;
      for (var k = 0; k < events.length; k++) {
        var e = events[k];
        if (e.kind === "milestone" && e.ms > prevMs && e.ms <= nextMs) hit = true;
      }
      if (!hit && metric === "total") {
        var a = valueOf("total", prevMs), b = valueOf("total", nextMs);
        for (k = 0; k < PULSE_THRESHOLDS.length; k++) if (a < PULSE_THRESHOLDS[k] && b >= PULSE_THRESHOLDS[k]) hit = true;
      }
      if (hit && (!pulse || now - pulse.t0 > 900)) pulse = { t0: now };
    }

    /* ---------- animasjonsløkke ---------- */
    function frame(now) {
      raf = 0;
      if (destroyed) return;
      var dt = lastT ? Math.min(0.1, (now - lastT) / 1000) : 1 / 60;
      lastT = now;
      if (pendingShow.length) { pendingShow.forEach(function (g) { g.style.opacity = "1"; }); pendingShow = []; }

      var prev = animMs;
      if (reduced) { animMs = targetMs; mix = 1; vDate = 0; }
      else {
        mix = clamp((now - mixStart) / mixDur, 0, 1);
        // kritisk dempet fjær (i dager): myk start, myk landing, ~1 s
        var sd = spring(animMs / DAY, vDate, targetMs / DAY, 6.5, dt);
        animMs = sd[0] * DAY; vDate = sd[1];
        if (Math.abs(targetMs - animMs) < 0.2 * DAY && Math.abs(vDate) < 1) { animMs = targetMs; vDate = 0; }
      }
      checkPulse(prev, animMs, now);

      yMaxTarget = yMaxFor(targetMs);
      var need = yMaxFor(animMs) / 1.16 * 1.04;  // aldri la kurven gå ut over toppen
      if (reduced) yMax = yMaxTarget;
      else {
        // fjær i log-rom, så zoom fra 1k til 1M føles like jevn som 10k til 20k
        var sy = spring(Math.log(yMax), vY, Math.log(yMaxTarget), 7, dt);
        yMax = Math.exp(sy[0]); vY = sy[1];
        if (Math.abs(Math.log(yMaxTarget / yMax)) < 0.001 && Math.abs(vY) < 0.01) { yMax = yMaxTarget; vY = 0; }
      }
      if (yMax < need) { yMax = need; if (vY < 0) vY = 0; }

      xEndTarget = xEndFor(targetMs);
      if (reduced) xEnd = xEndTarget;
      else {
        var sx = spring(xEnd / DAY, vX, xEndTarget / DAY, 5.5, dt);
        xEnd = sx[0] * DAY; vX = sx[1];
        if (Math.abs(xEndTarget - xEnd) < 0.3 * DAY && Math.abs(vX) < 1) { xEnd = xEndTarget; vX = 0; }
      }
      var minEnd = Math.min(D1, animMs + 20 * DAY);
      if (xEnd < minEnd) xEnd = minEnd;

      var info = render(now);
      var busy = animMs !== targetMs || xEnd !== xEndTarget || yMax !== yMaxTarget || mix < 1 || pulse || pendingShow.length;
      if (busy) { raf = root.requestAnimationFrame(frame); }
      else lastT = 0;
      emit(info);
    }
    function spring(x, v, target, w, dt) {
      var n = Math.max(1, Math.ceil(dt / (1 / 120))), h = dt / n;
      for (var k = 0; k < n; k++) {
        v += (-2 * w * v - w * w * (x - target)) * h;
        x += v * h;
      }
      return [x, v];
    }
    function kick() { if (!raf && !destroyed) { raf = root.requestAnimationFrame(frame); } }

    /* ---------- resize ---------- */
    var roPending = 0;
    function resize() {
      if (destroyed) return;
      readTokens(); applyColors();
      layout(); buildStatic();
      lastValStr = "";
      if (!yMax) yMax = yMaxFor(animMs);
      render(root.performance ? root.performance.now() : Date.now());
      pendingShow.forEach(function (g) { g.style.opacity = "1"; }); pendingShow = [];
      kick();
    }
    var ro = null;
    if (root.ResizeObserver) {
      ro = new ResizeObserver(function () {
        if (roPending) return;
        roPending = root.requestAnimationFrame(function () { roPending = 0; resize(); });
      });
      ro.observe(container);
    }
    // Tekstmål blir riktige først når fontene er lastet.
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(function () { if (!destroyed) resize(); });

    /* ---------- offentlig API ---------- */
    var api = {
      setDate: function (d) {
        var ms = dayEnd(d);
        if (isNaN(ms)) return api;
        reqMs = clamp(ms, D0, D1);
        targetMs = snapMs(reqMs);
        if (reduced) animMs = targetMs;
        kick();
        return api;
      },
      setMetric: function (m) {
        if (!METRIC_LABEL[m] || m === metric) return api;
        var now = root.performance ? root.performance.now() : Date.now();
        prevMetric = metric;
        metric = m; mix = reduced ? 1 : 0; mixStart = now;
        if (reduced) prevMetric = m;
        kick();
        return api;
      },
      resize: function () { resize(); return api; },
      on: function (name, fn) {
        if (!listeners[name]) listeners[name] = [];
        listeners[name].push(fn);
        lastEmit = "";
        kick();
        return function () { api.off(name, fn); };
      },
      off: function (name, fn) {
        var a = listeners[name]; if (!a) return api;
        var k = a.indexOf(fn); if (k >= 0) a.splice(k, 1);
        return api;
      },
      getState: function () { return { date: isoDate(reqMs - DAY), metric: metric, animDate: isoDate(animMs - DAY) }; },
      destroy: function () {
        destroyed = true;
        if (raf) root.cancelAnimationFrame(raf);
        if (ro) ro.disconnect();
        svg.remove();
      }
    };

    layout();
    yMax = yMaxFor(animMs);
    buildStatic();
    if (opts.date) api.setDate(opts.date);
    animMs = targetMs; yMax = yMaxFor(animMs); xEnd = xEndTarget = xEndFor(animMs);
    render(0);
    pendingShow.forEach(function (g) { g.style.opacity = "1"; }); pendingShow = [];
    kick();
    return api;
  }

  root.SagaChart = { create: create, version: "1.0.0" };
})(typeof window !== "undefined" ? window : this);

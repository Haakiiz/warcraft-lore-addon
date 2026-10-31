/* =========================================================================
   Terran-briefing (arbeider D)
   - Tegner et rundt, skittent industrirom i <canvas> (640x360, skalert pikselert)
   - Terminaltekst på monitorene, portretter med statisk støy
   - Briefingtekst skrives ut tegn for tegn (lyd via window.SCAudio?.type())
   All grafikk er laget her; ingen eksterne bilder.
   ========================================================================= */
(function () {
  "use strict";

  /* ---------- Hjelpere ---------- */
  function rng(seed) {                       // mulberry32: samme rom hver gang
    return function () {
      seed |= 0; seed = (seed + 0x6d2b79f5) | 0;
      var t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
      t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }
  function clamp(v, a, b) { return v < a ? a : v > b ? b : v; }
  function rgb(r, g, b, a) {
    r = Math.round(clamp(r, 0, 255)); g = Math.round(clamp(g, 0, 255)); b = Math.round(clamp(b, 0, 255));
    return a == null ? "rgb(" + r + "," + g + "," + b + ")" : "rgba(" + r + "," + g + "," + b + "," + a + ")";
  }
  function sfx(name) {
    try {
      var a = window.SCAudio;
      if (a && typeof a[name] === "function") a[name]();
    } catch (e) { /* lyd er valgfritt */ }
  }

  /* ---------- Skalering av 16:9-scenen ---------- */
  var stage = document.getElementById("bfStage");
  function fit() {
    var s = Math.min(window.innerWidth / 1280, window.innerHeight / 720);
    stage.style.transform = "translate(-50%, -50%) scale(" + s + ")";
  }
  window.addEventListener("resize", fit);
  fit();

  /* =======================================================================
     ROMMET
     Sylinderprojeksjon: et punkt på veggen (vinkel th, høyde v) havner på
     x = CX + F*sin(th), y = HOR + G*v*(1 + K*(1-cos th)). Flisene smalner
     av mot sidene, og ringlinjene krummer innover som i et rundt rom.
     ======================================================================= */
  var W = 640, H = 360, CX = 380, F = 372, G = 300, K = 0.95, HOR = 168;
  var V_TOP = -0.40, V_FLOOR = 0.44;
  var BAYER = [0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5];
  function bayer(x, y) { return (BAYER[(y & 3) * 4 + (x & 3)] + 0.5) / 16; }
  var LAMPS = [
    { th: -0.62, v: -0.30 }, { th: -0.30, v: -0.30 },
    { th: 0.27, v: -0.30 }, { th: 0.58, v: -0.30 }
  ];
  function P(th, v) { return [CX + F * Math.sin(th), HOR + G * v * (1 + K * (1 - Math.cos(th)))]; }

  function drawRoom(cv) {
    var c = cv.getContext("2d");
    var R = rng(7331);
    c.imageSmoothingEnabled = false;

    var TH0 = -1.56, TH1 = 0.80, DT = 0.036, DV = 0.042;

    /* --- 1. fliser: hver flis får egen lyshet (±8 %) og eget støylag --- */
    c.fillStyle = "rgb(8,9,8)";
    c.fillRect(0, 0, W, H);
    var cells = [];
    for (var th = TH0; th < TH1; th += DT) {
      for (var v = V_TOP; v < V_FLOOR; v += DV) {
        var a = P(th, v), b = P(th + DT, v), d = P(th + DT, v + DV), e = P(th, v + DV);
        var k = 0.92 + R() * 0.16;
        if (R() < 0.05) k *= 0.8;             // enkelte skitne fliser
        c.fillStyle = rgb(86 * k, 90 * k, 90 * k);
        c.beginPath(); c.moveTo(a[0], a[1]); c.lineTo(b[0], b[1]); c.lineTo(d[0], d[1]); c.lineTo(e[0], e[1]); c.closePath();
        c.fill();
        // støylag inne i flisen
        var x0 = Math.ceil(Math.min(a[0], e[0])), x1 = Math.floor(Math.max(b[0], d[0]));
        var y0 = Math.ceil(Math.max(a[1], b[1])), y1 = Math.floor(Math.min(d[1], e[1]));
        for (var ny = y0 + 1; ny < y1; ny++) for (var nx = x0 + 1; nx < x1; nx++) {
          var r = R();
          if (r < 0.22) { c.fillStyle = r < 0.11 ? "rgba(0,0,0,0.16)" : "rgba(255,255,255,0.07)"; c.fillRect(nx, ny, 1, 1); }
        }
        // svak fas: lys topp i flisen
        c.fillStyle = rgb(118 * k, 122 * k, 120 * k, 0.35);
        c.fillRect(a[0] + 1, a[1] + 1, Math.max(1, b[0] - a[0] - 2), 1);
        cells.push([a, b, e]);
      }
    }
    /* --- 2. fuger: 1 px #1a1814, ujevne, enkelte segmenter mangler --- */
    c.fillStyle = "#1a1814";
    cells.forEach(function (q) {
      var a = q[0], b = q[1], e = q[2], jit, n, i;
      if (R() > 0.1) {                                  // øvre fuge (kort, nesten rett linje)
        jit = R() < 0.3 ? (R() < 0.5 ? -1 : 1) : 0;
        n = Math.max(1, Math.round(b[0] - a[0]));
        for (i = 0; i <= n; i++) {
          if (R() < 0.04) continue;                     // små hull
          var fx = a[0] + (b[0] - a[0]) * i / n, fy = a[1] + (b[1] - a[1]) * i / n;
          c.fillRect(Math.round(fx), Math.round(fy) + jit, 1, 1);
        }
      }
      if (R() > 0.1) {                                  // venstre fuge
        jit = R() < 0.3 ? (R() < 0.5 ? -1 : 1) : 0;
        c.fillRect(Math.round(a[0]) + jit, Math.round(a[1]), 1, Math.max(1, Math.round(e[1] - a[1])));
      }
    });

    /* --- 3. skitt: store, myke flekker (lavoppløst støy skalert opp) --- */
    var nz = document.createElement("canvas"); nz.width = 32; nz.height = 18;
    var nc = nz.getContext("2d");
    for (var y = 0; y < 18; y++) for (var x = 0; x < 32; x++) {
      nc.fillStyle = "rgba(24,20,12," + (R() * 0.5).toFixed(3) + ")";
      nc.fillRect(x, y, 1, 1);
    }
    c.imageSmoothingEnabled = true;
    c.drawImage(nz, 0, 0, W, H);
    c.imageSmoothingEnabled = false;

    /* --- 5. tak og ringhylle øverst --- */
    function band(v0, v1, fill) {
      c.fillStyle = fill;
      c.beginPath();
      for (var t = TH0; t <= TH1 + 0.01; t += 0.01) { var q = P(t, v0); if (t === TH0) c.moveTo(q[0], q[1]); else c.lineTo(q[0], q[1]); }
      for (t = TH1; t >= TH0 - 0.01; t -= 0.01) { q = P(t, v1); c.lineTo(q[0], q[1]); }
      c.closePath(); c.fill();
    }
    function ringLine(v, style, dy) {
      c.strokeStyle = style; c.beginPath();
      for (var t = TH0; t <= TH1 + 0.01; t += 0.01) { var q = P(t, v); if (t === TH0) c.moveTo(q[0], q[1] + (dy || 0)); else c.lineTo(q[0], q[1] + (dy || 0)); }
      c.stroke();
    }
    /* --- 6. rør --- */
    function hPipe(v, t0, t1, w) {
      var layers = [[w + 2, "rgb(14,15,13)", 0], [w, "rgb(58,60,54)", 0], [Math.max(1, w * 0.4), "rgb(104,104,92)", -w * 0.22]];
      layers.forEach(function (L) {
        c.lineWidth = L[0]; c.strokeStyle = L[1]; c.beginPath();
        for (var t = t0; t <= t1 + 0.005; t += 0.01) { var q = P(t, v); if (t === t0) c.moveTo(q[0], q[1] + L[2]); else c.lineTo(q[0], q[1] + L[2]); }
        c.stroke();
      });
      c.lineWidth = 1;
      for (var t = t0 + 0.03; t < t1; t += 0.11) {            // klammer
        var q = P(t, v);
        c.fillStyle = "rgb(22,22,20)"; c.fillRect(Math.round(q[0]) - 1, Math.round(q[1] - w / 2 - 2), 3, w + 4);
        c.fillStyle = "rgb(110,108,96)"; c.fillRect(Math.round(q[0]) - 1, Math.round(q[1] - w / 2 - 2), 1, w + 4);
      }
    }
    function vPipe(th, v0, v1, w) {
      var a = P(th, v0), b = P(th, v1);
      var x = Math.round(a[0]);
      w = Math.max(2, Math.round(w * Math.cos(th)));
      c.fillStyle = "rgb(14,15,13)"; c.fillRect(x - 1, a[1], w + 2, b[1] - a[1]);
      c.fillStyle = "rgb(58,60,54)"; c.fillRect(x, a[1], w, b[1] - a[1]);
      c.fillStyle = "rgb(108,108,96)"; c.fillRect(x + 1, a[1], 1, b[1] - a[1]);
      c.fillStyle = "rgba(0,0,0,0.35)"; c.fillRect(x + w + 1, a[1], 2, b[1] - a[1]);   // slagskygge mot veggen
      for (var vv = v0 + 0.05; vv < v1; vv += 0.12) {
        var q = P(th, vv);
        c.fillStyle = "rgb(24,24,22)"; c.fillRect(x - 2, Math.round(q[1]), w + 4, 2);
      }
    }
    hPipe(-0.375, TH0, TH1, 4);
    // horisontalt rør (8 px) med flenser ca. 60 % ned på veggen
    var MOUNTS = [];
    function flangePipe(v, t0, t1) {
      hPipe(v, t0, t1, 4);
      for (var t = t0 + 0.06; t < t1 - 0.02; t += 0.19) {
        var q = P(t, v), x = Math.round(q[0]), y = Math.round(q[1]);
        c.fillStyle = "rgb(10,10,9)"; c.fillRect(x - 2, y - 5, 5, 11);
        c.fillStyle = "rgb(70,70,64)"; c.fillRect(x - 1, y - 4, 3, 9);
        c.fillStyle = "#6a6a6a"; c.fillRect(x - 1, y - 4, 1, 9); c.fillRect(x - 1, y - 4, 3, 1);
        c.fillStyle = "rgb(20,20,18)"; c.fillRect(x + 1, y - 4, 1, 9);
        MOUNTS.push({ x: x, y: y + 6 });
      }
    }
    flangePipe(0.10, TH0, -0.69);
    flangePipe(0.10, -0.47, TH1);
    hPipe(-0.365, -0.92, -0.52, 2);
    hPipe(0.29, TH0, -0.67, 5);
    hPipe(0.29, -0.49, TH1, 5);
    hPipe(0.335, TH0, -0.67, 3);
    hPipe(0.335, -0.49, TH1, 3);
    vPipe(-0.80, -0.375, V_FLOOR, 4);
    vPipe(-0.40, -0.375, V_FLOOR, 3);
    vPipe(-0.36, -0.375, 0.29, 2);
    vPipe(0.20, -0.375, V_FLOOR, 3);
    vPipe(0.66, -0.375, V_FLOOR, 4);

    /* --- 7. dør til venstre --- */
    (function door() {
      var t0 = -0.665, t1 = -0.495, v0 = -0.20, v1 = V_FLOOR;
      var A = P(t0, v0), B = P(t1, v0), C = P(t1, v1), D = P(t0, v1);
      var arch = 18;
      // karm
      c.fillStyle = "rgb(30,31,28)";
      c.beginPath(); c.moveTo(A[0] - 4, D[1]); c.lineTo(A[0] - 4, A[1] + arch);
      c.quadraticCurveTo((A[0] + B[0]) / 2, A[1] - arch - 4, B[0] + 4, B[1] + arch);
      c.lineTo(B[0] + 4, C[1]); c.closePath(); c.fill();
      // dørblad
      c.fillStyle = "rgb(56,58,52)";
      c.beginPath(); c.moveTo(A[0], D[1]); c.lineTo(A[0], A[1] + arch);
      c.quadraticCurveTo((A[0] + B[0]) / 2, A[1] - arch, B[0], B[1] + arch);
      c.lineTo(B[0], C[1]); c.closePath(); c.fill();
      c.strokeStyle = "rgba(130,126,110,0.6)"; c.lineWidth = 1;
      c.beginPath(); c.moveTo(A[0] + 1.5, D[1]); c.lineTo(A[0] + 1.5, A[1] + arch);
      c.quadraticCurveTo((A[0] + B[0]) / 2, A[1] - arch + 2, B[0] - 1, B[1] + arch); c.stroke();
      // panelfelt og nagler
      var mx = (A[0] + B[0]) / 2, w = B[0] - A[0];
      c.fillStyle = "rgb(40,42,38)";
      c.fillRect(A[0] + 6, A[1] + arch + 34, w - 12, 28);
      c.fillRect(A[0] + 6, A[1] + arch + 70, w - 12, 50);
      for (var ry = A[1] + arch; ry < D[1]; ry += 9) {
        c.fillStyle = "rgb(128,124,110)"; c.fillRect(Math.round(A[0] + 3), Math.round(ry), 1, 1); c.fillRect(Math.round(B[0] - 4), Math.round(ry), 1, 1);
      }
      // kikkehull
      c.fillStyle = "rgb(16,18,16)"; c.beginPath(); c.arc(mx, A[1] + arch + 12, 7, 0, Math.PI * 2); c.fill();
      c.strokeStyle = "rgb(110,108,94)"; c.beginPath(); c.arc(mx, A[1] + arch + 12, 7, Math.PI * 0.9, Math.PI * 1.7); c.stroke();
      // ratt
      var wy = A[1] + arch + 48;
      c.strokeStyle = "rgb(20,20,18)"; c.lineWidth = 3; c.beginPath(); c.arc(mx, wy, 9, 0, Math.PI * 2); c.stroke();
      c.strokeStyle = "rgb(112,110,96)"; c.lineWidth = 1; c.beginPath(); c.arc(mx, wy, 9, Math.PI, Math.PI * 1.6); c.stroke();
      c.fillStyle = "rgb(20,20,18)"; c.fillRect(mx - 9, wy - 1, 18, 2); c.fillRect(mx - 1, wy - 9, 2, 18);
      c.fillStyle = "rgb(90,30,18)"; c.fillRect(mx - 2, wy - 2, 4, 4);
      // lite rødt varsellys over døren
      c.fillStyle = "rgb(200,40,24)"; c.fillRect(Math.round(mx) - 1, Math.round(A[1] - arch - 8), 3, 2);
    })();

    /* --- 8. stige til høyre --- */
    (function ladder() {
      var t0 = 0.40, t1 = 0.45, v0 = -0.37, v1 = V_FLOOR;
      var a0 = P(t0, v0), b0 = P(t1, v0), a1 = P(t0, v1);
      var xa = Math.round(a0[0]), xb = Math.round(b0[0]);
      for (var v = v0 + 0.02; v < v1; v += 0.045) {
        var p = P(t0, v), q = P(t1, v);
        c.strokeStyle = "rgba(0,0,0,0.5)"; c.beginPath(); c.moveTo(p[0], p[1] + 2.5); c.lineTo(q[0] + 2, q[1] + 2.5); c.stroke();
        c.strokeStyle = "rgb(30,30,27)"; c.lineWidth = 2; c.beginPath(); c.moveTo(p[0], p[1]); c.lineTo(q[0], q[1]); c.stroke();
        c.strokeStyle = "rgb(150,146,128)"; c.lineWidth = 1; c.beginPath(); c.moveTo(p[0], p[1] - 0.5); c.lineTo(q[0], q[1] - 0.5); c.stroke();
      }
      [xa, xb].forEach(function (x) {
        c.fillStyle = "rgba(0,0,0,0.45)"; c.fillRect(x + 3, a0[1], 2, a1[1] - a0[1]);
        c.fillStyle = "rgb(24,24,22)"; c.fillRect(x - 1, a0[1] - 4, 3, a1[1] - a0[1] + 4);
        c.fillStyle = "rgb(140,136,118)"; c.fillRect(x - 1, a0[1] - 4, 1, a1[1] - a0[1] + 4);
      });
    })();

    /* --- 9. lysberegning per piksel: lamper, hardt avgrensede lysfelt, mørke sider (dithret) --- */
    var img = c.getImageData(0, 0, W, H), px = img.data;
    var LC = [216, 184, 96];                                   // #d8b860
    for (y = 0; y < H; y++) {
      for (x = 0; x < W; x++) {
        var sx = clamp((x - CX) / F, -0.9995, 0.9995);
        var t = Math.asin(sx), fac = 1 + K * (1 - Math.cos(t)), vv = (y - HOR) / (G * fac);
        var bz = bayer(x, y);
        var warm = 0, field = 0;
        for (var li = 0; li < LAMPS.length; li++) {
          var dt = t - LAMPS[li].th, dv = vv - LAMPS[li].v;
          warm += Math.exp(-(dt * dt) / 0.010 - dv * dv / (dv > 0 ? 0.05 : 0.015));
          if (dv > -0.03 && dv < 0.30) {                        // lyskjegle under lampen
            var halfw = 0.05 + Math.max(0, dv) * 0.2;
            var m = Math.min(1 - Math.abs(dt) / halfw, 1 - (dv + 0.03) / 0.33);
            if (m > 0) {
              var tier = dv < 0.14 ? 1 : 0.6;                   // to harde trinn
              if (m > 0.14 || m / 0.14 > bz) field = Math.max(field, tier);
            }
          }
        }
        warm = Math.min(warm, 1.2);
        var amb = 0.56 - Math.max(0, -vv - 0.22) * 1.2 - Math.max(0, vv - 0.18) * 0.25;
        var green = 0.16 * Math.exp(-(t * t) / 0.03 - (vv + 0.17) * (vv + 0.17) / 0.04);   // grønt skjær fra monitorene
        var L = Math.max(0.10, amb) + warm * 0.22;
        // mørke sider: kvantisert i trinn med Bayer-dithering (ingen blur)
        var side = t < 0 ? clamp((-t - 0.70) / 0.62, 0, 1) : clamp((t - 0.50) / 0.30, 0, 1);
        var lvl = Math.min(4, Math.floor(side * 4 + bz)) / 4;
        L *= 1 - lvl * 0.82;
        var n = (R() - 0.5) * 20;
        var i4 = (y * W + x) * 4;
        var r0 = px[i4], g0 = px[i4 + 1], b0 = px[i4 + 2];
        if (field) {                                            // sterkere flis-/fugekontrast i lyset
          r0 = clamp(r0 + (r0 - 60) * 0.7, 0, 255); g0 = clamp(g0 + (g0 - 62) * 0.7, 0, 255); b0 = clamp(b0 + (b0 - 62) * 0.7, 0, 255);
        }
        var r = r0 * L * (1 + warm * 0.25), g = g0 * (L + green) * (1 + warm * 0.15), b = b0 * L * (1 - warm * 0.1);
        if (field) {
          var lum = (r0 + g0 + b0) / 3 / 255, k = 0.45 * field * (1 - lvl);
          r += (LC[0] * (0.25 + lum) - r) * k; g += (LC[1] * (0.25 + lum) - g) * k; b += (LC[2] * (0.25 + lum) - b) * k;
        }
        px[i4] = clamp(r + n, 0, 255);
        px[i4 + 1] = clamp(g + n, 0, 255);
        px[i4 + 2] = clamp(b + n * 0.8, 0, 255);
      }
    }
    c.putImageData(img, 0, 0);

    /* --- 9b. mørkt tak med ribber (tegnes etter lyset, med egen dempet palett) --- */
    band(-3, V_TOP - 0.03, "rgb(13,14,13)");
    // mørkt tak: metallribber som buer innover mot midten
    for (var rt = TH0 + 0.06; rt < TH1; rt += 0.17) {
      var r0 = P(rt, V_TOP - 0.03);
      var ex = CX + (r0[0] - CX) * 0.38, ey = -40;
      var qx = r0[0] + (CX - r0[0]) * 0.04, qy = r0[1] - 70;
      c.lineWidth = 4; c.strokeStyle = "rgb(6,6,6)";
      c.beginPath(); c.moveTo(r0[0], r0[1]); c.quadraticCurveTo(qx, qy, ex, ey); c.stroke();
      c.lineWidth = 2; c.strokeStyle = "rgb(40,41,37)";
      c.beginPath(); c.moveTo(r0[0], r0[1]); c.quadraticCurveTo(qx, qy, ex, ey); c.stroke();
      c.lineWidth = 1; c.strokeStyle = "rgb(96,94,82)";
      c.beginPath(); c.moveTo(r0[0] - 1, r0[1]); c.quadraticCurveTo(qx - 1, qy, ex - 1, ey); c.stroke();
    }
    // tverrbånd i taket
    [-0.50].forEach(function (cv) {
      c.lineWidth = 2; c.strokeStyle = "rgb(30,31,28)"; c.beginPath();
      for (var t = TH0; t <= TH1 + 0.01; t += 0.01) {
        var q = P(t, cv), qy2 = q[1] + (q[1] < HOR ? 0 : 0);
        var cx2 = CX + (q[0] - CX) * (1 - Math.min(0.5, (V_TOP - cv) * 0.9));
        if (t === TH0) c.moveTo(cx2, qy2); else c.lineTo(cx2, qy2);
      }
      c.stroke(); c.lineWidth = 1;
    });
    band(V_TOP - 0.03, V_TOP + 0.012, "rgb(44,45,40)");
    ringLine(V_TOP - 0.03, "rgba(120,118,104,0.8)", 0.5);
    ringLine(V_TOP + 0.012, "rgba(8,8,8,0.95)", 0.5);
    for (rt = TH0; rt < TH1; rt += 0.04) {   // nagler i hyllen
      var rv = P(rt, V_TOP - 0.009);
      c.fillStyle = "rgb(120,118,106)"; c.fillRect(Math.round(rv[0]), Math.round(rv[1]), 1, 1);
      c.fillStyle = "rgb(10,10,10)"; c.fillRect(Math.round(rv[0]) + 1, Math.round(rv[1]) + 1, 1, 1);
    }

    /* --- 9c. rustspor ETTER lyset: 8–12 under hver lampe og hvert rørfeste --- */
    function rustTrail(x, y) {
      var w = 1 + Math.floor(R() * 3);                       // 1–3 canvaspx = 2–6 px på scenen
      var len = 20 + Math.floor(R() * 41);                   // 20–60 canvaspx = 40–120 px
      var al = 0.35 + R() * 0.25;
      for (var i = 0; i < w; i++) {
        var L = Math.round(len * (0.55 + R() * 0.45)), xx = x + i, wob = 0;
        var g = c.createLinearGradient(0, y, 0, y + L);
        g.addColorStop(0, "rgba(90,42,20," + al.toFixed(2) + ")");          // #5a2a14
        g.addColorStop(0.55, "rgba(70,32,16," + (al * 0.7).toFixed(2) + ")");
        g.addColorStop(1, "rgba(58,26,12,0)");                               // #3a1a0c
        c.fillStyle = g;
        for (var yy = 0; yy < L; yy += 6) {                   // svak vandring sidelengs
          if (R() < 0.15) wob += R() < 0.5 ? -1 : 1;
          c.fillRect(xx + wob, y + yy, 1, Math.min(6, L - yy));
        }
      }
    }
    LAMPS.forEach(function (l) {
      var q = P(l.th, l.v), n = 8 + Math.floor(R() * 5);
      for (var i = 0; i < n; i++) rustTrail(Math.round(q[0] + (R() - 0.5) * 26), Math.round(q[1] + 12 + R() * 6));
    });
    MOUNTS.forEach(function (m) {
      var n = 8 + Math.floor(R() * 5);
      for (var i = 0; i < n; i++) rustTrail(Math.round(m.x + (R() - 0.5) * 28), m.y - 2 + Math.floor(R() * 8));
    });

    /* --- 10. gulv --- */
    c.fillStyle = "rgb(12,12,11)";
    c.beginPath();
    for (th = TH0; th <= TH1 + 0.01; th += 0.01) { var p = P(th, V_FLOOR); if (th === TH0) c.moveTo(p[0], p[1]); else c.lineTo(p[0], p[1]); }
    c.lineTo(W, H); c.lineTo(0, H); c.closePath(); c.fill();
    c.strokeStyle = "rgba(70,70,62,0.5)"; c.lineWidth = 1;
    for (var ring = 0; ring < 4; ring++) {
      c.beginPath(); c.ellipse(CX, 352 + ring * 3, 150 + ring * 70, 16 + ring * 6, 0, Math.PI, Math.PI * 2); c.stroke();
    }

    /* --- 11. sentral maskin --- */
    drawMachine(c);

    /* --- 11b. blågrå tone over hele rommet (multiply #2a3038, 0,25) --- */
    c.globalCompositeOperation = "multiply";
    c.fillStyle = "rgba(42,48,56,0.25)"; c.fillRect(0, 0, W, H);
    c.globalCompositeOperation = "source-over";

    /* --- 12. lyskjegler (trekant) og lamper i buede bur --- */
    LAMPS.forEach(function (l) {
      var q = P(l.th, l.v), x = q[0], y = q[1] + 9;
      var g = c.createLinearGradient(0, y, 0, y + 92);
      g.addColorStop(0, "rgba(255,210,120,0.18)"); g.addColorStop(1, "rgba(255,210,120,0)");
      c.fillStyle = g;
      c.beginPath(); c.moveTo(x - 3, y); c.lineTo(x + 3, y); c.lineTo(x + 26, y + 92); c.lineTo(x - 26, y + 92); c.closePath(); c.fill();
    });
    LAMPS.forEach(function (l) {
      var q = P(l.th, l.v), x = Math.round(q[0]) + 0.5, y = Math.round(q[1]);
      // oppheng fra røret
      c.fillStyle = "rgb(18,18,16)"; c.fillRect(x - 0.5, y - 21, 1, 11);
      // glorie: maks 4 canvaspx (8 px på scenen)
      var gl = c.createRadialGradient(x, y + 1, 0, x, y + 1, 7);
      gl.addColorStop(0, "rgba(255,216,112,0.55)"); gl.addColorStop(0.6, "rgba(255,190,90,0.18)"); gl.addColorStop(1, "rgba(255,180,80,0)");
      c.fillStyle = gl; c.fillRect(x - 7, y - 6, 14, 14);
      // svakt glass
      c.fillStyle = "rgba(210,160,80,0.35)";
      c.beginPath(); c.ellipse(x, y + 1, 5, 6, 0, 0, Math.PI * 2); c.fill();
      // pærekjerne #ffd870
      c.fillStyle = "#ffd870"; c.beginPath(); c.ellipse(x, y + 1, 2, 3, 0, 0, Math.PI * 2); c.fill();
      c.fillStyle = "rgb(255,246,214)"; c.fillRect(x - 0.5, y - 1, 1, 2);
      // rund topp (kuppel)
      c.fillStyle = "rgb(26,25,22)"; c.beginPath(); c.arc(x, y - 5, 5, Math.PI, 0); c.fill();
      c.fillStyle = "rgb(26,25,22)"; c.fillRect(x - 1.5, y - 11, 3, 2);
      c.strokeStyle = "#6a6a6a"; c.lineWidth = 1; c.beginPath(); c.arc(x, y - 5, 4.5, Math.PI * 1.05, Math.PI * 1.55); c.stroke();
      // 4 buede burstag
      c.strokeStyle = "rgb(22,20,16)";
      [[-4.5, -7.5], [-1.5, -2.5], [1.5, 2.5], [4.5, 7.5]].forEach(function (s) {
        c.beginPath(); c.moveTo(x + s[0], y - 5); c.quadraticCurveTo(x + s[1], y + 1, x + s[0], y + 7); c.stroke();
      });
      c.strokeStyle = "rgba(120,110,90,0.8)";
      c.beginPath(); c.moveTo(x - 4.5, y - 5); c.quadraticCurveTo(x - 7.5, y + 1, x - 4.5, y + 7); c.stroke();
      // ring på midten + rund bunn
      c.strokeStyle = "rgb(22,20,16)"; c.beginPath(); c.ellipse(x, y + 1, 6, 1.5, 0, 0, Math.PI); c.stroke();
      c.fillStyle = "rgb(26,25,22)"; c.beginPath(); c.arc(x, y + 7, 4.5, 0, Math.PI); c.fill();
      c.fillRect(x - 1, y + 11, 2, 2);
    });
  }

  /* Maskinen i midten: sokkel, søyle, slanger, arm og høyttalertrakt */
  function drawMachine(c) {
    function bez(p0, p1, p2, p3, t) {
      var u = 1 - t;
      return u * u * u * p0 + 3 * u * u * t * p1 + 3 * u * t * t * p2 + t * t * t * p3;
    }
    function tube(pts, w, base, clamps) {
      var b = base || [60, 60, 54];
      function path(dx, dy) {
        c.beginPath(); c.moveTo(pts[0] + dx, pts[1] + dy);
        for (var i = 2; i < pts.length; i += 6) c.bezierCurveTo(pts[i] + dx, pts[i + 1] + dy, pts[i + 2] + dx, pts[i + 3] + dy, pts[i + 4] + dx, pts[i + 5] + dy);
      }
      c.lineCap = "round";
      path(0, 0); c.lineWidth = w + 2; c.strokeStyle = "rgb(8,8,8)"; c.stroke();
      path(0, 0); c.lineWidth = w; c.strokeStyle = rgb(b[0], b[1], b[2]); c.stroke();
      path(-w * 0.2, -w * 0.2); c.lineWidth = 1; c.strokeStyle = rgb(b[0] * 2, b[1] * 1.95, b[2] * 1.85); c.stroke();   // 1 px highlight
      path(w * 0.3, w * 0.3); c.lineWidth = 1; c.strokeStyle = "rgba(0,0,0,0.6)"; c.stroke();                          // 1 px skygge
      c.setLineDash([1, 2]);
      path(0, 0); c.lineWidth = w; c.strokeStyle = "rgba(0,0,0,0.3)"; c.stroke();     // riller/dither
      c.setLineDash([]);
      c.lineCap = "butt"; c.lineWidth = 1;
      // 2–3 klemringer med 1 px lyse kanter (#6a6a6a)
      var segs = (pts.length - 2) / 6;
      (clamps || [0.3, 0.7]).forEach(function (tt) {
        var si = Math.min(segs - 1, Math.floor(tt * segs)), lt = tt * segs - si, o = si * 6;
        var P0x = pts[o], P0y = pts[o + 1], P1x = pts[o + 2], P1y = pts[o + 3], P2x = pts[o + 4], P2y = pts[o + 5], P3x = pts[o + 6], P3y = pts[o + 7];
        var x = bez(P0x, P1x, P2x, P3x, lt), y = bez(P0y, P1y, P2y, P3y, lt);
        var x2 = bez(P0x, P1x, P2x, P3x, Math.min(1, lt + 0.02)), y2 = bez(P0y, P1y, P2y, P3y, Math.min(1, lt + 0.02));
        var ang = Math.atan2(y2 - y, x2 - x);
        c.save(); c.translate(x, y); c.rotate(ang);
        c.fillStyle = "rgb(10,10,10)"; c.fillRect(-2.5, -w / 2 - 1.5, 5, w + 3);
        c.fillStyle = "rgb(44,44,40)"; c.fillRect(-1.5, -w / 2 - 1, 3, w + 2);
        c.fillStyle = "#6a6a6a"; c.fillRect(-1.5, -w / 2 - 1, 1, w + 2); c.fillRect(1.5, -w / 2 - 1, 1, w + 2);
        c.restore();
      });
    }
    // flate med dithret skyggelegging (1 px highlight + skygge, Bayer-overganger, kornstøy)
    function metalPoly(xt0, xt1, xb0, xb1, y0, y1, base, hl) {
      for (var y = Math.round(y0); y < Math.round(y1); y++) {
        var f = (y - y0) / Math.max(1, y1 - y0);
        var xl = Math.round(xt0 + (xb0 - xt0) * f), xr = Math.round(xt1 + (xb1 - xt1) * f);
        for (var x = xl; x < xr; x++) {
          var u = (x - xl) / Math.max(1, xr - xl - 1);
          var prof = 0.25 + 0.95 * Math.max(0, Math.cos((u - (hl || 0.32)) * 2.7));
          var lvl = Math.floor(prof * 4 + bayer(x, y)) / 4;
          var m = 0.35 + lvl * 0.55 + (Math.random() - 0.5) * 0.08;
          if (x === xl) m = 0.15; else if (x === xr - 1) m = 0.12;
          c.fillStyle = rgb(base[0] * m, base[1] * m, base[2] * m); c.fillRect(x, y, 1, 1);
        }
        if (y === Math.round(y0)) { c.fillStyle = "rgb(150,146,132)"; c.fillRect(xl + 1, y, xr - xl - 2, 1); }
      }
      c.fillStyle = "rgb(6,6,6)"; c.fillRect(Math.round(xb0), Math.round(y1) - 1, Math.round(xb1 - xb0), 1);
    }
    // skygge på gulvet
    c.fillStyle = "rgba(0,0,0,0.65)"; c.beginPath(); c.ellipse(382, 352, 118, 13, 0, 0, Math.PI * 2); c.fill();

    // slanger bak/rundt foten (3–9 px, 2–3 klemringer hver)
    tube([330, 348, 268, 352, 234, 320, 248, 282, 260, 256, 296, 246, 312, 190], 9, [50, 52, 54], [0.2, 0.55, 0.85]);
    tube([436, 346, 506, 354, 528, 318, 504, 282, 488, 262, 452, 244, 458, 198], 7, [50, 52, 54], [0.25, 0.6, 0.88]);
    tube([344, 336, 298, 334, 282, 300, 298, 272, 312, 254, 342, 252, 368, 236], 5, [58, 58, 56], [0.3, 0.75]);
    tube([424, 336, 466, 330, 478, 306, 462, 284, 448, 270, 418, 262, 400, 252], 4, [62, 62, 60], [0.35, 0.8]);
    tube([370, 300, 332, 298, 312, 268, 318, 190], 6, null, [0.3, 0.7]);
    tube([404, 300, 428, 290, 446, 252, 462, 200], 3, null, [0.4, 0.8]);
    tube([376, 240, 344, 230, 330, 160, 352, 124], 3, [44, 46, 48], [0.35, 0.7]);
    tube([398, 236, 424, 222, 432, 160, 414, 124], 4, [44, 46, 48], [0.3, 0.65, 0.9]);

    // faset metallboks: lys topp/venstre, mørk bunn/høyre
    function box(x, y, w, h, col) {
      c.fillStyle = "rgb(6,6,6)"; c.fillRect(x - 1, y - 1, w + 2, h + 2);
      c.fillStyle = rgb(col[0], col[1], col[2]); c.fillRect(x, y, w, h);
      c.fillStyle = rgb(col[0] * 1.9, col[1] * 1.85, col[2] * 1.7); c.fillRect(x, y, w, 1); c.fillRect(x, y, 1, h);
      c.fillStyle = rgb(col[0] * 0.45, col[1] * 0.45, col[2] * 0.45); c.fillRect(x, y + h - 1, w, 1); c.fillRect(x + w - 1, y, 1, h);
    }
    function rivets(x0, x1, y, step) {
      for (var x = x0; x <= x1; x += step) {
        c.fillStyle = "rgb(150,142,116)"; c.fillRect(Math.round(x), y, 1, 1);
        c.fillStyle = "rgb(8,8,8)"; c.fillRect(Math.round(x) + 1, y + 1, 1, 1);
      }
    }
    function tier(xt0, xt1, xb0, xb1, y0, y1, hi) {
      metalPoly(xt0, xt1, xb0, xb1, y0, y1, [hi * 1.25, hi * 1.25, hi * 1.28]);
    }
    // bred, naglet sokkel i tre trinn
    tier(310, 454, 298, 466, 336, 352, 66);
    rivets(304, 460, 344, 7);
    tier(326, 438, 320, 444, 312, 336, 74);
    rivets(326, 438, 316, 8);
    for (var hx = 0; hx < 13; hx++) {                          // fareskilt-stripe
      c.fillStyle = hx % 2 ? "rgb(20,18,10)" : "rgb(150,120,24)";
      c.beginPath(); c.moveTo(332 + hx * 8, 322); c.lineTo(338 + hx * 8, 322); c.lineTo(334 + hx * 8, 329); c.lineTo(328 + hx * 8, 329); c.closePath(); c.fill();
    }
    c.fillStyle = "rgb(8,8,8)"; c.fillRect(326, 330, 112, 1);
    tier(348, 416, 344, 420, 296, 312, 82);
    rivets(350, 414, 300, 6);
    box(306, 340, 14, 9, [46, 46, 40]); box(444, 340, 14, 9, [46, 46, 40]);

    // søyle: tre segmenter som forskyves litt ut av midtaksen, med skrå flenser og naglerader
    metalPoly(370, 392, 371, 393, 118, 168, [92, 92, 94], 0.3);
    metalPoly(366, 398, 372, 392, 166, 174, [100, 100, 100], 0.3);      // skrå flens
    rivets(370, 394, 169, 4);
    metalPoly(373, 395, 375, 397, 174, 226, [88, 88, 90], 0.34);
    metalPoly(368, 402, 375, 397, 222, 228, [100, 100, 100], 0.34);
    metalPoly(377, 399, 379, 401, 240, 288, [86, 86, 88], 0.36);
    metalPoly(370, 406, 377, 401, 286, 297, [100, 100, 100], 0.36);    // nedre flens mot sokkelen
    rivets(373, 404, 290, 4);
    for (var cy = 184; cy < 222; cy += 12) rivets(376, 394, cy, 6);
    for (cy = 250; cy < 286; cy += 12) rivets(380, 398, cy, 6);
    // krage med lys
    box(366, 228, 40, 12, [34, 34, 32]);
    c.fillStyle = "rgb(255,58,42)"; c.fillRect(370, 233, 2, 2);
    c.fillStyle = "rgb(255,176,32)"; c.fillRect(376, 233, 2, 2);
    c.fillStyle = "rgb(60,240,60)"; c.fillRect(382, 233, 2, 2);
    // små fasede koblingsbokser og klammer
    box(394, 176, 12, 16, [48, 47, 42]); c.fillStyle = "rgb(255,176,32)"; c.fillRect(399, 180, 2, 2);
    box(358, 196, 12, 12, [44, 44, 40]);
    box(398, 258, 9, 14, [40, 40, 40]);

    // arm og høyttalertrakt til høyre for hovedskjermen
    tube([394, 150, 420, 150, 432, 142, 446, 126], 4);
    c.fillStyle = "rgb(22,22,20)";
    c.beginPath(); c.moveTo(442, 122); c.lineTo(452, 116); c.lineTo(472, 146); c.lineTo(458, 152); c.closePath(); c.fill();
    c.fillStyle = "rgb(70,68,60)";
    c.beginPath(); c.moveTo(444, 122); c.lineTo(450, 118); c.lineTo(466, 144); c.lineTo(460, 148); c.closePath(); c.fill();
    c.fillStyle = "rgb(8,8,8)"; c.beginPath(); c.ellipse(466, 150, 10, 5, -0.55, 0, Math.PI * 2); c.fill();
    c.strokeStyle = "rgb(120,116,100)"; c.beginPath(); c.ellipse(466, 150, 10, 5, -0.55, Math.PI, Math.PI * 1.8); c.stroke();

    // holder bak hovedskjermen
    c.fillStyle = "rgb(20,20,18)"; c.fillRect(356, 112, 52, 10);
    c.fillStyle = "rgb(90,86,74)"; c.fillRect(356, 112, 52, 1);
  }

  var roomCv = document.getElementById("bfRoom");
  if (roomCv && roomCv.getContext) drawRoom(roomCv);

  /* =======================================================================
     MONITORENE: grønn terminaltekst som ruller
     ======================================================================= */
  var TERM = {
    main: [
      "KESTREL STN // RELAY 07", "> UPLINK ........... OK", "> GRID A ...... OFFLINE",
      "> GRID B ...... OFFLINE", "> HAB-3 SEAL ........ 94%", "> BULKHEAD E2 . BREACH",
      "  SCAN 3F2A 1B07 0C44", "> COLONISTS ....... 311", "> LZ ALPHA ...... CLEAR",
      "> TOWER PWR ......... 0%", "> STORM FRONT  T-04:10", "  TRACE >>>>>>......",
      "> DROPSHIP 2 .... FUELED", "> AWAITING COMMAND_"
    ],
    left: ["SECTOR 9", "0x4A 0x1F", "PING 212ms", "ECHO ....", "E2 ##__#", "TEMP 41C", "O2  63%", "RTN >>"],
    right: null
  };
  var termEls = {};
  Array.prototype.forEach.call(document.querySelectorAll(".bf-term"), function (el) { termEls[el.getAttribute("data-term")] = el; });
  function termStep(name, rows) {
    var el = termEls[name]; if (!el) return;
    var src = TERM[name], idx = el._i || 0;
    var line = document.createElement("div");
    line.textContent = src[idx % src.length];
    if (idx % 5 === 3) line.className = "bf-term__dim";
    el.appendChild(line);
    while (el.children.length > rows) el.removeChild(el.firstChild);
    el._i = idx + 1;
  }
  var graph = [];
  for (var gi = 0; gi < 17; gi++) graph.push(1 + Math.round(Math.random() * 3));
  function barsStep() {                       // lavoppløst grønn graf i monospace
    var el = termEls.right; if (!el) return;
    graph.shift();
    var last = graph[graph.length - 1];
    graph.push(clamp(last + Math.round((Math.random() - 0.45) * 2), 0, 4));
    var load = Math.round(graph.reduce(function (a, b) { return a + b; }, 0) / (graph.length * 4) * 100);
    var rows = ["GRID LOAD " + (load < 10 ? " " : "") + load + "%"];
    for (var r = 4; r >= 1; r--) {
      var line = r === 4 ? "4|" : r === 1 ? "0|" : " |";
      for (var i = 0; i < graph.length; i++) line += graph[i] >= r ? (graph[i] === r ? "#" : ":") : " ";
      rows.push(line);
    }
    rows.push(" +" + new Array(graph.length + 1).join("-"));
    el.textContent = rows.join("\n");
  }
  for (var pre = 0; pre < 11; pre++) termStep("main", 11);
  for (pre = 0; pre < 6; pre++) termStep("left", 7);
  barsStep();
  setInterval(function () { termStep("main", 11); }, 700);
  setInterval(function () { termStep("left", 7); }, 1100);
  setInterval(barsStep, 420);

  /* =======================================================================
     PORTRETTER: egne abstrakte figurer + animert statisk støy
     ======================================================================= */
  var PORTRAITS = {
    relay: { tint: [150, 190, 210], draw: function (c) {             // hjelm med visir
      head(c, 34, 24, 15, 17, "rgb(70,78,86)");
      c.fillStyle = "rgb(36,40,46)"; c.fillRect(19, 18, 30, 12);
      c.fillStyle = "rgb(120,220,240)"; c.fillRect(21, 21, 26, 5);
      c.fillStyle = "rgb(200,250,255)"; c.fillRect(23, 22, 8, 1);
      c.fillStyle = "rgb(90,96,104)"; c.fillRect(16, 26, 4, 8); c.fillRect(48, 26, 4, 8);
    } },
    corso: { tint: [200, 196, 150], draw: function (c) {             // kortklipt hode med headset
      head(c, 34, 25, 12, 15, "rgb(120,104,84)");
      c.fillStyle = "rgb(40,34,28)"; c.beginPath(); c.ellipse(34, 15, 13, 7, 0, Math.PI, Math.PI * 2); c.fill();
      c.fillStyle = "rgb(30,26,22)"; c.fillRect(26, 22, 5, 2); c.fillRect(37, 22, 5, 2);
      c.strokeStyle = "rgb(60,60,60)"; c.beginPath(); c.arc(34, 22, 14, Math.PI * 1.05, Math.PI * 1.95); c.stroke();
      c.fillStyle = "rgb(40,40,40)"; c.fillRect(19, 21, 4, 7);
      c.strokeStyle = "rgb(80,80,80)"; c.beginPath(); c.moveTo(21, 28); c.quadraticCurveTo(22, 35, 29, 34); c.stroke();
    } },
    reyes: { tint: [180, 200, 160], draw: function (c) {             // offiser med lue og høy krage
      head(c, 34, 26, 12, 15, "rgb(110,96,80)");
      c.fillStyle = "rgb(36,42,34)"; c.fillRect(21, 11, 26, 7);
      c.fillStyle = "rgb(24,28,22)"; c.fillRect(18, 17, 32, 3);
      c.fillStyle = "rgb(200,170,60)"; c.fillRect(32, 13, 4, 3);
      c.fillStyle = "rgb(30,26,22)"; c.fillRect(27, 24, 4, 2); c.fillRect(37, 24, 4, 2);
      c.fillStyle = "rgb(60,50,40)"; c.fillRect(30, 34, 8, 1);
    } }
  };
  function head(c, x, y, rx, ry, col) {
    // skuldre
    c.fillStyle = "rgb(40,46,40)"; c.beginPath(); c.ellipse(34, 56, 30, 16, 0, Math.PI, Math.PI * 2); c.fill();
    c.fillStyle = "rgb(58,66,56)"; c.beginPath(); c.ellipse(28, 54, 18, 10, 0, Math.PI, Math.PI * 2); c.fill();
    c.fillStyle = "rgb(50,46,40)"; c.fillRect(x - 5, y + ry - 4, 10, 8);
    var g = c.createRadialGradient(x - rx * 0.4, y - ry * 0.3, 1, x, y, rx * 1.4);
    g.addColorStop(0, col); g.addColorStop(1, "rgb(14,14,14)");
    c.fillStyle = g; c.beginPath(); c.ellipse(x, y, rx, ry, 0, 0, Math.PI * 2); c.fill();
  }

  var portraits = [];
  Array.prototype.forEach.call(document.querySelectorAll(".bf-portrait"), function (fig) {
    var key = fig.getAttribute("data-speaker"), def = PORTRAITS[key];
    var cv = fig.querySelector("canvas"); if (!cv || !def) return;
    var w = cv.width, h = cv.height;
    var base = document.createElement("canvas"); base.width = w; base.height = h;
    var bc = base.getContext("2d");
    var bg = bc.createLinearGradient(0, 0, 0, h); bg.addColorStop(0, "rgb(18,24,22)"); bg.addColorStop(1, "rgb(4,6,6)");
    bc.fillStyle = bg; bc.fillRect(0, 0, w, h);
    def.draw(bc);
    portraits.push({ el: fig, key: key, ctx: cv.getContext("2d"), base: bc.getImageData(0, 0, w, h), tint: def.tint, w: w, h: h, roll: Math.random() * h });
  });
  function renderPortrait(p) {
    var speaking = p.el.classList.contains("is-speaking");
    var out = p.ctx.createImageData(p.w, p.h), s = p.base.data, d = out.data;
    var amp = speaking ? 34 : 95, mix = speaking ? 0.15 : 0.42;
    p.roll = (p.roll + (speaking ? 0.6 : 1.7)) % p.h;
    for (var y = 0; y < p.h; y++) {
      var tear = (!speaking && Math.random() < 0.04) ? Math.round((Math.random() - 0.5) * 6) : 0;
      var band = Math.abs(y - p.roll) < 3 ? 1.35 : 1;
      for (var x = 0; x < p.w; x++) {
        var sx = clamp(x + tear, 0, p.w - 1), si = (y * p.w + sx) * 4, di = (y * p.w + x) * 4;
        var lum = (s[si] * 0.3 + s[si + 1] * 0.55 + s[si + 2] * 0.15) / 255;
        var n = Math.random() * amp;
        for (var ch = 0; ch < 3; ch++) {
          var col = (s[si + ch] * 0.45 + lum * p.tint[ch] * 0.75) * band;
          d[di + ch] = clamp(col * (1 - mix) + n * mix + (n - amp / 2) * 0.25, 0, 255);
        }
        d[di + 3] = 255;
      }
    }
    p.ctx.putImageData(out, 0, 0);
  }
  function renderPortraits() { portraits.forEach(renderPortrait); }
  renderPortraits();
  setInterval(renderPortraits, 70);

  function setSpeaker(key) {
    portraits.forEach(function (p) { p.el.classList.toggle("is-speaking", p.key === key); });
  }

  /* =======================================================================
     BRIEFINGTEKST: skrives tegn for tegn
     ======================================================================= */
  var SCRIPT = [
    { who: "relay", name: "Relay Officer", text: "Commander, long-range relay has reestablished contact with Kestrel Station. The colony's refinery grid went dark nine hours ago, and the orbital beacon is looping a distress call." },
    { who: "corso", name: "Lt. Corso", text: "Three hundred colonists are sealed in the lower habitats, sir. Something is chewing through the eastern bulkheads, and their air scrubbers are running on reserve power." },
    { who: "reyes", name: "Cmdr. Reyes", text: "Then we go in now. Secure the landing pad, restore power to the relay tower and get those people out before the storm front closes the pass." },
    { who: "relay", name: "Relay Officer", text: "Objectives transmitted. Dropships are fueled and waiting on your command." }
  ];
  var CHAR_MS = 28, LINE_PAUSE = 700;
  var textEl = document.getElementById("bfText");
  var cursor = document.createElement("span"); cursor.className = "bf-cursor"; cursor.setAttribute("aria-hidden", "true");
  var state = { line: 0, ch: 0, timer: null, span: null, done: false };

  function newLine(i) {
    var item = SCRIPT[i];
    Array.prototype.forEach.call(textEl.querySelectorAll(".bf-line"), function (el) { el.classList.add("is-old"); });
    var p = document.createElement("p"); p.className = "bf-line";
    var who = document.createElement("span"); who.className = "bf-line__who"; who.textContent = item.name + ": ";
    var body = document.createElement("span");
    p.appendChild(who); p.appendChild(body); p.appendChild(cursor);
    textEl.appendChild(p);
    setSpeaker(item.who);
    state.span = body; state.ch = 0;
  }
  function scrollDown() { textEl.scrollTop = textEl.scrollHeight; }
  function tick() {
    if (state.done) return;
    var item = SCRIPT[state.line];
    if (!state.span) newLine(state.line);
    if (state.ch < item.text.length) {
      var chr = item.text.charAt(state.ch++);
      state.span.textContent += chr;
      if (chr !== " " && state.ch % 2 === 0) sfx("type");
      scrollDown();
      state.timer = setTimeout(tick, /[.,]/.test(chr) ? CHAR_MS * 6 : CHAR_MS);
    } else if (state.line < SCRIPT.length - 1) {
      state.line++; state.span = null;
      state.timer = setTimeout(tick, LINE_PAUSE);
    } else {
      state.done = true;
    }
  }
  function restart() {
    clearTimeout(state.timer);
    textEl.innerHTML = "";
    state = { line: 0, ch: 0, timer: null, span: null, done: false };
    setSpeaker(null);
    state.timer = setTimeout(tick, 400);
  }
  function skip() {
    clearTimeout(state.timer);
    if (state.done) return;
    if (!state.span) newLine(state.line);
    state.span.textContent = SCRIPT[state.line].text;
    for (var i = state.line + 1; i < SCRIPT.length; i++) {
      newLine(i); state.span.textContent = SCRIPT[i].text;
    }
    state.line = SCRIPT.length - 1; state.done = true;
    scrollDown();
  }

  var fade = document.getElementById("bfFade");
  function start(fromKey) {
    if (fromKey === true) sfx("open");    // klikk får lyd via sc-audio.js (data-sfx="open")
    skip();
    fade.classList.add("is-on");
    setTimeout(function () { fade.classList.remove("is-on"); restart(); }, 2200);
  }

  document.getElementById("bfRestart").addEventListener("click", restart);
  document.getElementById("bfSkip").addEventListener("click", skip);
  document.getElementById("bfStart").addEventListener("click", function () { start(false); });
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") skip();
    else if (e.key === "Enter" && document.activeElement === document.body) start(true);
  });

  setSpeaker(null);
  state.timer = setTimeout(tick, 400);
})();

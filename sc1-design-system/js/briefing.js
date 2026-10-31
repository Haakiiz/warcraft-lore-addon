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

    /* --- 1. fliser --- */
    c.fillStyle = "rgb(8,9,8)";
    c.fillRect(0, 0, W, H);
    for (var th = TH0; th < TH1; th += DT) {
      for (var v = V_TOP; v < V_FLOOR; v += DV) {
        var a = P(th, v), b = P(th + DT, v), d = P(th + DT, v + DV), e = P(th, v + DV);
        var k = 0.86 + R() * 0.22;
        if (R() < 0.06) k *= 0.72;            // flekkete fliser
        if (R() < 0.03) k *= 1.18;
        c.fillStyle = rgb(88 * k, 94 * k, 84 * k);
        c.beginPath(); c.moveTo(a[0], a[1]); c.lineTo(b[0], b[1]); c.lineTo(d[0], d[1]); c.lineTo(e[0], e[1]); c.closePath();
        c.fill();
        // svak fas: lys topp/venstre kant i flisen
        c.fillStyle = rgb(110 * k, 116 * k, 104 * k, 0.35);
        c.fillRect(a[0] + 1, a[1] + 1, Math.max(1, b[0] - a[0] - 2), 1);
      }
    }
    /* --- 2. fuger --- */
    c.lineWidth = 1;
    for (v = V_TOP; v <= V_FLOOR + 0.001; v += DV) {
      c.strokeStyle = "rgba(18,20,18,0.95)";
      c.beginPath();
      for (th = TH0; th <= TH1 + 0.01; th += 0.01) {
        var p = P(th, v);
        if (th === TH0) c.moveTo(p[0], p[1] + 0.5); else c.lineTo(p[0], p[1] + 0.5);
      }
      c.stroke();
    }
    for (th = TH0; th <= TH1; th += DT) {
      var top = P(th, V_TOP), bot = P(th, V_FLOOR);
      c.strokeStyle = "rgba(18,20,18,0.95)";
      c.beginPath(); c.moveTo(Math.round(top[0]) + 0.5, top[1]); c.lineTo(Math.round(bot[0]) + 0.5, bot[1]); c.stroke();
    }

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

    /* --- 4. rustrenner: brunoransje, lav opasitet, starter under rør/lamper, 3–5 per veggfelt --- */
    function streak(th0, v0, len) {
      var cr = 90 + R() * 32, cg = 42 + R() * 16, cb = 18 + R() * 6;      // #5a2a12–#7a3a18
      var cols = 2 + Math.floor(R() * 3), al = 0.30 + R() * 0.22;
      var x0 = Math.round(P(th0, v0)[0]);
      for (var i = 0; i < cols; i++) {
        var p0 = P(th0, v0 + R() * 0.01), L = len * (0.35 + R() * 0.65);
        var p1 = P(th0, v0 + L);
        var g = c.createLinearGradient(0, p0[1], 0, p1[1]);
        g.addColorStop(0, rgb(cr, cg, cb, al));
        g.addColorStop(0.15 + R() * 0.4, rgb(cr * 0.9, cg * 0.9, cb, al * 0.55));
        g.addColorStop(1, rgb(cr * 0.7, cg * 0.7, cb, 0));
        c.fillStyle = g;
        c.fillRect(x0 + i, Math.round(p0[1]), 1, Math.round(p1[1] - p0[1]));
      }
    }
    var PANELS = [TH0, -0.80, -0.40, 0.20, 0.66, TH1];
    for (var pi = 0; pi < PANELS.length - 1; pi++) {
      var lo = PANELS[pi] + 0.02, hi = PANELS[pi + 1] - 0.02;
      var lampsHere = LAMPS.filter(function (l) { return l.th > lo && l.th < hi; });
      var count = 3 + Math.floor(R() * 3);
      for (var si = 0; si < count; si++) {
        var src = R(), st, sv;
        if (lampsHere.length && src < 0.4) {
          var lp = lampsHere[Math.floor(R() * lampsHere.length)];
          st = lp.th + (R() - 0.5) * 0.04; sv = lp.v + 0.05;
        } else if (src < 0.8) { st = lo + R() * (hi - lo); sv = -0.36; }
        else { st = lo + R() * (hi - lo); sv = 0.305; }
        streak(st, sv, sv > 0 ? 0.05 + R() * 0.1 : 0.08 + R() * 0.32);
      }
    }

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
        var amb = 0.46 - Math.max(0, -vv - 0.22) * 1.2 - Math.max(0, vv - 0.15) * 0.6;
        var green = 0.16 * Math.exp(-(t * t) / 0.03 - (vv + 0.17) * (vv + 0.17) / 0.04);   // grønt skjær fra monitorene
        var L = Math.max(0.10, amb) + warm * 0.22;
        // mørke sider: kvantisert i trinn med Bayer-dithering (ingen blur)
        var side = t < 0 ? clamp((-t - 0.70) / 0.62, 0, 1) : clamp((t - 0.50) / 0.30, 0, 1);
        var lvl = Math.min(4, Math.floor(side * 4 + bz)) / 4;
        L *= 1 - lvl * 0.82;
        var n = (R() - 0.5) * 20;
        var i4 = (y * W + x) * 4;
        var r0 = px[i4], g0 = px[i4 + 1], b0 = px[i4 + 2];
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

    /* --- 10. gulv --- */
    c.fillStyle = "rgb(12,12,11)";
    c.beginPath();
    for (th = TH0; th <= TH1 + 0.01; th += 0.01) { p = P(th, V_FLOOR); if (th === TH0) c.moveTo(p[0], p[1]); else c.lineTo(p[0], p[1]); }
    c.lineTo(W, H); c.lineTo(0, H); c.closePath(); c.fill();
    c.strokeStyle = "rgba(70,70,62,0.5)"; c.lineWidth = 1;
    for (var ring = 0; ring < 4; ring++) {
      c.beginPath(); c.ellipse(CX, 352 + ring * 3, 150 + ring * 70, 16 + ring * 6, 0, Math.PI, Math.PI * 2); c.stroke();
    }

    /* --- 11. sentral maskin --- */
    drawMachine(c);

    /* --- 12. lamper i bur med varm glød --- */
    c.globalCompositeOperation = "lighter";
    LAMPS.forEach(function (l) {
      var q = P(l.th, l.v);
      var g = c.createRadialGradient(q[0], q[1] + 2, 0, q[0], q[1] + 2, 16);
      g.addColorStop(0, "rgba(255,210,120,0.55)");
      g.addColorStop(0.25, "rgba(200,140,60,0.22)");
      g.addColorStop(1, "rgba(120,70,20,0)");
      c.fillStyle = g; c.fillRect(q[0] - 18, q[1] - 16, 36, 36);
    });
    c.globalCompositeOperation = "source-over";
    LAMPS.forEach(function (l) {
      var q = P(l.th, l.v), x = Math.round(q[0]), y = Math.round(q[1]);
      // oppheng fra røret
      c.fillStyle = "rgb(18,18,16)"; c.fillRect(x, y - 21, 1, 11);
      // kuppel (lampeskjerm)
      c.fillStyle = "rgb(30,30,27)"; c.fillRect(x - 3, y - 11, 7, 2); c.fillRect(x - 6, y - 9, 13, 3);
      c.fillStyle = "rgb(96,92,80)"; c.fillRect(x - 6, y - 9, 13, 1);
      // glødende glass
      c.fillStyle = "rgb(236,170,80)"; c.fillRect(x - 5, y - 6, 11, 13);
      c.fillStyle = "rgb(255,214,130)"; c.fillRect(x - 4, y - 5, 9, 11);
      c.fillStyle = "rgb(255,248,210)"; c.fillRect(x - 1, y - 3, 3, 7);
      // burstenger
      c.fillStyle = "rgb(24,22,18)";
      c.fillRect(x - 6, y - 6, 1, 14); c.fillRect(x + 6, y - 6, 1, 14);
      c.fillRect(x - 2, y - 6, 1, 14); c.fillRect(x + 2, y - 6, 1, 14);
      c.fillRect(x - 6, y - 1, 13, 1); c.fillRect(x - 6, y + 4, 13, 1);
      // bunnplate
      c.fillStyle = "rgb(30,30,27)"; c.fillRect(x - 5, y + 8, 11, 2); c.fillRect(x - 1, y + 10, 3, 2);
    });
  }

  /* Maskinen i midten: sokkel, søyle, slanger, arm og høyttalertrakt */
  function drawMachine(c) {
    function tube(pts, w, base) {
      var b = base || [60, 60, 54];
      function path(dx, dy) {
        c.beginPath(); c.moveTo(pts[0] + dx, pts[1] + dy);
        for (var i = 2; i < pts.length; i += 6) c.bezierCurveTo(pts[i] + dx, pts[i + 1] + dy, pts[i + 2] + dx, pts[i + 3] + dy, pts[i + 4] + dx, pts[i + 5] + dy);
      }
      c.lineCap = "round";
      path(0, 0); c.lineWidth = w + 2; c.strokeStyle = "rgb(8,8,8)"; c.stroke();
      path(0, 0); c.lineWidth = w; c.strokeStyle = rgb(b[0], b[1], b[2]); c.stroke();
      path(-w * 0.18, -w * 0.18); c.lineWidth = Math.max(1, w * 0.3); c.strokeStyle = rgb(b[0] * 1.9, b[1] * 1.85, b[2] * 1.75); c.stroke();
      c.setLineDash([1, 3]);
      path(0, 0); c.lineWidth = w; c.strokeStyle = "rgba(0,0,0,0.35)"; c.stroke();
      c.setLineDash([]);
      c.lineCap = "butt"; c.lineWidth = 1;
    }
    // skygge på gulvet
    c.fillStyle = "rgba(0,0,0,0.65)"; c.beginPath(); c.ellipse(382, 352, 118, 13, 0, 0, Math.PI * 2); c.fill();

    // slanger bak/rundt foten (ulik tykkelse)
    tube([330, 348, 268, 352, 234, 320, 248, 282, 260, 256, 296, 246, 312, 190], 11, [50, 50, 44]);
    tube([436, 346, 502, 352, 522, 316, 502, 284, 486, 262, 452, 240, 458, 198], 9, [50, 50, 44]);
    tube([344, 336, 298, 334, 282, 300, 298, 272, 312, 254, 342, 252, 368, 236], 6, [58, 56, 48]);
    tube([420, 336, 458, 332, 474, 300, 456, 280, 444, 268, 414, 262, 396, 250], 4, [62, 60, 52]);
    tube([366, 300, 330, 296, 312, 270, 318, 190], 5);
    tube([398, 300, 424, 290, 440, 250, 462, 200], 5);
    tube([372, 240, 340, 230, 330, 160, 352, 124], 3, [44, 44, 40]);
    tube([392, 240, 420, 226, 430, 160, 414, 124], 3, [44, 44, 40]);

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
      var g = c.createLinearGradient(xb0, 0, xb1, 0);
      g.addColorStop(0, "rgb(16,16,14)"); g.addColorStop(0.28, rgb(hi, hi, hi * 0.88)); g.addColorStop(0.55, rgb(hi * 0.62, hi * 0.62, hi * 0.55)); g.addColorStop(1, "rgb(12,12,10)");
      c.fillStyle = g;
      c.beginPath(); c.moveTo(xt0, y0); c.lineTo(xt1, y0); c.lineTo(xb1, y1); c.lineTo(xb0, y1); c.closePath(); c.fill();
      c.fillStyle = "rgb(150,144,124)"; c.fillRect(xt0 + 2, y0, xt1 - xt0 - 4, 1);     // lys toppfas
      c.fillStyle = "rgb(6,6,6)"; c.fillRect(xb0, y1 - 1, xb1 - xb0, 1);
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

    // søyle
    var g = c.createLinearGradient(368, 0, 396, 0);
    g.addColorStop(0, "rgb(16,16,14)"); g.addColorStop(0.35, "rgb(86,86,76)"); g.addColorStop(0.6, "rgb(50,50,44)"); g.addColorStop(1, "rgb(12,12,10)");
    c.fillStyle = g; c.fillRect(370, 118, 24, 180);
    for (var cy = 130; cy < 296; cy += 14) { c.fillStyle = "rgba(0,0,0,0.55)"; c.fillRect(370, cy, 24, 2); c.fillStyle = "rgba(160,150,120,0.35)"; c.fillRect(370, cy + 2, 24, 1); }
    // krage med lys
    box(362, 228, 40, 12, [34, 34, 30]);
    c.fillStyle = "rgb(255,58,42)"; c.fillRect(366, 233, 2, 2);
    c.fillStyle = "rgb(255,176,32)"; c.fillRect(372, 233, 2, 2);
    c.fillStyle = "rgb(60,240,60)"; c.fillRect(378, 233, 2, 2);
    // små fasede koblingsbokser og klammer
    box(394, 176, 12, 16, [48, 47, 42]); c.fillStyle = "rgb(255,176,32)"; c.fillRect(399, 180, 2, 2);
    box(358, 196, 12, 12, [44, 44, 40]);
    box(360, 270, 44, 7, [40, 40, 36]);

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
  function barsStep() {
    var el = termEls.right; if (!el) return;
    el.innerHTML = "";
    for (var i = 0; i < 6; i++) {
      var b = document.createElement("span");
      b.className = "bf-term__bar";
      b.style.width = (20 + Math.random() * 78).toFixed(0) + "%";
      el.appendChild(b);
    }
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

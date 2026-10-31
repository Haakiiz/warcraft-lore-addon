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
     x = CX + F*tan(th), y = HOR + F*v/cos(th). Da buer fugelinjene seg
     som i et rundt rom sett innenfra.
     ======================================================================= */
  var W = 640, H = 360, CX = 380, F = 250, VS = 1.28, HOR = 168;
  var V_TOP = -0.455, V_FLOOR = 0.44;
  var LAMPS = [
    { th: -0.62, v: -0.30 }, { th: -0.30, v: -0.30 },
    { th: 0.27, v: -0.30 }, { th: 0.58, v: -0.30 }
  ];
  function P(th, v) { return [CX + F * Math.tan(th), HOR + F * VS * v / Math.cos(th)]; }

  function drawRoom(cv) {
    var c = cv.getContext("2d");
    var R = rng(7331);
    c.imageSmoothingEnabled = false;

    var TH0 = -1.02, TH1 = 0.82, DT = 0.054, DV = 0.042;

    /* --- 1. fliser --- */
    c.fillStyle = "rgb(60,64,58)";
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

    /* --- 4. rustrenner --- */
    function streak(th0, v0, len, strength) {
      var cols = 2 + Math.floor(R() * 5);
      for (var i = 0; i < cols; i++) {
        var t = th0 + (R() - 0.5) * 0.012;
        var p0 = P(t, v0), L = len * (0.4 + R() * 0.6);
        var p1 = P(t, v0 + L);
        var g = c.createLinearGradient(0, p0[1], 0, p1[1]);
        var al = strength * (0.35 + R() * 0.55);
        g.addColorStop(0, "rgba(70,34,16," + al + ")");
        g.addColorStop(0.5, "rgba(58,30,16," + (al * 0.6) + ")");
        g.addColorStop(1, "rgba(40,24,14,0)");
        c.fillStyle = g;
        c.fillRect(Math.round(p0[0]), p0[1], 1 + (R() < 0.3 ? 1 : 0), p1[1] - p0[1]);
      }
    }
    for (var s = 0; s < 46; s++) {
      var st = TH0 + R() * (TH1 - TH0);
      var sv = [V_TOP + 0.01, -0.37, -0.27, 0.30][Math.floor(R() * 4)];
      streak(st, sv, 0.08 + R() * 0.38, 0.55);
    }
    LAMPS.forEach(function (l) { streak(l.th - 0.01, l.v + 0.06, 0.45, 1); streak(l.th + 0.012, l.v + 0.06, 0.3, 0.8); });

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
    band(-1.2, V_TOP - 0.03, "rgb(16,17,15)");
    // tak-ribber over hyllen
    for (var rt = TH0; rt < TH1; rt += 0.085) {
      var r0 = P(rt, -1.2), r1 = P(rt, V_TOP - 0.03);
      c.strokeStyle = "rgba(48,50,44,0.9)"; c.beginPath(); c.moveTo(r0[0] + 0.5, r0[1]); c.lineTo(r1[0] + 0.5, r1[1]); c.stroke();
    }
    band(V_TOP - 0.03, V_TOP + 0.012, "rgb(44,45,40)");
    ringLine(V_TOP - 0.03, "rgba(120,118,104,0.7)", 0.5);
    ringLine(V_TOP + 0.012, "rgba(8,8,8,0.9)", 0.5);
    for (rt = TH0; rt < TH1; rt += 0.05) {   // nagler i hyllen
      var rv = P(rt, V_TOP - 0.009);
      c.fillStyle = "rgb(120,118,106)"; c.fillRect(Math.round(rv[0]), Math.round(rv[1]), 1, 1);
      c.fillStyle = "rgb(10,10,10)"; c.fillRect(Math.round(rv[0]) + 1, Math.round(rv[1]) + 1, 1, 1);
    }
    // buede «horn»-braketter fra hyllen
    [-0.86, -0.58, -0.26, 0.42, 0.68].forEach(function (bt) {
      var p1 = P(bt - 0.022, V_TOP + 0.01), p2 = P(bt + 0.03, V_TOP + 0.01);
      var p3 = P(bt + 0.004, V_TOP + 0.16), p4 = P(bt - 0.012, V_TOP + 0.08);
      c.fillStyle = "rgb(30,31,28)";
      c.beginPath(); c.moveTo(p1[0], p1[1]); c.lineTo(p2[0], p2[1]);
      c.quadraticCurveTo(p2[0] - 1, p3[1] - 12, p3[0], p3[1]);
      c.quadraticCurveTo(p4[0], p4[1], p1[0], p1[1]); c.fill();
      c.strokeStyle = "rgba(130,126,108,0.6)";
      c.beginPath(); c.moveTo(p1[0], p1[1]); c.quadraticCurveTo(p4[0], p4[1], p3[0], p3[1]); c.stroke();
    });

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
      var t0 = 0.47, t1 = 0.525, v0 = -0.37, v1 = V_FLOOR;
      var a0 = P(t0, v0), b0 = P(t1, v0), a1 = P(t0, v1);
      var xa = Math.round(a0[0]), xb = Math.round(b0[0]);
      for (var v = v0 + 0.02; v < v1; v += 0.045) {
        var p = P(t0, v), q = P(t1, v);
        c.strokeStyle = "rgba(0,0,0,0.5)"; c.beginPath(); c.moveTo(p[0], p[1] + 2.5); c.lineTo(q[0] + 2, q[1] + 2.5); c.stroke();
        c.strokeStyle = "rgb(30,30,27)"; c.lineWidth = 2; c.beginPath(); c.moveTo(p[0], p[1]); c.lineTo(q[0], q[1]); c.stroke();
        c.strokeStyle = "rgb(116,112,98)"; c.lineWidth = 1; c.beginPath(); c.moveTo(p[0], p[1] - 0.5); c.lineTo(q[0], q[1] - 0.5); c.stroke();
      }
      [xa, xb].forEach(function (x) {
        c.fillStyle = "rgba(0,0,0,0.45)"; c.fillRect(x + 3, a0[1], 2, a1[1] - a0[1]);
        c.fillStyle = "rgb(24,24,22)"; c.fillRect(x - 1, a0[1] - 4, 3, a1[1] - a0[1] + 4);
        c.fillStyle = "rgb(106,104,92)"; c.fillRect(x - 1, a0[1] - 4, 1, a1[1] - a0[1] + 4);
      });
    })();

    /* --- 9. lysberegning per piksel (lamper, mørke kanter, kornstøy) --- */
    var img = c.getImageData(0, 0, W, H), px = img.data;
    for (y = 0; y < H; y++) {
      for (x = 0; x < W; x++) {
        var t = Math.atan((x - CX) / F), cs = Math.cos(t), vv = (y - HOR) * cs / (F * VS);
        var warm = 0;
        for (var li = 0; li < LAMPS.length; li++) {
          var dt = t - LAMPS[li].th, dv = vv - LAMPS[li].v;
          var below = dv > 0 ? 0.075 : 0.022;
          warm += Math.exp(-(dt * dt) / 0.012 - (dv - (dv > 0 ? 0.06 : 0) ) * (dv - (dv > 0 ? 0.06 : 0)) / below);
        }
        warm = Math.min(warm, 1.3);
        var amb = 0.50 - Math.max(0, -vv - 0.2) * 0.9 - Math.max(0, vv - 0.15) * 0.55;
        amb -= Math.abs(t - 0.05) * 0.10;
        var green = 0.18 * Math.exp(-(t * t) / 0.03 - (vv + 0.17) * (vv + 0.17) / 0.04);   // grønt skjær fra monitorene
        var L = Math.max(0.12, amb) + warm * 0.85;
        var n = (R() - 0.5) * 22;
        var i4 = (y * W + x) * 4;
        px[i4]     = clamp(px[i4] * L * (1 + warm * 0.30) + n, 0, 255);
        px[i4 + 1] = clamp(px[i4 + 1] * (L + green) * (1 + warm * 0.18) + n, 0, 255);
        px[i4 + 2] = clamp(px[i4 + 2] * L * (1 - warm * 0.12) + n * 0.8, 0, 255);
      }
    }
    c.putImageData(img, 0, 0);

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
      var g = c.createRadialGradient(q[0], q[1] + 2, 0, q[0], q[1] + 2, 42);
      g.addColorStop(0, "rgba(255,210,120,0.55)");
      g.addColorStop(0.25, "rgba(200,140,60,0.22)");
      g.addColorStop(1, "rgba(120,70,20,0)");
      c.fillStyle = g; c.fillRect(q[0] - 44, q[1] - 42, 88, 88);
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
    c.fillStyle = "rgba(0,0,0,0.6)"; c.beginPath(); c.ellipse(382, 356, 96, 12, 0, 0, Math.PI * 2); c.fill();

    // store slanger som bukter seg ut fra sokkelen (som i referansen)
    tube([352, 346, 300, 350, 248, 330, 258, 290, 266, 262, 300, 250, 318, 196], 9, [52, 52, 46]);
    tube([410, 344, 470, 350, 500, 318, 486, 286, 476, 262, 450, 240, 456, 206], 8, [52, 52, 46]);
    tube([366, 300, 330, 296, 312, 270, 318, 190], 5);
    tube([398, 300, 424, 290, 440, 250, 462, 200], 5);
    tube([372, 240, 340, 230, 330, 160, 352, 124], 3, [44, 44, 40]);
    tube([392, 240, 420, 226, 430, 160, 414, 124], 3, [44, 44, 40]);

    // sokkel
    var g = c.createLinearGradient(330, 0, 434, 0);
    g.addColorStop(0, "rgb(18,18,16)"); g.addColorStop(0.3, "rgb(72,72,64)"); g.addColorStop(0.55, "rgb(46,46,42)"); g.addColorStop(1, "rgb(14,14,12)");
    c.fillStyle = g;
    c.beginPath(); c.moveTo(344, 300); c.lineTo(420, 300); c.lineTo(440, 352); c.lineTo(324, 352); c.closePath(); c.fill();
    c.fillStyle = "rgb(10,10,10)"; c.fillRect(324, 352, 116, 4);
    for (var ry = 308; ry < 350; ry += 10) { c.fillStyle = "rgba(0,0,0,0.5)"; c.fillRect(338 - (ry - 300) * 0.3, ry, 88 + (ry - 300) * 0.6, 1); }
    c.fillStyle = "rgb(150,140,110)"; [336, 352, 412, 428].forEach(function (x) { c.fillRect(x, 344, 1, 1); });
    // gul/svart fareskilt-stripe på sokkelen
    for (var hx = 0; hx < 9; hx++) {
      c.fillStyle = hx % 2 ? "rgb(20,18,10)" : "rgb(150,120,24)";
      c.beginPath(); c.moveTo(346 + hx * 8, 322); c.lineTo(352 + hx * 8, 322); c.lineTo(348 + hx * 8, 328); c.lineTo(342 + hx * 8, 328); c.closePath(); c.fill();
    }

    // søyle
    g = c.createLinearGradient(368, 0, 396, 0);
    g.addColorStop(0, "rgb(16,16,14)"); g.addColorStop(0.35, "rgb(86,86,76)"); g.addColorStop(0.6, "rgb(50,50,44)"); g.addColorStop(1, "rgb(12,12,10)");
    c.fillStyle = g; c.fillRect(370, 118, 24, 184);
    for (var cy = 130; cy < 300; cy += 14) { c.fillStyle = "rgba(0,0,0,0.55)"; c.fillRect(370, cy, 24, 2); c.fillStyle = "rgba(160,150,120,0.35)"; c.fillRect(370, cy + 2, 24, 1); }
    // krage
    c.fillStyle = "rgb(30,30,27)"; c.fillRect(362, 228, 40, 12);
    c.fillStyle = "rgb(110,104,88)"; c.fillRect(362, 228, 40, 1);
    c.fillStyle = "rgb(255,58,42)"; c.fillRect(366, 233, 2, 2);
    c.fillStyle = "rgb(255,176,32)"; c.fillRect(372, 233, 2, 2);
    c.fillStyle = "rgb(60,240,60)"; c.fillRect(378, 233, 2, 2);

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

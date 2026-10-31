/* =========================================================================
   SC1-inspirert designsystem – scene.js (mønstre, arbeider B)
   Alt er tegnet selv på <canvas>: verdensrom til glue screen, isometrisk
   terreng, minimap, portrett med statisk støy, metall-/marmor-/kjøtt-teksturer.
   Ingen originalgrafikk. Deterministisk (seedet PRNG) så skjermbilder er stabile.
   API: window.SCScene = { fitStage, textures, drawSpace, drawTerrain,
                          drawMinimap, portrait, wireframe, consoleShape }
   ========================================================================= */
(function () {
  'use strict';
  var SC = (window.SCScene = window.SCScene || {});

  /* ---------- PRNG + verdistøy ---------- */
  function rng(a) {
    return function () {
      a |= 0; a = (a + 0x6d2b79f5) | 0;
      var t = Math.imul(a ^ (a >>> 15), 1 | a);
      t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
      return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
    };
  }
  function makeNoise(seed) {
    var r = rng(seed), perm = new Uint8Array(512), vals = new Float32Array(256), i;
    for (i = 0; i < 256; i++) { vals[i] = r(); perm[i] = i; }
    for (i = 255; i > 0; i--) { var j = (r() * (i + 1)) | 0, t = perm[i]; perm[i] = perm[j]; perm[j] = t; }
    for (i = 0; i < 256; i++) perm[i + 256] = perm[i];
    function v(ix, iy, p) {
      if (p) { ix = ((ix % p) + p) % p; iy = ((iy % p) + p) % p; }
      return vals[perm[(ix & 255) + perm[iy & 255]]];
    }
    function noise(x, y, p) {
      var ix = Math.floor(x), iy = Math.floor(y), fx = x - ix, fy = y - iy;
      var sx = fx * fx * (3 - 2 * fx), sy = fy * fy * (3 - 2 * fy);
      var a = v(ix, iy, p), b = v(ix + 1, iy, p), c = v(ix, iy + 1, p), d = v(ix + 1, iy + 1, p);
      return a + (b - a) * sx + (c - a) * sy + (a - b - c + d) * sx * sy;
    }
    /* p = periode (for flislagte teksturer); dobles per oktav */
    function fbm(x, y, oct, p) {
      var s = 0, amp = 0.5, f = 1, n = 0;
      for (var o = 0; o < oct; o++) {
        s += amp * noise(x * f, y * f, p ? p * f : 0);
        n += amp; amp *= 0.5; f *= 2;
      }
      return s / n;
    }
    return { noise: noise, fbm: fbm };
  }
  function clamp(x, a, b) { return x < a ? a : x > b ? b : x; }
  function sstep(a, b, x) { var t = clamp((x - a) / (b - a), 0, 1); return t * t * (3 - 2 * t); }
  function mix(a, b, t) { return a + (b - a) * t; }
  function canvasOf(w, h) { var c = document.createElement('canvas'); c.width = w; c.height = h; return c; }

  /* ---------- Skalering av 1280×720-scenen ---------- */
  SC.fitStage = function (stage) {
    function fit() {
      var s = Math.min(window.innerWidth / 1280, window.innerHeight / 720);
      stage.style.setProperty('--x-scale', s);
    }
    fit();
    window.addEventListener('resize', fit);
  };

  /* ---------- Teksturer som CSS-variabler (data-URL) ----------
     --x-grime  : slitt metall (gråskala-alfa, legges over metallgradienter)
     --x-marble : Protoss blåsvart marmor
     --x-flesh  : Zerg kjøtt/kitin                                          */
  SC.textures = function () {
    var root = document.documentElement.style, S = 128;
    var N = makeNoise(11), r = rng(5);

    var g = canvasOf(S, S), gx = g.getContext('2d'), gd = gx.createImageData(S, S);
    for (var y = 0; y < S; y++) for (var x = 0; x < S; x++) {
      var i = (y * S + x) * 4;
      var blot = N.fbm(x / 32, y / 32, 3, 4);
      var grain = r();
      var dark = blot < 0.45 ? (0.45 - blot) * 1.6 : 0;
      if (grain > 0.92) { gd.data[i] = gd.data[i + 1] = gd.data[i + 2] = 255; gd.data[i + 3] = 22; }
      else { gd.data[i] = gd.data[i + 1] = gd.data[i + 2] = 0; gd.data[i + 3] = Math.round(255 * (dark * 0.55 + grain * 0.12)); }
    }
    gx.putImageData(gd, 0, 0);
    /* riper */
    gx.strokeStyle = 'rgba(255,255,255,0.07)'; gx.lineWidth = 1;
    for (var k = 0; k < 14; k++) {
      var sx = r() * S, sy = r() * S, len = 6 + r() * 18;
      gx.beginPath(); gx.moveTo(sx, sy); gx.lineTo(sx + len, sy + len * (r() - 0.5) * 0.4); gx.stroke();
    }
    root.setProperty('--x-grime', 'url("' + g.toDataURL() + '")');

    var M = 160, m = canvasOf(M, M), mx = m.getContext('2d'), md = mx.createImageData(M, M), N2 = makeNoise(77);
    for (y = 0; y < M; y++) for (x = 0; x < M; x++) {
      i = (y * M + x) * 4;
      var n = N2.fbm(x / 40, y / 40, 5, 4);
      var vein = Math.abs(Math.sin((x + y * 0.6) / 14 + n * 9));
      var vv = Math.pow(1 - vein, 10);
      var base = 0.35 + n * 0.5;
      md.data[i] = 6 * base + 40 * vv;
      md.data[i + 1] = 12 * base + 80 * vv;
      md.data[i + 2] = 34 * base + 120 * vv;
      md.data[i + 3] = 255;
    }
    mx.putImageData(md, 0, 0);
    root.setProperty('--x-marble', 'url("' + m.toDataURL() + '")');

    var f = canvasOf(M, M), fx = f.getContext('2d'), fd = fx.createImageData(M, M), N3 = makeNoise(303);
    for (y = 0; y < M; y++) for (x = 0; x < M; x++) {
      i = (y * M + x) * 4;
      var c = N3.fbm(x / 20, y / 20, 4, 8);
      var cell = Math.abs(N3.noise(x / 10, y / 10, 16) - 0.5) * 2;
      var ridge = Math.pow(1 - cell, 6);
      var lum = 0.5 + c * 0.7;
      fd.data[i] = 70 * lum + 70 * ridge;
      fd.data[i + 1] = 30 * lum + 30 * ridge;
      fd.data[i + 2] = 40 * lum + 26 * ridge;
      fd.data[i + 3] = 255;
    }
    fx.putImageData(fd, 0, 0);
    root.setProperty('--x-flesh', 'url("' + f.toDataURL() + '")');
  };

  /* =====================================================================
     GLUE SCREEN: verdensrom
     ===================================================================== */
  SC.drawSpace = function (canvas) {
    var W = 1280, H = 720;
    canvas.width = W; canvas.height = H;
    var ctx = canvas.getContext('2d', { willReadFrequently: true });
    var r = rng(1998), N = makeNoise(42);

    ctx.fillStyle = '#020106';
    ctx.fillRect(0, 0, W, H);

    /* stjerner */
    for (var s = 0; s < 1100; s++) {
      var x = r() * W, y = r() * H, b = Math.pow(r(), 3);
      var tint = r();
      ctx.fillStyle = 'rgba(' + (tint > 0.8 ? '255,210,200' : tint < 0.2 ? '200,215,255' : '235,235,240') + ',' + (0.25 + b * 0.75) + ')';
      ctx.fillRect(x | 0, y | 0, 1, 1);
      if (b > 0.75) { ctx.fillRect((x | 0) - 1, y | 0, 3, 1); ctx.fillRect(x | 0, (y | 0) - 1, 1, 3); }
    }

    /* tåke (halv oppløsning, skaleres opp) */
    var nw = 640, nh = 360, off = canvasOf(nw, nh), o = off.getContext('2d'), id = o.createImageData(nw, nh), d = id.data;
    for (y = 0; y < nh; y++) for (x = 0; x < nw; x++) {
      var u = x / nw, v = y / nh, i = (y * nw + x) * 4;
      var n = N.fbm(x / 70, y / 70, 6);
      var n2 = N.fbm(x / 34 + 50, y / 34 + 20, 5);
      var dr = Math.hypot((u - 0.97) * 1.4, v - 0.2);
      var mRed = Math.pow(clamp(1 - dr / 0.7, 0, 1), 0.9);
      var red = mRed * sstep(0.28, 0.66, n) * (0.7 + 0.8 * n2) * 1.25;
      var core = mRed * sstep(0.55, 0.85, n * 0.6 + n2 * 0.5);
      var mHaze = clamp(1 - Math.hypot(u - 0.3, (v - 0.5) * 1.3) / 0.5, 0, 1) * 0.6
                + clamp(1 - Math.hypot(u - 0.66, (v - 0.8) * 1.2) / 0.32, 0, 1) * 0.3
                + clamp(1 - Math.hypot(u - 0.12, (v - 0.08) * 1.5) / 0.3, 0, 1) * 0.2;
      var haze = mHaze * sstep(0.38, 0.78, n2) * (0.5 + n);
      var mPur = clamp(1 - Math.hypot(u - 0.5, v - 0.3) / 0.35, 0, 1);
      var pur = mPur * sstep(0.45, 0.8, n) * 0.35;
      var dust = 0.55 + 0.45 * sstep(0.3, 0.6, N.fbm(x / 22 + 9, y / 22, 3));
      d[i] = clamp(255 * (red * 0.95 + core * 0.35 + haze * 0.55 + pur * 0.35) * dust, 0, 255);
      d[i + 1] = clamp(255 * (red * 0.07 + core * 0.22 + haze * 0.05 + pur * 0.05) * dust, 0, 255);
      d[i + 2] = clamp(255 * (red * 0.09 + core * 0.2 + haze * 0.16 + pur * 0.45) * dust, 0, 255);
      d[i + 3] = 255;
    }
    o.putImageData(id, 0, 0);
    ctx.save();
    ctx.globalCompositeOperation = 'lighter';
    ctx.imageSmoothingQuality = 'high';
    ctx.drawImage(off, 0, 0, W, H);
    ctx.restore();

    /* noen få stjerner foran tåka */
    for (s = 0; s < 120; s++) {
      ctx.fillStyle = 'rgba(255,240,240,' + (0.5 + r() * 0.5) + ')';
      ctx.fillRect((r() * W) | 0, (r() * H) | 0, 1, 1);
    }

    drawShips(ctx, r);
    drawPlanet(ctx, N);
    drawWormhole(ctx, N);
    drawSatellite(ctx);
  };

  /* --- små skip oppe til venstre --- */
  function drawShips(ctx, r) {
    var ships = [
      [262, 52, 0.7, 0.15, 0], [300, 70, 0.5, 0.1, 0], [345, 90, 1.25, 0.05, 1], [420, 46, 1.0, -0.1, 2],
      [470, 72, 0.6, 0.2, 0], [380, 128, 0.55, 0.0, 0], [560, 118, 1.15, 0.12, 3], [612, 84, 0.45, 0.3, 0],
      [244, 104, 0.5, -0.2, 0], [508, 150, 0.5, 0.1, 0], [330, 156, 0.45, 0.4, 0], [600, 52, 0.45, 0.0, 0]
    ];
    ships.forEach(function (s) {
      var x = s[0], y = s[1], k = s[2], a = s[3], t = s[4];
      ctx.save(); ctx.translate(x, y); ctx.rotate(a); ctx.scale(k, k);
      /* motorglød */
      var eg = ctx.createRadialGradient(-26, 0, 0, -26, 0, 9);
      eg.addColorStop(0, 'rgba(255,220,140,0.95)'); eg.addColorStop(0.4, 'rgba(255,120,30,0.6)'); eg.addColorStop(1, 'rgba(255,60,0,0)');
      ctx.fillStyle = eg; ctx.fillRect(-36, -9, 20, 18);
      var hull = ctx.createLinearGradient(0, -10, 0, 10);
      if (t === 3) { hull.addColorStop(0, '#d8c070'); hull.addColorStop(0.45, '#8a7030'); hull.addColorStop(1, '#2a2010'); }
      else { hull.addColorStop(0, '#b0aaa0'); hull.addColorStop(0.45, '#5a5650'); hull.addColorStop(1, '#16140f'); }
      ctx.fillStyle = hull; ctx.strokeStyle = 'rgba(0,0,0,0.8)'; ctx.lineWidth = 1;
      ctx.beginPath();
      if (t === 1) { /* kryss-skrog */
        ctx.moveTo(30, 0); ctx.lineTo(10, -6); ctx.lineTo(-4, -16); ctx.lineTo(-14, -16); ctx.lineTo(-8, -6);
        ctx.lineTo(-24, -6); ctx.lineTo(-24, 6); ctx.lineTo(-8, 6); ctx.lineTo(-14, 16); ctx.lineTo(-4, 16); ctx.lineTo(10, 6);
      } else if (t === 2) { /* langt skrog */
        ctx.moveTo(34, -2); ctx.lineTo(20, -8); ctx.lineTo(-22, -8); ctx.lineTo(-26, -3); ctx.lineTo(-26, 4); ctx.lineTo(-20, 8); ctx.lineTo(24, 6);
      } else if (t === 3) { /* oval frakter */
        ctx.ellipse(0, 0, 32, 9, 0, 0, Math.PI * 2);
      } else {
        ctx.moveTo(20, 0); ctx.lineTo(4, -7); ctx.lineTo(-18, -6); ctx.lineTo(-22, 0); ctx.lineTo(-18, 6); ctx.lineTo(4, 7);
      }
      ctx.closePath(); ctx.fill(); ctx.stroke();
      ctx.fillStyle = 'rgba(255,255,255,0.35)'; ctx.fillRect(-12, -5, 18, 1);
      ctx.fillStyle = 'rgba(255,160,60,0.9)'; ctx.fillRect(6, -1, 2, 2);
      ctx.restore();
    });
  }

  /* --- planet med nattside, bylys og blå atmosfærekant --- */
  function drawPlanet(ctx, N) {
    var cx = 150, cy = 985, R = 610;
    var x0 = 0, y0 = 360, w = 780, h = 360;
    var img = ctx.getImageData(x0, y0, w, h), d = img.data;
    var L = [-0.78, -0.5, -0.05], ll = Math.hypot(L[0], L[1], L[2]);
    L = [L[0] / ll, L[1] / ll, L[2] / ll];
    for (var y = 0; y < h; y++) for (var x = 0; x < w; x++) {
      var dx = x + x0 - cx, dy = y + y0 - cy, dd = Math.hypot(dx, dy);
      if (dd > R) continue;
      var i = (y * w + x) * 4;
      var nx = dx / R, ny = dy / R, nz = Math.sqrt(Math.max(0, 1 - nx * nx - ny * ny));
      var lon = Math.atan2(nx, nz), lat = Math.asin(ny);
      var land = N.fbm(lon * 3.2 + 7, lat * 5.5 + 3, 6);
      var isLand = sstep(0.47, 0.53, land);
      var cloud = sstep(0.55, 0.8, N.fbm(lon * 6 + 30, lat * 14, 5));
      var light = Math.max(0, nx * L[0] + ny * L[1] + nz * L[2]);
      var day = sstep(0.05, 0.6, light) * 0.75;
      var limb = 0.35 + 0.65 * nz;
      var rr = mix(3, 14, isLand), gg = mix(6, 9, isLand), bb = mix(18, 8, isLand);
      rr += day * mix(20, 70, isLand) + cloud * day * 90; gg += day * mix(45, 58, isLand) + cloud * day * 95; bb += day * mix(110, 40, isLand) + cloud * day * 120;
      /* bylys på nattsiden */
      var night = 1 - day;
      if (isLand > 0.5 && night > 0.2) {
        var dens = sstep(0.42, 0.7, N.fbm(lon * 9 + 2, lat * 18 + 8, 3));
        var sp = N.noise(lon * 300, lat * 560) * 0.7 + N.noise(lon * 90, lat * 170) * 0.3;
        var city = sstep(0.55, 0.85, sp) * dens * night * (1 - cloud * 0.6);
        var glow = dens * night * 0.5;
        rr += city * 255 + glow * 70; gg += city * 120 + glow * 22; bb += city * 24 + glow * 4;
      }
      d[i] = clamp(rr * limb + d[i] * 0, 0, 255);
      d[i + 1] = clamp(gg * limb, 0, 255);
      d[i + 2] = clamp(bb * limb, 0, 255);
    }
    ctx.putImageData(img, x0, y0);
    /* atmosfære: blå/lilla kant */
    ctx.save();
    ctx.globalCompositeOperation = 'lighter';
    var g = ctx.createRadialGradient(cx, cy, R - 26, cx, cy, R + 22);
    g.addColorStop(0, 'rgba(40,70,200,0)');
    g.addColorStop(0.42, 'rgba(60,100,255,0.35)');
    g.addColorStop(0.53, 'rgba(140,170,255,0.75)');
    g.addColorStop(0.6, 'rgba(110,80,230,0.35)');
    g.addColorStop(1, 'rgba(80,40,200,0)');
    ctx.fillStyle = g;
    ctx.beginPath(); ctx.arc(cx, cy, R + 22, 0, Math.PI * 2); ctx.fill();
    ctx.restore();
  }

  /* --- blått spiralt ormehull --- */
  function drawWormhole(ctx, N) {
    var cx = 915, cy = 610, rx = 122, ry = 88, rot = -0.18;
    var x0 = cx - 170, y0 = cy - 130, w = 340, h = 260;
    var img = ctx.getImageData(x0, y0, w, h), d = img.data;
    var cr = Math.cos(-rot), sr = Math.sin(-rot);
    for (var y = 0; y < h; y++) for (var x = 0; x < w; x++) {
      var px = x + x0 - cx, py = y + y0 - cy;
      var ex = (px * cr - py * sr) / rx, ey = (px * sr + py * cr) / ry;
      var r = Math.hypot(ex, ey);
      if (r > 1.35) continue;
      var th = Math.atan2(ey, ex);
      var n = N.fbm(ex * 3 + 40, ey * 3 + 40, 4);
      var sp = 0.5 + 0.5 * Math.sin(th * 2 - Math.log(r + 0.03) * 6.5 + n * 3);
      var arm = Math.pow(sp, 2.2);
      var env = sstep(0.07, 0.28, r) * (1 - sstep(0.55, 1.3, r));
      var I = arm * env * (0.6 + 0.6 * n);
      var ring = Math.exp(-Math.pow((r - 0.2) / 0.06, 2)) * 0.9;
      var i = (y * w + x) * 4;
      var hole = 1 - sstep(0.06, 0.16, r);
      d[i] = clamp(d[i] * (1 - hole) + 30 * I + 170 * I * I + 120 * ring, 0, 255);
      d[i + 1] = clamp(d[i + 1] * (1 - hole) + 70 * I + 200 * I * I + 170 * ring, 0, 255);
      d[i + 2] = clamp(d[i + 2] * (1 - hole) + 255 * I + 120 * I * I + 255 * ring, 0, 255);
    }
    ctx.putImageData(img, x0, y0);
  }

  /* --- egen satellitt/romstasjon --- */
  function cyl(ctx, x1, y1, x2, y2, wd, stops) {
    var a = Math.atan2(y2 - y1, x2 - x1), len = Math.hypot(x2 - x1, y2 - y1);
    ctx.save(); ctx.translate(x1, y1); ctx.rotate(a);
    var g = ctx.createLinearGradient(0, -wd / 2, 0, wd / 2);
    stops.forEach(function (s, k) { g.addColorStop(k / (stops.length - 1), s); });
    ctx.fillStyle = g; ctx.strokeStyle = 'rgba(0,0,0,0.85)'; ctx.lineWidth = 1;
    ctx.beginPath(); ctx.rect(0, -wd / 2, len, wd); ctx.fill(); ctx.stroke();
    ctx.restore();
  }
  var STEEL = ['#1a1814', '#9a948a', '#e4dccc', '#7a7468', '#2a2620', '#0c0b09'];
  var STEEL_D = ['#121110', '#5e5a52', '#9a948a', '#4a463e', '#141210'];
  function drawSatellite(ctx) {
    /* lang antenne nedover */
    ctx.save();
    ctx.fillStyle = '#8a8478'; ctx.strokeStyle = '#000';
    ctx.beginPath(); ctx.moveTo(536, 586); ctx.lineTo(552, 580); ctx.lineTo(616, 706); ctx.lineTo(611, 709); ctx.closePath(); ctx.fill(); ctx.stroke();
    ctx.restore();
    cyl(ctx, 516, 548, 560, 622, 14, STEEL_D);
    /* solcellebom (diagonal) */
    cyl(ctx, 278, 436, 660, 290, 6, ['#14120f', '#8a8478', '#d0c8b8', '#3a3630']);
    ctx.fillStyle = '#c01818'; ctx.save(); ctx.translate(660, 290); ctx.rotate(Math.atan2(290 - 436, 660 - 278));
    ctx.fillRect(-18, -3, 18, 6); ctx.restore();
    ctx.fillStyle = '#7a7468'; ctx.fillRect(272, 433, 8, 7);
    /* hovedkropp */
    cyl(ctx, 438, 336, 520, 552, 58, STEEL);
    /* ringer på kroppen */
    [0.18, 0.42, 0.7, 0.92].forEach(function (t) {
      var x = mix(438, 520, t), y = mix(336, 552, t);
      cyl(ctx, x - 2, y - 5, x + 2, y + 5, 62, ['#0a0908', '#6a645a', '#bab2a2', '#3a3630', '#0a0908']);
    });
    /* toppkuppel */
    var dg = ctx.createRadialGradient(426, 330, 4, 438, 338, 32);
    dg.addColorStop(0, '#f0e8d8'); dg.addColorStop(0.5, '#8a8478'); dg.addColorStop(1, '#14120e');
    ctx.fillStyle = dg; ctx.strokeStyle = '#000';
    ctx.beginPath(); ctx.ellipse(438, 338, 30, 22, 1.2, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
    /* sidetank */
    cyl(ctx, 506, 380, 530, 446, 22, STEEL);
    /* parabol */
    ctx.save(); ctx.translate(392, 380); ctx.rotate(-0.5);
    var pg = ctx.createLinearGradient(-44, -30, 40, 30);
    pg.addColorStop(0, '#e8e0d0'); pg.addColorStop(0.5, '#8a8478'); pg.addColorStop(1, '#1c1a16');
    ctx.fillStyle = pg; ctx.strokeStyle = '#000';
    ctx.beginPath(); ctx.ellipse(0, 0, 44, 34, 0, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
    ctx.strokeStyle = 'rgba(0,0,0,0.45)';
    for (var k = 1; k < 4; k++) { ctx.beginPath(); ctx.ellipse(0, 0, 44 * k / 4, 34 * k / 4, 0, 0, Math.PI * 2); ctx.stroke(); }
    ctx.restore();
    ctx.strokeStyle = '#b0a898'; ctx.lineWidth = 2;
    ctx.beginPath(); ctx.moveTo(392, 380); ctx.lineTo(420, 366); ctx.stroke(); ctx.lineWidth = 1;
    /* lilla lampe */
    ctx.fillStyle = '#c070ff'; ctx.fillRect(468, 404, 3, 3);
    ctx.fillStyle = 'rgba(190,110,255,0.35)'; ctx.fillRect(466, 402, 7, 7);
  }

  /* =====================================================================
     SPILL: isometrisk terreng
     ===================================================================== */
  var THEMES = {
    terran: { g1: [34, 25, 15], g2: [66, 50, 30], peb: [104, 96, 84], tile: [46, 46, 50], hi: [86, 86, 92], lo: [16, 16, 18], mark: '#c8a020', seed: 21 },
    protoss: { g1: [38, 40, 56], g2: [72, 76, 98], peb: [120, 124, 146], tile: [22, 38, 40], hi: [52, 84, 86], lo: [8, 16, 18], mark: '#30a0b8', seed: 33 },
    zerg: { g1: [34, 24, 18], g2: [64, 46, 30], peb: [98, 84, 70], tile: [52, 34, 30], hi: [96, 70, 56], lo: [20, 10, 8], mark: '#a07040', seed: 55 }
  };
  /* plattform-striper i iso-rutenett (i0,i1,j0,j1) */
  var ROADS = [
    [12, 30, 20, 22], [30, 32, 10, 22], [30, 48, 10, 12], [30, 32, 22, 36], [19, 26, 31, 38],
    [8, 22, 34, 36], [38, 40, 22, 46], [39, 54, 30, 32], [44, 46, 0, 10], [8, 10, 14, 34]
  ];
  function isPlat(i, j) {
    for (var k = 0; k < ROADS.length; k++) { var q = ROADS[k]; if (i >= q[0] && i <= q[1] && j >= q[2] && j <= q[3]) return true; }
    return false;
  }

  SC.drawTerrain = function (canvas, race) {
    var T = THEMES[race] || THEMES.terran;
    var W = 1280, H = 720; canvas.width = W; canvas.height = H;
    var ctx = canvas.getContext('2d'), r = rng(T.seed), N = makeNoise(T.seed);
    var img = ctx.createImageData(W, H), d = img.data;
    for (var y = 0; y < H; y++) for (var x = 0; x < W; x++) {
      var i = (y * W + x) * 4;
      var n = N.fbm(x / 120, y / 60, 4);
      var pb = N.noise(x / 5, y / 2.6);
      var k = sstep(0.25, 0.75, n), j = (r() - 0.5) * 18;
      var lum = 0.82 + pb * 0.35;
      var c0 = mix(T.g1[0], T.g2[0], k) * lum + j, c1 = mix(T.g1[1], T.g2[1], k) * lum + j, c2 = mix(T.g1[2], T.g2[2], k) * lum + j;
      if (race === 'zerg') { /* kryp (creep) */
        var cr = sstep(0.5, 0.56, N.fbm(x / 160 + 9, y / 80 + 4, 4) + (1 - Math.hypot(x - 620, (y - 330) * 1.8) / 700) * 0.35);
        var vein = Math.pow(1 - Math.abs(N.noise(x / 26, y / 13) - 0.5) * 2, 14);
        c0 = mix(c0, 44 + vein * 42 + pb * 16, cr); c1 = mix(c1, 18 + vein * 12, cr); c2 = mix(c2, 40 + vein * 34 + pb * 14, cr);
      }
      d[i] = c0; d[i + 1] = c1; d[i + 2] = c2; d[i + 3] = 255;
    }
    ctx.putImageData(img, 0, 0);

    /* steinklynger */
    for (var p = 0; p < 2600; p++) {
      var px = r() * W, py = r() * H;
      if (N.fbm(px / 70 + 3, py / 35 + 3, 3) < 0.5) continue;
      var rx = 1.5 + r() * 3.5, ry = rx * (0.5 + r() * 0.2), sh = 0.7 + r() * 0.5;
      ctx.fillStyle = 'rgba(0,0,0,0.45)';
      ctx.beginPath(); ctx.ellipse(px + 1, py + ry * 0.6, rx, ry, 0, 0, Math.PI * 2); ctx.fill();
      ctx.fillStyle = 'rgb(' + (T.peb[0] * sh | 0) + ',' + (T.peb[1] * sh | 0) + ',' + (T.peb[2] * sh | 0) + ')';
      ctx.beginPath(); ctx.ellipse(px, py, rx, ry, 0, 0, Math.PI * 2); ctx.fill();
      ctx.fillStyle = 'rgba(255,255,255,0.18)'; ctx.fillRect(px - rx * 0.4, py - ry * 0.5, Math.max(1, rx * 0.6), 1);
    }

    /* plattform-fliser (bak→fram) */
    var TW = 48, TH = 24, ox = 640, oy = -360;
    var tiles = [];
    for (var a = 0; a < 70; a++) for (var b = 0; b < 60; b++) if (isPlat(a, b)) tiles.push([a, b]);
    tiles.sort(function (m, n2) { return (m[0] + m[1]) - (n2[0] + n2[1]); });
    var rgb = function (c, f) { return 'rgb(' + (c[0] * f | 0) + ',' + (c[1] * f | 0) + ',' + (c[2] * f | 0) + ')'; };
    tiles.forEach(function (t) {
      var ti = t[0], tj = t[1];
      var sx = (ti - tj) * TW / 2 + ox, sy = (ti + tj) * TH / 2 + oy;
      if (sx < -80 || sx > W + 80 || sy < -60 || sy > H + 40) return;
      var top = [sx, sy], rgt = [sx + TW / 2, sy + TH / 2], bot = [sx, sy + TH], lft = [sx - TW / 2, sy + TH / 2];
      var E = 6;
      /* sideflater der naboen ikke er plattform */
      if (!isPlat(ti, tj + 1)) {
        ctx.fillStyle = rgb(T.lo, 1.2);
        ctx.beginPath(); ctx.moveTo(lft[0], lft[1]); ctx.lineTo(bot[0], bot[1]); ctx.lineTo(bot[0], bot[1] + E); ctx.lineTo(lft[0], lft[1] + E); ctx.closePath(); ctx.fill();
      }
      if (!isPlat(ti + 1, tj)) {
        ctx.fillStyle = rgb(T.lo, 0.7);
        ctx.beginPath(); ctx.moveTo(bot[0], bot[1]); ctx.lineTo(rgt[0], rgt[1]); ctx.lineTo(rgt[0], rgt[1] + E); ctx.lineTo(bot[0], bot[1] + E); ctx.closePath(); ctx.fill();
      }
      var v = 0.85 + r() * 0.3;
      ctx.fillStyle = rgb(T.tile, v);
      ctx.beginPath(); ctx.moveTo(top[0], top[1]); ctx.lineTo(rgt[0], rgt[1]); ctx.lineTo(bot[0], bot[1]); ctx.lineTo(lft[0], lft[1]); ctx.closePath(); ctx.fill();
      /* fasede kanter */
      ctx.strokeStyle = rgb(T.hi, 1); ctx.lineWidth = 1;
      ctx.beginPath(); ctx.moveTo(lft[0] + 1, lft[1]); ctx.lineTo(top[0], top[1] + 1); ctx.lineTo(rgt[0] - 1, rgt[1]); ctx.stroke();
      ctx.strokeStyle = rgb(T.lo, 1);
      ctx.beginPath(); ctx.moveTo(lft[0] + 1, lft[1]); ctx.lineTo(bot[0], bot[1] - 1); ctx.lineTo(rgt[0] - 1, rgt[1]); ctx.stroke();
      /* platefuge (indre diamant) */
      ctx.strokeStyle = 'rgba(0,0,0,0.45)';
      ctx.beginPath(); ctx.moveTo(sx, sy + 6); ctx.lineTo(sx + 12, sy + 12); ctx.lineTo(sx, sy + 18); ctx.lineTo(sx - 12, sy + 12); ctx.closePath(); ctx.stroke();
      /* gule markeringer langs kanter */
      if (!isPlat(ti, tj + 1) && r() > 0.45) {
        ctx.strokeStyle = T.mark; ctx.beginPath(); ctx.moveTo(lft[0] + 6, lft[1] + 3); ctx.lineTo(lft[0] + 12, lft[1] + 6); ctx.stroke();
      }
      if (!isPlat(ti + 1, tj) && r() > 0.45) {
        ctx.strokeStyle = T.mark; ctx.beginPath(); ctx.moveTo(rgt[0] - 6, rgt[1] + 3); ctx.lineTo(rgt[0] - 12, rgt[1] + 6); ctx.stroke();
      }
    });

    drawUnits(ctx, race, r);
  };

  function drawUnits(ctx, race, r) {
    var team = race === 'protoss' ? ['#e8c040', '#3a70ff'] : race === 'zerg' ? ['#a04070', '#e0c060'] : ['#e8d040', '#3a8cff'];
    /* bygning med utvalgsellipse */
    var bx = 360, by = 330;
    ctx.save();
    ctx.fillStyle = 'rgba(0,0,0,0.5)';
    ctx.beginPath(); ctx.ellipse(bx + 6, by + 30, 70, 30, 0, 0, Math.PI * 2); ctx.fill();
    if (race === 'protoss') {
      ctx.fillStyle = '#b08a28'; ctx.beginPath(); ctx.moveTo(bx, by - 52); ctx.lineTo(bx + 56, by + 12); ctx.lineTo(bx, by + 34); ctx.closePath(); ctx.fill();
      ctx.fillStyle = '#e8c048'; ctx.beginPath(); ctx.moveTo(bx, by - 52); ctx.lineTo(bx - 56, by + 12); ctx.lineTo(bx, by + 34); ctx.closePath(); ctx.fill();
      ctx.fillStyle = '#40d0ff'; ctx.fillRect(bx - 4, by - 10, 8, 14);
      ctx.fillStyle = '#2a50c0'; ctx.fillRect(bx - 40, by + 8, 10, 4); ctx.fillRect(bx + 30, by + 8, 10, 4);
    } else if (race === 'zerg') {
      var zg = ctx.createRadialGradient(bx - 14, by - 20, 4, bx, by, 60);
      zg.addColorStop(0, '#b06a60'); zg.addColorStop(0.5, '#6a2a40'); zg.addColorStop(1, '#200810');
      ctx.fillStyle = zg; ctx.beginPath(); ctx.ellipse(bx, by, 58, 36, 0, Math.PI, 0); ctx.lineTo(bx + 58, by + 14); ctx.ellipse(bx, by + 14, 58, 20, 0, 0, Math.PI); ctx.closePath(); ctx.fill();
      ctx.fillStyle = '#e0d0a8';
      for (var s = -2; s <= 2; s++) { ctx.beginPath(); ctx.moveTo(bx + s * 20 - 4, by - 26 + Math.abs(s) * 8); ctx.lineTo(bx + s * 22, by - 44 + Math.abs(s) * 10); ctx.lineTo(bx + s * 20 + 4, by - 26 + Math.abs(s) * 8); ctx.fill(); }
      ctx.fillStyle = '#ff6020'; ctx.fillRect(bx - 3, by - 6, 6, 4);
    } else {
      ctx.fillStyle = '#4a4e56'; ctx.beginPath(); ctx.moveTo(bx - 52, by - 4); ctx.lineTo(bx, by + 22); ctx.lineTo(bx, by + 40); ctx.lineTo(bx - 52, by + 14); ctx.closePath(); ctx.fill();
      ctx.fillStyle = '#2c2f35'; ctx.beginPath(); ctx.moveTo(bx + 52, by - 4); ctx.lineTo(bx, by + 22); ctx.lineTo(bx, by + 40); ctx.lineTo(bx + 52, by + 14); ctx.closePath(); ctx.fill();
      ctx.fillStyle = '#7a7e86'; ctx.beginPath(); ctx.moveTo(bx, by - 30); ctx.lineTo(bx + 52, by - 4); ctx.lineTo(bx, by + 22); ctx.lineTo(bx - 52, by - 4); ctx.closePath(); ctx.fill();
      ctx.fillStyle = '#5a5e66'; ctx.fillRect(bx - 16, by - 20, 30, 16);
      ctx.fillStyle = '#e8c020'; ctx.fillRect(bx - 40, by + 6, 6, 3); ctx.fillRect(bx + 30, by + 6, 6, 3);
      ctx.fillStyle = '#ff7020'; ctx.fillRect(bx - 3, by - 16, 4, 4);
      ctx.fillStyle = team[1]; ctx.fillRect(bx - 30, by - 8, 8, 3);
    }
    /* grønn utvalgsellipse + prikket HP-linje */
    ctx.strokeStyle = '#30e030'; ctx.lineWidth = 1.5;
    ctx.beginPath(); ctx.ellipse(bx, by + 12, 76, 38, 0, 0, Math.PI * 2); ctx.stroke();
    for (var q = 0; q < 24; q++) { ctx.fillStyle = q < 21 ? '#30e030' : '#1a5a1a'; ctx.fillRect(bx - 48 + q * 4, by + 58, 3, 3); }
    ctx.restore();

    /* abstrakte enhetsprikker */
    var units = [[700, 120, 0], [742, 140, 0], [720, 170, 0], [770, 110, 0], [680, 200, 0], [905, 90, 1], [940, 120, 1], [980, 96, 1],
      [520, 420, 0], [560, 446, 0], [600, 410, 0], [1010, 320, 1], [1050, 350, 1], [210, 200, 1]];
    units.forEach(function (u) {
      var x = u[0], y = u[1];
      ctx.fillStyle = 'rgba(0,0,0,0.5)'; ctx.beginPath(); ctx.ellipse(x + 2, y + 7, 8, 4, 0, 0, Math.PI * 2); ctx.fill();
      ctx.fillStyle = '#3a3c42'; ctx.beginPath(); ctx.ellipse(x, y, 6, 7, 0, 0, Math.PI * 2); ctx.fill();
      ctx.fillStyle = team[u[2]]; ctx.fillRect(x - 3, y - 2, 6, 3);
      ctx.fillStyle = 'rgba(255,255,255,0.5)'; ctx.fillRect(x - 2, y - 5, 2, 1);
    });
    /* noen blå energiprosjektiler */
    [[640, 300], [700, 340], [880, 250]].forEach(function (p) {
      var g = ctx.createRadialGradient(p[0], p[1], 0, p[0], p[1], 9);
      g.addColorStop(0, 'rgba(230,240,255,1)'); g.addColorStop(0.35, 'rgba(90,150,255,0.8)'); g.addColorStop(1, 'rgba(40,80,255,0)');
      ctx.fillStyle = g; ctx.fillRect(p[0] - 9, p[1] - 9, 18, 18);
    });
  }

  /* --- minimap --- */
  SC.drawMinimap = function (canvas, race) {
    var T = THEMES[race] || THEMES.terran, S = 128;
    canvas.width = S; canvas.height = S;
    var ctx = canvas.getContext('2d'), N = makeNoise(T.seed + 1), r = rng(T.seed + 2);
    var img = ctx.createImageData(S, S), d = img.data;
    for (var y = 0; y < S; y++) for (var x = 0; x < S; x++) {
      var i = (y * S + x) * 4;
      var n = N.fbm(x / 26, y / 26, 4) + (0.5 - Math.hypot(x - 64, y - 70) / 120) * 0.6;
      var land = n > 0.52, hi = n > 0.62;
      var c = land ? (hi ? T.g2 : T.g1) : [0, 0, 0];
      var f = land ? 1.6 + (r() - 0.5) * 0.3 : 0;
      d[i] = c[0] * f; d[i + 1] = c[1] * f; d[i + 2] = c[2] * f; d[i + 3] = 255;
    }
    ctx.putImageData(img, 0, 0);
    function blob(cx, cy, n, col) {
      ctx.fillStyle = col;
      for (var k = 0; k < n; k++) ctx.fillRect((cx + (r() - 0.5) * 22) | 0, (cy + (r() - 0.5) * 18) | 0, 2, 2);
    }
    var mine = race === 'protoss' ? '#e8d040' : race === 'zerg' ? '#c040a0' : '#e8e040';
    blob(40, 30, 30, '#d040d0'); blob(96, 50, 16, '#30d0e0'); blob(62, 96, 40, mine); blob(28, 84, 12, '#30d0e0'); blob(100, 98, 14, mine);
    ctx.strokeStyle = '#ffffff'; ctx.lineWidth = 1;
    ctx.strokeRect(46.5, 78.5, 40, 24);
  };

  /* --- portrett: abstrakt hjelm + animert statisk støy --- */
  function figure(race) {
    var w = 60, h = 72, c = canvasOf(w, h), x = c.getContext('2d');
    if (race === 'protoss') {
      var bg = x.createLinearGradient(0, 0, 0, h); bg.addColorStop(0, '#0a1838'); bg.addColorStop(1, '#02060e');
      x.fillStyle = bg; x.fillRect(0, 0, w, h);
      x.fillStyle = '#a07820'; x.beginPath(); x.moveTo(6, 72); x.lineTo(14, 56); x.lineTo(46, 56); x.lineTo(54, 72); x.fill();
      var hg = x.createLinearGradient(16, 0, 46, 0); hg.addColorStop(0, '#3a3a5a'); hg.addColorStop(0.5, '#8a86a8'); hg.addColorStop(1, '#2a2840');
      x.fillStyle = hg; x.beginPath(); x.ellipse(30, 32, 13, 24, 0, 0, Math.PI * 2); x.fill();
      x.fillStyle = '#0a0a18'; x.fillRect(19, 34, 22, 6);
      x.fillStyle = '#80f0ff'; x.fillRect(21, 35, 5, 3); x.fillRect(34, 35, 5, 3);
      x.fillStyle = '#e8b830'; x.fillRect(22, 52, 16, 3);
    } else if (race === 'zerg') {
      var zb = x.createLinearGradient(0, 0, 0, h); zb.addColorStop(0, '#2a0a18'); zb.addColorStop(1, '#0a0206');
      x.fillStyle = zb; x.fillRect(0, 0, w, h);
      var cg = x.createRadialGradient(24, 26, 2, 30, 34, 28); cg.addColorStop(0, '#a06a50'); cg.addColorStop(0.6, '#4a1e2a'); cg.addColorStop(1, '#14060a');
      x.fillStyle = cg; x.beginPath(); x.moveTo(8, 72); x.lineTo(12, 30); x.lineTo(30, 10); x.lineTo(48, 30); x.lineTo(52, 72); x.fill();
      x.fillStyle = '#d8c8a0';
      [[12, 30, 2, 14], [48, 30, 58, 16], [22, 18, 16, 4], [38, 18, 44, 4]].forEach(function (s) { x.beginPath(); x.moveTo(s[0] - 2, s[1]); x.lineTo(s[2], s[3]); x.lineTo(s[0] + 2, s[1] + 2); x.fill(); });
      x.fillStyle = '#ff7020'; x.fillRect(20, 36, 6, 3); x.fillRect(34, 36, 6, 3);
      x.fillStyle = '#2a0810'; x.fillRect(24, 50, 12, 6);
    } else {
      var tb = x.createLinearGradient(0, 0, 0, h); tb.addColorStop(0, '#1a2224'); tb.addColorStop(1, '#060808');
      x.fillStyle = tb; x.fillRect(0, 0, w, h);
      x.fillStyle = '#3a4246'; x.beginPath(); x.moveTo(2, 72); x.lineTo(8, 54); x.lineTo(52, 54); x.lineTo(58, 72); x.fill();
      var tg = x.createLinearGradient(12, 0, 48, 0); tg.addColorStop(0, '#2a3034'); tg.addColorStop(0.35, '#9aa4a8'); tg.addColorStop(1, '#1a1e20');
      x.fillStyle = tg; x.beginPath(); x.arc(30, 32, 19, Math.PI, 0); x.lineTo(49, 50); x.lineTo(11, 50); x.closePath(); x.fill();
      x.fillStyle = '#0a0c0c'; x.fillRect(14, 30, 32, 9);
      x.fillStyle = '#e8a020'; x.fillRect(16, 32, 28, 3);
      x.fillStyle = '#5a6468'; x.fillRect(8, 36, 5, 12); x.fillRect(47, 36, 5, 12);
      x.fillStyle = '#c8d0d0'; x.fillRect(46, 8, 1, 14);
      x.fillStyle = '#ff3a2a'; x.fillRect(45, 7, 3, 2);
    }
    return c;
  }
  SC.portrait = function (canvas) {
    var w = 60, h = 72; canvas.width = w; canvas.height = h;
    var ctx = canvas.getContext('2d', { willReadFrequently: true }), r = rng(9), race = 'terran', fig = figure(race), t = 0;
    var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    function frame() {
      t++;
      ctx.drawImage(fig, 0, 0);
      var id = ctx.getImageData(0, 0, w, h), d = id.data, band = (t * 3) % (h + 20) - 10;
      for (var y = 0; y < h; y++) {
        var scan = y % 2 ? 0.78 : 1, inBand = Math.abs(y - band) < 3 ? 1.35 : 1;
        var shift = (Math.abs(y - band) < 2 && r() > 0.5) ? 2 : 0;
        for (var x = 0; x < w; x++) {
          var i = (y * w + x) * 4, n = (r() - 0.5) * 70;
          var sx = Math.min(w - 1, x + shift), si = (y * w + sx) * 4;
          d[i] = clamp((d[si] + n) * scan * inBand, 0, 255);
          d[i + 1] = clamp((d[si + 1] + n) * scan * inBand, 0, 255);
          d[i + 2] = clamp((d[si + 2] + n) * scan * inBand, 0, 255);
        }
      }
      ctx.putImageData(id, 0, 0);
    }
    frame();
    var timer = reduce ? 0 : setInterval(frame, 90);
    return {
      setRace: function (r2) { race = r2; fig = figure(race); frame(); },
      stop: function () { clearInterval(timer); }
    };
  };

  /* --- grønne trådmodeller (SVG) --- */
  SC.wireframe = function (race) {
    var open = '<svg viewBox="0 0 120 100" class="pt-wire__svg" aria-hidden="true"><g fill="currentColor" fill-opacity="0.12" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round">';
    var body;
    if (race === 'protoss') {
      body = '<path d="M60 8 L104 58 L60 80 L16 58 Z"/><path d="M60 8 L60 80"/><path d="M60 30 L84 56 L60 68 L36 56 Z"/>' +
        '<path d="M26 66 L16 92 L36 80 Z"/><path d="M94 66 L104 92 L84 80 Z"/><path d="M48 46 h24 M44 54 h32 M52 38 h16"/>' +
        '<rect x="54" y="42" width="12" height="10"/><path d="M38 72 L60 86 L82 72"/>';
    } else if (race === 'zerg') {
      body = '<path d="M14 70 Q16 34 60 26 Q104 34 106 70 Q60 92 14 70 Z"/><path d="M30 50 Q60 40 90 50"/><path d="M24 62 Q60 52 96 62"/>' +
        '<path d="M60 26 L56 6 L64 6 Z"/><path d="M36 34 L26 14 L32 12 Z"/><path d="M84 34 L94 14 L88 12 Z"/>' +
        '<ellipse cx="60" cy="66" rx="10" ry="6"/><path d="M18 74 L8 92 M102 74 L112 92 M40 82 L36 96 M80 82 L84 96"/>';
    } else {
      body = '<path d="M14 46 L60 24 L106 46 L106 70 L60 92 L14 70 Z"/><path d="M14 46 L60 68 L106 46 M60 68 L60 92"/>' +
        '<path d="M30 40 L30 26 L58 12 L86 26 L86 40"/><path d="M30 26 L58 40 L86 26 M58 40 L58 50"/>' +
        '<path d="M22 56 L50 70 M22 62 L50 76 M70 70 L98 56 M70 76 L98 62"/><rect x="40" y="24" width="10" height="8"/>' +
        '<path d="M66 18 L74 14 L80 18 L72 22 Z"/><path d="M8 80 h10 M102 80 h10"/>';
    }
    return open + body + '</g></svg>';
  };

  /* --- konsollsilhuett: samme punkter for clip-path og kantlinje --- */
  SC.consoleShape = function (body, svg, points, trimPts) {
    body.style.clipPath = 'polygon(' + points.map(function (p) { return p[0] + 'px ' + p[1] + 'px'; }).join(',') + ')';
    var pts = points.map(function (p) { return p.join(','); }).join(' ');
    var top = (trimPts || points).map(function (p) { return p.join(','); }).join(' ');
    svg.innerHTML =
      '<polygon class="pt-console__edge-dark" points="' + pts + '"/>' +
      '<polyline class="pt-console__edge-hi" points="' + top + '"/>' +
      '<polyline class="pt-console__edge-trim" points="' + top + '"/>';
  };
})();

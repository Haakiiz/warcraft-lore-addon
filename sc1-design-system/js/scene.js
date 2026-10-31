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

  /* --- små skip oppe til venstre (lav kontrast, skyggeside, panellinjer, lyspunkter) --- */
  function hull(ctx, t) {
    ctx.beginPath();
    if (t === 1) { /* kryss-skrog med vinger */
      ctx.moveTo(30, 0); ctx.lineTo(12, -6); ctx.lineTo(-2, -16); ctx.lineTo(-14, -17); ctx.lineTo(-10, -6);
      ctx.lineTo(-24, -6); ctx.lineTo(-24, 6); ctx.lineTo(-10, 6); ctx.lineTo(-14, 17); ctx.lineTo(-2, 16); ctx.lineTo(12, 6);
    } else if (t === 2) { /* langt krysserskrog med tårn */
      ctx.moveTo(34, -1); ctx.lineTo(22, -7); ctx.lineTo(4, -7); ctx.lineTo(0, -13); ctx.lineTo(-12, -13); ctx.lineTo(-14, -8);
      ctx.lineTo(-26, -8); ctx.lineTo(-28, -3); ctx.lineTo(-28, 5); ctx.lineTo(-22, 9); ctx.lineTo(22, 7);
    } else if (t === 3) { /* frakter: buk + motorgondoler */
      ctx.ellipse(0, 0, 30, 9, 0, 0, Math.PI * 2);
      ctx.moveTo(-18, 8); ctx.rect(-26, 6, 16, 6);
    } else { /* fregatt med sidegondoler */
      ctx.moveTo(18, 0); ctx.lineTo(8, -4); ctx.lineTo(-6, -5); ctx.lineTo(-10, -9); ctx.lineTo(-17, -9); ctx.lineTo(-18, -4);
      ctx.lineTo(-22, -3); ctx.lineTo(-22, 3); ctx.lineTo(-18, 4); ctx.lineTo(-17, 9); ctx.lineTo(-10, 9); ctx.lineTo(-6, 5); ctx.lineTo(8, 4);
    }
    ctx.closePath();
  }
  function drawShips(ctx, r) {
    var ships = [
      [262, 52, 0.75, 0.15, 0], [300, 70, 0.55, 0.1, 0], [345, 90, 1.2, 0.05, 1], [420, 46, 1.05, -0.1, 2],
      [470, 72, 0.65, 0.2, 0], [380, 128, 0.6, 0.0, 0], [560, 118, 1.1, 0.12, 3], [612, 84, 0.5, 0.3, 0],
      [244, 104, 0.55, -0.2, 0], [508, 150, 0.55, 0.1, 0], [330, 156, 0.5, 0.4, 0], [600, 52, 0.5, 0.0, 0]
    ];
    ships.forEach(function (s) {
      var k = s[2], t = s[4];
      ctx.save(); ctx.translate(s[0], s[1]); ctx.rotate(s[3]); ctx.scale(k, k);
      var eg = ctx.createRadialGradient(-27, 0, 0, -27, 0, 6);
      eg.addColorStop(0, 'rgba(255,200,130,0.85)'); eg.addColorStop(0.5, 'rgba(255,110,40,0.3)'); eg.addColorStop(1, 'rgba(255,60,0,0)');
      ctx.fillStyle = eg; ctx.fillRect(-34, -6, 14, 12);
      var g = ctx.createLinearGradient(0, -12, 0, 12);
      if (t === 3) { g.addColorStop(0, '#8a7a4a'); g.addColorStop(0.4, '#5a4c28'); g.addColorStop(1, '#120e06'); }
      else { g.addColorStop(0, '#7a766e'); g.addColorStop(0.4, '#48453f'); g.addColorStop(1, '#0e0d0b'); }
      hull(ctx, t); ctx.fillStyle = g; ctx.fill();
      ctx.save(); hull(ctx, t); ctx.clip();
      ctx.fillStyle = 'rgba(0,0,0,0.5)'; ctx.fillRect(-40, 1, 80, 20);           /* skyggeside */
      ctx.strokeStyle = 'rgba(0,0,0,0.55)'; ctx.lineWidth = 1 / k;
      for (var x = -20; x < 24; x += 7) { ctx.beginPath(); ctx.moveTo(x, -16); ctx.lineTo(x, 16); ctx.stroke(); }
      ctx.beginPath(); ctx.moveTo(-30, -1); ctx.lineTo(30, -1); ctx.stroke();
      ctx.fillStyle = 'rgba(255,240,220,0.14)'; ctx.fillRect(-30, -7, 60, 2);       /* svakt toppskinn */
      ctx.restore();
      if (t === 2 || t === 1) { ctx.fillStyle = '#2a2824'; ctx.fillRect(-10, -12, 8, 5); }
      hull(ctx, t); ctx.strokeStyle = 'rgba(0,0,0,0.75)'; ctx.lineWidth = 1 / k; ctx.stroke();
      ctx.fillStyle = 'rgba(255,255,240,0.9)'; ctx.fillRect(t === 2 ? 30 : 14, -1, 1.5 / k, 1.5 / k);
      ctx.fillStyle = 'rgba(255,60,40,0.9)'; ctx.fillRect(-20, -6, 1.5 / k, 1.5 / k);
      ctx.fillStyle = 'rgba(120,200,255,0.8)'; ctx.fillRect(-6, 2, 1.2 / k, 1.2 / k);
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
      var day = sstep(0.15, 0.7, light) * 0.5;
      var limb = 0.25 + 0.75 * nz;
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

  /* --- ormehull: tett blå spiral med lyst sentrum som faller mot svart --- */
  function drawWormhole(ctx, N) {
    var cx = 915, cy = 612, rx = 104, ry = 72, rot = -0.15;
    var x0 = cx - 150, y0 = cy - 110, w = 300, h = 220;
    var img = ctx.getImageData(x0, y0, w, h), d = img.data;
    var cr = Math.cos(-rot), sr = Math.sin(-rot);
    for (var y = 0; y < h; y++) for (var x = 0; x < w; x++) {
      var px = x + x0 - cx, py = y + y0 - cy;
      var ex = (px * cr - py * sr) / rx, ey = (px * sr + py * cr) / ry;
      var r = Math.hypot(ex, ey);
      if (r > 1.3) continue;
      var th = Math.atan2(ey, ex), i = (y * w + x) * 4;
      var n = N.fbm(ex * 5 + 40, ey * 5 + 40, 4);
      /* to tette spiralarmer (vinkel + log r), lyst sentrum, fall mot svart */
      var arm = 0.5 + 0.5 * Math.cos(2 * th + Math.log(r + 0.02) * 7 + n * 2.5);
      arm = Math.pow(arm, 1.6);
      var fall = Math.exp(-r * 1.9);
      var core = Math.exp(-Math.pow(r / 0.1, 2));
      var edge = 1 - sstep(0.7, 1.25, r);
      var I = (arm * 0.9 + 0.1) * fall * edge * (0.85 + 0.6 * n) * 1.3;
      var dark = 1 - edge * 0.85;
      d[i] = clamp(d[i] * dark + 40 * I + 230 * core, 0, 255);
      d[i + 1] = clamp(d[i + 1] * dark + 120 * I + 240 * core, 0, 255);
      d[i + 2] = clamp(d[i + 2] * dark + 255 * I * 1.2 + 255 * core, 0, 255);
    }
    ctx.putImageData(img, x0, y0);
  }

  /* --- egen satellitt/romstasjon (dempet stål, skyggeside, panellinjer, lys) --- */
  function cyl(ctx, x1, y1, x2, y2, wd, stops, panels) {
    var a = Math.atan2(y2 - y1, x2 - x1), len = Math.hypot(x2 - x1, y2 - y1);
    ctx.save(); ctx.translate(x1, y1); ctx.rotate(a);
    var g = ctx.createLinearGradient(0, -wd / 2, 0, wd / 2);
    stops.forEach(function (s, k) { g.addColorStop(k / (stops.length - 1), s); });
    ctx.fillStyle = g; ctx.fillRect(0, -wd / 2, len, wd);
    if (panels) {
      ctx.fillStyle = 'rgba(0,0,0,0.4)'; ctx.fillRect(0, wd * 0.12, len, wd * 0.38);
      ctx.fillStyle = 'rgba(0,0,0,0.5)';
      for (var p = panels; p < len; p += panels) ctx.fillRect(p, -wd / 2, 1, wd);
      ctx.fillStyle = 'rgba(0,0,0,0.35)'; ctx.fillRect(0, -wd * 0.18, len, 1);
    }
    ctx.strokeStyle = 'rgba(0,0,0,0.85)'; ctx.lineWidth = 1; ctx.strokeRect(0, -wd / 2, len, wd);
    ctx.restore();
  }
  var STEEL = ['#0a0908', '#4a463e', '#86806f', '#57524a', '#1c1a16', '#070605'];
  var STEEL_D = ['#0a0908', '#3a3630', '#6a655a', '#2e2b26', '#0a0908'];
  function drawSatellite(ctx) {
    ctx.fillStyle = '#5a554c'; ctx.strokeStyle = '#000';
    ctx.beginPath(); ctx.moveTo(536, 586); ctx.lineTo(552, 580); ctx.lineTo(616, 706); ctx.lineTo(611, 709); ctx.closePath(); ctx.fill(); ctx.stroke();
    ctx.fillStyle = 'rgba(0,0,0,0.5)'; ctx.beginPath(); ctx.moveTo(546, 584); ctx.lineTo(552, 580); ctx.lineTo(616, 706); ctx.lineTo(613, 708); ctx.fill();
    cyl(ctx, 516, 548, 560, 622, 14, STEEL_D, 10);
    cyl(ctx, 278, 436, 660, 290, 6, ['#0e0d0b', '#5a554c', '#8a8476', '#2a2722'], 24);
    /* solcellepaneler på bommen */
    [[310, 424], [600, 312]].forEach(function (p) {
      ctx.save(); ctx.translate(p[0], p[1]); ctx.rotate(Math.atan2(290 - 436, 660 - 278));
      ctx.fillStyle = '#141826'; ctx.fillRect(-22, -9, 44, 18);
      ctx.strokeStyle = 'rgba(120,130,160,0.35)'; ctx.lineWidth = 1;
      for (var k = -22; k <= 22; k += 7) { ctx.beginPath(); ctx.moveTo(k, -9); ctx.lineTo(k, 9); ctx.stroke(); }
      ctx.beginPath(); ctx.moveTo(-22, 0); ctx.lineTo(22, 0); ctx.stroke();
      ctx.strokeStyle = '#000'; ctx.strokeRect(-22, -9, 44, 18);
      ctx.restore();
    });
    ctx.fillStyle = '#8a1414'; ctx.save(); ctx.translate(660, 290); ctx.rotate(Math.atan2(290 - 436, 660 - 278)); ctx.fillRect(-16, -3, 16, 6); ctx.restore();
    cyl(ctx, 438, 336, 520, 552, 58, STEEL, 16);
    [0.18, 0.42, 0.7, 0.92].forEach(function (t) {
      var x = mix(438, 520, t), y = mix(336, 552, t);
      cyl(ctx, x - 2, y - 5, x + 2, y + 5, 62, ['#060505', '#3e3a33', '#6e695e', '#26231f', '#060505']);
    });
    var dg = ctx.createRadialGradient(426, 330, 4, 438, 338, 32);
    dg.addColorStop(0, '#9a9384'); dg.addColorStop(0.5, '#4e4a42'); dg.addColorStop(1, '#0c0b09');
    ctx.fillStyle = dg; ctx.strokeStyle = '#000';
    ctx.beginPath(); ctx.ellipse(438, 338, 30, 22, 1.2, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
    cyl(ctx, 506, 380, 530, 446, 22, STEEL, 12);
    ctx.save(); ctx.translate(392, 380); ctx.rotate(-0.5);
    var pg = ctx.createLinearGradient(-44, -30, 40, 30);
    pg.addColorStop(0, '#948d7e'); pg.addColorStop(0.45, '#57524a'); pg.addColorStop(1, '#0e0d0b');
    ctx.fillStyle = pg; ctx.strokeStyle = '#000';
    ctx.beginPath(); ctx.ellipse(0, 0, 44, 34, 0, 0, Math.PI * 2); ctx.fill(); ctx.stroke();
    ctx.fillStyle = 'rgba(0,0,0,0.4)'; ctx.beginPath(); ctx.ellipse(6, 5, 36, 26, 0, 0, Math.PI * 2); ctx.fill();
    ctx.strokeStyle = 'rgba(0,0,0,0.5)';
    for (var k = 1; k < 4; k++) { ctx.beginPath(); ctx.ellipse(0, 0, 44 * k / 4, 34 * k / 4, 0, 0, Math.PI * 2); ctx.stroke(); }
    for (k = 0; k < 6; k++) { var an = k * Math.PI / 3; ctx.beginPath(); ctx.moveTo(0, 0); ctx.lineTo(Math.cos(an) * 44, Math.sin(an) * 34); ctx.stroke(); }
    ctx.restore();
    ctx.strokeStyle = '#6a655a'; ctx.lineWidth = 2;
    ctx.beginPath(); ctx.moveTo(392, 380); ctx.lineTo(420, 366); ctx.stroke(); ctx.lineWidth = 1;
    /* små lyspunkter */
    [[468, 404, '#c070ff'], [452, 352, '#ff4030'], [658, 291, '#ffd0c0'], [280, 436, '#a0d0ff'], [534, 440, '#ffb040']].forEach(function (l) {
      ctx.fillStyle = l[2]; ctx.fillRect(l[0], l[1], 2, 2);
      ctx.globalAlpha = 0.3; ctx.fillRect(l[0] - 1, l[1] - 1, 4, 4); ctx.globalAlpha = 1;
    });
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

  /* =====================================================================
     SVG-PLATER: fasekanter regnes ut per kant (lys mot opp/venstre, mørk
     mot høyre/ned), skitten tekstur via feTurbulence + multiply.
     ===================================================================== */
  function P(pts) { return pts.map(function (p) { return p[0] + ',' + p[1]; }).join(' '); }
  function bevel(pts, o) {
    var a = 0, n = pts.length, i, s = '', w = o.w || 2;
    for (i = 0; i < n; i++) { var p0 = pts[i], q0 = pts[(i + 1) % n]; a += p0[0] * q0[1] - q0[0] * p0[1]; }
    var sg = a > 0 ? 1 : -1;
    for (i = 0; i < n; i++) {
      var p = pts[i], q = pts[(i + 1) % n], dx = q[0] - p[0], dy = q[1] - p[1], L = Math.hypot(dx, dy);
      if (!L) continue;
      if (o.skipY != null && p[1] === o.skipY && q[1] === o.skipY) continue;
      var nx = sg * dy / L, ny = -sg * dx / L, ix = -nx * w / 2, iy = -ny * w / 2, col;
      if (ny < -0.6) col = o.hi;
      else if (ny < -0.2) col = nx < 0 ? o.hi : o.mid;
      else if (nx < -0.6) col = o.mid;
      else col = o.lo;
      s += '<line x1="' + (p[0] + ix).toFixed(1) + '" y1="' + (p[1] + iy).toFixed(1) + '" x2="' + (q[0] + ix).toFixed(1) + '" y2="' + (q[1] + iy).toFixed(1) +
        '" stroke="' + col + '" stroke-width="' + w + '"/>';
    }
    return s;
  }
  var uid = 0;
  function plate(pts, o) {
    o = o || {};
    var id = 'pl' + (++uid), s = '';
    if (o.shadow) s += '<polygon points="' + P(pts.map(function (p) { return [p[0] + o.shadow[0], p[1] + o.shadow[1]]; })) + '" fill="#000" opacity="0.6"/>';
    s += '<clipPath id="' + id + '"><polygon points="' + P(pts) + '"/></clipPath>';
    s += '<polygon points="' + P(pts) + '" fill="' + (o.fill || 'url(#tMetal)') + '"/>';
    s += '<g clip-path="url(#' + id + ')">';
    if (o.inner) s += o.inner;
    (o.seams || []).forEach(function (x) {
      s += '<rect x="' + (x - 1) + '" y="-60" width="2" height="800" fill="#0a0908" opacity="0.9"/><rect x="' + (x + 2) + '" y="-60" width="1" height="800" fill="#5a5854" opacity="0.5"/>';
    });
    (o.hseams || []).forEach(function (y) {
      s += '<rect x="0" y="' + (y - 1) + '" width="2000" height="3" fill="#0b0907" opacity="0.9"/><rect x="0" y="' + (y + 2) + '" width="2000" height="1" fill="#5a5854" opacity="0.45"/>';
    });
    if (o.grime !== false) s += '<rect x="0" y="0" width="2000" height="800" filter="url(#' + (o.grimeId || 'grime') + ')" style="mix-blend-mode:multiply"/>';
    s += '</g>';
    s += '<polygon points="' + P(pts) + '" fill="none" stroke="#000" stroke-width="1"/>';
    s += bevel(pts, { hi: o.hi || '#6a6660', mid: o.mid || '#4a4744', lo: o.lo || '#0c0c0c', w: o.w || 1, skipY: o.skipY });
    return s;
  }
  function recess(x, y, w, h) { /* innfelt brønn: mørk kant oppe/venstre, lys nede/høyre */
    return plate([[x, y], [x + w, y], [x + w, y + h], [x, y + h]], { fill: '#0c0c0b', hi: '#050505', mid: '#050505', lo: '#56534e', grime: false });
  }
  function bolt(x, y) { /* sekskantbolt (ikke perfekt rund) */
    var pts = [], k;
    for (k = 0; k < 6; k++) pts.push([x + 3 * Math.cos(k * Math.PI / 3 + 0.3), y + 3 * Math.sin(k * Math.PI / 3 + 0.3)]);
    return '<polygon points="' + P(pts.map(function (p) { return [p[0].toFixed(1), p[1].toFixed(1)]; })) + '" fill="#5e5a54" stroke="#0a0a0a" stroke-width="1"/>' +
      '<path d="M' + (x - 2) + ' ' + (y + 1) + ' L' + (x + 2) + ' ' + (y - 1) + '" stroke="#1a1816" stroke-width="1"/>';
  }
  function rivet(x, y) { /* 3 px nagle med lys topp og mørk skygge */
    return '<rect x="' + (x - 1) + '" y="' + (y - 1) + '" width="3" height="3" fill="#0c0c0c"/>' +
      '<rect x="' + (x - 2) + '" y="' + (y - 2) + '" width="3" height="3" fill="#6a6660"/><rect x="' + (x - 2) + '" y="' + (y - 2) + '" width="1" height="1" fill="#8a8680"/>';
  }
  function rivets4(x1, y1, x2, y2) { return rivet(x1, y1) + rivet(x2, y1) + rivet(x1, y2) + rivet(x2, y2); }
  function led(x, y, c) {
    return '<rect x="' + (x - 1) + '" y="' + (y - 1) + '" width="7" height="6" fill="#000"/><rect x="' + x + '" y="' + y + '" width="5" height="4" fill="' + c + '" filter="url(#ledGlow)"/>';
  }
  function hazard(x, y, w, h) {
    return plate([[x, y], [x + w, y], [x + w, y + h], [x, y + h]], { fill: 'url(#tHaz)', grimeId: 'grimeHeavy', hi: '#050505', mid: '#050505', lo: '#5a5650' });
  }

  /* målt i referansen: metall median ca. #262624–#2a2a28, høylys ca. #424042, nesten umettet,
     svak brun i skyggene. Støyen er liten (2–6 px) og lavkontrast – ingen store flekker. */
  var DEFS_COMMON =
    '<filter id="grime" x="0" y="0" width="1" height="1" color-interpolation-filters="sRGB">' +
      '<feTurbulence type="fractalNoise" baseFrequency="0.24" numOctaves="2" seed="4" result="a"/>' +
      '<feColorMatrix in="a" type="matrix" values="0 0 0 0 0.42  0 0 0 0 0.36  0 0 0 0 0.3  0.9 0 0 0 -0.28" result="fine"/>' +
      '<feTurbulence type="fractalNoise" baseFrequency="0.08 0.14" numOctaves="2" seed="21" result="b"/>' +
      '<feColorMatrix in="b" type="matrix" values="0 0 0 0 0.3  0 0 0 0 0.24  0 0 0 0 0.16  0.7 0 0 0 -0.26" result="mid"/>' +
      '<feMerge><feMergeNode in="mid"/><feMergeNode in="fine"/></feMerge></filter>' +
    '<filter id="grimeHeavy" x="0" y="0" width="1" height="1" color-interpolation-filters="sRGB">' +
      '<feTurbulence type="fractalNoise" baseFrequency="0.12 0.2" numOctaves="3" seed="13" result="a"/>' +
      '<feColorMatrix in="a" type="matrix" values="0 0 0 0 0.3  0 0 0 0 0.26  0 0 0 0 0.22  1.6 0 0 0 -0.45" result="blot"/>' +
      '<feTurbulence type="fractalNoise" baseFrequency="0.9" numOctaves="2" seed="3" result="g"/>' +
      '<feColorMatrix in="g" type="matrix" values="0 0 0 0 0.25  0 0 0 0 0.22  0 0 0 0 0.2  1.2 0 0 0 -0.4" result="grain"/>' +
      '<feMerge><feMergeNode in="blot"/><feMergeNode in="grain"/></feMerge></filter>' +
    '<filter id="ledGlow" x="-1" y="-1" width="3" height="3"><feGaussianBlur stdDeviation="1.2" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>' +
    '<linearGradient id="tMetal" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#3c3a3a"/><stop offset="0.1" stop-color="#2e2d2b"/><stop offset="0.55" stop-color="#282725"/><stop offset="1" stop-color="#1c1712"/></linearGradient>' +
    '<linearGradient id="tMetalHi" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#424042"/><stop offset="0.14" stop-color="#32312f"/><stop offset="0.6" stop-color="#2a2a28"/><stop offset="1" stop-color="#1e1912"/></linearGradient>' +
    '<linearGradient id="tMetalDark" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#2a2927"/><stop offset="1" stop-color="#121110"/></linearGradient>' +
    '<linearGradient id="aMetal" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#4a4038"/><stop offset="0.5" stop-color="#36302a"/><stop offset="1" stop-color="#2a2622"/></linearGradient>' +
    '<linearGradient id="aMetalV" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#2a2622"/><stop offset="0.3" stop-color="#4a4038"/><stop offset="1" stop-color="#241f1b"/></linearGradient>' +
    '<linearGradient id="tPipe" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#080808"/><stop offset="0.22" stop-color="#363533"/><stop offset="0.4" stop-color="#5a5854"/><stop offset="0.65" stop-color="#2a2927"/><stop offset="1" stop-color="#080808"/></linearGradient>' +
    '<linearGradient id="tPipeV" x1="0" y1="0" x2="1" y2="0"><stop offset="0" stop-color="#080808"/><stop offset="0.3" stop-color="#55524e"/><stop offset="0.6" stop-color="#2a2927"/><stop offset="1" stop-color="#080808"/></linearGradient>' +
    '<pattern id="tHaz" width="12" height="12" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><rect width="6" height="12" fill="#8a7a3e"/><rect x="6" width="6" height="12" fill="#161513"/></pattern>';
  var T_EDGE = { hi: '#6a6660', mid: '#4a4744', lo: '#0c0c0c', w: 1 };
  function tplate(pts, o) { o = o || {}; for (var k in T_EDGE) if (o[k] == null) o[k] = T_EDGE[k]; return plate(pts, o); }

  /* ---------- TERRAN ---------- */
  function terranConsole() {
    var s = '<defs>' + DEFS_COMMON + '</defs>';
    /* grunnkropp: tydelig senket midtdel */
    s += tplate([[0, 232], [0, 48], [100, 48], [112, 60], [332, 60], [356, 84], [776, 84], [796, 64], [1280, 64], [1280, 232]], { seams: [62, 470, 600, 700], hseams: [156], skipY: 232 });
    s += rivets4(8, 56, 92, 224) + rivets4(364, 92, 770, 224);
    /* horisontalt rør over midtskjermen */
    s += '<rect x="358" y="72" width="420" height="12" fill="url(#tPipe)" stroke="#000"/>';
    [380, 470, 566, 662, 752].forEach(function (x) { s += '<rect x="' + x + '" y="69" width="8" height="18" fill="url(#tPipeV)" stroke="#000"/>'; });
    /* rørstabel til venstre */
    [72, 100, 128].forEach(function (y) {
      s += '<rect x="0" y="' + y + '" width="112" height="20" fill="url(#tPipe)" stroke="#000"/>';
      [28, 74].forEach(function (rx) { s += '<rect x="' + rx + '" y="' + (y - 2) + '" width="7" height="24" fill="url(#tPipeV)" stroke="#000"/>'; });
    });
    s += tplate([[8, 162], [104, 162], [104, 222], [8, 222]], { fill: 'url(#tMetalDark)', seams: [56] });
    s += rivets4(13, 167, 99, 217);
    s += led(18, 200, '#30e030') + led(28, 200, '#ffb020') + led(38, 200, '#ff3a2a');
    /* høyre maskinblokk med vifte */
    s += tplate([[1160, 232], [1160, 36], [1176, 20], [1280, 20], [1280, 232]], { seams: [1240], skipY: 232 });
    s += rivets4(1168, 30, 1272, 224);
    s += '<circle cx="1220" cy="104" r="42" fill="#080808" stroke="#000" stroke-width="2"/><circle cx="1220" cy="104" r="38" fill="url(#tMetalDark)"/>';
    for (var k = 0; k < 12; k++) {
      var an = k * Math.PI / 6;
      s += '<path d="M1220 104 L' + (1220 + 36 * Math.cos(an)).toFixed(1) + ' ' + (104 + 36 * Math.sin(an)).toFixed(1) + ' L' + (1220 + 36 * Math.cos(an + 0.32)).toFixed(1) + ' ' + (104 + 36 * Math.sin(an + 0.32)).toFixed(1) + ' Z" fill="#0e0d0c"/>';
    }
    s += '<circle cx="1220" cy="104" r="8" fill="#3a3836" stroke="#000"/><circle cx="1220" cy="104" r="42" fill="none" stroke="#6a6660" stroke-width="1" stroke-dasharray="40 30" opacity="0.5"/>';
    s += hazard(1170, 168, 102, 18);
    s += led(1176, 204, '#30e030') + led(1188, 204, '#ffb020');
    /* minimap-hus: høy skulder, 16 px 45°-faser */
    s += tplate([[112, 232], [112, 18], [128, 2], [330, 2], [346, 18], [346, 232]], { fill: 'url(#tMetalHi)', shadow: [4, 3], skipY: 232 });
    s += recess(150, 10, 58, 26) + '<polyline points="154,30 164,30 168,16 176,26 182,14 188,28 194,20 204,30" fill="none" stroke="#e8c020" stroke-width="1.5" filter="url(#ledGlow)"/>';
    s += hazard(216, 12, 96, 20);
    s += recess(140, 42, 186, 188);
    s += rivets4(120, 24, 338, 224);
    /* kommandokort-hus: skrått inn mot midten */
    s += tplate([[920, 232], [920, 42], [956, 6], [1144, 6], [1160, 22], [1160, 232]], { fill: 'url(#tMetalHi)', shadow: [4, 3], skipY: 232 });
    s += hazard(1000, 12, 78, 12) + led(966, 14, '#ff3a2a') + led(976, 14, '#ff3a2a') + led(1112, 14, '#ffb020') + led(1124, 14, '#ff3a2a');
    s += recess(940, 28, 208, 202);
    s += rivets4(1152, 28, 1152, 224) + rivet(930, 224);
    /* portretthus: hevet, tykk fas, skygge, fareskiltfelt på hver side av MENU */
    s += tplate([[780, 232], [780, 58], [796, 42], [908, 42], [924, 58], [924, 232]], { fill: 'url(#tMetalHi)', shadow: [5, 4], skipY: 232, hseams: [216] });
    s += hazard(790, 50, 22, 24) + hazard(892, 50, 22, 24);
    s += recess(806, 84, 92, 124);
    s += rivets4(788, 66, 916, 224) + rivets4(788, 80, 916, 80);
    return s;
  }

  /* ---------- PROTOSS: organisk bue, blåsvart marmor, gullbånd, cyan rør ---------- */
  var P_TOP = 'M0,46 C40,46 70,42 96,32 C120,22 130,8 162,8 L298,8 C330,8 340,24 352,42 C362,60 374,70 402,70 C470,70 500,50 570,50 C640,50 670,70 738,70 C768,70 778,58 790,42 C800,28 812,24 832,24 L878,24 C898,24 906,30 912,36 C920,22 932,12 954,12 L1280,12';
  function protossConsole() {
    var body = P_TOP + ' L1280,232 L0,232 Z', s = '<defs>' +
      '<filter id="pMarble" x="0" y="0" width="1" height="1" color-interpolation-filters="sRGB">' +
        '<feTurbulence type="turbulence" baseFrequency="0.007 0.02" numOctaves="5" seed="12" result="t"/>' +
        '<feComponentTransfer in="t" result="tt"><feFuncR type="gamma" amplitude="1" exponent="0.4" offset="0"/></feComponentTransfer>' +
        '<feColorMatrix in="tt" type="matrix" values="-0.56 0 0 0 0.4  -0.6 0 0 0 0.48  -0.62 0 0 0 0.64  0 0 0 0 1"/>' +
        '<feComposite in2="SourceGraphic" operator="in"/></filter>' +
      '<filter id="pGlow" x="-0.05" y="-0.05" width="1.1" height="1.1"><feGaussianBlur stdDeviation="1" result="b"/><feMerge><feMergeNode in="b"/><feMergeNode in="SourceGraphic"/></feMerge></filter>' +
      '<linearGradient id="pShade" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#1a2840" stop-opacity="0.15"/><stop offset="1" stop-color="#000" stop-opacity="0.4"/></linearGradient>' +
      '</defs>';
    s += '<path d="' + body + '" fill="#0a1020"/>';
    s += '<path d="' + body + '" fill="#000" filter="url(#pMarble)"/>';
    s += '<path d="' + body + '" fill="url(#pShade)"/>';
    /* modulrammer: 5 px rør #2a8ad8, 1 px #9ef0ff inni, 1 px #003366 utenfor, glød maks 2 px */
    [[136, 40, 194, 192, 18], [350, 84, 432, 150, 24], [800, 80, 104, 132, 16], [922, 24, 218, 208, 20]].forEach(function (w) {
      var x = w[0], y = w[1], ww = w[2], h = w[3], r = w[4];
      s += '<rect x="' + x + '" y="' + y + '" width="' + ww + '" height="' + h + '" rx="' + r + '" fill="#000" opacity="0.45"/>';
      s += '<rect x="' + x + '" y="' + y + '" width="' + ww + '" height="' + h + '" rx="' + r + '" fill="none" stroke="#003366" stroke-width="7"/>';
      s += '<rect x="' + x + '" y="' + y + '" width="' + ww + '" height="' + h + '" rx="' + r + '" fill="none" stroke="#2a8ad8" stroke-width="5" filter="url(#pGlow)"/>';
      s += '<rect x="' + (x + 2) + '" y="' + (y + 2) + '" width="' + (ww - 4) + '" height="' + (h - 4) + '" rx="' + (r - 2) + '" fill="none" stroke="#9ef0ff" stroke-width="1"/>';
    });
    /* tykt gullbånd (ca. 10 px) langs hele toppkanten: lys→mørk gull, mørk underkant, plateskjøter */
    s += '<path d="' + P_TOP + '" transform="translate(0,1.5)" fill="none" stroke="#2a1c06" stroke-width="12" stroke-linejoin="round"/>';
    s += '<path d="' + P_TOP + '" fill="none" stroke="#c09020" stroke-width="10" stroke-linejoin="round" stroke-linecap="round"/>';
    s += '<path d="' + P_TOP + '" transform="translate(0,3)" fill="none" stroke="#6a4a10" stroke-width="4" stroke-linejoin="round"/>';
    s += '<path d="' + P_TOP + '" transform="translate(0,-2.5)" fill="none" stroke="#f8e080" stroke-width="4" stroke-linejoin="round"/>';
    s += '<path d="' + P_TOP + '" transform="translate(0,-3.5)" fill="none" stroke="#fff4c0" stroke-width="1" stroke-linejoin="round" opacity="0.8"/>';
    s += '<path d="' + P_TOP + '" fill="none" stroke="#3a2808" stroke-width="11" stroke-dasharray="2 70" stroke-dashoffset="-30"/>';
    /* hevet gullbue over midtskjermen */
    var arch = 'M470,84 C500,70 530,64 566,64 C602,64 636,70 664,84';
    s += '<path d="' + arch + '" fill="none" stroke="#2a1c06" stroke-width="9"/><path d="' + arch + '" fill="none" stroke="#c09020" stroke-width="7" stroke-linecap="round"/>' +
      '<path d="' + arch + '" transform="translate(0,-2)" fill="none" stroke="#f8e080" stroke-width="2.5"/>';
    return s;
  }

  /* ---------- ZERG: kjøtt, kitin og bein ---------- */
  var Z_TOP = 'M0,40 C30,30 60,46 96,30 C120,16 132,0 172,4 C222,8 262,-2 302,6 C336,12 344,34 358,54 C372,72 402,78 442,72 C502,64 522,78 572,72 C632,64 682,80 742,72 C772,68 782,48 798,38 C814,28 842,30 882,34 C902,36 906,22 920,12 C950,-2 1000,8 1050,4 C1110,0 1180,14 1280,8';
  function zergConsole() {
    var body = Z_TOP + ' L1280,232 L0,232 Z', s = '<defs>' +
      '<filter id="zFlesh" x="0" y="0" width="1" height="1" color-interpolation-filters="sRGB">' +
        '<feTurbulence type="fractalNoise" baseFrequency="0.018 0.03" numOctaves="5" seed="31" result="t"/>' +
        '<feColorMatrix in="t" type="matrix" values="0.85 0 0 0 -0.05  0.3 0 0 0 0  0.45 0 0 0 0  0 0 0 0 1"/>' +
        '<feComposite in2="SourceGraphic" operator="in"/></filter>' +
      '<linearGradient id="zShade" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#b06a44" stop-opacity="0.25"/><stop offset="1" stop-color="#100004" stop-opacity="0.6"/></linearGradient>' +
      '<linearGradient id="zBone" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#efe2bc"/><stop offset="1" stop-color="#8a7452"/></linearGradient>' +
      '<radialGradient id="zEye" cx="0.5" cy="0.5" r="0.5"><stop offset="0" stop-color="#ffd060"/><stop offset="0.5" stop-color="#e04010"/><stop offset="1" stop-color="#300408"/></radialGradient>' +
      '<clipPath id="zBody"><path d="' + body + '"/></clipPath>' +
      '</defs>';
    s += '<path d="' + body + '" fill="#2a0c10"/>';
    s += '<path d="' + body + '" fill="#000" filter="url(#zFlesh)"/>';
    s += '<path d="' + body + '" fill="url(#zShade)"/>';
    /* årer */
    s += '<g clip-path="url(#zBody)" fill="none" stroke="#5a1a4a" stroke-width="2" opacity="0.8">' +
      '<path d="M0,120 C60,110 80,150 130,140"/><path d="M340,200 C380,150 420,170 360,110"/><path d="M780,120 C760,160 790,190 770,232"/>' +
      '<path d="M1160,232 C1170,170 1200,150 1250,160"/><path d="M500,232 C520,220 560,236 600,226"/><path d="M60,232 C70,200 40,180 50,150"/></g>';
    /* ribbein i venstre felt */
    for (var i = 0; i < 4; i++) {
      var y = 74 + i * 36;
      s += '<path d="M6,' + y + ' C40,' + (y - 18) + ' 90,' + (y - 14) + ' 118,' + (y + 4) + '" fill="none" stroke="#1a0406" stroke-width="9" stroke-linecap="round"/>';
      s += '<path d="M6,' + y + ' C40,' + (y - 18) + ' 90,' + (y - 14) + ' 118,' + (y + 4) + '" fill="none" stroke="url(#zBone)" stroke-width="5" stroke-linecap="round"/>';
    }
    /* øye i høyre felt */
    s += '<ellipse cx="1220" cy="110" rx="40" ry="30" fill="#1a0406"/><ellipse cx="1220" cy="110" rx="34" ry="24" fill="url(#zEye)"/><ellipse cx="1220" cy="110" rx="5" ry="20" fill="#120204"/>';
    s += '<path d="M1176,110 C1190,74 1250,74 1264,110" fill="none" stroke="url(#zBone)" stroke-width="5"/><path d="M1176,110 C1190,146 1250,146 1264,110" fill="none" stroke="#5a2a20" stroke-width="5"/>';
    /* kitinrammer rundt feltene */
    [[136, 40, 194, 192, 22], [350, 86, 432, 148, 26], [800, 80, 104, 132, 20], [922, 24, 218, 208, 24]].forEach(function (w) {
      s += '<rect x="' + w[0] + '" y="' + w[1] + '" width="' + w[2] + '" height="' + w[3] + '" rx="' + w[4] + '" fill="#0c0204" stroke="#120204" stroke-width="10"/>';
      s += '<rect x="' + w[0] + '" y="' + w[1] + '" width="' + w[2] + '" height="' + w[3] + '" rx="' + w[4] + '" fill="none" stroke="#7a4a32" stroke-width="5"/>';
      s += '<rect x="' + (w[0] - 1) + '" y="' + (w[1] - 1) + '" width="' + w[2] + '" height="' + w[3] + '" rx="' + w[4] + '" fill="none" stroke="#c8a87a" stroke-width="1.5" stroke-dasharray="30 12 8 12" opacity="0.8"/>';
    });
    /* toppkant og beinpigger */
    s += '<path d="' + Z_TOP + '" fill="none" stroke="#120204" stroke-width="7" stroke-linejoin="round"/>';
    s += '<path d="' + Z_TOP + '" fill="none" stroke="#8a5a40" stroke-width="3" stroke-linejoin="round"/>';
    [[52, 38, -18], [172, 4, -24], [292, 6, -22], [404, 76, -18], [574, 72, -24], [744, 72, -18], [842, 30, -16], [962, 0, -22], [1110, 2, -20], [1238, 10, -20]].forEach(function (b) {
      var x = b[0], y = b[1], h = b[2];
      s += '<path d="M' + (x - 7) + ',' + (y + 4) + ' Q' + (x - 2) + ',' + (y + h / 2) + ' ' + (x + 4) + ',' + (y + h) + ' Q' + (x + 3) + ',' + (y + h / 2) + ' ' + (x + 7) + ',' + (y + 4) + ' Z" fill="url(#zBone)" stroke="#2a1008" stroke-width="1.2"/>';
    });
    return s;
  }

  SC.consoleSVG = function (race) {
    uid = 0;
    return race === 'protoss' ? protossConsole() : race === 'zerg' ? zergConsole() : terranConsole();
  };

  /* ---------- Glue screen: smal, mørk gråbrun metallarm som klemmer nyhetspanelet ---------- */
  SC.armSVG = function () {
    uid = 100;
    var A = { fill: 'url(#aMetal)', hi: '#6a6660', mid: '#4a4744', lo: '#0c0c0c', w: 1 };
    function ap(pts, extra) { var o = {}, k; for (k in A) o[k] = A[k]; for (k in extra || {}) o[k] = extra[k]; return plate(pts, o); }
    var s = '<defs>' + DEFS_COMMON + '</defs>';
    /* kabler bak */
    s += '<path d="M1180,64 C1222,110 1240,220 1228,470" fill="none" stroke="#080707" stroke-width="7"/><path d="M1180,64 C1222,110 1240,220 1228,470" fill="none" stroke="#2e2a26" stroke-width="2.5" stroke-dasharray="4 3"/>';
    s += '<path d="M1134,346 C1140,400 1170,430 1186,470" fill="none" stroke="#080707" stroke-width="5"/><path d="M1134,346 C1140,400 1170,430 1186,470" fill="none" stroke="#4a2418" stroke-width="2"/>';
    /* toppbjelke (ca. 40 px) */
    s += ap([[880, 20], [894, 6], [1280, 6], [1280, 44], [1150, 44], [1138, 54], [906, 54], [896, 62], [880, 62]], { seams: [1010, 1210], shadow: [3, 3] });
    s += hazard(950, 14, 46, 16);
    s += '<rect x="906" y="46" width="230" height="7" fill="url(#tPipe)" stroke="#000"/>';
    [930, 1000, 1080].forEach(function (x) { s += '<rect x="' + x + '" y="44" width="5" height="11" fill="url(#tPipeV)" stroke="#000"/>'; });
    s += rivets4(900, 14, 1270, 36);
    /* klo over panelets øvre venstre hjørne */
    s += ap([[762, 86], [776, 72], [892, 72], [900, 80], [888, 92], [786, 92], [786, 118], [774, 118], [762, 106]], { shadow: [3, 3] });
    s += ap([[868, 54], [900, 54], [900, 76], [868, 76]], { fill: 'url(#tMetalDark)' });
    s += bolt(774, 88) + bolt(774, 108) + rivet(880, 82) + rivet(800, 82);
    /* ledd oppe til høyre */
    s += ap([[1096, 28], [1170, 28], [1182, 40], [1182, 84], [1170, 96], [1096, 96], [1086, 86], [1086, 38]], { fill: 'url(#tMetalDark)', shadow: [3, 3] });
    s += recess(1104, 44, 44, 20) + led(1110, 52, '#2ad84a') + led(1122, 52, '#1a7a2a') + led(1134, 52, '#e8a020');
    s += bolt(1096, 88) + bolt(1172, 88);
    /* vertikal arm (ca. 40 px bred) langs panelets høyre side */
    s += '<rect x="1158" y="96" width="9" height="244" fill="url(#tPipeV)" stroke="#000"/>';
    [150, 230, 300].forEach(function (y) { s += '<rect x="1155" y="' + y + '" width="15" height="5" fill="url(#tPipe)" stroke="#000"/>'; });
    s += ap([[1114, 96], [1146, 96], [1154, 104], [1154, 330], [1146, 338], [1122, 338], [1114, 330]], { fill: 'url(#aMetalV)', hseams: [176, 262], shadow: [3, 3] });
    s += ap([[1122, 338], [1146, 338], [1142, 348], [1126, 348]], { fill: 'url(#tMetalDark)' });
    s += rivets4(1120, 110, 1148, 324);
    /* klemmer som griper panelrammen */
    [[146, 44], [270, 44]].forEach(function (c) {
      var y = c[0], h = c[1];
      s += ap([[1076, y], [1114, y], [1114, y + h], [1076, y + h], [1070, y + h - 6], [1070, y + 6]], { shadow: [3, 3] });
      s += '<rect x="1072" y="' + (y + 8) + '" width="5" height="' + (h - 16) + '" fill="#0a0908"/>';
      s += bolt(1094, y + 10) + bolt(1094, y + h - 10);
    });
    return s;
  };
})();

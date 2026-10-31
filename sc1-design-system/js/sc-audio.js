/* =========================================================================
   SC1-inspirert design system – sc-audio.js
   Syntetiserte grensesnittlyder med Web Audio (ingen lydfiler).
   API:  SCAudio.click() .hover() .error() .type() .open()
         SCAudio.setMuted(bool) .toggleMute() .isMuted() .context
   Auto-kobling (delegerte lyttere):
     - [data-sfx="click|hover|error|type|open|none"]
     - .sc-btn, .sc-menu-link, .sc-cmd  -> hover + click
     - .sc-input                        -> type ved tastetrykk
     - [data-sfx-toggle]                -> lyd av/på-knapp
   AudioContext opprettes først ved første brukerinteraksjon.
   ========================================================================= */
(function (global) {
  "use strict";

  var STORE_KEY = "sc-audio-muted";
  var ctx = null;
  var master = null;
  var noiseBuf = null;
  var unlocked = false;
  var muted = false;
  var listeners = [];

  try { muted = global.localStorage.getItem(STORE_KEY) === "1"; } catch (e) { muted = false; }

  function AC() { return global.AudioContext || global.webkitAudioContext || null; }

  function ensure() {
    if (ctx) {
      if (ctx.state === "suspended") { try { ctx.resume(); } catch (e) {} }
      return ctx;
    }
    if (!unlocked) return null;           // aldri før en brukergest
    var Ctor = AC();
    if (!Ctor) return null;
    try {
      ctx = new Ctor();
    } catch (e) { ctx = null; return null; }
    var comp = ctx.createDynamicsCompressor();
    comp.threshold.value = -14;
    comp.ratio.value = 6;
    master = ctx.createGain();
    master.gain.value = muted ? 0 : 0.55;
    master.connect(comp);
    comp.connect(ctx.destination);
    // 1 s hvit støy, gjenbrukes av alle lyder
    noiseBuf = ctx.createBuffer(1, ctx.sampleRate, ctx.sampleRate);
    var d = noiseBuf.getChannelData(0);
    for (var i = 0; i < d.length; i++) d[i] = Math.random() * 2 - 1;
    try { global.dispatchEvent(new CustomEvent("sc-audio:ready", { detail: { context: ctx } })); } catch (e) {}
    return ctx;
  }

  /* ---------- byggeklosser ---------- */
  function env(g, t, peak, attack, decay) {
    g.gain.cancelScheduledValues(t);
    g.gain.setValueAtTime(0.0001, t);
    g.gain.exponentialRampToValueAtTime(peak, t + attack);
    g.gain.exponentialRampToValueAtTime(0.0001, t + attack + decay);
  }
  function osc(type, f0, f1, t, dur, peak, dest) {
    var o = ctx.createOscillator(), g = ctx.createGain();
    o.type = type;
    o.frequency.setValueAtTime(f0, t);
    if (f1 && f1 !== f0) o.frequency.exponentialRampToValueAtTime(f1, t + dur);
    env(g, t, peak, 0.002, dur);
    o.connect(g); g.connect(dest || master);
    o.start(t); o.stop(t + dur + 0.03);
    return o;
  }
  function noise(t, dur, peak, filterType, freq, q, dest) {
    var s = ctx.createBufferSource(), f = ctx.createBiquadFilter(), g = ctx.createGain();
    s.buffer = noiseBuf;
    f.type = filterType; f.frequency.setValueAtTime(freq, t); f.Q.value = q || 1;
    env(g, t, peak, 0.001, dur);
    s.connect(f); f.connect(g); g.connect(dest || master);
    s.start(t, Math.random() * 0.5); s.stop(t + dur + 0.03);
    return f;
  }
  function ready() { return !muted && ensure(); }

  /* ---------- lyder ---------- */
  // Kort metallisk blipp: to ikke-harmoniske firkantbølger + båndpasset støy
  function click() {
    if (!ready()) return;
    var t = ctx.currentTime + 0.005;
    var bp = ctx.createBiquadFilter();
    bp.type = "bandpass"; bp.frequency.value = 2400; bp.Q.value = 4;
    bp.connect(master);
    osc("square", 1760, 1180, t, 0.05, 0.16, bp);
    osc("square", 2637, 2093, t, 0.04, 0.09, bp);
    osc("triangle", 880, 660, t, 0.07, 0.12);
    noise(t, 0.025, 0.12, "highpass", 3500, 0.7);
  }
  // Svært kort, lav tikk
  function hover() {
    if (!ready()) return;
    var t = ctx.currentTime + 0.002;
    osc("sine", 340, 200, t, 0.018, 0.06);
    noise(t, 0.008, 0.035, "lowpass", 900, 0.8);
  }
  // Lav buzz med tremolo
  function error() {
    if (!ready()) return;
    var t = ctx.currentTime + 0.005;
    var lp = ctx.createBiquadFilter(); lp.type = "lowpass"; lp.frequency.value = 520; lp.Q.value = 2;
    var g = ctx.createGain(); g.gain.value = 1;
    var trem = ctx.createOscillator(), tremAmt = ctx.createGain();
    trem.frequency.value = 28; tremAmt.gain.value = 0.45;
    trem.connect(tremAmt); tremAmt.connect(g.gain);
    lp.connect(g); g.connect(master);
    osc("sawtooth", 72, 66, t, 0.32, 0.22, lp);
    osc("square", 74.5, 68, t, 0.32, 0.12, lp);
    trem.start(t); trem.stop(t + 0.4);
  }
  // Terminal-tikk (tilfeldig variasjon så rader med tegn ikke låter maskinelt like)
  function type() {
    if (!ready()) return;
    var t = ctx.currentTime + 0.001;
    var v = 0.85 + Math.random() * 0.3;
    noise(t, 0.012, 0.09, "bandpass", 4200 * v, 3);
    osc("square", 1150 * v, 900 * v, t, 0.012, 0.035);
  }
  // Dialog åpner: kort resonant sveip opp
  function open() {
    if (!ready()) return;
    var t = ctx.currentTime + 0.005;
    var bp = ctx.createBiquadFilter();
    bp.type = "bandpass"; bp.Q.value = 9;
    bp.frequency.setValueAtTime(300, t);
    bp.frequency.exponentialRampToValueAtTime(3200, t + 0.2);
    bp.connect(master);
    osc("sawtooth", 180, 720, t, 0.22, 0.2, bp);
    var nf = noise(t, 0.2, 0.18, "bandpass", 500, 6);
    nf.frequency.exponentialRampToValueAtTime(5000, t + 0.2);
    osc("sine", 1320, 1980, t + 0.17, 0.06, 0.05);
  }

  /* ---------- mute ---------- */
  function setMuted(m) {
    muted = !!m;
    try { global.localStorage.setItem(STORE_KEY, muted ? "1" : "0"); } catch (e) {}
    if (master && ctx) master.gain.setTargetAtTime(muted ? 0 : 0.55, ctx.currentTime, 0.01);
    syncToggles();
    for (var i = 0; i < listeners.length; i++) { try { listeners[i](muted); } catch (e) {} }
  }
  function syncToggles() {
    if (!global.document) return;
    var els = document.querySelectorAll("[data-sfx-toggle]");
    for (var i = 0; i < els.length; i++) {
      var el = els[i];
      el.setAttribute("aria-pressed", muted ? "false" : "true");
      var on = el.getAttribute("data-label-on") || "Sound: On";
      var off = el.getAttribute("data-label-off") || "Sound: Off";
      var lbl = el.querySelector("[data-sfx-label]") || el;
      lbl.textContent = muted ? off : on;
    }
  }

  var api = {
    click: click, hover: hover, error: error, type: type, open: open,
    setMuted: setMuted,
    toggleMute: function () { setMuted(!muted); return muted; },
    isMuted: function () { return muted; },
    onMuteChange: function (fn) { if (typeof fn === "function") listeners.push(fn); },
    get context() { return ctx; }
  };
  global.SCAudio = api;

  /* ---------- auto-kobling ---------- */
  if (!global.document) return;
  var AUTO = ".sc-btn, .sc-menu-link, .sc-cmd";
  var SOUNDS = { click: click, hover: hover, error: error, type: type, open: open };

  function unlock() {
    if (unlocked) return;
    unlocked = true;
    ensure();
  }
  ["pointerdown", "keydown", "touchstart"].forEach(function (ev) {
    document.addEventListener(ev, unlock, { capture: true, passive: true });
  });

  function target(el) {
    if (!el || !el.closest) return null;
    return el.closest("[data-sfx], " + AUTO);
  }
  function disabled(el) {
    return el.disabled || el.getAttribute("aria-disabled") === "true" || el.classList.contains("sc-cmd--empty");
  }

  var lastHover = null;
  document.addEventListener("pointerover", function (e) {
    var el = target(e.target);
    if (el === lastHover) return;
    lastHover = el;
    if (!el || disabled(el)) return;
    var s = el.getAttribute("data-sfx");
    if (s === "none") return;
    if (!s || s === "hover" || el.hasAttribute("data-sfx-hover")) hover();
  }, true);

  document.addEventListener("click", function (e) {
    var tog = e.target.closest && e.target.closest("[data-sfx-toggle]");
    if (tog) {
      unlock();
      api.toggleMute();
      if (!muted) click();
      return;
    }
    var el = target(e.target);
    if (!el) return;
    var s = el.getAttribute("data-sfx");
    if (s === "none" || s === "hover" || s === "type") return;
    if (disabled(el)) { error(); return; }
    (SOUNDS[s] || click)();
  }, true);

  document.addEventListener("keydown", function (e) {
    var el = e.target;
    if (!el || !el.matches) return;
    if (el.matches(".sc-input, [data-sfx='type']") && (e.key.length === 1 || e.key === "Backspace" || e.key === "Enter")) type();
  }, true);

  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", syncToggles);
  else syncToggles();
})(window);

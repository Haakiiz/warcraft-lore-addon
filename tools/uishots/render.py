"""render.py: turn a MOCK.dump() JSON into a PNG.

usage: python render.py dump.json out.png [--crop Frame1,Frame2] [--margin 24] [--addon DIR] [--bg r,g,b]

Layout (anchors -> rectangles) is resolved by the mock itself (wowmock.lua, MOCK.dump writes "rect" in WoW
coordinates, origin bottom-left, y up); this script only draws.
"""
import json, math, os, re, sys
import numpy as np
from PIL import Image, ImageDraw, ImageFont

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from fonts import get_font, kind_of, advance

ADDON = r"C:\Users\Håkon\PycharmProjects\WoW-WC-Addon\WarcraftLore"
STRATA = ["BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", "FULLSCREEN", "FULLSCREEN_DIALOG", "TOOLTIP"]
LAYER = ["BACKGROUND", "BORDER", "ARTWORK", "OVERLAY", "HIGHLIGHT"]
REGIONS = ("Texture", "FontString", "MaskTexture")
SCREEN_W, SCREEN_H = 1920, 1080


def rnd(x):
    return int(math.floor(x + 0.5))


# ------------------------------------------------------------------ textures
_img_cache = {}


def placeholder(label="?", portrait=False):
    S = 64
    im = Image.new("RGBA", (S, S), (28, 30, 44, 255))
    d = ImageDraw.Draw(im)
    if portrait:
        d.ellipse((20, 8, 44, 34), fill=(96, 104, 128, 255))
        d.ellipse((6, 38, 58, 90), fill=(78, 86, 110, 255))
    else:
        d.rectangle((0, 0, S - 1, S - 1), outline=(70, 72, 92, 255))
        f = ImageFont.truetype(r"C:\Windows\Fonts\georgiab.ttf", 46)
        d.text((S / 2, S / 2 + 2), label, font=f, fill=(232, 190, 60, 255), anchor="mm")
    return im


def load_texture(path):
    """Returns a PIL RGBA image or None."""
    if path in _img_cache:
        return _img_cache[path]
    im = None
    norm = path.replace("/", "\\")
    low = norm.lower()
    if path == "@unit-portrait":
        im = placeholder(portrait=True)
    elif low.startswith("interface\\addons\\warcraftlore\\"):
        rel = norm.split("\\", 3)[3]
        for ext in ("", ".tga", ".png"):
            p = os.path.join(ADDON, rel + ext)
            if os.path.isfile(p):
                im = Image.open(p).convert("RGBA")
                break
        if im is None and "portraits" in low:
            im = placeholder(portrait=True)
    elif low.startswith("interface\\"):
        im = placeholder("?")
    _img_cache[path] = im
    return im


def sample(img, w, h, tc, wrap):
    """Bilinear sample of PIL image into (h, w, 4) premultiplied float array. tc = (left, right, top, bottom)."""
    arr = np.asarray(img, dtype=np.float32) / 255.0
    arr = np.concatenate([arr[..., :3] * arr[..., 3:4], arr[..., 3:4]], axis=2)
    H, W = arr.shape[:2]
    l, r, t, b = tc
    u = l + (np.arange(w) + 0.5) / w * (r - l)
    v = t + (np.arange(h) + 0.5) / h * (b - t)
    px = u * W - 0.5
    py = v * H - 0.5
    x0 = np.floor(px).astype(int)
    y0 = np.floor(py).astype(int)
    fx = (px - x0)[None, :, None]
    fy = (py - y0)[:, None, None]

    def idx(i, n):
        return (i % n) if wrap else np.clip(i, 0, n - 1)

    xa, xb = idx(x0, W), idx(x0 + 1, W)
    ya, yb = idx(y0, H), idx(y0 + 1, H)
    p00 = arr[ya][:, xa]
    p01 = arr[ya][:, xb]
    p10 = arr[yb][:, xa]
    p11 = arr[yb][:, xb]
    return (p00 * (1 - fx) + p01 * fx) * (1 - fy) + (p10 * (1 - fx) + p11 * fx) * fy


def to_image(prem):
    a = prem[..., 3:4]
    rgb = np.where(a > 1e-6, prem[..., :3] / np.maximum(a, 1e-6), 0)
    out = np.concatenate([rgb, a], axis=2)
    return Image.fromarray((np.clip(out, 0, 1) * 255 + 0.5).astype(np.uint8), "RGBA")


# ------------------------------------------------------------------ compositing helpers
def composite(canvas, layer, ox, oy, clip):
    """alpha_composite `layer` at (ox, oy), restricted to clip = (x0, y0, x1, y1) in canvas pixels."""
    x0, y0, x1, y1 = ox, oy, ox + layer.width, oy + layer.height
    if clip:
        x0, y0, x1, y1 = max(x0, clip[0]), max(y0, clip[1]), min(x1, clip[2]), min(y1, clip[3])
    x0, y0 = max(x0, 0), max(y0, 0)
    x1, y1 = min(x1, canvas.width), min(y1, canvas.height)
    if x1 <= x0 or y1 <= y0:
        return
    sub = layer.crop((x0 - ox, y0 - oy, x1 - ox, y1 - oy))
    canvas.alpha_composite(sub, (x0, y0))


# ------------------------------------------------------------------ the renderer
class Scene:
    def __init__(self, data):
        self.objs = {o["id"]: o for o in data["objects"]}
        self.order = data["objects"]
        self.children = {}
        for o in self.order:
            self.children.setdefault(o.get("parent"), []).append(o)

    def px_rect(self, o):
        r = o.get("rect")
        if not r:
            return None
        l, b, rr, t = r
        return (rnd(l), rnd(SCREEN_H - t), rnd(rr), rnd(SCREEN_H - b))

    def chain_alpha(self, o):
        a = 1.0
        while o is not None:
            a *= o.get("alpha", 1)
            o = self.objs.get(o.get("parent"))
        return a

    def clip_of(self, o):
        clip = None
        p = self.objs.get(o.get("parent"))
        while p is not None:
            if p["kind"] == "ScrollFrame":
                pr = self.px_rect(p)
                if pr:
                    clip = pr if clip is None else (max(clip[0], pr[0]), max(clip[1], pr[1]), min(clip[2], pr[2]), min(clip[3], pr[3]))
            p = self.objs.get(p.get("parent"))
        return clip

    # --- texture
    def draw_texture(self, canvas, o):
        pr = self.px_rect(o)
        if not pr:
            return
        x0, y0, x1, y1 = pr
        w, h = x1 - x0, y1 - y0
        if w <= 0 or h <= 0:
            return
        alpha = self.chain_alpha(o)
        vc = o.get("vc") or [1, 1, 1, 1]
        if o.get("color"):
            c = o["color"]
            rgb = np.array([c[0] * vc[0], c[1] * vc[1], c[2] * vc[2]])
            a = c[3] * vc[3]
            prem = np.zeros((h, w, 4), np.float32)
            prem[..., :3] = rgb * a
            prem[..., 3] = a
        elif o.get("tex"):
            img = load_texture(o["tex"])
            if img is None:
                return
            tc = o.get("tc") or [0, 1, 0, 1]
            wrap = o.get("wrapH") == "REPEAT" or o.get("wrapV") == "REPEAT"
            prem = sample(img, w, h, tc, wrap)
            prem = prem * np.array([vc[0], vc[1], vc[2], 1], np.float32)  # tint rgb (premult stays consistent)
            prem = prem * vc[3]
        else:
            return
        for mid in o.get("masks") or []:
            m = self.objs.get(mid)
            mimg = load_texture(m["tex"]) if m and m.get("tex") else None
            if mimg is not None:
                ms = sample(mimg, w, h, m.get("tc") or [0, 1, 0, 1], False)
                a = ms[..., 3]
                if a.min() > 0.99:  # opaque mask: use luminance
                    a = ms[..., :3].mean(axis=2)
                prem = prem * a[..., None]
        prem = prem * alpha
        if o.get("blend") == "ADD":
            cx0, cy0 = max(x0, 0), max(y0, 0)
            cx1, cy1 = min(x1, canvas.width), min(y1, canvas.height)
            if cx1 > cx0 and cy1 > cy0:
                region = np.asarray(canvas.crop((cx0, cy0, cx1, cy1)), np.float32) / 255.0
                add = prem[cy0 - y0:cy1 - y0, cx0 - x0:cx1 - x0, :3]
                region[..., :3] = np.clip(region[..., :3] + add, 0, 1)
                canvas.paste(Image.fromarray((region * 255 + 0.5).astype(np.uint8), "RGBA"), (cx0, cy0))
            return
        composite(canvas, to_image(prem), x0, y0, self.clip_of(o))

    # --- text
    def parse(self, text, default):
        out, color, i, n = [], None, 0, len(text)
        while i < n:
            ch = text[i]
            if ch == "|" and i + 1 < n:
                nx = text[i + 1]
                if nx == "|":
                    out.append(("|", color)); i += 2; continue
                if nx == "c" and re.fullmatch(r"[0-9a-fA-F]{8}", text[i + 2:i + 10] or ""):
                    h = text[i + 2:i + 10]
                    color = (int(h[2:4], 16) / 255, int(h[4:6], 16) / 255, int(h[6:8], 16) / 255)
                    i += 10; continue
                if nx == "r":
                    color = None; i += 2; continue
                if nx == "n":
                    out.append(("\n", color)); i += 2; continue
                if nx == "T":
                    j = text.find("|t", i)
                    i = (j + 2) if j >= 0 else n
                    continue
            out.append((ch, color))
            i += 1
        return out

    def draw_text(self, canvas, o):
        pr = self.px_rect(o)
        if not pr or not o.get("text"):
            return
        x0, y0, x1, y1 = pr
        bw, bh = x1 - x0, y1 - y0
        size = int(o["fsize"])
        kind = kind_of(o.get("font"))
        font = get_font(kind, size)
        lh, spacing = o["lh"], o.get("spacing", 0)
        chars = self.parse(o["text"], None)
        base = o.get("tcolor") or [1, 1, 1, 1]
        alpha = self.chain_alpha(o) * base[3]
        lines = o.get("lines") or []
        n = len(lines)
        if not n:
            return
        total = n * lh + (n - 1) * spacing
        jv = "MIDDLE" if o["kind"] == "EditBox" else o.get("jv", "MIDDLE")
        jh = "LEFT" if o["kind"] == "EditBox" else o.get("jh", "CENTER")
        pad = 4
        W, H = max(bw, 1) + 2 * pad + 40, max(bh, total) + 2 * pad + 40
        if jv == "TOP":
            ytop = 0
        elif jv == "BOTTOM":
            ytop = bh - total
        else:
            ytop = (bh - total) / 2
        asc, desc = font.getmetrics()
        masks = {}
        stroke_mask = Image.new("L", (W, H), 0)
        sdraw = ImageDraw.Draw(stroke_mask)
        outline = "OUTLINE" in (o.get("fflags") or "").upper()
        for li, (s, e, ell, lw) in enumerate(lines):
            seg = chars[s - 1:e - 1]
            if ell:
                seg = seg + [(".", seg[-1][1] if seg else None)] * 3
            if jh == "LEFT":
                x = 0.0
            elif jh == "RIGHT":
                x = bw - lw
            else:
                x = (bw - lw) / 2
            ytop_line = ytop + li * (lh + spacing)
            baseline = ytop_line + (lh - (asc + desc)) / 2 + asc
            for ch, col in seg:
                key = col if col is not None else tuple(base[:3])
                m = masks.get(key)
                if m is None:
                    m = Image.new("L", (W, H), 0)
                    masks[key] = m
                if ch != " ":
                    ImageDraw.Draw(m).text((x + pad, baseline + pad), ch, font=font, fill=255, anchor="ls")
                    if outline:
                        sdraw.text((x + pad, baseline + pad), ch, font=font, fill=255, anchor="ls", stroke_width=1)
                x += advance(kind, size, ord(ch))
        layer = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        if outline:
            blk = Image.new("RGBA", (W, H), (0, 0, 0, 255))
            blk.putalpha(stroke_mask)
            layer = Image.alpha_composite(layer, blk)
        for key, m in masks.items():
            sol = Image.new("RGBA", (W, H), tuple(int(c * 255 + 0.5) for c in key) + (255,))
            sol.putalpha(m)
            layer = Image.alpha_composite(layer, sol)
        if alpha < 0.999:
            a = layer.getchannel("A").point(lambda v: int(v * alpha))
            layer.putalpha(a)
        composite(canvas, layer, x0 - pad, y0 - pad, self.clip_of(o))

    # --- scene
    def render(self, bg=(58, 64, 52)):
        yy = np.linspace(0, 1, SCREEN_H)[:, None, None]
        base = np.array(bg, np.float32)[None, None, :]
        arr = np.broadcast_to(base * (1.15 - 0.3 * yy), (SCREEN_H, SCREEN_W, 3))
        canvas = Image.fromarray(np.clip(arr, 0, 255).astype(np.uint8), "RGB").convert("RGBA")
        frames = [o for o in self.order if o["kind"] not in REGIONS and o["shown"]]
        frames.sort(key=lambda o: (STRATA.index(o.get("strata", "MEDIUM")), o.get("level", 0), o["id"]))
        for f in frames:
            regs = [c for c in self.children.get(f["id"], []) if c["kind"] in REGIONS and c["shown"]]
            regs.sort(key=lambda c: (LAYER.index(c.get("layer", "ARTWORK")) if c.get("layer") in LAYER else 2, c.get("sub", 0), c["id"]))
            for c in regs:
                if c["kind"] == "Texture":
                    self.draw_texture(canvas, c)
                elif c["kind"] == "FontString":
                    self.draw_text(canvas, c)
            if f["kind"] == "EditBox":
                self.draw_text(canvas, f)
        return canvas

    def frame_box(self, names):
        box = None
        for n in names:
            for o in self.order:
                if o.get("name") == n and o.get("rect") and o["shown"]:
                    r = self.px_rect(o)
                    box = r if box is None else (min(box[0], r[0]), min(box[1], r[1]), max(box[2], r[2]), max(box[3], r[3]))
        return box


def main():
    global ADDON
    args = sys.argv[1:]
    opts = {"--crop": None, "--margin": "24", "--addon": None, "--bg": None}
    pos = []
    i = 0
    while i < len(args):
        if args[i] in opts:
            opts[args[i]] = args[i + 1]; i += 2
        else:
            pos.append(args[i]); i += 1
    src, out = pos
    if opts["--addon"]:
        ADDON = opts["--addon"]
    data = json.load(open(src, encoding="utf-8"))
    scene = Scene(data)
    bg = tuple(int(x) for x in opts["--bg"].split(",")) if opts["--bg"] else (58, 64, 52)
    canvas = scene.render(bg)
    if opts["--crop"] and opts["--crop"].startswith("box:"):
        x0, y0, x1, y1 = (int(v) for v in opts["--crop"][4:].split(","))
        canvas = canvas.crop((x0, y0, x1, y1))
    elif opts["--crop"]:
        box = scene.frame_box(opts["--crop"].split(","))
        if box:
            m = int(opts["--margin"])
            box = (max(0, box[0] - m), max(0, box[1] - m), min(SCREEN_W, box[2] + m), min(SCREEN_H, box[3] + m))
            canvas = canvas.crop(box)
    canvas = canvas.convert("RGB")
    canvas.save(out)
    base, ext = os.path.splitext(out)
    canvas.resize((canvas.width * 2, canvas.height * 2), Image.NEAREST).save(base + "@2x" + ext)
    print("wrote", out, canvas.size)


if __name__ == "__main__":
    main()

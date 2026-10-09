"""Generates the addon's frame textures (TGA, power-of-two sizes) into WarcraftLore/Textures.

Run:  python tools/make_textures.py

Everything is drawn at 4x and scaled down for smooth edges. Colors follow the
"violet & turquoise vines" frame mockup. The ring textures are white so the addon
can tint them per game with SetVertexColor.
"""
import math
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

OUT = Path(__file__).resolve().parent.parent / "WarcraftLore" / "Textures"
SS = 4  # supersampling

VIOLET = (139, 108, 214, 255)
LEAF = (63, 184, 168, 255)
LEAF_EDGE = (28, 90, 82, 255)
TEAL_DARK = (42, 111, 104, 255)
CORE = (18, 15, 28, 255)


def canvas(w, h):
    return Image.new("RGBA", (w * SS, h * SS), (0, 0, 0, 0))


def save(img, name, w, h):
    OUT.mkdir(parents=True, exist_ok=True)
    img.resize((w, h), Image.LANCZOS).save(OUT / name, format="TGA")
    print("wrote", OUT / name)


def leaf_polygon(cx, cy, length, width, angle):
    """A pointed leaf (two arcs) starting at (cx, cy), pointing along angle (radians)."""
    pts_top, pts_bot = [], []
    for i in range(21):
        t = i / 20
        x = t * length
        y = math.sin(math.pi * t) * width / 2
        pts_top.append((x, -y))
        pts_bot.append((x, y))
    pts = pts_top + pts_bot[::-1]
    ca, sa = math.cos(angle), math.sin(angle)
    return [(cx + x * ca - y * sa, cy + x * sa + y * ca) for x, y in pts]


def draw_leaf(d, cx, cy, length, width, angle):
    d.polygon(leaf_polygon(cx, cy, length, width, angle), fill=LEAF, outline=LEAF_EDGE, width=SS)
    # center vein
    ex, ey = cx + math.cos(angle) * length * 0.9, cy + math.sin(angle) * length * 0.9
    d.line([(cx, cy), (ex, ey)], fill=LEAF_EDGE, width=SS)


def vine_h():
    """128x32 tile: one full sine period of violet vine with two leaves. Tiles seamlessly."""
    w, h = 128, 32
    img = canvas(w, h)
    d = ImageDraw.Draw(img)
    W, H = w * SS, h * SS
    amp, mid = H * 0.16, H / 2
    pts = [(x, mid + amp * math.sin(2 * math.pi * x / W)) for x in range(-SS, W + SS + 1, 2)]
    d.line(pts, fill=VIOLET, width=int(2.4 * SS), joint="curve")
    # leaves at the crest and trough, pointing away from the vine (kept inside the 32 px tile)
    L, Wd = 11 * SS, 6 * SS
    draw_leaf(d, W * 0.25, mid + amp, L, Wd, math.radians(60))
    draw_leaf(d, W * 0.75, mid - amp, L, Wd, math.radians(-60))
    return img, w, h


def vine_v():
    """32x128 tile: the horizontal vine turned 90 degrees, for the left and right edges."""
    img, w, h = vine_h()
    return img.rotate(90, expand=True), h, w


def corner():
    """64x64 rosette: violet disc with a dark core and two leaves."""
    w = h = 64
    img = canvas(w, h)
    d = ImageDraw.Draw(img)
    c = w * SS / 2
    L, Wd = 26 * SS, 13 * SS
    draw_leaf(d, c, c, L, Wd, math.radians(8))
    draw_leaf(d, c, c, L, Wd, math.radians(82))
    r = 12 * SS
    d.ellipse([c - r, c - r, c + r, c + r], fill=VIOLET, outline=TEAL_DARK, width=2 * SS)
    r2 = 5 * SS
    d.ellipse([c - r2, c - r2, c + r2, c + r2], fill=CORE)
    return img, w, h


def ring_glow():
    """128x128 white ring with a soft halo. Tinted per game in the addon."""
    w = h = 128
    img = Image.new("RGBA", (w * SS, h * SS), (255, 255, 255, 0))
    c = w * SS / 2
    halo = Image.new("L", img.size, 0)
    hd = ImageDraw.Draw(halo)
    r, t = 50 * SS, 12 * SS
    hd.ellipse([c - r - t / 2, c - r - t / 2, c + r + t / 2, c + r + t / 2], outline=235, width=int(t))
    halo = halo.filter(ImageFilter.GaussianBlur(6 * SS))
    core = Image.new("L", img.size, 0)
    cd = ImageDraw.Draw(core)
    t2 = 5 * SS
    cd.ellipse([c - r - t2 / 2, c - r - t2 / 2, c + r + t2 / 2, c + r + t2 / 2], outline=255, width=int(t2))
    alpha = Image.composite(core, halo, core)
    img.putalpha(alpha)
    return img, w, h


def ring_thin():
    """128x128 crisp white ring, used as the portrait's inner border."""
    w = h = 128
    img = Image.new("RGBA", (w * SS, h * SS), (255, 255, 255, 0))
    a = Image.new("L", img.size, 0)
    d = ImageDraw.Draw(a)
    m, t = 4 * SS, 7 * SS
    d.ellipse([m, m, w * SS - m, h * SS - m], outline=255, width=t)
    img.putalpha(a)
    return img, w, h


def circle_mask():
    """128x128 circular alpha mask for the portrait."""
    w = h = 128
    img = Image.new("RGBA", (w * SS, h * SS), (255, 255, 255, 0))
    a = Image.new("L", img.size, 0)
    m = 6 * SS
    ImageDraw.Draw(a).ellipse([m, m, w * SS - m, h * SS - m], fill=255)
    img.putalpha(a)
    return img, w, h


def pill_glow():
    """256x64 soft glow for the nearby-alert pill. White, tinted in the addon, drawn with ADD blend.

    Shown stretched to 268x80, i.e. 16 px around a 236x48 pill. The alpha falls off smoothly
    over those 16 px and is zero at the texture border.
    """
    import numpy as np
    w, h = 256, 64
    pad = 16
    sx, sy = (236 + 2 * pad) / w, (48 + 2 * pad) / h       # texture px -> screen px
    xs = (np.arange(w) + 0.5) * sx
    ys = (np.arange(h) + 0.5) * sy
    X, Y = np.meshgrid(xs, ys)
    dx = np.maximum(np.maximum(pad - X, X - (236 + pad)), 0)
    dy = np.maximum(np.maximum(pad - Y, Y - (48 + pad)), 0)
    dist = np.hypot(dx, dy)                                # screen px outside the pill rectangle
    t = np.clip(1 - dist / pad, 0, 1)
    alpha = 0.85 * t ** 2.4
    a8 = (np.clip(alpha, 0, 1) * 255 + 0.5).astype(np.uint8)
    rgba = np.zeros((h, w, 4), np.uint8)
    rgba[..., :3] = 255
    rgba[..., 3] = a8
    return Image.fromarray(rgba), w, h


def shadow_v():
    """4x32 black strip, opaque at the top and clear at the bottom (a popup's drop shadow, top/bottom)."""
    img = Image.new("RGBA", (4, 32))
    for y in range(32):
        a = int(255 * (1 - y / 31) ** 1.8)
        for x in range(4):
            img.putpixel((x, y), (0, 0, 0, a))
    return img


def shadow_h():
    """32x4 black strip, opaque at the left and clear at the right (drop shadow, sides)."""
    return shadow_v().rotate(90, expand=True)

def _glyph(draw_fn, size=16):
    img = Image.new("RGBA", (size * SS, size * SS), (255, 255, 255, 0))
    a = Image.new("L", img.size, 0)
    draw_fn(ImageDraw.Draw(a))
    img.putalpha(a)
    return img, size, size


def chevron_down():
    """16x16 white "v", drawn to be shown at 10x10 (a 7 x 3.5 glyph), tinted in the addon."""
    def draw(d):
        k = 16 / 10 * SS                   # display px -> texture px (supersampled)
        c = 8 * SS
        d.line([(c - 3.5 * k * 0.625, c - 1.75 * k * 0.625), (c, c + 1.75 * k * 0.625), (c + 3.5 * k * 0.625, c - 1.75 * k * 0.625)],
               fill=255, width=int(1.2 * k), joint="curve")
    return _glyph(draw)


def chevron_right():
    """16x16 white ">", drawn to be shown at 10x10 (a 4.5 x 8 glyph)."""
    def draw(d):
        k = 16 / 10 * SS
        c = 8 * SS
        d.line([(c - 2.0 * k, c - 4.0 * k), (c + 2.0 * k - 0.4 * k, c), (c - 2.0 * k, c + 4.0 * k)],
               fill=255, width=int(1.3 * k), joint="curve")
    return _glyph(draw)


def magnifier():
    """16x16 white magnifier, drawn to be shown at 12x12."""
    def draw(d):
        k = SS / 0.75                      # display px (12 px box) -> supersampled texture px
        cx, cy, r = 5 * k, 5 * k, 3.6 * k
        d.ellipse([cx - r, cy - r, cx + r, cy + r], outline=255, width=int(1.4 * k))
        d.line([(7.7 * k, 7.7 * k), (11 * k, 11 * k)], fill=255, width=int(1.4 * k))
    return _glyph(draw)


def fade_down():
    """4x32 strip in the panel color, transparent at the top and opaque at the bottom (list fade)."""
    w, h = 4, 32
    img = Image.new("RGBA", (w, h))
    for y in range(h):
        a = int(255 * (y / (h - 1)) ** 1.2)
        for x in range(w):
            img.putpixel((x, y), (16, 13, 24, a))
    return img, w, h


def save_exact(img, name):
    OUT.mkdir(parents=True, exist_ok=True)
    img.save(OUT / name, format="TGA")
    print("wrote", OUT / name)

if __name__ == "__main__":
    for name, fn in [("VineH.tga", vine_h), ("VineV.tga", vine_v), ("Corner.tga", corner), ("RingGlow.tga", ring_glow),
                     ("RingThin.tga", ring_thin), ("CircleMask.tga", circle_mask), ("PillGlow.tga", pill_glow),
                     ("ChevronDown.tga", chevron_down), ("ChevronRight.tga", chevron_right), ("Magnifier.tga", magnifier)]:
        img, w, h = fn()
        save(img, name, w, h)
    img, w, h = fade_down()
    save_exact(img, "FadeDown.tga")
    save_exact(shadow_v(), "ShadowV.tga")
    save_exact(shadow_h(), "ShadowH.tga")

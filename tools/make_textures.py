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


if __name__ == "__main__":
    for name, fn in [("VineH.tga", vine_h), ("VineV.tga", vine_v), ("Corner.tga", corner), ("RingGlow.tga", ring_glow),
                     ("RingThin.tga", ring_thin), ("CircleMask.tga", circle_mask)]:
        img, w, h = fn()
        save(img, name, w, h)

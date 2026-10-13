"""Generate procedural, seamlessly tiling textures for the WC2-style UI kit.

Everything is made from scratch (seeded random + numpy noise); nothing is
downloaded or copied. Output: tex/leather.png (256x256), tex/stone.png (128x128).

    python .kritikk/wc2ui/make_tex.py
"""
import os

import numpy as np
from PIL import Image, ImageFilter

HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, "tex")


def tile_noise(size, cells, rng, blur=0.0):
    """Tileable value noise in [0,1]: random grid, tiled 3x3, smooth-resized, centre crop."""
    g = rng.random((cells, cells)).astype(np.float32)
    big = np.tile(g, (3, 3))
    im = Image.fromarray((big * 255).astype(np.uint8))
    im = im.resize((size * 3, size * 3), Image.BICUBIC)
    if blur:
        im = im.filter(ImageFilter.GaussianBlur(blur))
    a = np.asarray(im, dtype=np.float32)[size:2 * size, size:2 * size] / 255.0
    return a


def fbm(size, rng, octaves=((4, 1.0), (8, 0.5), (16, 0.25), (32, 0.12))):
    acc = np.zeros((size, size), np.float32)
    tot = 0.0
    for cells, w in octaves:
        acc += tile_noise(size, cells, rng) * w
        tot += w
    acc /= tot
    return (acc - acc.min()) / (acc.max() - acc.min() + 1e-6)


def hex2rgb(h):
    h = h.lstrip("#")
    return np.array([int(h[i:i + 2], 16) for i in (0, 2, 4)], np.float32)


def voronoi(X, Y, pts, size, w=None):
    """Toroidal F1/F2 Voronoi distances (seamless) + nearest index.
    Optional additive weights w (bigger w => bigger cell)."""
    d1 = np.full(X.shape, 1e9, np.float32)
    d2 = np.full(X.shape, 1e9, np.float32)
    idx = np.zeros(X.shape, np.int32)
    for i, (px, py) in enumerate(pts):
        dx = np.mod(X - px, size)
        dx = np.minimum(dx, size - dx)
        dy = np.mod(Y - py, size)
        dy = np.minimum(dy, size - dy)
        d = np.sqrt(dx * dx + dy * dy)
        if w is not None:
            d = d - w[i]
        closer = d < d1
        d2 = np.where(closer, d1, np.minimum(d2, d))
        idx = np.where(closer, i, idx)
        d1 = np.where(closer, d, d1)
    return d1, d2, idx


def poisson_pts(size, n, rng, min_d):
    pts = []
    tries = 0
    while len(pts) < n and tries < 20000:
        tries += 1
        p = rng.random(2) * size
        ok = True
        for q in pts:
            d = np.abs(p - q)
            d = np.minimum(d, size - d)
            if (d * d).sum() < min_d * min_d:
                ok = False
                break
        if ok:
            pts.append(p)
    return np.array(pts, np.float32)


def leather(size=256, seed=11):
    rng = np.random.default_rng(seed)
    yy, xx = np.mgrid[0:size, 0:size].astype(np.float32)

    # two-scale domain warp: slow wobble + jagged high-frequency kinks
    wx = (fbm(size, rng) - 0.5) * 18 + (tile_noise(size, 48, rng) - 0.5) * 3.0
    wy = (fbm(size, rng) - 0.5) * 18 + (tile_noise(size, 48, rng) - 0.5) * 3.0
    X, Y = xx + wx, yy + wy

    # main plates: irregular sizes (poisson-ish, ~20 plates per tile)
    pts = poisson_pts(size, 30, rng, 24)
    wts = (rng.random(len(pts)) ** 2 * 22).astype(np.float32)
    d1, d2, idx = voronoi(X, Y, pts, size, wts)
    edge = d2 - d1

    # secondary hairline cracks: finer Voronoi, only kept where a mask says so,
    # so some cracks run partway into a plate and stop (like dried earth)
    pts2 = poisson_pts(size, 70, rng, 20)
    e1, e2, _ = voronoi(X * 1.0 + 3, Y * 1.0 - 2, pts2, size)
    edge2 = e2 - e1
    mask2 = np.clip((fbm(size, rng) - 0.55) * 5, 0, 1)

    wn = fbm(size, rng, ((3, 1.0), (6, 0.6), (12, 0.3)))
    deep = np.clip((wn - 0.55) * 3.0, 0, 1)          # stretches where cracks gape
    wvar = 1.2 + 1.2 * fbm(size, rng, ((8, 1.0), (16, 0.6))) + 3.2 * deep
    crack = np.clip(1.0 - edge / wvar, 0, 1)
    crack2 = np.clip(1.0 - edge2 / 0.9, 0, 1) * mask2 * 0.8
    rim = np.clip(1.0 - edge / (wvar + 4.0), 0, 1) - crack

    top = hex2rgb("#6b4423")
    low = hex2rgb("#4a2e16")
    crack_c = hex2rgb("#2a180a")

    # plate tone: mostly mid, a few lighter / darker plates
    t = np.clip(0.45 + 0.28 * rng.standard_normal(len(pts)), 0.05, 1.0).astype(np.float32)
    plate_t = t[idx]
    mott = fbm(size, rng, ((6, 1.0), (12, 0.7), (24, 0.4)))
    tone = np.clip(plate_t * 0.6 + mott * 0.55 + 0.12, 0, 1)
    base = low[None, None, :] + (top - low)[None, None, :] * tone[..., None]

    # lit plate edges: the lower/right wall of a crack (facing up-left) catches light
    gx = (np.roll(edge, -1, 1) - np.roll(edge, 1, 1)) * 0.5
    gy = (np.roll(edge, -1, 0) - np.roll(edge, 1, 0)) * 0.5
    near = np.clip(1 - edge / 6.0, 0, 1) * (1 - crack)
    light = np.clip((gx + gy) * 0.7, -1, 1) * near
    shade = 1.0 + 0.16 * light

    dome = np.clip(edge / 18.0, 0, 1) ** 0.7
    shade = shade * (0.9 + 0.12 * dome)

    grain = fbm(size, rng, ((32, 1.0), (64, 0.8), (128, 0.6)))
    speck = tile_noise(size, 128, rng)
    shade = shade * (0.90 + 0.17 * grain) * (0.95 + 0.08 * speck)

    col = base * shade[..., None] * 1.16   # lift plates so visible base sits ~#5a3a1e-#6b4423
    col = col * (1 - 0.30 * rim[..., None])
    c =np.maximum(crack, crack2)
    abyss = hex2rgb("#120a03")
    cc = crack_c[None, None, :] * (1 - deep[..., None]) + abyss[None, None, :] * deep[..., None]
    # crack core darkest in the middle of wide cracks
    core = np.clip(1.0 - edge / (wvar * 0.5), 0, 1) * deep
    cc = cc * (1 - 0.35 * core[..., None])
    col = col * (1 - c[..., None]) + cc * c[..., None]
    col[..., 1] *= 1.02
    col[..., 2] *= 0.80   # warmer, like sun-baked earth
    return Image.fromarray(np.clip(col, 0, 255).astype(np.uint8))


def stone(size=128, seed=3):
    rng = np.random.default_rng(seed)
    lo, hi = hex2rgb("#8f8466"), hex2rgb("#9a8b68")
    n = fbm(size, rng, ((4, 1.0), (8, 0.6), (16, 0.4), (32, 0.3), (64, 0.25)))
    tint = lo[None, None, :] + (hi - lo)[None, None, :] * n[..., None]
    speck = tile_noise(size, 128, rng)
    fine = rng.random((size, size)).astype(np.float32)          # per-pixel speckle (+-6%)
    dark = (tile_noise(size, 64, rng) > 0.84).astype(np.float32)  # dark flecks / pits
    light = (tile_noise(size, 64, rng) > 0.86).astype(np.float32)  # pale mineral flecks
    shade = 0.86 + 0.20 * n
    shade *= 0.95 + 0.08 * speck
    shade *= 0.94 + 0.12 * fine
    shade *= 1 - 0.22 * dark
    shade *= 1 + 0.12 * light
    col = tint * shade[..., None]
    return Image.fromarray(np.clip(col, 0, 255).astype(np.uint8))


def seam_check(img):
    a = np.asarray(img, np.float32)
    h = np.abs(a[:, 0] - a[:, -1]).mean()
    v = np.abs(a[0] - a[-1]).mean()
    inner = np.abs(a[:, 1:] - a[:, :-1]).mean()
    return h, v, inner


def main():
    os.makedirs(OUT, exist_ok=True)
    for name, img in (("leather.png", leather()), ("stone.png", stone())):
        p = os.path.join(OUT, name)
        img = img.quantize(colors=128, method=Image.MEDIANCUT, dither=Image.NONE).convert("RGB")
        img.save(p, optimize=True)
        h, v, inner = seam_check(img)
        print(f"{name}: {os.path.getsize(p) // 1024} KB, edge diff h={h:.1f} v={v:.1f} (inner {inner:.1f})")
        # 2x2 preview for eyeballing seams
        w, ht = img.size
        prev = Image.new("RGB", (w * 2, ht * 2))
        for ox in (0, w):
            for oy in (0, ht):
                prev.paste(img, (ox, oy))
        prev.save(os.path.join(OUT, "_preview_" + name))


if __name__ == "__main__":
    main()

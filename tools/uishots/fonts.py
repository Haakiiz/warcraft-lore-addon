"""Shared font config: WoW font path -> TTF used for measuring and drawing."""
from PIL import ImageFont
FONTS = {
    "body": r"C:\Windows\Fonts\trebuc.ttf",    # stands in for Friz Quadrata
    "title": r"C:\Windows\Fonts\georgiab.ttf",  # stands in for Morpheus
}
_cache = {}
def kind_of(path):
    return "title" if path and "MORPHEUS" in path.upper() else "body"
def get_font(kind, size):
    k = (kind, size)
    if k not in _cache:
        _cache[k] = ImageFont.truetype(FONTS[kind], size, layout_engine=ImageFont.Layout.BASIC)
    return _cache[k]
def advance(kind, size, cp):
    return get_font(kind, size).getlength(chr(cp))
CODEPOINTS = list(range(32, 127)) + list(range(160, 256)) + [0x2013, 0x2014, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2026]

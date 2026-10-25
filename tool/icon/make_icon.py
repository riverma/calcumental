# The app icon: the four operators as Khelo sticker tiles, two by two on cream paper, with
# the kangura border top and bottom. Each tile is one of Khelo's painted truck-art hues with
# a kajal outline and a hard, unblurred sticker shadow; each sign is drawn thick and
# round-capped over its own offset block, like signboard lettering.
#
#   python3 tool/icon/make_icon.py && sh tool/icon/render.sh

INK, PAPER = '#2a1840', '#fff9ee'

# patterns.css's kangura tile, 32x16 units, drawn at 4x.
TILE = ("<g transform='translate({x},{y}) scale(4{fy})'>"
        "<rect y='12' width='32' height='4' fill='#91165f'/>"
        "<path d='M4 12V9h4V6h4V3h8v3h4v3h4v3z' fill='#f5a300' stroke='#2a1840' stroke-width='1'/>"
        "<circle cx='16' cy='7.5' r='1.6' fill='#91165f'/></g>")


def kangura(y, flip):
    return ''.join(TILE.format(x=x * 128, y=y, fy=',-4' if flip else '') for x in range(8))


SIZE, GAP = 296, 34
START = (1024 - (2 * SIZE + GAP)) // 2
HALF, WEIGHT = 82, 42  # half-length and weight of a stroke


def sign(op, cx, cy, ink, side):
    def strokes(dx, dy, color):
        x, y = cx + dx, cy + dy
        paint = f"stroke='{color}' stroke-width='{WEIGHT}' stroke-linecap='round' fill='none'"
        h = f"<path d='M{x - HALF} {y}H{x + HALF}' {paint}/>"
        v = f"<path d='M{x} {y - HALF}V{y + HALF}' {paint}/>"
        dot = lambda oy: f"<circle cx='{x}' cy='{y + oy}' r='{WEIGHT * 0.62}' fill='{color}'/>"
        return {
            '+': h + v,
            '-': h,
            'x': f"<g transform='rotate(45 {x} {y})'>{h}{v}</g>",
            '/': h + dot(-66) + dot(66),
        }[op]

    # The block: the same sign, offset down and right, under the face.
    return strokes(11, 11, side) + strokes(0, 0, ink)


# (sign, tile fill, sign ink, block colour): marigold, rani, firozi, tota.
TILES = [
    ('+', '#f5a300', INK, '#9f4721'),
    ('-', '#d81b7f', PAPER, INK),
    ('x', '#11a8a4', INK, '#156e76'),
    ('/', '#4fa82a', INK, '#3c6e2a'),
]

body = ''
for i, (op, fill, ink, side) in enumerate(TILES):
    x = START + (i % 2) * (SIZE + GAP)
    y = START + (i // 2) * (SIZE + GAP)
    body += (
        f"<rect x='{x + 16}' y='{y + 16}' width='{SIZE}' height='{SIZE}' rx='56' fill='{INK}'/>"
        f"<rect x='{x}' y='{y}' width='{SIZE}' height='{SIZE}' rx='56' fill='{fill}' stroke='{INK}' stroke-width='14'/>"
        + sign(op, x + SIZE / 2, y + SIZE / 2, ink, side)
    )

svg = (
    "<svg xmlns='http://www.w3.org/2000/svg' width='1024' height='1024' viewBox='0 0 1024 1024'>"
    f"<rect width='1024' height='1024' fill='#fbf0d9'/>{kangura(0, False)}{kangura(1024, True)}{body}</svg>"
)
open('tool/icon/icon.svg', 'w').write(svg)

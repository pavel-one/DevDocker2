#!/usr/bin/env python3
"""
Generate a dimensioned technical drawing (SVG) of the shelf rack.

Views: front, side and a top view of one shelf, with dimension lines.
All values mirror the parameters in shelf_rack.scad (millimetres).

Usage:  python3 make_drawing.py  ->  writes drawing.svg
"""

# ---- model parameters (keep in sync with shelf_rack.scad) -------------
WIDTH = 280          # X - front width  ("28 см, не больше")
DEPTH = 550          # Y - side depth   ("55 см")
TUBE  = 25           # square tube
H1, GAP2, GAP3 = 200, 300, 375
H2 = H1 + GAP2       # 500
H3 = H2 + GAP3       # 875  (top)

# lengthwise slats across the width
N_SLATS = max(2, round((WIDTH + 85) / (85 + TUBE)))
STEP    = (WIDTH - TUBE) / (N_SLATS - 1)
SLAT_GAP = STEP - TUBE

S = 0.62             # drawing scale, px per mm
AR = "#1f3a4d"       # ink colour
DIM = "#b3402a"      # dimension colour

parts = []
def add(s): parts.append(s)

def rect(x, y, w, h, fill=AR):
    add(f'<rect x="{x:.1f}" y="{y:.1f}" width="{w:.1f}" height="{h:.1f}" '
        f'fill="{fill}" stroke="#0d2330" stroke-width="0.8"/>')

def line(x1, y1, x2, y2, color="#7a8a96", w=0.8, dash=""):
    d = f' stroke-dasharray="{dash}"' if dash else ""
    add(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}" '
        f'stroke="{color}" stroke-width="{w}"{d}/>')

def text(x, y, s, size=15, anchor="middle", color="#13212b", rot=None, weight="normal"):
    tr = f' transform="rotate({rot} {x:.1f} {y:.1f})"' if rot is not None else ""
    add(f'<text x="{x:.1f}" y="{y:.1f}" font-family="DejaVu Sans, Arial, sans-serif" '
        f'font-size="{size}" font-weight="{weight}" text-anchor="{anchor}" '
        f'fill="{color}"{tr}>{s}</text>')

def dim_h(xa, xb, y_dim, y_obj, label):
    """Horizontal dimension between xa..xb, dim line at y_dim, object edge at y_obj."""
    line(xa, y_obj, xa, y_dim, DIM, 0.7)
    line(xb, y_obj, xb, y_dim, DIM, 0.7)
    add(f'<line x1="{xa:.1f}" y1="{y_dim:.1f}" x2="{xb:.1f}" y2="{y_dim:.1f}" '
        f'stroke="{DIM}" stroke-width="1" marker-start="url(#arr)" marker-end="url(#arr)"/>')
    text((xa + xb) / 2, y_dim - 5, label, 14, "middle", DIM, weight="bold")

def dim_v(ya, yb, x_dim, x_obj, label):
    """Vertical dimension between ya..yb, dim line at x_dim, object edge at x_obj."""
    line(x_obj, ya, x_dim, ya, DIM, 0.7)
    line(x_obj, yb, x_dim, yb, DIM, 0.7)
    add(f'<line x1="{x_dim:.1f}" y1="{ya:.1f}" x2="{x_dim:.1f}" y2="{yb:.1f}" '
        f'stroke="{DIM}" stroke-width="1" marker-start="url(#arr)" marker-end="url(#arr)"/>')
    ym = (ya + yb) / 2
    text(x_dim - 5, ym, label, 14, "middle", DIM, rot=-90, weight="bold")

# ======================================================================
#  FRONT VIEW  (looking along -Y): width x height
# ======================================================================
fx, fy0 = 150, 660            # local origin: left edge / floor baseline
def FX(x): return fx + x * S
def FZ(z): return fy0 - z * S  # z up -> svg up

text(FX(WIDTH / 2), FZ(H3) - 60, "Вид спереди", 18, "middle", AR, weight="bold")

# two front legs
rect(FX(0), FZ(H3), TUBE * S, H3 * S)
rect(FX(WIDTH - TUBE), FZ(H3), TUBE * S, H3 * S)
# three shelf front rails (full width)
for h in (H1, H2, H3):
    rect(FX(0), FZ(h), WIDTH * S, TUBE * S)

# vertical dims (left) : 20 / 30 / 35-40 and total
dim_v(FZ(H1), FZ(0),  FX(0) - 35, FX(0), "200")
dim_v(FZ(H2), FZ(H1), FX(0) - 35, FX(0), "300")
dim_v(FZ(H3), FZ(H2), FX(0) - 35, FX(0), "375")
dim_v(FZ(H3), FZ(0),  FX(0) - 80, FX(0), "875")
# width dim (top)
dim_h(FX(0), FX(WIDTH), FZ(H3) - 28, FZ(H3), "280  (не больше)")
# tube dim
dim_h(FX(0), FX(TUBE), FZ(0) + 40, FZ(0), "25")

# ======================================================================
#  SIDE VIEW  (looking along X): depth x height
# ======================================================================
sx, sy0 = 470, 660
def SX(y): return sx + y * S
def SZ(z): return sy0 - z * S

text(SX(DEPTH / 2), SZ(H3) - 60, "Вид сбоку", 18, "middle", AR, weight="bold")

# two legs (front y=0, back y=DEPTH-TUBE)
rect(SX(0), SZ(H3), TUBE * S, H3 * S)
rect(SX(DEPTH - TUBE), SZ(H3), TUBE * S, H3 * S)
# three shelves: lengthwise slats seen along their length -> full-depth bars
for h in (H1, H2, H3):
    rect(SX(0), SZ(h), DEPTH * S, TUBE * S)

dim_h(SX(0), SX(DEPTH), SZ(0) + 40, SZ(0), "550")
dim_v(SZ(H3), SZ(0), SX(DEPTH) + 45, SX(DEPTH), "875")

# ======================================================================
#  TOP VIEW of one shelf (looking down): width x depth, slats
# ======================================================================
tx, ty0 = 980, 150
def TX(x): return tx + x * S
def TY(y): return ty0 + y * S

text(TX(WIDTH / 2), ty0 - 35, "Полка — вид сверху", 18, "middle", AR, weight="bold")

# end rails (along width) front & back
rect(TX(0), TY(0), WIDTH * S, TUBE * S)
rect(TX(0), TY(DEPTH - TUBE), WIDTH * S, TUBE * S)
# lengthwise slats (full depth)
for i in range(N_SLATS):
    rect(TX(i * STEP), TY(0), TUBE * S, DEPTH * S)

dim_h(TX(0), TX(WIDTH), TY(0) - 22, TY(0), "280")
dim_v(TY(0), TY(DEPTH), TX(WIDTH) + 40, TX(WIDTH), "550")
# slat gap + slat width (between first two slats)
dim_h(TX(TUBE), TX(STEP), TY(DEPTH) + 38, TY(DEPTH), f"{SLAT_GAP:.0f}")
dim_h(TX(0), TX(TUBE), TY(DEPTH) + 64, TY(DEPTH), "25")

# ======================================================================
#  Title block
# ======================================================================
tb_y = 720
add(f'<rect x="40" y="{tb_y}" width="1180" height="70" fill="none" '
    f'stroke="#0d2330" stroke-width="1"/>')
line(40, tb_y + 35, 1220, tb_y + 35, "#0d2330", 1)
line(820, tb_y, 820, tb_y + 70, "#0d2330", 1)
text(60, tb_y + 23, "Стеллаж для цветочных горшков — 3 яруса", 16, "start", AR, weight="bold")
text(60, tb_y + 58,
     f"Труба 25×25 мм · полки: рейки вдоль длины ({N_SLATS} шт), просвет ≈{SLAT_GAP:.0f} мм",
     13, "start", "#33424c")
text(840, tb_y + 23, "Размеры в мм", 14, "start", "#33424c")
text(840, tb_y + 50, "Габарит: 280 × 550 × 875", 14, "start", "#33424c")

# ======================================================================
svg = f'''<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="1260" height="820" viewBox="0 0 1260 820">
  <defs>
    <marker id="arr" markerWidth="11" markerHeight="9" refX="9" refY="4"
            orient="auto-start-reverse" markerUnits="userSpaceOnUse">
      <path d="M0,0 L9,4 L0,8 z" fill="{DIM}"/>
    </marker>
  </defs>
  <rect x="0" y="0" width="1260" height="820" fill="#ffffff"/>
  <rect x="14" y="14" width="1232" height="792" fill="none" stroke="#0d2330" stroke-width="1.5"/>
  {''.join(parts)}
</svg>
'''

with open("drawing.svg", "w", encoding="utf-8") as f:
    f.write(svg)
print("wrote drawing.svg")
print(f"slats={N_SLATS}  step={STEP:.1f}  clear gap={SLAT_GAP:.1f} mm")

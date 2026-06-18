// ============================================================
//  3D model of a 3-tier open metal-frame rack / stand
//  Reconstructed from the hand drawing.
//
//  All dimensions are in millimetres.
//
//  Footprint (from drawing):
//      width  (front)  = 280 mm  ("28 см, не больше")
//      depth  (side)   = 550 mm  ("55 см")
//
//  Vertical layout (heights measured from the floor, from drawing):
//      bottom shelf    = 200 mm  ("20")
//      middle shelf    = +300 mm -> 500 mm   ("30")
//      top shelf       = +375 mm -> 875 mm   ("35-40", mid value used)
// ============================================================

/* [Footprint] */
width  = 280;   // X - front width  (max 280)
depth  = 550;   // Y - side depth

/* [Shelf heights from floor] */
h1 = 200;       // bottom shelf  (top surface)
gap2 = 300;     // distance to middle shelf
gap3 = 375;     // distance to top shelf (35-40 cm -> 37.5 cm)

/* [Construction] */
tube = 25;            // square tube cross-section (25 x 25 mm)
slat_gap = 85;        // target clear gap between shelf slats (lets light through)
slats_lengthwise = true;  // true: slats run along the 550 mm length (full width of the shelf)

// Derived heights (top surface of each shelf rail)
h2 = h1 + gap2;          // 500
h3 = h2 + gap3;          // 875
top_height = h3;         // legs run from floor to the top shelf

$fn = 24;

// ---- helper: a single vertical leg -------------------------
module leg(x, y) {
    translate([x, y, 0])
        cube([tube, tube, top_height]);
}

// ---- helper: even slat count for a target clear gap over a span ----
function slat_count(span) = max(2, round((span + slat_gap) / (slat_gap + tube)));
function slat_step(span, n) = (span - tube) / (n - 1);  // centre-to-centre pitch

// ---- helper: one shelf made of slatted tube at height h ----
//  h = z of the TOP surface of the shelf (rails + slats are flush)
//  Slats are the same 25x25 tube, spaced with a clear gap so light reaches
//  the shelves below. Slats run along the 550 mm length so flower pots rest
//  on continuous rails, supported by cross-rails underneath.
module shelf_frame(h) {
    z = h - tube;   // bottom of the rails / slats

    if (slats_lengthwise) {
        // Cross-rails run along X (the 280 mm width): front, middle, back.
        // They tie the legs together and carry/support the lengthwise slats.
        for (yy = [0, (depth - tube) / 2, depth - tube])
            translate([0, yy, z]) cube([width, tube, tube]);

        // Slats run along Y (the full 550 mm length), spread across the width.
        n    = slat_count(width);
        step = slat_step(width, n);
        for (i = [0 : n - 1])
            translate([i * step, 0, z]) cube([tube, depth, tube]);
    } else {
        // Slats run across the 280 mm width, spread along the 550 mm depth.
        translate([0,            0, z]) cube([tube, depth, tube]);
        translate([width - tube, 0, z]) cube([tube, depth, tube]);
        n    = slat_count(depth);
        step = slat_step(depth, n);
        for (i = [0 : n - 1])
            translate([tube, i * step, z]) cube([width - 2 * tube, tube, tube]);
    }
}

// ============================================================
//  Assembly
// ============================================================
module rack() {
    color("SlateGray") {
        // 4 corner legs
        leg(0,            0);
        leg(width - tube, 0);
        leg(0,            depth - tube);
        leg(width - tube, depth - tube);

        // 3 shelf frames
        shelf_frame(h1);
        shelf_frame(h2);
        shelf_frame(h3);
    }
}

rack();

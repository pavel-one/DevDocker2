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
tube = 25;        // square tube cross-section (25 x 25 mm)
slat_gap = 85;    // target clear gap between shelf slats (lets light through)

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

// ---- helper: one shelf made of slatted tube at height h ----
//  h = z of the TOP surface of the shelf (frame + slats are flush)
//  The slats are the same 25x25 tube, spaced with a clear gap so
//  light reaches the shelves below.
module shelf_frame(h) {
    z = h - tube;   // bottom of the rails / slats

    // Two long side rails (run along Y, the 550 mm depth) - carry the slats
    translate([0,            0, z]) cube([tube, depth, tube]);
    translate([width - tube, 0, z]) cube([tube, depth, tube]);

    // Slats run along X (the 280 mm width), seated between the side rails,
    // distributed along Y (the depth) with equal clear gaps. The first and
    // last slats sit flush with the front/back edges and double as end rails.
    inner_w = width - 2 * tube;                                   // span of each slat (X)
    n   = max(2, round((depth + slat_gap) / (slat_gap + tube)));  // slat count for ~slat_gap
    gap = (depth - n * tube) / (n - 1);                           // resulting equal clear gap

    for (i = [0 : n - 1]) {
        translate([tube, i * (tube + gap), z])
            cube([inner_w, tube, tube]);
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

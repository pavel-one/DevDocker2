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
tube = 20;      // square tube cross-section (20 x 20 mm)
crossbars = true;  // add intermediate support bars on each shelf

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

// ---- helper: one rectangular shelf frame at height h -------
//  h = z of the TOP surface of the frame rails
module shelf_frame(h) {
    z = h - tube;   // bottom of the rails

    // Two long side rails (run along Y, the 550 mm depth)
    translate([0,            0, z]) cube([tube, depth, tube]);
    translate([width - tube, 0, z]) cube([tube, depth, tube]);

    // Front and back rails (run along X), fitted between side rails
    inner_w = width - 2 * tube;
    translate([tube, 0,            z]) cube([inner_w, tube, tube]);
    translate([tube, depth - tube, z]) cube([inner_w, tube, tube]);

    // Intermediate cross supports (run along X) for the shelf surface
    if (crossbars) {
        for (f = [1/3, 2/3]) {
            ypos = f * (depth - tube);
            translate([tube, ypos, z]) cube([inner_w, tube, tube]);
        }
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

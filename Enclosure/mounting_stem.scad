stem_base_r = 5;       // outer radius of stem
stem_base_h = 20;       // height of stem base
stem_top_r = 5;        // outer radius of screw insert
stem_top_h = 5;        // height of screw insert

insert_r = 3;
insert_h = 4;
screw_well_depth = 2;  // thickness of base of screw well

screw_shaft_r = 1.5;
screw_head_r = 3;

stem_base();
stem_top();
stem_negative();

module stem_negative() {
    translate([0,0,-1]) {
        linear_extrude(stem_base_h + stem_top_h + 2) {
            circle(stem_base_r);
        }
    }
}

module stem_base(r=stem_base_r, h=stem_base_h) {
    difference() {
        linear_extrude(h) {
            circle(r);
        }
        translate([0,0,h - insert_h]) {
            linear_extrude(insert_h + 1) {
                circle(insert_r);
            }
        }
    }
}

module stem_top() {
    translate([0,0,stem_base_h]) {
        difference() {
            linear_extrude(stem_top_h) {
                circle(stem_top_r);
            }
            translate([0,0,screw_well_depth]) {
                linear_extrude(stem_top_h) {
                    circle(screw_head_r);
                }
            }
            translate([0,0,-1]) {
                linear_extrude(screw_well_depth + 2) {
                    circle(screw_shaft_r);
                }
            }
        }
    }
}

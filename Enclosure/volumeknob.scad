include <volumeknob.h>

//rounded square
module mod1() {
	minkowski() {
		square(size=[enc_x, enc_y]);
		circle(r=corner_r);
	}
}

//circular knob cutout
module mod2() {
	translate([enc_x /2 , enc_y /2, 0])
		circle(r=knob_diam/2);
}

//walls
module walls() {
	linear_extrude(enc_z) {
		difference() {
			mod1();
			offset(delta=-wall_thickness) {
				mod1();
			}
		}

		*difference() {
			mod2();
			offset(delta=-wall_thickness) {
				mod2();
			}
		}
	}
}

//base
module base() {
	linear_extrude(wall_thickness) {
		difference() {
			mod1();
			mod2();
		}
	}
}

//assembly
difference() {
	walls();
	translate([(enc_x/2) - (cutout/2), 0, enc_z - cutout_depth]) {
		cube(size=[cutout, enc_y, cutout_depth]);
	}
}
base();
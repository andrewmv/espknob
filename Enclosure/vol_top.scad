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

//pot bracket
module pot_bracket() {
	bracket_length = knob_diam + 10;
	bracket_width = 20;
	bracket_height = 10; //placeholder
	bracket_thickenss = 2;
	//pot holder
	translate([enc_x / 2, enc_y / 2, bracket_height])
	linear_extrude(bracket_thickenss) {
		difference() {
			square(size=[bracket_length, bracket_width], center=true);
			circle(r=5);	//placeholder value
		}
	}
	//side supports
	translate([0,(enc_y / 2) - (bracket_width / 2),0]) {
		cube(size=[bracket_thickenss, bracket_width, bracket_height]);
	}
	translate([bracket_length - bracket_thickenss,(enc_y / 2) - (bracket_width / 2),0]) {
		cube(size=[bracket_thickenss, bracket_width, bracket_height]);
	}
}

//assembly
module asm_top() {
	difference() {
		walls();
		translate([(enc_x/2) - (cutout/2), 0, enc_z - cutout_depth]) {
			cube(size=[cutout, enc_y, cutout_depth]);
		}
	}
	base();
}
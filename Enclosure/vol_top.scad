include <volumeknob.h>

top_vers_lbl = ["v1.1", "2021-11"];

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
	difference() {
		//walls
		linear_extrude(enc_z) {
			difference() {
				mod1();
				offset(delta=-wall_thickness) {
					mod1();
				}
			}
		}
		//USB cut
		xoff = enc_x - esp_pos.x - esp_cuts[0][0] - esp_cuts[0][1] - esp_cut_tol;
		zoff = enc_z - esp_pos.z + esp_dim.z + 1 - esp_cut_tol;
		translate([xoff, -10, zoff])
			cube([	esp_cuts[0][1] + (esp_cut_tol * 2),
					10,
					2 + (esp_cut_tol * 2)]);
		//ICSP cut
		yoff = esp_pos.y + esp_debug_cut[0] - esp_cut_tol;
		color("cyan")
		translate([enc_x + 5,yoff, zoff])
			cube([	10,
					esp_debug_cut[1] + (2 *esp_cut_tol),
					2 + (esp_cut_tol * 2)]);
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

module pot_bracket() {
	a = bracket_height + bracket_thickenss;
	b = 10;
	c = rot_dim.z;
	d = bracket_length - (2 * b);
	ex = bracket_width;
	xoff = (enc_x / 2) - (bracket_length / 2) - (bracket_thickenss / 2);
	yoff = (enc_y / 2) - (bracket_width / 2);
	bushing_r = 6.75/2;
	difference() {
		translate([xoff, yoff, a]) {
			rotate([-90,0,0]) {
				linear_extrude(ex) {
					square([bracket_thickenss, a]);
					square([b,bracket_thickenss]);
					translate([b,0,0])
						square([bracket_thickenss,c]);
					translate([b,c,0])
						square([d + bracket_thickenss,bracket_thickenss]);
					translate([b+d,0,0]) {
						square([bracket_thickenss,c]);
						square([b,bracket_thickenss]);
					}
					translate([2*b+d,0,0])
						square([bracket_thickenss,a]);
				}
			}
		}
		translate([enc_x / 2, enc_y / 2,-a]) {
			cylinder(r=bushing_r, h=enc_z);
			translate([bushing_r + 3,0,0])
				cube(size=[1,2,enc_z], center=true);
		}
	}
}

//pot bracket
// module pot_bracket() {
// 	//pot holder
// 	translate([enc_x / 2, enc_y / 2, bracket_height]) {
// 		difference() {
// 			linear_extrude(bracket_thickenss) {
// 				difference() {
// 					square(size=[bracket_length, bracket_width], center=true);
// 					circle(r=(6.75/2));	
// 				}
// 			}
// 			//pot alignment notch
// 			translate([6.75 + 3, 0, 3])
// 				cube(size=[1,2,10], center=true);
// 		}
// 	}
// 	//side supports
// 	translate([(enc_x / 2) - bracket_length / 2,(enc_y / 2) - (bracket_width / 2),0]) {
// 		cube(size=[bracket_thickenss, bracket_width, bracket_height]);
// 	}
// 	translate([(enc_x / 2) + (bracket_length / 2) - bracket_thickenss,(enc_y / 2) - (bracket_width / 2),0]) {
// 		cube(size=[bracket_thickenss, bracket_width, bracket_height]);
// 	}
// }

//assembly
module asm_top() {
	difference() {
		walls();
		translate([(enc_x/2) - (cutout/2), 0, enc_z - cutout_depth]) {
			cube(size=[cutout, enc_y, cutout_depth]);
		}
	}
	base();
	color("grey") top_label();
}

module top_label() {
	translate([-3,5,wall_thickness]) {
		linear_extrude(1) {
			for(i = [0:len(top_vers_lbl)-1]) {
				translate([0, -i * 6, 0]) 
					text(top_vers_lbl[i], size=5);
			}
		}
	}
}
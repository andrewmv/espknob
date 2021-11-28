include <vol_top.scad>

module asm_base() {
	translate([0,0,enc_z]) {
		mod1();
	}
}
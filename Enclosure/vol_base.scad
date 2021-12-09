include <volumeknob.h>
include <vol_top.scad>
include </home/growlph/3D Printer Models/OpenSCAD Projects/retclip.scad>

base_vers_lbl = ["1.2", "2021-12", "SF8266T"];

module asm_base() {
	translate([0,0,enc_z]) {
		color("gray")
			linear_extrude(wall_thickness)
				mod1();
		base_placeholders();
		base_mounts();
		base_label();
		alignment_lip();
	}
}

module base_mounts() {
	//ESP Mounts
	translate([esp_pos.x, esp_pos.y, wall_thickness]) {
		for(i = [0:len(esp_mounting_holes)-1]) {
			translate(esp_mounting_holes[i]) {
				mounting_stem();
			}
		}
	}
	//Battery Clips
	translate(batt_pos) {
		a=0; b=batt_dim.z; c=1; d=3; e=3; f=1; ex=5;
		// Front / mating face
		translate([8,-2,0])
			rotate([0,-90,0]) cage_join_clip(a,b,c,d,e,f,ex);
		translate([batt_dim.x - 8 + ex,-2,0])
			rotate([0,-90,0]) cage_join_clip(a,b,c,d,e,f,ex);
		// Back
		translate([(batt_dim.x / 2) - (ex/2),batt_dim.y + 2,0])
			rotate([0,-90,180]) cage_join_clip(a,b,c,d,e,f,ex);
		// Left (from front)
		translate([-2,5,0])
			rotate([0,-90,-90]) cage_join_clip(a,b,c,d,e,f,ex);
		translate([-2,batt_dim.y - 8,0])
			rotate([0,-90,-90]) cage_join_clip(a,b,c,d,e,f,ex);
		// Right (from front)
		translate([batt_dim.x + 2,(batt_dim.y / 2) + (ex / 2),0])
			rotate([0,-90,90]) cage_join_clip(a,b,c,d,e,f,ex);
	}
}

module base_placeholders() {
	if (render_placeholders) {
		translate(esp_pos) {
			color("green")	cube(esp_dim);
			translate([esp_cuts[0][0],0,-2])
				color("silver")	cube([esp_cuts[0][1],5,2]);
		}
		translate(batt_pos) {
			color("pink")	cube(batt_dim);
		}
		translate(rot_pos) {
			color("blue")	cube(rot_dim);
		}
	}
}

module mounting_stem(depth = mounting_stem_depth, stem_r = mounting_stem_r, hole_r = mounting_hole_r) {
	difference() {
		linear_extrude(depth) {
			circle(stem_r);
		}
		translate([0,0,2]) {
			linear_extrude(depth + 1) {
				circle(hole_r);
			}
		}
	}
}

module alignment_lip() {
	d = 20; // Alignment lip distance from edge
	t = 0.25; // Nudge lips toward center
	translate([d,-corner_r + wall_thickness + t,0])
		cube([enc_x - 2*d,2,wall_thickness + 3]);
	translate([d,enc_y + corner_r - wall_thickness - 2 - t,0])
		cube([enc_x - 2*d,2,wall_thickness + 3]);
	translate([-corner_r + wall_thickness + t, d + 18, 0])
		cube([2,enc_y - 2*d - 5,wall_thickness + 3]);
	translate([enc_y + corner_r - wall_thickness - 2 -t, d, 0])
		cube([2,enc_y - 2*d,wall_thickness + 3]);
}

module base_label() {
	translate([0,29,wall_thickness]) {
		linear_extrude(1) {
			for(i = [0:len(base_vers_lbl)-1]) {
				translate([0, -i * 6, 0]) 
					text(base_vers_lbl[i], size=5);
			}
		}
	}
}
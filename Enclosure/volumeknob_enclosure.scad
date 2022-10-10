include <vol_top.scad>
include <vol_base.scad>
include <vol_knob.scad>

*asm_top();

translate([enc_x,0,enc_z * 2 + wall_thickness])
rotate([0,180,0])
asm_base();
    
color("red")
pot_bracket();

translate([enc_x / 2, enc_y / 2, -dial_depth + bracket_height - wall_thickness])
color("white")
*dial_asm();

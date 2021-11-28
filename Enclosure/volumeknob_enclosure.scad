include <vol_top.scad>
include <vol_base.scad>
include <vol_knob.scad>

asm_top();
color("gray")
    *asm_base();
    
color("red")
pot_bracket();
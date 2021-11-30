// Settings

render_placeholders = true;
$fn = 50;

// Major dimensions
knob_diam = 50;
enc_x = 58;
enc_y = enc_x;
enc_z = 18;
wall_thickness = 3;
cutout = 10;
cutout_depth=3;

// Rounded corners
corner_r = 10;

// Dial
dial_pos = [23.63,19.52];
dial_r = (knob_diam / 2) - 2;
dial_bezel_r = 3;
dial_depth = 16;
dial_walls = 1.5;
dial_shaft_depth = 5;
dial_shaft_r = 10 / 2;
dial_hole_r = 6.25 / 2;
dial_hole_cut = (dial_hole_r * 2) - 4.75;
dial_faceplate_tol = 1.0;

// Pot Bracket
bracket_length = knob_diam + 5;
bracket_width = 20;
bracket_height = 5; 
bracket_thickenss = 2;

// Standoffs
mounting_stem_depth = 6;
mounting_stem_r = 6.5/2;
mounting_hole_r = 2.8/2;

// ESP8266Thing
esp_pos = [-1,-5.5,wall_thickness + mounting_stem_depth];
esp_dim = [26.5,55.6,2];
esp_mounting_holes = [
	[2.5, 12.0],
	[2.5, 43.8],
	[22.5, 12.0],
	[22.5, 43.8]
];
esp_cuts = [
	[3.0,9.0]
];
esp_cut_tol = 3;

// Battery
batt_pos = [29,5,wall_thickness];
batt_dim = [34.0,51.0,5.7];

// Rotary encoder module
rot_dim = [19.5,26.2,8.6];
rot_pos = [	(enc_x / 2) - (19.5/2),
			(enc_y / 2) - (26.2/2),
			wall_thickness + enc_z - bracket_height - bracket_thickenss
		  ];

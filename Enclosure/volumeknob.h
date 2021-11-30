// Settings

render_placeholders = false;

// Major dimensions
knob_diam = 50;
enc_x = 60;
enc_y = enc_x;
enc_z = 20;
wall_thickness = 3;
cutout = 10;
cutout_depth=3;

// Rounded corners
corner_r = 10;

// Dial
dial_pos = [23.63,19.52];
dial_r = (knob_diam / 2) - 2;
dial_bezel_r = 3;
dial_depth = 14;
dial_walls = 1.5;
dial_shaft_depth = 5;
dial_shaft_r = 10 / 2;
dial_hole_r = 6.25 / 2;
dial_hole_cut = (dial_hole_r * 2) - 4.75;
dial_faceplate_tol = 1.0;

// Standoffs
mounting_stem_depth = 6;
mounting_stem_r = 6.5/2;
mounting_hole_r = 2.8/2;

// ESP8266Thing
esp_pos = [-5,0,wall_thickness + mounting_stem_depth];
esp_dim = [26.5,55.6,6.7];
esp_mounting_holes = [
	[2.5, 12.0],
	[2.5, 43.8],
	[23.3, 12.0],
	[23.3, 43.8]
];
esp_cuts = [
	[14.0,9.0]
];

// Battery
batt_pos = [30,5,wall_thickness];
batt_dim = [34.0,51.0,5.7];

// Rotary encoder module
rot_pos = [	(enc_x / 2) - (19.5/2),
			(enc_y / 2) - (26.2/2),
			21	
		  ];
rot_dim = [19.5,26.2,8.6];

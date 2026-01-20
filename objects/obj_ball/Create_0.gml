/// @description Initialize ball

// State: HELD, PASSING, SHOOTING, LOOSE
state = "HELD";

// Holder reference
holder = noone;
pass_target = noone;
shot_shooter = noone;

// Flight variables
start_x = 0;
start_y = 0;
target_x = 0;
target_y = 0;
travel_progress = 0;
travel_speed = 0.03;
arc_height = 100;

// Shot power (stored when shot is taken)
shot_power = 0;

// Visual
ball_radius = 8;
rotation = 0;

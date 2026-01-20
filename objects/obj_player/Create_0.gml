/// @description Initialize player

// Team assignment
team_id = 0;
player_color = c_red;

// Attributes
shooting_accuracy = 0.5;
player_speed = 4;

// State
is_ball_carrier = false;
is_offense = true;
is_shooting = false;
shoot_power = 0;

// Cooldowns
tackle_cooldown = 0;

// Visual
player_radius = 15;
jersey_number = irandom_range(0, 99);

/// @description Shootout room setup

// Set fixed distance for shootout
global.selected_distance = 20;
global.point_value = 20;

// Create field
instance_create_layer(0, 0, "Instances", obj_field);

// Create basket at 20 yard position
var basket = instance_create_layer(room_width / 2, 250, "Instances", obj_basket);
basket.base_x = room_width / 2;
basket.move_speed = 4;  // Medium speed for shootout
basket.move_range = 100;

// Create ball
instance_create_layer(room_width / 2, 100, "Instances", obj_ball);

// Create single shooter
var shooter_team = (global.shootout_turn == 0) ? global.player_team_id : global.cpu_team_id;
var team = get_team(shooter_team);

var shooter = instance_create_layer(room_width / 2, 100, "Instances", obj_player);
shooter.team_id = shooter_team;
shooter.player_color = team.color_primary;
shooter.shooting_accuracy = team.shooting;
shooter.is_ball_carrier = true;
shooter.is_offense = true;

global.ball_carrier = shooter;

// Attach ball to shooter
with (obj_ball) {
    holder = shooter;
    state = "HELD";
}

// Create a simple controller for shootout
global.shootout_state = "SHOOTING";  // SHOOTING, RESULT, NEXT_TURN

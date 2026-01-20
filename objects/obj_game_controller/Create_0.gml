/// @description Initialize game

// Initialize teams (randomize tiers)
init_teams();

// Initialize game state
init_game();

// UI state
global.show_power_meter = false;
global.power_meter_value = 0;

// Track possession switching
switch_possession_pending = false;

// Selected team index for menu
global.selected_team_index = 0;

// Create field
instance_create_layer(0, 0, "Instances", obj_field);

// Create basket
var basket = instance_create_layer(room_width / 2, 200, "Instances", obj_basket);
basket.base_x = room_width / 2;
basket.move_speed = get_team_basket_speed(global.cpu_team_id);
basket.move_range = 120;

// Create ball
instance_create_layer(room_width / 2, 100, "Instances", obj_ball);

// Create players (7 per team)
var player_team = get_team(global.player_team_id);
var cpu_team = get_team(global.cpu_team_id);

// Player's team (offense starts)
for (var i = 0; i < 7; i++) {
    var px = 80 + (i * 90);
    var py = 80;
    var p = instance_create_layer(px, py, "Instances", obj_player);
    p.team_id = global.player_team_id;
    p.player_color = player_team.color_primary;
    p.shooting_accuracy = player_team.shooting;
    p.player_speed = 4;
    p.is_offense = true;
}

// CPU team (defense starts)
for (var i = 0; i < 7; i++) {
    var px = 80 + (i * 90);
    var py = 350;
    var p = instance_create_layer(px, py, "Instances", obj_player);
    p.team_id = global.cpu_team_id;
    p.player_color = cpu_team.color_primary;
    p.shooting_accuracy = cpu_team.shooting;
    p.player_speed = 3.5;
    p.is_offense = false;
}

// Create HUD
instance_create_layer(0, 0, "Instances", obj_hud);

// Set initial state
global.game_state = "PRE_PLAY";

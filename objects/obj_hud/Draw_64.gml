/// @description Draw HUD (GUI layer)

var hud_height = 45;

// Top bar background
draw_set_color(c_black);
draw_set_alpha(0.8);
draw_rectangle(0, 0, display_get_gui_width(), hud_height, false);
draw_set_alpha(1);

// Team scores
var gui_width = display_get_gui_width();
var player_team = get_team(global.player_team_id);
var cpu_team = get_team(global.cpu_team_id);

// Player team (left)
draw_set_color(player_team.color_primary);
draw_rectangle(10, 5, 150, 40, false);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_text(15, 8, player_team.name);
draw_set_halign(fa_right);
draw_text(145, 20, string(global.score_player));

// CPU team (right)
draw_set_color(cpu_team.color_primary);
draw_rectangle(gui_width - 150, 5, gui_width - 10, 40, false);
draw_set_color(c_white);
draw_set_halign(fa_right);
draw_text(gui_width - 15, 8, cpu_team.name);
draw_set_halign(fa_left);
draw_text(gui_width - 145, 20, string(global.score_cpu));

// Center info
draw_set_halign(fa_center);
draw_set_color(c_white);

// Game clock
var time_str = format_time(global.game_timer);
draw_text(gui_width / 2, 5, "Q" + string(global.current_half) + "  " + time_str);

// Shot clock (when playing)
if (global.game_state == "PLAYING") {
    var shot_seconds = ceil(global.shot_clock / 60);
    var shot_color = (shot_seconds <= 5) ? c_red : c_yellow;
    draw_set_color(shot_color);
    draw_text(gui_width / 2, 22, "SHOT: " + string(shot_seconds));
}

// Down indicator
draw_set_color(c_lime);
draw_text(gui_width / 2 + 80, 14, "DOWN: " + string(global.current_down) + "/" + string(global.max_downs));

// Possession indicator
var poss_text = (global.offense_team == 0) ? "YOUR BALL" : "CPU BALL";
var poss_color = (global.offense_team == 0) ? c_lime : c_red;
draw_set_color(poss_color);
draw_text(gui_width / 2 - 100, 14, poss_text);

// Distance/Points indicator (during pre-play)
if (global.game_state == "PRE_PLAY") {
    draw_set_color(c_yellow);
    draw_text(gui_width / 2, 55, "Distance: " + string(global.selected_distance) + " yds = " + string(global.point_value) + " pts");
}

draw_set_halign(fa_left);

// Controls help (bottom of screen)
if (global.game_state == "PLAYING" && global.offense_team == 0) {
    var help_y = display_get_gui_height() - 20;
    draw_set_color(c_white);
    draw_set_alpha(0.7);
    draw_set_halign(fa_center);
    draw_text(gui_width / 2, help_y, "WASD: Move | CLICK: Pass | SPACE: Shoot | TAB: Switch");
    draw_set_alpha(1);
    draw_set_halign(fa_left);
}

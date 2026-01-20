/// @description Draw game UI elements

// Draw distance selection UI (PRE_PLAY)
if (global.game_state == "PRE_PLAY" && global.offense_team == 0) {
    // Semi-transparent overlay
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, room_height - 220, room_width, room_height, false);
    draw_set_alpha(1);

    // Title
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_font(-1);
    draw_text(room_width / 2, room_height - 200, "SELECT SHOT DISTANCE");

    // Distance buttons
    var distances = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
    for (var i = 0; i < 10; i++) {
        var btn_x = 80 + (i mod 5) * 130;
        var btn_y = room_height - 150 + floor(i / 5) * 55;
        var dist = distances[i];

        // Button background
        if (dist == global.selected_distance) {
            draw_set_color(c_lime);
        } else {
            draw_set_color(c_gray);
        }
        draw_roundrect(btn_x - 55, btn_y - 22, btn_x + 55, btn_y + 22, false);

        // Button text
        draw_set_color(c_black);
        draw_text(btn_x, btn_y - 8, string(dist) + " yds");
        draw_set_color(c_maroon);
        draw_text(btn_x, btn_y + 8, string(dist) + " pts");
    }

    // Start button
    draw_set_color(c_green);
    draw_roundrect(room_width/2 - 80, room_height - 45, room_width/2 + 80, room_height - 5, false);
    draw_set_color(c_white);
    draw_text(room_width / 2, room_height - 30, "START PLAY [ENTER]");

    draw_set_halign(fa_left);
}

// Draw power meter when shooting
if (global.show_power_meter && global.game_state == "PLAYING") {
    var meter_x = global.ball_carrier.x;
    var meter_y = global.ball_carrier.y - 50;
    var meter_width = 60;
    var meter_height = 10;

    // Background
    draw_set_color(c_dkgray);
    draw_rectangle(meter_x - meter_width/2, meter_y - meter_height/2,
                   meter_x + meter_width/2, meter_y + meter_height/2, false);

    // Power fill
    var fill_width = meter_width * global.power_meter_value;
    draw_set_color(get_power_meter_color(global.power_meter_value));
    draw_rectangle(meter_x - meter_width/2, meter_y - meter_height/2,
                   meter_x - meter_width/2 + fill_width, meter_y + meter_height/2, false);

    // Perfect zone indicator
    draw_set_color(c_white);
    var perfect_start = meter_x - meter_width/2 + (meter_width * 0.65);
    var perfect_end = meter_x - meter_width/2 + (meter_width * 0.85);
    draw_line(perfect_start, meter_y - meter_height/2 - 3, perfect_start, meter_y + meter_height/2 + 3);
    draw_line(perfect_end, meter_y - meter_height/2 - 3, perfect_end, meter_y + meter_height/2 + 3);
}

// Draw halftime screen
if (global.game_state == "HALFTIME") {
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(room_width/2, room_height/2 - 60, "HALFTIME");
    draw_text(room_width/2, room_height/2 - 20, get_team_name(global.player_team_id) + ": " + string(global.score_player));
    draw_text(room_width/2, room_height/2 + 10, get_team_name(global.cpu_team_id) + ": " + string(global.score_cpu));
    draw_text(room_width/2, room_height/2 + 60, "Press ENTER to continue");
    draw_set_halign(fa_left);
}

// Draw game over screen
if (global.game_state == "GAMEOVER") {
    draw_set_alpha(0.8);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);

    draw_set_color(c_white);
    draw_set_halign(fa_center);

    var winner = (global.score_player > global.score_cpu) ? "YOU WIN!" : "CPU WINS!";
    if (global.score_player == global.score_cpu) winner = "TIE!";

    draw_text(room_width/2, room_height/2 - 60, "GAME OVER");
    draw_text(room_width/2, room_height/2 - 20, winner);
    draw_text(room_width/2, room_height/2 + 20, get_team_name(global.player_team_id) + ": " + string(global.score_player));
    draw_text(room_width/2, room_height/2 + 50, get_team_name(global.cpu_team_id) + ": " + string(global.score_cpu));
    draw_text(room_width/2, room_height/2 + 100, "Press ENTER for menu");
    draw_set_halign(fa_left);
}

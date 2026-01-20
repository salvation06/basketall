/// @description Player input handling

/// @function handle_player_input()
/// @description Process all player input each frame
function handle_player_input() {
    if (global.game_state != "PLAYING") return;
    if (global.offense_team != 0) return;  // Only when player is on offense

    handle_movement_input();
    handle_pass_input();
    handle_shoot_input();
    handle_switch_player_input();
}

/// @function handle_movement_input()
/// @description Handle WASD/Arrow movement
function handle_movement_input() {
    if (global.ball_carrier == noone) return;
    if (!instance_exists(global.ball_carrier)) return;

    var carrier = global.ball_carrier;

    // Get input
    var h_input = keyboard_check(vk_right) - keyboard_check(vk_left);
    var v_input = keyboard_check(vk_down) - keyboard_check(vk_up);

    // WASD alternative
    h_input += keyboard_check(ord("D")) - keyboard_check(ord("A"));
    v_input += keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // Clamp to -1, 0, 1
    h_input = clamp(h_input, -1, 1);
    v_input = clamp(v_input, -1, 1);

    // Apply movement
    if (h_input != 0 || v_input != 0) {
        var move_dir = point_direction(0, 0, h_input, v_input);
        var speed = carrier.player_speed;

        // Slower when charging shot
        if (carrier.is_shooting) {
            speed *= 0.3;
        }

        carrier.x += lengthdir_x(speed, move_dir);
        carrier.y += lengthdir_y(speed, move_dir);

        // Keep in bounds
        carrier.x = clamp(carrier.x, 20, room_width - 20);
        carrier.y = clamp(carrier.y, 20, room_height - 100);
    }

    // Update ball position if held
    var ball = instance_find(obj_ball, 0);
    if (ball.state == "HELD" && ball.holder == carrier) {
        ball.x = carrier.x;
        ball.y = carrier.y;
    }
}

/// @function handle_pass_input()
/// @description Handle clicking to pass to teammate
function handle_pass_input() {
    if (mouse_check_button_pressed(mb_left)) {
        // Check if clicking on a teammate
        var clicked_player = noone;

        with (obj_player) {
            if (point_in_circle(mouse_x, mouse_y, x, y, 25)) {
                if (team_id == global.player_team_id && !is_ball_carrier) {
                    clicked_player = id;
                    break;
                }
            }
        }

        if (clicked_player != noone && global.ball_carrier != noone) {
            pass_ball(global.ball_carrier, clicked_player);
        }
    }
}

/// @function handle_shoot_input()
/// @description Handle spacebar shooting (hold for power)
function handle_shoot_input() {
    if (global.ball_carrier == noone) return;
    if (!instance_exists(global.ball_carrier)) return;

    var carrier = global.ball_carrier;

    // Start charging shot
    if (keyboard_check(vk_space)) {
        if (!carrier.is_shooting) {
            carrier.is_shooting = true;
            carrier.shoot_power = 0;
        }

        // Increase power
        carrier.shoot_power += 0.015;
        carrier.shoot_power = min(carrier.shoot_power, 1);

        global.show_power_meter = true;
        global.power_meter_value = carrier.shoot_power;
    }

    // Release shot
    if (keyboard_check_released(vk_space)) {
        if (carrier.is_shooting && carrier.is_ball_carrier) {
            var basket = instance_find(obj_basket, 0);
            shoot_ball(carrier, basket.x, basket.y, carrier.shoot_power);
        }

        carrier.is_shooting = false;
        carrier.shoot_power = 0;
        global.show_power_meter = false;
    }
}

/// @function handle_switch_player_input()
/// @description Handle Tab to switch controlled player
function handle_switch_player_input() {
    if (keyboard_check_pressed(vk_tab)) {
        cycle_controlled_player();
    }
}

/// @function cycle_controlled_player()
/// @description Switch control to next teammate
function cycle_controlled_player() {
    // Only works when player doesn't have ball
    if (global.ball_carrier != noone && global.ball_carrier.is_ball_carrier) {
        // Can't switch while holding ball
        return;
    }

    // Find next player on team
    var players = [];
    with (obj_player) {
        if (team_id == global.player_team_id && is_offense) {
            array_push(players, id);
        }
    }

    if (array_length(players) == 0) return;

    // Find current controlled index
    var current_idx = 0;
    for (var i = 0; i < array_length(players); i++) {
        if (players[i] == global.controlled_player) {
            current_idx = i;
            break;
        }
    }

    // Cycle to next
    var next_idx = (current_idx + 1) mod array_length(players);
    global.controlled_player = players[next_idx];
}

/// @function handle_menu_input()
/// @description Handle input on menu screens
function handle_menu_input() {
    // Start game
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        room_goto(rm_team_select);
    }
}

/// @function handle_team_select_input()
/// @description Handle team selection input
function handle_team_select_input() {
    // Click on team to select
    if (mouse_check_button_pressed(mb_left)) {
        for (var i = 0; i < 4; i++) {
            var btn_x = 150 + (i * 180);
            var btn_y = room_height / 2;
            var btn_w = 150;
            var btn_h = 200;

            if (point_in_rectangle(mouse_x, mouse_y,
                    btn_x - btn_w/2, btn_y - btn_h/2,
                    btn_x + btn_w/2, btn_y + btn_h/2)) {
                global.player_team_id = i;
                global.cpu_team_id = (i + irandom_range(1, 3)) mod 4;  // Random opponent

                // Start game
                room_goto(rm_game);
                break;
            }
        }
    }

    // Keyboard navigation
    if (keyboard_check_pressed(vk_right)) {
        global.selected_team_index = (global.selected_team_index + 1) mod 4;
    }
    if (keyboard_check_pressed(vk_left)) {
        global.selected_team_index = (global.selected_team_index + 3) mod 4;  // -1 mod 4
    }
    if (keyboard_check_pressed(vk_enter)) {
        global.player_team_id = global.selected_team_index;
        global.cpu_team_id = (global.selected_team_index + irandom_range(1, 3)) mod 4;
        room_goto(rm_game);
    }
}

/// @function handle_distance_select_input()
/// @description Handle pre-play distance selection
function handle_distance_select_input() {
    if (global.game_state != "PRE_PLAY") return;
    if (global.offense_team != 0) return;  // Only when player is on offense

    // Number keys 1-0 for distance (1=5yds, 2=10yds, etc.)
    var distances = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50];
    var keys = [ord("1"), ord("2"), ord("3"), ord("4"), ord("5"),
                ord("6"), ord("7"), ord("8"), ord("9"), ord("0")];

    for (var i = 0; i < 10; i++) {
        if (keyboard_check_pressed(keys[i])) {
            select_distance(distances[i]);
        }
    }

    // Up/Down to adjust
    if (keyboard_check_pressed(vk_up)) {
        select_distance(global.selected_distance + 5);
    }
    if (keyboard_check_pressed(vk_down)) {
        select_distance(global.selected_distance - 5);
    }

    // Confirm with Enter
    if (keyboard_check_pressed(vk_enter)) {
        start_play();
    }

    // Mouse click on distance buttons
    if (mouse_check_button_pressed(mb_left)) {
        for (var i = 0; i < 10; i++) {
            var btn_x = 100 + (i mod 5) * 120;
            var btn_y = room_height - 150 + floor(i / 5) * 50;

            if (point_in_rectangle(mouse_x, mouse_y, btn_x - 50, btn_y - 20, btn_x + 50, btn_y + 20)) {
                select_distance(distances[i]);
            }
        }

        // Start button
        var start_btn_x = room_width / 2;
        var start_btn_y = room_height - 50;
        if (point_in_rectangle(mouse_x, mouse_y, start_btn_x - 80, start_btn_y - 25, start_btn_x + 80, start_btn_y + 25)) {
            start_play();
        }
    }
}

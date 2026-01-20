/// @description Main game loop

// Handle pre-play (distance selection)
if (global.game_state == "PRE_PLAY") {
    handle_distance_select_input();

    // CPU selects distance automatically
    if (global.offense_team == 1) {
        global.selected_distance = ai_select_distance();
        global.point_value = global.selected_distance;
        start_play();
    }
}

// Main gameplay
if (global.game_state == "PLAYING") {
    // Update timers
    update_game_timer();

    // Handle player input (when on offense)
    if (global.offense_team == 0) {
        handle_player_input();
    }

    // AI updates
    if (global.offense_team == 1) {
        ai_offense_update();
    } else {
        ai_defense_update();
    }
}

// Halftime handling
if (global.game_state == "HALFTIME") {
    // Wait for input to continue
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        global.game_state = "PRE_PLAY";
    }
}

// Game over handling
if (global.game_state == "GAMEOVER") {
    // Wait for input to return to menu
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space)) {
        room_goto(rm_menu);
    }
}

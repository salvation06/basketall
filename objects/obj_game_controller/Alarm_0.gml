/// @description Post-play transition

// Check if we need to switch possession
if (variable_global_exists("switch_possession") && global.switch_possession) {
    switch_possession();
    global.switch_possession = false;
} else {
    // Same team continues, just reset for next down
    global.game_state = "PRE_PLAY";
}

// Reset positions
reset_player_positions();
setup_ball_carrier();

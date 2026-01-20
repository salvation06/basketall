/// @description Menu step

// Title animation
title_bounce += 0.05;

// Check for room type and handle input
if (room == rm_menu) {
    handle_menu_input();
} else if (room == rm_team_select) {
    handle_team_select_input();
}

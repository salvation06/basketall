/// @description Draw menu screens

if (room == rm_menu) {
    // Background
    draw_set_color(make_color_rgb(20, 30, 50));
    draw_rectangle(0, 0, room_width, room_height, false);

    // Title
    var title_y = 120 + sin(title_bounce) * 10;
    draw_set_halign(fa_center);
    draw_set_color(c_orange);
    draw_text_transformed(room_width / 2, title_y, "basketALL", 3, 3, 0);

    // Subtitle
    draw_set_color(c_white);
    draw_text(room_width / 2, title_y + 60, "Where Basketball Meets Football");

    // Play button
    var btn_y = room_height / 2 + 50;
    draw_set_color(c_green);
    draw_roundrect(room_width/2 - 100, btn_y - 30, room_width/2 + 100, btn_y + 30, false);
    draw_set_color(c_white);
    draw_text(room_width / 2, btn_y - 8, "PLAY");

    // Instructions
    draw_set_color(c_gray);
    draw_text(room_width / 2, room_height - 100, "Press ENTER or SPACE to start");

    // Credits
    draw_text(room_width / 2, room_height - 40, "Reddit Daily Games Hackathon 2026");

    draw_set_halign(fa_left);
}

if (room == rm_team_select) {
    // Background
    draw_set_color(make_color_rgb(20, 30, 50));
    draw_rectangle(0, 0, room_width, room_height, false);

    // Title
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(room_width / 2, 40, "SELECT YOUR TEAM");

    // Warning about hidden tiers
    draw_set_color(c_yellow);
    draw_text(room_width / 2, 80, "Teams are randomly balanced - choose by color!");

    // Team cards
    for (var i = 0; i < 4; i++) {
        var team = get_team(i);
        var card_x = 100 + (i * 170);
        var card_y = room_height / 2;
        var card_w = 140;
        var card_h = 180;

        // Card background
        var is_selected = (i == global.selected_team_index);
        if (is_selected) {
            draw_set_color(c_yellow);
            draw_roundrect(card_x - card_w/2 - 5, card_y - card_h/2 - 5,
                          card_x + card_w/2 + 5, card_y + card_h/2 + 5, false);
        }

        draw_set_color(team.color_primary);
        draw_roundrect(card_x - card_w/2, card_y - card_h/2,
                      card_x + card_w/2, card_y + card_h/2, false);

        // Team jersey preview
        draw_set_color(team.color_secondary);
        draw_rectangle(card_x - 25, card_y - 50, card_x + 25, card_y + 10, false);

        // Jersey number
        draw_set_color(team.color_primary);
        draw_text(card_x, card_y - 30, "00");

        // Team name
        draw_set_color(c_white);
        draw_text(card_x, card_y + 50, team.name);

        // Click hint
        if (is_selected) {
            draw_set_color(c_lime);
            draw_text(card_x, card_y + 80, "[ENTER]");
        }
    }

    // Navigation hint
    draw_set_color(c_gray);
    draw_text(room_width / 2, room_height - 50, "Arrow Keys or Click to Select | ENTER to Confirm");

    draw_set_halign(fa_left);
}

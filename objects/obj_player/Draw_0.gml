/// @description Draw player (football uniform, no helmet)

var px = x;
var py = y;

// Shadow
draw_set_alpha(0.3);
draw_set_color(c_black);
draw_ellipse(px - 12, py + 10, px + 12, py + 18, false);
draw_set_alpha(1);

// Legs (football pants)
draw_set_color(c_white);
draw_rectangle(px - 6, py + 2, px - 2, py + 14, false);
draw_rectangle(px + 2, py + 2, px + 6, py + 14, false);

// Body (jersey)
draw_set_color(player_color);
draw_roundrect(px - 10, py - 12, px + 10, py + 4, false);

// Jersey number
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(px, py - 4, string(jersey_number mod 100));

// Head (no helmet - face visible)
draw_set_color(make_color_rgb(210, 180, 140));  // Skin tone
draw_circle(px, py - 18, 7, false);

// Hair
draw_set_color(c_black);
draw_ellipse(px - 6, py - 26, px + 6, py - 20, false);

// Ball carrier indicator
if (is_ball_carrier) {
    draw_set_color(c_yellow);
    draw_circle(px, py - 30, 5, false);
}

// Offense/Defense indicator (subtle)
if (is_offense) {
    draw_set_color(c_lime);
} else {
    draw_set_color(c_red);
}
draw_circle(px, py + 18, 3, false);

// Reset draw settings
draw_set_halign(fa_left);
draw_set_valign(fa_top);

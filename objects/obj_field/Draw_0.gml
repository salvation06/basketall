/// @description Draw football field

// Field dimensions
var field_top = 50;
var field_bottom = room_height - 50;
var field_left = 20;
var field_right = room_width - 20;
var field_height = field_bottom - field_top;

// Green turf
draw_set_color(make_color_rgb(34, 139, 34));  // Forest green
draw_rectangle(field_left, field_top, field_right, field_bottom, false);

// Darker stripes (every 10 yards)
draw_set_color(make_color_rgb(28, 120, 28));
var stripe_height = field_height / 10;
for (var i = 0; i < 10; i += 2) {
    var sy = field_top + (i * stripe_height);
    draw_rectangle(field_left, sy, field_right, sy + stripe_height, false);
}

// Yard lines
draw_set_color(c_white);
var yards_per_line = 5;
var line_count = 50 / yards_per_line;
var pixels_per_yard = field_height / 50;

for (var i = 0; i <= line_count; i++) {
    var ly = field_top + (i * yards_per_line * pixels_per_yard);
    draw_line_width(field_left, ly, field_right, ly, 1);

    // Yard markers
    var yards = i * yards_per_line;
    draw_set_halign(fa_right);
    draw_text(field_left - 5, ly - 8, string(yards));
    draw_set_halign(fa_left);
    draw_text(field_right + 5, ly - 8, string(yards));
}

// End zones
draw_set_color(make_color_rgb(139, 0, 0));  // Dark red
draw_rectangle(field_left, field_top - 30, field_right, field_top, false);

// Sidelines
draw_set_color(c_white);
draw_rectangle(field_left, field_top, field_right, field_bottom, true);

// Field border
draw_set_color(c_white);
draw_line_width(field_left, field_top, field_right, field_top, 3);
draw_line_width(field_left, field_bottom, field_right, field_bottom, 3);
draw_line_width(field_left, field_top, field_left, field_bottom, 3);
draw_line_width(field_right, field_top, field_right, field_bottom, 3);

// Center logo area (simplified)
var center_y = (field_top + field_bottom) / 2;
draw_set_alpha(0.3);
draw_set_color(c_white);
draw_circle(room_width / 2, center_y, 40, false);
draw_set_alpha(1);

// "basketALL" text at midfield
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_alpha(0.5);
draw_text(room_width / 2, center_y, "basketALL");
draw_set_alpha(1);
draw_set_halign(fa_left);

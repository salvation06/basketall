/// @description Draw basketball

// Shadow (when in air)
if (state == "SHOOTING" || state == "PASSING") {
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    // Shadow on ground below ball
    var shadow_y = lerp(start_y, target_y, travel_progress);
    draw_ellipse(x - 8, shadow_y + 5, x + 8, shadow_y + 12, false);
    draw_set_alpha(1);
}

// Basketball body
draw_set_color(make_color_rgb(255, 127, 39));  // Orange
draw_circle(x, y, ball_radius, false);

// Basketball lines
draw_set_color(c_black);

// Horizontal line
draw_line(x - ball_radius + 2, y, x + ball_radius - 2, y);

// Vertical line
draw_line(x, y - ball_radius + 2, x, y + ball_radius - 2);

// Curved lines (simplified)
var curve_offset = sin(degtorad(rotation)) * 3;
draw_arc(x + curve_offset, y, ball_radius - 2, 60, 120, false);
draw_arc(x - curve_offset, y, ball_radius - 2, 240, 300, false);

// Highlight
draw_set_color(c_white);
draw_set_alpha(0.4);
draw_circle(x - 3, y - 3, 3, false);
draw_set_alpha(1);

/// @description Draw basketball hoop

var bx = x;
var by = y;

// Glow effect behind basket
draw_set_alpha(glow_alpha);
draw_set_color(c_yellow);
draw_circle(bx, by, rim_width + 10, false);
draw_set_alpha(1);

// Backboard
draw_set_color(c_white);
draw_rectangle(bx - backboard_width/2, by - backboard_height,
               bx + backboard_width/2, by - 5, false);

// Backboard border
draw_set_color(c_black);
draw_rectangle(bx - backboard_width/2, by - backboard_height,
               bx + backboard_width/2, by - 5, true);

// Backboard square (target)
draw_set_color(c_red);
draw_rectangle(bx - 15, by - 30, bx + 15, by - 10, true);

// Rim (orange ring)
draw_set_color(make_color_rgb(255, 100, 50));
draw_ellipse(bx - rim_width/2, by - rim_height,
             bx + rim_width/2, by + rim_height, false);

// Rim inner (hole)
draw_set_color(c_black);
draw_ellipse(bx - rim_width/2 + 4, by - rim_height + 2,
             bx + rim_width/2 - 4, by + rim_height - 2, false);

// Net (simplified vertical lines)
draw_set_color(c_white);
for (var i = -3; i <= 3; i++) {
    var nx = bx + (i * 5);
    draw_line(nx, by + rim_height, nx, by + 25);
}
// Net bottom curve
draw_line(bx - 15, by + 25, bx, by + 30);
draw_line(bx + 15, by + 25, bx, by + 30);

// Movement indicator arrows
draw_set_color(c_lime);
draw_set_alpha(0.7);
draw_triangle(bx - rim_width/2 - 15, by,
              bx - rim_width/2 - 5, by - 8,
              bx - rim_width/2 - 5, by + 8, false);
draw_triangle(bx + rim_width/2 + 15, by,
              bx + rim_width/2 + 5, by - 8,
              bx + rim_width/2 + 5, by + 8, false);
draw_set_alpha(1);

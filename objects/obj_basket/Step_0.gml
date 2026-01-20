/// @description Basket step

// Glow animation
glow_alpha += 0.03 * glow_direction;
if (glow_alpha >= 0.6) {
    glow_direction = -1;
} else if (glow_alpha <= 0.1) {
    glow_direction = 1;
}

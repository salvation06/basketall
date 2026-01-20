/// @description Player step

// Update cooldowns
if (tackle_cooldown > 0) {
    tackle_cooldown--;
}

// Keep in bounds
x = clamp(x, 20, room_width - 20);
y = clamp(y, 20, room_height - 60);

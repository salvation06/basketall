/// @description Ball step

// Update based on state
switch (state) {
    case "HELD":
        // Follow holder
        if (holder != noone && instance_exists(holder)) {
            x = holder.x;
            y = holder.y - 5;  // Slightly above player
        }
        break;

    case "PASSING":
    case "SHOOTING":
        // Update flight
        update_ball_flight();
        rotation += 15;  // Spin while in air
        break;

    case "LOOSE":
        // Ball is loose - could add bounce physics here
        break;
}

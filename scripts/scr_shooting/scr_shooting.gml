/// @description Shooting and ball mechanics

/// @function shoot_ball(shooter, target_x, target_y, power)
/// @param {Id.Instance} shooter - Player instance shooting
/// @param {Real} target_x - Target X position (basket)
/// @param {Real} target_y - Target Y position (basket)
/// @param {Real} power - Shot power (0-1)
function shoot_ball(shooter, target_x, target_y, power) {
    with (obj_ball) {
        state = "SHOOTING";
        start_x = shooter.x;
        start_y = shooter.y;
        self.target_x = target_x;
        self.target_y = target_y;
        travel_progress = 0;
        holder = noone;

        // Calculate arc based on distance
        var dist = point_distance(start_x, start_y, target_x, target_y);
        arc_height = dist * 0.5;

        // Store power for accuracy calculation
        shot_power = power;
        shot_shooter = shooter;

        // Calculate travel time based on distance
        travel_speed = 0.025;  // Adjust for desired ball speed
    }

    shooter.is_ball_carrier = false;
    shooter.is_shooting = false;
}

/// @function pass_ball(passer, receiver)
/// @param {Id.Instance} passer - Player passing the ball
/// @param {Id.Instance} receiver - Target player to receive
function pass_ball(passer, receiver) {
    with (obj_ball) {
        state = "PASSING";
        start_x = passer.x;
        start_y = passer.y;
        target_x = receiver.x;
        target_y = receiver.y;
        travel_progress = 0;
        holder = noone;
        pass_target = receiver;

        // Passes are faster than shots
        travel_speed = 0.05;

        // Lower arc for passes
        var dist = point_distance(start_x, start_y, target_x, target_y);
        arc_height = dist * 0.15;
    }

    passer.is_ball_carrier = false;
}

/// @function update_ball_flight()
/// @description Update ball position during flight (call in obj_ball step)
function update_ball_flight() {
    if (state == "SHOOTING" || state == "PASSING") {
        travel_progress += travel_speed;

        if (travel_progress >= 1) {
            travel_progress = 1;

            if (state == "SHOOTING") {
                // Check if shot made
                check_shot_result();
            } else if (state == "PASSING") {
                // Complete pass
                complete_pass();
            }
        } else {
            // Interpolate position with arc
            x = lerp(start_x, target_x, travel_progress);

            // Parabolic arc
            var arc = sin(travel_progress * pi) * arc_height;
            var base_y = lerp(start_y, target_y, travel_progress);
            y = base_y - arc;
        }
    }
}

/// @function check_shot_result()
/// @description Determine if shot is made or missed
function check_shot_result() {
    var basket = instance_find(obj_basket, 0);

    // Distance from ball's target to actual basket position
    var dist_to_basket = point_distance(target_x, target_y, basket.x, basket.y);

    // Get shooter's team shooting accuracy
    var shooter_team = shot_shooter.team_id;
    var base_accuracy = get_team_shooting(shooter_team);

    // Power modifier (perfect is around 0.7-0.8)
    var power_diff = abs(shot_power - 0.75);
    var power_modifier = 1 - (power_diff * 1.5);
    power_modifier = clamp(power_modifier, 0.3, 1.2);

    // Distance from selected distance affects accuracy
    var distance_penalty = (obj_game_controller.selected_distance / 50) * 0.3;

    // Moving basket penalty (how far basket moved from where we aimed)
    var basket_penalty = (dist_to_basket / 100) * 0.5;

    // Final accuracy calculation
    var final_accuracy = base_accuracy * power_modifier - distance_penalty - basket_penalty;
    final_accuracy = clamp(final_accuracy, 0.05, 0.95);

    // Roll for success
    var roll = random(1);

    if (roll < final_accuracy) {
        // MADE SHOT
        with (obj_game_controller) {
            shot_made();
        }
    } else {
        // MISSED SHOT
        with (obj_game_controller) {
            shot_missed();
        }
    }

    // Reset ball state
    state = "LOOSE";
}

/// @function complete_pass()
/// @description Handle pass completion
function complete_pass() {
    if (instance_exists(pass_target)) {
        // Check for interception (nearby defenders)
        var intercepted = false;

        with (obj_player) {
            if (team_id != other.pass_target.team_id) {
                var dist_to_ball = point_distance(x, y, other.x, other.y);
                if (dist_to_ball < 30) {
                    // Interception chance
                    if (random(1) < 0.3) {
                        intercepted = true;
                        break;
                    }
                }
            }
        }

        if (!intercepted) {
            // Successful catch
            state = "HELD";
            holder = pass_target;
            x = pass_target.x;
            y = pass_target.y;
            pass_target.is_ball_carrier = true;

            with (obj_game_controller) {
                ball_carrier = other.pass_target;
            }
        } else {
            // Interception - turnover
            state = "LOOSE";
            with (obj_game_controller) {
                play_stopped("INTERCEPTION");
            }
        }
    } else {
        state = "LOOSE";
    }
}

/// @function get_power_meter_color(power)
/// @param {Real} power - Current power level (0-1)
/// @returns {Constant.Color} Color for power meter
function get_power_meter_color(power) {
    if (power >= 0.65 && power <= 0.85) {
        return c_green;  // Perfect zone
    } else if (power >= 0.5 && power <= 0.9) {
        return c_yellow; // Good zone
    } else {
        return c_red;    // Bad zone
    }
}

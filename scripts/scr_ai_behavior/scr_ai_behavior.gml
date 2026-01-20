/// @description AI behavior for CPU team and basket movement

/// @function ai_move_basket()
/// @description Control the moving basket (defense)
function ai_move_basket() {
    with (obj_basket) {
        var ball = instance_find(obj_ball, 0);

        if (ball.state == "SHOOTING") {
            // Dodge the shot - move away from ball trajectory
            var dodge_dir = sign(x - ball.target_x);
            if (dodge_dir == 0) dodge_dir = choose(-1, 1);

            // Faster movement when dodging
            x += dodge_dir * move_speed * 2;
        } else if (ball.state == "HELD" && ball.holder != noone) {
            // Track the ball carrier - try to stay opposite
            var ball_carrier_x = ball.holder.x;
            var center = room_width / 2;

            // Move opposite to ball carrier position
            if (ball_carrier_x < center) {
                move_direction = 1;  // Move right
            } else {
                move_direction = -1; // Move left
            }

            x += move_direction * move_speed;
        } else {
            // Default pattern - oscillate
            x += move_direction * move_speed;

            if (x > base_x + move_range) {
                move_direction = -1;
            } else if (x < base_x - move_range) {
                move_direction = 1;
            }
        }

        // Clamp to bounds
        x = clamp(x, 50, room_width - 50);
    }
}

/// @function ai_select_distance()
/// @returns {Real} Selected distance in yards
/// @description CPU selects shot distance based on team tier
function ai_select_distance() {
    var cpu_team = get_team(global.cpu_team_id);
    var tier = cpu_team.tier;

    // Better teams attempt longer shots
    switch (tier) {
        case 1:  // Best team - aggressive
            return choose(25, 30, 35, 40, 45);
        case 2:
            return choose(20, 25, 30, 35);
        case 3:
            return choose(15, 20, 25, 30);
        case 4:  // Worst team - conservative
            return choose(10, 15, 20);
        default:
            return 20;
    }
}

/// @function ai_offense_update()
/// @description CPU offensive decision making
function ai_offense_update() {
    if (global.offense_team != 1) return;  // Only run when CPU is on offense
    if (global.game_state != "PLAYING") return;

    var ball = instance_find(obj_ball, 0);
    if (ball.state != "HELD") return;

    var carrier = ball.holder;
    if (carrier == noone) return;

    // Decision weights
    var shot_clock_pressure = 1 - (global.shot_clock / global.shot_clock_max);
    var cpu_team = get_team(global.cpu_team_id);

    // Check if good shot opportunity
    var basket = instance_find(obj_basket, 0);
    var dist_to_basket = point_distance(carrier.x, carrier.y, basket.x, basket.y);
    var angle_quality = 1 - (abs(carrier.x - basket.x) / (room_width / 2));

    // Urgency increases with shot clock
    var shoot_threshold = 0.4 - (shot_clock_pressure * 0.3);

    // Should we shoot?
    if (shot_clock_pressure > 0.7 || (angle_quality > 0.6 && random(1) > shoot_threshold)) {
        // Take the shot
        ai_take_shot(carrier);
        return;
    }

    // Should we pass?
    if (random(1) < 0.02) {  // 2% chance per frame to pass
        ai_make_pass(carrier);
        return;
    }

    // Move towards better position
    ai_move_carrier(carrier);
}

/// @function ai_take_shot(carrier)
/// @param {Id.Instance} carrier - Ball carrier instance
function ai_take_shot(carrier) {
    var basket = instance_find(obj_basket, 0);
    var cpu_team = get_team(global.cpu_team_id);

    // AI shot power based on team skill (better teams more consistent)
    var ideal_power = 0.75;
    var variance = 0.15 * (1 - cpu_team.shooting);  // Less variance for better teams
    var power = ideal_power + random_range(-variance, variance);
    power = clamp(power, 0.3, 1.0);

    carrier.is_shooting = true;
    carrier.shoot_power = power;

    // Slight delay then shoot
    alarm[3] = 15;  // Will call shoot_ball after short delay
    global.ai_pending_shot = {
        carrier: carrier,
        power: power
    };
}

/// @function ai_execute_shot()
/// @description Execute pending AI shot
function ai_execute_shot() {
    if (variable_global_exists("ai_pending_shot")) {
        var shot = global.ai_pending_shot;
        if (instance_exists(shot.carrier) && shot.carrier.is_ball_carrier) {
            var basket = instance_find(obj_basket, 0);
            shoot_ball(shot.carrier, basket.x, basket.y, shot.power);
        }
        global.ai_pending_shot = undefined;
    }
}

/// @function ai_make_pass(carrier)
/// @param {Id.Instance} carrier - Ball carrier instance
function ai_make_pass(carrier) {
    // Find best pass target
    var best_target = noone;
    var best_score = -999;

    with (obj_player) {
        if (id == carrier) continue;
        if (team_id != carrier.team_id) continue;

        // Score based on position (closer to basket is better)
        var basket = instance_find(obj_basket, 0);
        var dist_to_basket = point_distance(x, y, basket.x, basket.y);
        var position_score = 1 - (dist_to_basket / 500);

        // Penalty for nearby defenders
        var defender_penalty = 0;
        with (obj_player) {
            if (team_id != other.team_id) {
                var def_dist = point_distance(x, y, other.x, other.y);
                if (def_dist < 50) {
                    defender_penalty += (50 - def_dist) / 100;
                }
            }
        }

        var total_score = position_score - defender_penalty;
        if (total_score > best_score) {
            best_score = total_score;
            best_target = id;
        }
    }

    if (best_target != noone) {
        pass_ball(carrier, best_target);
    }
}

/// @function ai_move_carrier(carrier)
/// @param {Id.Instance} carrier - Ball carrier to move
function ai_move_carrier(carrier) {
    var basket = instance_find(obj_basket, 0);

    // Move towards shooting position
    var target_x = basket.x + random_range(-50, 50);
    var target_y = basket.y - 80;  // Stay in front of basket

    var dir = point_direction(carrier.x, carrier.y, target_x, target_y);
    var move_dist = min(carrier.player_speed, point_distance(carrier.x, carrier.y, target_x, target_y));

    carrier.x += lengthdir_x(move_dist * 0.5, dir);
    carrier.y += lengthdir_y(move_dist * 0.5, dir);
}

/// @function ai_defense_update()
/// @description CPU defensive behavior (when player is on offense)
function ai_defense_update() {
    if (global.offense_team != 0) return;  // Only run when player is on offense
    if (global.game_state != "PLAYING") return;

    var ball = instance_find(obj_ball, 0);

    with (obj_player) {
        if (team_id != global.cpu_team_id) continue;  // Only CPU players
        if (is_offense) continue;  // Skip if somehow on offense

        // Find closest offensive player to guard
        var target = noone;
        var min_dist = 9999;

        with (obj_player) {
            if (team_id != other.team_id && is_offense) {
                var dist = point_distance(x, y, other.x, other.y);
                if (dist < min_dist) {
                    min_dist = dist;
                    target = id;
                }
            }
        }

        if (target != noone) {
            // Move towards assigned player
            var dir = point_direction(x, y, target.x, target.y);
            var chase_speed = player_speed * 0.8;

            // If target has ball, be more aggressive
            if (target.is_ball_carrier) {
                chase_speed = player_speed * 1.1;

                // Attempt tackle if close enough
                if (min_dist < 25) {
                    attempt_tackle(id, target);
                }
            }

            x += lengthdir_x(chase_speed, dir);
            y += lengthdir_y(chase_speed, dir);
        }
    }

    // Move basket
    ai_move_basket();
}

/// @function attempt_tackle(defender, ball_carrier)
/// @param {Id.Instance} defender - Defender attempting tackle
/// @param {Id.Instance} ball_carrier - Player with ball
function attempt_tackle(defender, ball_carrier) {
    // Cooldown check
    if (variable_instance_exists(defender, "tackle_cooldown")) {
        if (defender.tackle_cooldown > 0) return;
    }

    var cpu_team = get_team(global.cpu_team_id);
    var tackle_chance = cpu_team.tackle_chance;

    if (random(1) < tackle_chance) {
        // Successful tackle!
        with (obj_game_controller) {
            play_stopped("TACKLE");
        }
    }

    // Set cooldown regardless
    defender.tackle_cooldown = 60;  // 1 second cooldown
}

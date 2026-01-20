/// @description Core game logic and state management

/// @function init_game()
/// @description Initialize a new game
function init_game() {
    // Game state
    global.game_state = "PRE_PLAY";  // PRE_PLAY, PLAYING, POST_PLAY, HALFTIME, GAMEOVER, SHOOTOUT

    // Match settings
    global.current_half = 1;
    global.half_duration = 5 * 60 * 60;  // 5 minutes at 60fps
    global.game_timer = global.half_duration;
    global.shot_clock = 24 * 60;  // 24 seconds
    global.shot_clock_max = 24 * 60;

    // Possession
    global.offense_team = 0;  // 0 = player's team, 1 = CPU team
    global.current_down = 1;
    global.max_downs = 4;

    // Scores
    global.score_player = 0;
    global.score_cpu = 0;

    // Selected distance
    global.selected_distance = 20;  // Default 20 yards
    global.point_value = 20;

    // Ball carrier reference
    global.ball_carrier = noone;

    // Shootout state
    global.shootout_round = 0;
    global.shootout_player_score = 0;
    global.shootout_cpu_score = 0;
    global.shootout_turn = 0;  // 0 = player, 1 = cpu
}

/// @function start_play()
/// @description Begin a new play after distance selection
function start_play() {
    global.game_state = "PLAYING";
    global.shot_clock = global.shot_clock_max;

    // Position basket at selected distance
    with (obj_basket) {
        // Convert yards to pixels (field is ~600 pixels for 50 yards)
        var pixels_per_yard = room_height * 0.7 / 50;
        y = 100 + (global.selected_distance * pixels_per_yard);
    }

    // Reset player positions
    reset_player_positions();

    // Give ball to starting player
    setup_ball_carrier();
}

/// @function reset_player_positions()
/// @description Reset all players to starting positions
function reset_player_positions() {
    var offense_y = 80;
    var defense_y = 100 + (global.selected_distance * (room_height * 0.7 / 50)) + 60;

    var player_index = 0;

    with (obj_player) {
        var spacing = room_width / 8;
        var player_num = player_index mod 7;
        x = spacing + (player_num * spacing);

        if ((global.offense_team == 0 && team_id == global.player_team_id) ||
            (global.offense_team == 1 && team_id == global.cpu_team_id)) {
            // Offense
            y = offense_y;
            is_offense = true;
        } else {
            // Defense
            y = defense_y;
            is_offense = false;
        }

        is_ball_carrier = false;
        player_index++;
    }
}

/// @function setup_ball_carrier()
/// @description Give ball to center offensive player
function setup_ball_carrier() {
    var center_x = room_width / 2;
    var closest_player = noone;
    var closest_dist = 9999;

    with (obj_player) {
        if (is_offense) {
            var dist = abs(x - center_x);
            if (dist < closest_dist) {
                closest_dist = dist;
                closest_player = id;
            }
        }
    }

    if (closest_player != noone) {
        closest_player.is_ball_carrier = true;
        global.ball_carrier = closest_player;

        with (obj_ball) {
            holder = closest_player;
            state = "HELD";
            x = closest_player.x;
            y = closest_player.y;
        }
    }
}

/// @function shot_made()
/// @description Handle successful shot
function shot_made() {
    // Award points
    if (global.offense_team == 0) {
        global.score_player += global.point_value;
    } else {
        global.score_cpu += global.point_value;
    }

    // Show celebration (brief pause)
    global.game_state = "POST_PLAY";
    alarm[0] = 90;  // 1.5 second pause

    // Will switch possession after alarm
    global.switch_possession = true;
}

/// @function shot_missed()
/// @description Handle missed shot
function shot_missed() {
    global.game_state = "POST_PLAY";
    alarm[0] = 60;  // 1 second pause

    // Next down or turnover
    global.current_down++;
    if (global.current_down > global.max_downs) {
        global.switch_possession = true;
        global.current_down = 1;
    } else {
        global.switch_possession = false;
    }
}

/// @function play_stopped(reason)
/// @param {String} reason - Why play stopped (TACKLE, INTERCEPTION, SHOT_CLOCK)
function play_stopped(reason) {
    global.game_state = "POST_PLAY";
    alarm[0] = 60;

    if (reason == "TACKLE" || reason == "SHOT_CLOCK") {
        global.current_down++;
        if (global.current_down > global.max_downs) {
            global.switch_possession = true;
            global.current_down = 1;
        } else {
            global.switch_possession = false;
        }
    } else if (reason == "INTERCEPTION") {
        global.switch_possession = true;
        global.current_down = 1;
    }
}

/// @function switch_possession()
/// @description Switch which team is on offense
function switch_possession() {
    global.offense_team = (global.offense_team + 1) mod 2;
    global.current_down = 1;
    global.game_state = "PRE_PLAY";
}

/// @function update_game_timer()
/// @description Update game clock each frame
function update_game_timer() {
    if (global.game_state == "PLAYING") {
        global.game_timer--;
        global.shot_clock--;

        // Shot clock violation
        if (global.shot_clock <= 0) {
            play_stopped("SHOT_CLOCK");
        }

        // Half/game end
        if (global.game_timer <= 0) {
            if (global.current_half == 1) {
                start_halftime();
            } else {
                end_game();
            }
        }
    }
}

/// @function start_halftime()
/// @description Begin halftime break
function start_halftime() {
    global.game_state = "HALFTIME";
    global.current_half = 2;
    global.game_timer = global.half_duration;

    // Trailing team gets possession choice (simplified: just switch)
    global.offense_team = (global.offense_team + 1) mod 2;
    global.current_down = 1;
}

/// @function end_game()
/// @description Handle end of regulation
function end_game() {
    if (global.score_player == global.score_cpu) {
        // Tie - go to shootout
        start_shootout();
    } else {
        global.game_state = "GAMEOVER";
    }
}

/// @function start_shootout()
/// @description Begin shootout tiebreaker
function start_shootout() {
    global.game_state = "SHOOTOUT";
    global.selected_distance = 20;  // Fixed at 20 yards
    global.point_value = 20;
    global.shootout_round = 1;
    global.shootout_player_score = 0;
    global.shootout_cpu_score = 0;
    global.shootout_turn = 0;

    room_goto(rm_shootout);
}

/// @function format_time(frames)
/// @param {Real} frames - Time in frames
/// @returns {String} Formatted time string (M:SS)
function format_time(frames) {
    var total_seconds = floor(frames / 60);
    var minutes = floor(total_seconds / 60);
    var seconds = total_seconds mod 60;

    var sec_str = (seconds < 10) ? "0" + string(seconds) : string(seconds);
    return string(minutes) + ":" + sec_str;
}

/// @function format_shot_clock(frames)
/// @param {Real} frames - Shot clock in frames
/// @returns {String} Shot clock seconds
function format_shot_clock(frames) {
    var seconds = ceil(frames / 60);
    return string(seconds);
}

/// @function select_distance(yards)
/// @param {Real} yards - Distance in yards (5, 10, 15, etc.)
function select_distance(yards) {
    global.selected_distance = clamp(yards, 5, 50);
    global.point_value = global.selected_distance;
}

/// @function get_distance_difficulty(yards)
/// @param {Real} yards - Distance in yards
/// @returns {String} Difficulty label
function get_distance_difficulty(yards) {
    if (yards <= 10) return "Easy";
    if (yards <= 20) return "Medium";
    if (yards <= 35) return "Hard";
    if (yards <= 45) return "Very Hard";
    return "HEROIC";
}

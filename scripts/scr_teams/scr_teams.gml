/// @description Team management functions

/// @function init_teams()
/// @description Initialize all teams with randomized tiers
function init_teams() {
    global.teams = array_create(4);

    // Base team visual data (names and colors stay fixed)
    var team_names = ["Blaze Battalion", "Thunder Wolves", "Frost Giants", "Shadow Hawks"];
    var team_colors = [c_red, c_purple, c_aqua, c_gray];
    var team_colors_secondary = [c_orange, c_white, c_white, c_black];

    // Tier stats (will be randomly assigned)
    var tier_stats = [
        { shooting: 0.70, defense: 85, basket_speed: 5, tackle_chance: 0.35 },  // Tier 1 (Best)
        { shooting: 0.55, defense: 70, basket_speed: 4, tackle_chance: 0.28 },  // Tier 2
        { shooting: 0.45, defense: 55, basket_speed: 3, tackle_chance: 0.20 },  // Tier 3
        { shooting: 0.35, defense: 40, basket_speed: 2, tackle_chance: 0.12 }   // Tier 4 (Worst)
    ];

    // Create shuffled tier indices
    var tiers = [0, 1, 2, 3];

    // Fisher-Yates shuffle
    for (var i = 3; i > 0; i--) {
        var j = irandom(i);
        var temp = tiers[i];
        tiers[i] = tiers[j];
        tiers[j] = temp;
    }

    // Assign shuffled tiers to teams
    for (var i = 0; i < 4; i++) {
        var assigned_tier = tiers[i];
        var stats = tier_stats[assigned_tier];

        global.teams[i] = {
            id: i,
            name: team_names[i],
            color_primary: team_colors[i],
            color_secondary: team_colors_secondary[i],
            tier: assigned_tier + 1,  // 1-4 (hidden from player)
            shooting: stats.shooting,
            defense: stats.defense,
            basket_speed: stats.basket_speed,
            tackle_chance: stats.tackle_chance
        };
    }
}

/// @function get_team(index)
/// @param {Real} index - Team index (0-3)
/// @returns {Struct} Team data
function get_team(index) {
    return global.teams[index];
}

/// @function get_team_color(index)
/// @param {Real} index - Team index (0-3)
/// @returns {Constant.Color} Primary team color
function get_team_color(index) {
    return global.teams[index].color_primary;
}

/// @function get_team_name(index)
/// @param {Real} index - Team index (0-3)
/// @returns {String} Team name
function get_team_name(index) {
    return global.teams[index].name;
}

/// @function get_team_shooting(index)
/// @param {Real} index - Team index (0-3)
/// @returns {Real} Shooting accuracy (0-1)
function get_team_shooting(index) {
    return global.teams[index].shooting;
}

/// @function get_team_basket_speed(index)
/// @param {Real} index - Team index (0-3)
/// @returns {Real} Basket movement speed
function get_team_basket_speed(index) {
    return global.teams[index].basket_speed;
}

/// @function get_team_tackle_chance(index)
/// @param {Real} index - Team index (0-3)
/// @returns {Real} Tackle success chance
function get_team_tackle_chance(index) {
    return global.teams[index].tackle_chance;
}

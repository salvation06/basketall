# basketALL - CPU Defense AI Documentation

## Overview

The CPU defense AI is implemented in `scripts/scr_ai_behavior/scr_ai_behavior.gml` and consists of three main components:

1. **Defender Movement AI** - 6 CPU players chase and tackle
2. **Basket Movement AI** - 1 CPU-controlled moving hoop
3. **Tackle System** - Probability-based tackle attempts

---

## 1. Defender Movement AI

### Function: `ai_defense_update()`

Called every frame when the **player is on offense**.

### How It Works:

```
FOR EACH CPU DEFENDER:
    1. Find the closest offensive player
    2. Move towards that player
    3. If target has the ball → move faster (1.1x speed)
    4. If within 25 pixels → attempt tackle
```

### Code Logic:

```gml
// Each defender finds closest offensive player
with (obj_player) {
    if (team_id != global.cpu_team_id) continue;  // Only CPU players

    // Find closest offensive player to guard
    var target = noone;
    var min_dist = 9999;

    with (obj_player) {
        if (is_offense) {
            var dist = point_distance(x, y, other.x, other.y);
            if (dist < min_dist) {
                min_dist = dist;
                target = id;
            }
        }
    }

    // Chase the target
    if (target != noone) {
        var dir = point_direction(x, y, target.x, target.y);
        var chase_speed = player_speed * 0.8;  // Normal speed

        // Faster if chasing ball carrier
        if (target.is_ball_carrier) {
            chase_speed = player_speed * 1.1;

            // Attempt tackle if close
            if (min_dist < 25) {
                attempt_tackle(id, target);
            }
        }

        // Move towards target
        x += lengthdir_x(chase_speed, dir);
        y += lengthdir_y(chase_speed, dir);
    }
}
```

### Speed Modifiers:
| Situation | Speed Multiplier |
|-----------|------------------|
| Guarding non-carrier | 0.8x |
| Chasing ball carrier | 1.1x |

---

## 2. Basket Movement AI

### Function: `ai_move_basket()`

The **key defensive mechanic** - the basket actively dodges shots!

### Three Behavior Modes:

#### Mode A: Shot Dodging (Highest Priority)
When a shot is in the air:
```gml
if (ball.state == "SHOOTING") {
    // Move AWAY from where the ball is aimed
    var dodge_dir = sign(x - ball.target_x);
    x += dodge_dir * move_speed * 2;  // 2x speed when dodging!
}
```

#### Mode B: Carrier Tracking
When ball is held by a player:
```gml
if (ball.state == "HELD") {
    // Move OPPOSITE to ball carrier position
    if (ball_carrier_x < center) {
        move_direction = 1;   // Carrier on left → basket goes right
    } else {
        move_direction = -1;  // Carrier on right → basket goes left
    }
    x += move_direction * move_speed;
}
```

#### Mode C: Default Oscillation
When ball is loose or no specific threat:
```gml
// Simple back-and-forth pattern
x += move_direction * move_speed;

if (x > base_x + move_range) {
    move_direction = -1;
} else if (x < base_x - move_range) {
    move_direction = 1;
}
```

### Basket Speed by Team Tier:
| Tier | Team Quality | Basket Speed |
|------|--------------|--------------|
| 1 | Best | 5 (fast) |
| 2 | Good | 4 |
| 3 | Average | 3 |
| 4 | Worst | 2 (slow) |

---

## 3. Tackle System

### Function: `attempt_tackle(defender, ball_carrier)`

### Tackle Probability by Team Tier:
| Tier | Tackle Chance |
|------|---------------|
| 1 (Best) | 35% |
| 2 | 28% |
| 3 | 20% |
| 4 (Worst) | 12% |

### How Tackles Work:

```gml
function attempt_tackle(defender, ball_carrier) {
    // Prevent spam - 1 second cooldown
    if (defender.tackle_cooldown > 0) return;

    // Get team's tackle chance
    var cpu_team = get_team(global.cpu_team_id);
    var tackle_chance = cpu_team.tackle_chance;

    // Roll for success
    if (random(1) < tackle_chance) {
        // SUCCESS - stop the play!
        play_stopped("TACKLE");
    }

    // Set 60-frame (1 second) cooldown
    defender.tackle_cooldown = 60;
}
```

### Tackle Conditions:
1. Defender must be within **25 pixels** of ball carrier
2. Defender's `tackle_cooldown` must be 0
3. Random roll must be under team's `tackle_chance`

---

## 4. CPU Offense AI (Bonus)

When CPU has the ball, `ai_offense_update()` handles:

### Decision Making:
```
EACH FRAME:
    1. Calculate shot clock pressure (0 to 1)
    2. Evaluate shot angle quality
    3. Decide: SHOOT, PASS, or MOVE

    IF shot_clock_pressure > 70% → FORCE SHOT
    IF good_angle AND random_check → TAKE SHOT
    IF 2% random chance → PASS
    ELSE → MOVE towards basket
```

### CPU Distance Selection:
Better teams attempt longer (riskier) shots:

| Tier | Distance Choices |
|------|------------------|
| 1 (Best) | 25, 30, 35, 40, 45 yds |
| 2 | 20, 25, 30, 35 yds |
| 3 | 15, 20, 25, 30 yds |
| 4 (Worst) | 10, 15, 20 yds |

---

## AI Difficulty Scaling

The AI difficulty is **automatically tied to team tiers**:

### Tier 1 (Best Team):
- Basket moves fast (speed 5)
- 35% tackle chance
- Attempts 25-45 yard shots
- Shot power variance: ±3%

### Tier 4 (Worst Team):
- Basket moves slow (speed 2)
- 12% tackle chance
- Attempts 10-20 yard shots
- Shot power variance: ±10%

---

## Visual Diagram: Defense AI Flow

```
┌─────────────────────────────────────────────────────────┐
│                    PLAYER ON OFFENSE                     │
└─────────────────────────────────────────────────────────┘
                           │
                           ▼
         ┌─────────────────┴─────────────────┐
         │                                   │
         ▼                                   ▼
┌─────────────────┐               ┌─────────────────────┐
│  6 DEFENDERS    │               │  BASKET MOVER AI    │
│  (ai_defense)   │               │  (ai_move_basket)   │
└────────┬────────┘               └──────────┬──────────┘
         │                                   │
         ▼                                   ▼
┌─────────────────┐               ┌─────────────────────┐
│ Find closest    │               │ Ball shooting?      │
│ offensive player│               │   → DODGE shot      │
└────────┬────────┘               │ Ball held?          │
         │                        │   → Move OPPOSITE   │
         ▼                        │ Otherwise?          │
┌─────────────────┐               │   → OSCILLATE      │
│ Chase target    │               └─────────────────────┘
│ (0.8x speed)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Has ball?       │──No──► Continue chase
└────────┬────────┘
         │ Yes
         ▼
┌─────────────────┐
│ Chase faster    │
│ (1.1x speed)    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Within 25px?    │──No──► Continue chase
└────────┬────────┘
         │ Yes
         ▼
┌─────────────────┐
│ attempt_tackle()│
│ Roll vs chance  │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
 SUCCESS    FAIL
    │         │
    ▼         ▼
 STOP      Cooldown
 PLAY      1 second
```

---

## Customization Tips

### Make Defense Harder:
```gml
// In scr_teams.gml, increase tackle chances:
{ tackle_chance: 0.50 }  // 50% instead of 35%

// In ai_move_basket(), increase dodge speed:
x += dodge_dir * move_speed * 3;  // 3x instead of 2x
```

### Make Defense Easier:
```gml
// Reduce tackle chances:
{ tackle_chance: 0.15 }

// Slow down basket:
basket.move_speed = 1;

// Reduce chase speed:
chase_speed = player_speed * 0.5;
```

---

## Summary

| Component | What It Does | Key Variables |
|-----------|--------------|---------------|
| `ai_defense_update()` | Defenders chase players | `chase_speed`, `min_dist` |
| `ai_move_basket()` | Basket dodges shots | `move_speed`, `move_range` |
| `attempt_tackle()` | Random tackle rolls | `tackle_chance`, `cooldown` |

The CPU defense creates challenge through:
1. **Pressure** - Defenders close in on ball carrier
2. **Unpredictability** - Basket moves to dodge shots
3. **Risk** - Tackle attempts can stop your play

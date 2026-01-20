# basketALL

**Where Basketball Meets Football!**

A 7v7 hybrid sports game for the Reddit Daily Games Hackathon 2026.

## Game Overview

basketALL combines the shooting mechanics of basketball with the field dynamics of football. Score by shooting a basketball through a **moving hoop** while the defense tries to stop you!

## How to Play

### Offense
- **WASD/Arrows**: Move your player
- **Click on teammate**: Pass the ball
- **Hold SPACE**: Charge shot power
- **Release SPACE**: Shoot at the basket
- **TAB**: Switch controlled player

### Rules
- You get **4 downs** to score
- Choose your shot distance (5-50 yards)
- Distance = Points (30 yards = 30 points)
- 24-second shot clock per play
- Score to switch possession
- Miss/Tackle = next down (or turnover on 4th)

### Defense (CPU)
- The basket **moves** to dodge shots
- Defenders will try to **tackle** the ball carrier
- Shots can be **blocked**

## Teams

4 teams with **hidden skill tiers** - you won't know which team is strongest!

- Blaze Battalion (Red)
- Thunder Wolves (Purple)
- Frost Giants (Aqua)
- Shadow Hawks (Gray)

Tiers are randomized each game.

## Technical Requirements

- **GameMaker**: 2024.1400.3 or later
- **Node.js**: 22.2.0 or later
- **Platform**: Reddit (Devvit Web)

## Building for Reddit

1. Open the project in GameMaker 2024.1400.3+
2. Go to **File → Create Executable → Reddit**
3. Test locally: `devvit playtest`
4. Upload: `devvit upload`
5. Publish: `devvit publish`

## Project Structure

```
basketALL/
├── basketALL.yyp         # GameMaker project file
├── devvit.yaml           # Reddit Devvit config
├── package.json          # Node.js config
├── scripts/              # GML scripts
│   ├── scr_game_logic/   # Core game mechanics
│   ├── scr_shooting/     # Shot system
│   ├── scr_ai_behavior/  # CPU AI
│   ├── scr_teams/        # Team management
│   └── scr_input/        # Player controls
├── objects/              # Game objects
│   ├── obj_game_controller/
│   ├── obj_player/
│   ├── obj_ball/
│   ├── obj_basket/
│   ├── obj_field/
│   ├── obj_hud/
│   └── obj_menu_controller/
└── rooms/                # Game rooms
    ├── rm_menu/
    ├── rm_team_select/
    ├── rm_game/
    └── rm_shootout/
```

## Hackathon Info

Created for the **Reddit Daily Games Hackathon 2026**
- Dates: January 15 - February 12, 2026
- Prize Pool: $40,000
- Special Award: Best GameMaker Game

## License

MIT License

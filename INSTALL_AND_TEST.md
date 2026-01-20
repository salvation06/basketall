# basketALL - Installation & Testing Guide

## Prerequisites

Before you begin, ensure you have:

### Required Software
| Software | Version | Download |
|----------|---------|----------|
| **GameMaker** | 2024.1400.3+ | [gamemaker.io](https://gamemaker.io) |
| **Node.js** | 22.2.0+ | [nodejs.org](https://nodejs.org) |
| **Devvit CLI** | Latest | Installed via npm |

### Verify Node.js Version
```bash
node --version
# Should output: v22.2.0 or higher
```

---

## Installation Steps

### Step 1: Install Devvit CLI
```bash
npm install -g devvit
```

### Step 2: Login to Reddit Developer Portal
```bash
devvit login
```
This opens a browser for Reddit authentication.

### Step 3: Open Project in GameMaker

1. Launch **GameMaker 2024.1400.3+**
2. Go to **File → Open Project**
3. Navigate to `C:\Users\18325\basketALL\`
4. Select `basketALL.yyp`
5. Click **Open**

### Step 4: Install Reddit Extension for GameMaker

1. In GameMaker, go to **Marketplace**
2. Search for "Reddit" or "Devvit"
3. Install the **Reddit Games Extension**
4. Restart GameMaker if prompted

---

## Testing Locally (GameMaker)

### Run in GameMaker IDE
1. Press **F5** or click the **Play** button
2. The game will launch in a test window
3. Test all features:
   - Menu navigation
   - Team selection
   - Gameplay mechanics
   - Shootout mode

### Debug Controls (Development Only)
| Key | Action |
|-----|--------|
| F1 | Show debug overlay |
| F2 | Skip to halftime |
| F3 | Force shootout |

---

## Testing on Reddit (Devvit Playtest)

### Step 1: Export from GameMaker
1. Go to **File → Create Executable → Reddit**
2. Select output folder (project root)
3. Wait for export to complete

### Step 2: Initialize Devvit (First Time Only)
```bash
cd C:\Users\18325\basketALL
npm install
```

### Step 3: Run Playtest
```bash
devvit playtest
```
This will:
- Create a test subreddit
- Upload your game
- Open it in a browser

### Step 4: Test on Reddit
1. The playtest URL will be displayed in terminal
2. Open the URL in your browser
3. Test the game as a Reddit post
4. Check for any Reddit-specific issues

---

## Uploading to Reddit

### Upload (Private)
```bash
devvit upload
```
This uploads a private version for testing.

### Publish (Public)
```bash
devvit publish
```
This makes your app available for subreddit installation.

---

## Troubleshooting

### GameMaker Won't Open Project
- Ensure you have GameMaker **2024.1400.3** or later
- Try: Help → Clear Cache and restart

### Node.js Version Error
```bash
# Install Node Version Manager (nvm) then:
nvm install 22.2.0
nvm use 22.2.0
```

### Devvit Login Failed
```bash
devvit logout
devvit login
```

### Export to Reddit Missing
- Verify Reddit extension is installed in GameMaker
- Check: Tools → Extension Packages

### Game Runs Slow on Reddit
- Reduce room size (currently 800x600)
- Optimize draw calls
- Test on different browsers

---

## Project File Structure

```
C:\Users\18325\basketALL\
│
├── basketALL.yyp          # GameMaker project file (OPEN THIS)
├── devvit.yaml            # Reddit app configuration
├── package.json           # Node.js dependencies
├── README.md              # General documentation
├── INSTALL_AND_TEST.md    # This file
│
├── scripts/               # GML game logic
│   ├── scr_game_logic/    # Core mechanics
│   ├── scr_shooting/      # Shot system
│   ├── scr_ai_behavior/   # CPU AI (see below)
│   ├── scr_teams/         # Team data
│   └── scr_input/         # Player controls
│
├── objects/               # Game objects
│   ├── obj_game_controller/
│   ├── obj_player/
│   ├── obj_ball/
│   ├── obj_basket/
│   ├── obj_field/
│   ├── obj_hud/
│   └── obj_menu_controller/
│
└── rooms/                 # Game screens
    ├── rm_menu/
    ├── rm_team_select/
    ├── rm_game/
    └── rm_shootout/
```

---

## Quick Test Checklist

- [ ] GameMaker opens project without errors
- [ ] Game runs with F5 (no crashes)
- [ ] Menu displays correctly
- [ ] Can select a team
- [ ] Game starts with distance selection
- [ ] Players move with WASD
- [ ] Ball passes to clicked teammate
- [ ] Shot power meter appears on SPACE hold
- [ ] Basket moves during play
- [ ] CPU defenders chase ball carrier
- [ ] Tackles stop play
- [ ] Score updates correctly
- [ ] Down counter works (1-4)
- [ ] Shot clock counts down
- [ ] Halftime screen appears
- [ ] Game over shows winner
- [ ] Shootout works on tie

---

## Support

- **GameMaker Docs**: [manual.gamemaker.io](https://manual.gamemaker.io)
- **Devvit Docs**: [developers.reddit.com](https://developers.reddit.com)
- **Hackathon**: [redditdailygames2026.devpost.com](https://redditdailygames2026.devpost.com)

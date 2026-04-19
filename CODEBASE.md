# Pixel Adventure - Codebase Documentation

> **Last Updated:** November 23, 2025

## Overview

This is a **2D platformer game** built with **Flutter** and the **Flame game engine**. It features multiple playable characters, 5 levels, enemies, collectibles, and a complete game loop with menus, pause functionality, and persistent save data.

---

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── pixel_adventure.dart         # Main game class (FlameGame)
├── components/                  # Game entities
│   ├── player.dart             # Player character
│   ├── chicken.dart            # Enemy (Chicken)
│   ├── fruit.dart              # Collectible items
│   ├── saw.dart                # Moving trap/obstacle
│   ├── checkpoint.dart         # Level end checkpoint
│   ├── collision_block.dart    # Collision boxes
│   ├── background_tile.dart    # Scrolling background
│   ├── level.dart              # Level loader (TMX)
│   ├── custom_hitbox.dart      # Custom collision box
│   ├── jump_button.dart        # Touch jump button
│   └── utils.dart              # Collision utilities
├── managers/
│   ├── game_manager.dart       # Game state & score
│   ├── level_manager.dart      # Level progression
│   ├── save_manager.dart       # Persistence (SharedPreferences)
│   └── analytics_manager.dart  # Event tracking
├── widgets/
│   ├── joystick.dart           # Mobile joystick control
│   ├── joystick_stick.dart     # Custom joystick stick
│   ├── white_space.dart        # UI spacing widget
│   ├── ball.dart               # UI component
│   ├── buttons/
│   │   ├── animated_game_button.dart
│   │   ├── character_button.dart
│   │   ├── level_button.dart
│   │   └── menu_button.dart
│   ├── displays/
│   │   ├── score_display.dart
│   │   ├── lives_display.dart
│   │   └── level_display.dart
│   └── overlays/
│       ├── main_menu_overlay.dart
│       ├── level_overlay.dart
│       ├── game_overlay.dart
│       ├── pause_overlay.dart
│       ├── game_over_overlay.dart
│       └── the_end_overlay.dart
└── constants/
    ├── game_constants.dart     # Physics, animation, UI constants
    └── asset_paths.dart        # Asset path strings
```

---

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flame` | ^1.8.2 | Game engine |
| `flame_tiled` | ^1.13.0 | TMX tilemap loader |
| `flame_audio` | ^2.1.1 | Sound effects |
| `flutter_joystick` | ^0.0.4 | Mobile joystick controls |
| `shared_preferences` | ^2.2.2 | Persistent storage |

---

## Architecture

### 1. Entry Point (`main.dart:13-68`)

- Sets fullscreen landscape mode via `Flame.device`
- Creates a `GameWidget` wrapping `PixelAdventure`
- Registers 6 overlay widgets for different game states

### 2. Game Class (`pixel_adventure.dart:21-341`)

The `PixelAdventure` class extends `FlameGame` with mixins:
- `HasKeyboardHandlerComponents` - Keyboard input
- `DragCallbacks` - Touch/drag input
- `HasCollisionDetection` - Collision system
- `TapCallbacks` - Tap input

**Key properties:**
- `player` - The current player instance
- `character` - Selected character enum (4 options)
- `gameManager` - Handles score, lives, game state
- `levelManager` - Handles level progression (5 levels)
- `saveManager` - Persistent storage
- `analytics` - Event tracking

**Game States** (enum in `game_manager.dart:5`):
- `intro` → Main menu
- `pickLevel` → Level selection
- `playing` → Active gameplay
- `paused` → Game paused
- `gameOver` → Player lost
- `theEnd` → Game completed

### 3. Level Loading (`level.dart:14-135`)

Levels are loaded from **Tiled TMX files** (`assets/tiles/Level-XX.tmx`). The `Level` class:
- Loads the TMX tilemap
- Spawns objects from the "Spawnpoints" layer (Player, Fruit, Saw, Checkpoint, Chicken)
- Creates collision blocks from the "Collisions" layer (Platform, Wall, Block)
- Sets up scrolling background from "Background" layer property

---

## Game Components

### Player (`player.dart:31-406`)

**States:** idle, running, jumping, doubleJumping, wallJumping, wallIdle, falling, hit, appearing, disappearing

**Features:**
- Double-jump (max 2 jumps)
- Wall sliding (reduced gravity)
- Keyboard controls (WASD/Arrow keys + Space)
- Mobile joystick support
- Fixed timestep physics (60 FPS)
- Sprite animations per character

**Physics Constants:**
- Gravity: `9.8`
- Jump force: `260.0`
- Terminal velocity: `300.0`
- Move speed: `100.0`

### Enemies

**Chicken (`chicken.dart:14-152`):**
- Patrols within a defined range (`offNeg`/`offPos`)
- Chases player when in range
- Can be stomped (killed) by jumping on it
- Damages player on side collision

### Traps

**Saw (`saw.dart:7-81`):**
- Moves horizontally or vertically
- Defined range via `offNeg`/`offPos` properties
- Causes player respawn on contact

### Collectibles

**Fruit (`fruit.dart:10-75`):**
- Multiple fruit types (Apple, etc.)
- Increases score when collected
- Plays "Collected" animation on pickup
- Plays pickup sound

### Level Completion

**Checkpoint (`checkpoint.dart:8-71`):**
- Flag animation when reached
- Triggers level transition
- Player disappears animation

---

## Managers

### GameManager (`game_manager.dart`)
- Tracks `score` (ValueNotifier)
- Tracks `livesRemaining` (ValueNotifier, starts at 3)
- Manages `GameState` enum
- Stores selected `character`

### LevelManager (`level_manager.dart`)
- Manages 10 levels: `Level-01` through `Level-10`
- Validates level files during preload
- Tracks `currentLevel` (ValueNotifier)
- Handles level progression and win condition

### SaveManager (`save_manager.dart`)
Persists via `SharedPreferences`:
- High score
- Highest level completed
- Sound enabled/volume
- Last selected character
- Total play time
- Games played count

---

## UI System

The game uses **Flutter overlays** on top of the Flame `GameWidget`:

| Overlay | Purpose |
|---------|---------|
| `mainMenuOverlay` | Character selection + start |
| `levelOverlay` | Level selection grid |
| `gameOverlay` | HUD (score, lives, level, pause, joystick, jump) |
| `pauseOverlay` | Pause menu |
| `gameOverOverlay` | Game over screen |
| `theEndOverlay` | Victory screen |

### Controls (Mobile)
- **Joystick** (bottom-left) - Horizontal movement
- **Jump button** (bottom-right) - Jump action
- **Pause button** (top-right) - Toggle pause

---

## Assets

### Images (`assets/images/`)
- `Background/` - Scrolling background tiles (Blue, Brown, Gray, Green, Pink, Purple, Yellow)
- `Main Characters/` - 4 characters (maskDude, ninjaFrog, pinkMan, virtualGuy) with sprite sheets
- `Enemies/Chicken/` - Chicken enemy sprites
- `Items/Fruits/` - Collectible fruit sprites
- `Items/Checkpoints/` - Checkpoint flag animations
- `Traps/Saw/` - Saw trap sprites
- `Terrain/` - Tileset sprites
- `HUD/` - Jump button
- `Menu/` - Buttons, level icons, text

### Audio (`assets/audio/`)
- `hit.wav` - Player hit
- `jump.wav` - Jump sound
- `pickupFruit.wav` - Fruit collected
- `disappear.wav` - Level complete
- `hitEnemy.wav` - Enemy stomped
- `click.wav` - UI click

### Levels (`assets/tiles/`)
- `Level-01.tmx` through `Level-10.tmx` (10 playable levels)
- `TheEnd.tmx` - End screen level
- `Pixel Adventure.tsx` - Main tileset
- `Terrain (amber).tsx` - Amber color tileset

**Level Themes:**
| Level | Background Color | Features |
|-------|-----------------|----------|
| 1 | Gray | Introduction, saws, platforms |
| 2 | Gray | Chicken enemy, vertical saw |
| 3 | Brown | Wall jumping, simple layout |
| 4 | Green | Wall corridors, many fruits |
| 5 | Brown | Basic platforming |
| 6 | Blue | Multiple pillars, chicken, saws |
| 7 | Purple | Platforming challenge, moving saw |
| 8 | Pink | Triple pillars, two chickens, three saws |
| 9 | Yellow | Ascending platforms, vertical saws |
| 10 | Gray | Final challenge, multiple enemies and saws |

### Fonts
- `MinecraftEvenings` - Title/menu text
- `AtariClassic` - Various weights

---

## Game Flow

```
App Start
    ↓
onLoad() - Preload all assets & levels
    ↓
MainMenuOverlay (character select)
    ↓
LevelOverlay (level select)
    ↓
startGame() → loadNextLevel()
    ↓
GameOverlay (HUD active)
    ↓
[Playing Loop]
  ├─ Collect fruit → +1 score
  ├─ Hit enemy/saw → -1 life, respawn
  ├─ Reach checkpoint → next level
  └─ Lives = 0 → GameOver
    ↓
Level 5 complete → TheEnd
```

---

## Notable Implementation Details

1. **Fixed Timestep Physics** (`player.dart:88-101`) - Uses accumulated time for consistent physics at 60 FPS regardless of frame rate

2. **Spatial Collision Optimization** (`player.dart:240-244`) - Only checks collision blocks within 500 units of player

3. **Level Preloading** (`pixel_adventure.dart:304-340`) - Validates all TMX files at startup to catch missing levels early

4. **ValueNotifier Pattern** - Score, lives, and level use `ValueNotifier` for reactive UI updates

5. **Character Enum** (`pixel_adventure.dart:19`) - Clean enum-based character selection: `ninjaFrog`, `maskDude`, `pinkMan`, `virtualGuy`

---

## Changelog

### November 23, 2025 (Update 2)
- Added 5 new levels (Level-06 through Level-10) with progressive difficulty
- Updated LevelManager to support 10 levels
- Updated level overlay to use Wrap layout for better display of multiple levels
- Fixed TheEndOverlay layout overflow issue

### November 23, 2025
- Initial documentation created
- Current features: 5 levels, 4 characters, chicken enemy, saw traps, fruit collectibles
- Save system implemented with SharedPreferences
- Analytics tracking in place

---

## Future Updates

<!-- Add notes about planned features or changes here -->


import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LevelManager extends Component with HasGameReference<PixelAdventure> {
  LevelManager({this.selectedLevel = 1, this.level = 1}) {
    currentLevel = ValueNotifier(level);
  }

  int selectedLevel; // level that the player selects at the beginning
  int level; // current level
  late ValueNotifier<int> currentLevel;
  bool reachedEnd = false;

  final Map<int, String> levelsConfig = {
    1: "Level-01",
    2: "Level-02",
    3: "Level-03",
    4: "Level-04",
    //Temporarily disabled corrupted levels 5-10
    5: "Level-05",
    6: "Level-06",
    7: "Level-07",
    8: "Level-08",
    9: "Level-09",
    10: "Level-10"
  };

  // Track which levels have been successfully validated/loaded
  final Set<int> _validatedLevels = {};

  Map<int, String> get levels => (levelsConfig);

  /// Get the count of validated levels
  int get validatedLevelCount => _validatedLevels.length;

  /// Validates that a level exists and has been successfully preloaded
  bool isLevelValid(int levelNumber) {
    return levelsConfig.containsKey(levelNumber) &&
           _validatedLevels.contains(levelNumber);
  }

  /// Mark a level as validated after successful preload
  void markLevelAsValidated(int levelNumber) {
    if (levelsConfig.containsKey(levelNumber)) {
      _validatedLevels.add(levelNumber);
    }
  }

  /// Get the next valid level number, or null if no more levels
  int? getNextValidLevel() {
    int nextLevel = level + 1;
    if (levelsConfig.containsKey(nextLevel)) {
      return nextLevel;
    }
    return null;
  }

  void increaseLevel() {
    // Check if the next level would exist
    if (levelsConfig.containsKey(level + 1)) {
      level++;
      currentLevel.value++;
    }
    // Note: Game completion is handled by the caller (PixelAdventure.loadNextLevel)
  }

  void selectLevel(int selectLevel) {
    // Make sure we're selecting a valid level from the config
    if (levelsConfig.containsKey(selectLevel)) {
      selectedLevel = selectLevel;
      level = selectLevel;
      currentLevel.value = level;
    }
  }

  void reset() {
    level = selectedLevel;
    currentLevel.value = level;
  }

  void theEnd() {
    game.onWin();
  }

  bool checkReachedEnd() {
    return reachedEnd;
  }
}

class Difficulty {
  final int score;

  const Difficulty({required this.score});
}

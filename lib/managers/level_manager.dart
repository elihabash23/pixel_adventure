import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LevelManager extends Component with HasGameRef<PixelAdventure> {
  LevelManager({this.selectedLevel = 1, this.level = 1});

  int selectedLevel; // level that the player selects at the beginning
  int level; // current level
  late ValueNotifier<int> currentLevel;

  // Configurations for different levels of difficulty,
  // Score indicates the score needed to be acheived to "level up"
  // final Map<String, Difficulty> levelsConfig = {
  //   "Level-01": const Difficulty(score: 0),
  //   "Level-02": const Difficulty(score: 20),
  //   "Level-03": const Difficulty(score: 40),
  //   "Level-04": const Difficulty(score: 80),
  // };

  final Map<int, String> levelsConfig = {
    1: "Level-01",
    2: "Level-02",
    3: "Level-03",
    4: "Level-04",
  };

  Map<int, String> get levels => (levelsConfig);

  void increaseLevel() {
    if (level < levelsConfig.keys.length) {
      level++;
      currentLevel.value++;
    } else {
      level = 0;
    }
  }

  void selectLevel(int selectLevel) {
    if (levelsConfig.containsKey(selectLevel)) {
      selectedLevel = selectLevel;
      level = selectLevel;
      currentLevel = ValueNotifier(level - 1);
    }
  }

  void reset() {
    level = selectedLevel;
  }
}

class Difficulty {
  final int score;

  const Difficulty({required this.score});
}

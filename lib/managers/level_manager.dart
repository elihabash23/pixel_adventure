import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

class LevelManager extends Component with HasGameRef<PixelAdventure> {
  LevelManager({this.selectedLevel = 1, this.level = 1});

  int selectedLevel; // level that the player selects at the beginning
  int level; // current level

  // Configurations for different levels of difficulty,
  // Score indicates the score needed to be acheived to "level up"
  final Map<String, Difficulty> levelsConfig = {
    "Level-01": const Difficulty(score: 0),
    "Level-02": const Difficulty(score: 20),
    "Level-03": const Difficulty(score: 40),
    "Level-04": const Difficulty(score: 80),
  };

  void increaseLevel() {
    if (level < levelsConfig.keys.length) {
      level++;
    }
  }

  void setLevel(int newLevel) {
    if (levelsConfig.containsKey(newLevel)) {
      level = newLevel;
    }
  }

  void selectLevel(int selectLevel) {
    if (levelsConfig.containsKey(selectLevel)) {
      selectedLevel = selectLevel;
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

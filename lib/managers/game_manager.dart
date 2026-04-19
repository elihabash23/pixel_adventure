import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

enum GameState { intro, playing, gameOver, pickLevel, paused, theEnd }

class GameManager extends Component with HasGameRef<PixelAdventure> {
  GameManager();

  Character character = Character.maskDude;
  ValueNotifier<int> score = ValueNotifier(0);
  ValueNotifier<int> livesRemaining = ValueNotifier(3);

  GameState state = GameState.intro; // Change to intro

  bool get isPlaying => state == GameState.playing;
  bool get isGameOver => state == GameState.gameOver;
  bool get isIntro => state == GameState.intro;
  bool get isPickLevel => state == GameState.pickLevel;
  bool get isPaused => state == GameState.paused;
  bool get isTheEnd => state == GameState.theEnd;

  void reset() {
    score.value = 0;
    livesRemaining.value = 3;
    state = GameState.intro;
  }

  void resetLives() {
    livesRemaining.value = 3;
  }

  void increaseScore() {
    score.value++;
  }

  void gainLife() {
    livesRemaining.value++;
  }

  void loseLife() {
    if (livesRemaining.value > 0) {
      livesRemaining.value--;
    }
  }

    void selectCharacter(Character selectedCharacter) {
    character = selectedCharacter;
  }
}
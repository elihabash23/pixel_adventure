import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages persistent storage for game progress and settings
class SaveManager {
  static const String _keyHighScore = 'high_score';
  static const String _keyHighestLevelCompleted = 'highest_level_completed';
  static const String _keySoundEnabled = 'sound_enabled';
  static const String _keySoundVolume = 'sound_volume';
  static const String _keyLastSelectedCharacter = 'last_selected_character';
  static const String _keyTotalPlayTime = 'total_play_time';
  static const String _keyGamesPlayed = 'games_played';

  SharedPreferences? _prefs;

  /// Initialize the save manager - call this before using other methods
  Future<void> initialize() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      if (kDebugMode) {
        print('SaveManager initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing SaveManager: $e');
      }
    }
  }

  /// Check if save manager is ready
  bool get isInitialized => _prefs != null;

  // ============ High Score ============

  /// Get the highest score achieved
  int getHighScore() {
    return _prefs?.getInt(_keyHighScore) ?? 0;
  }

  /// Save a new high score if it's higher than the current one
  Future<bool> saveHighScore(int score) async {
    if (_prefs == null) return false;

    final currentHighScore = getHighScore();
    if (score > currentHighScore) {
      final success = await _prefs!.setInt(_keyHighScore, score);
      if (kDebugMode && success) {
        debugPrint('New high score saved: $score (previous: $currentHighScore)');
      }
      return success;
    }
    return false;
  }

  // ============ Level Progress ============

  /// Get the highest level completed (0 if none)
  int getHighestLevelCompleted() {
    return _prefs?.getInt(_keyHighestLevelCompleted) ?? 0;
  }

  /// Save level completion progress
  Future<bool> saveLevelCompleted(int level) async {
    if (_prefs == null) return false;

    final currentHighest = getHighestLevelCompleted();
    if (level > currentHighest) {
      final success = await _prefs!.setInt(_keyHighestLevelCompleted, level);
      if (kDebugMode && success) {
        debugPrint('Level $level completion saved (previous highest: $currentHighest)');
      }
      return success;
    }
    return false;
  }

  /// Check if a level is unlocked (based on completing previous level)
  bool isLevelUnlocked(int level) {
    if (level == 1) return true; // First level is always unlocked
    return getHighestLevelCompleted() >= level - 1;
  }

  // ============ Sound Settings ============

  /// Get sound enabled setting
  bool getSoundEnabled() {
    return _prefs?.getBool(_keySoundEnabled) ?? true;
  }

  /// Save sound enabled setting
  Future<bool> saveSoundEnabled(bool enabled) async {
    if (_prefs == null) return false;
    return await _prefs!.setBool(_keySoundEnabled, enabled);
  }

  /// Get sound volume (0.0 to 1.0)
  double getSoundVolume() {
    return _prefs?.getDouble(_keySoundVolume) ?? 1.0;
  }

  /// Save sound volume (0.0 to 1.0)
  Future<bool> saveSoundVolume(double volume) async {
    if (_prefs == null) return false;
    final clampedVolume = volume.clamp(0.0, 1.0);
    return await _prefs!.setDouble(_keySoundVolume, clampedVolume);
  }

  // ============ Character Selection ============

  /// Get last selected character name
  String? getLastSelectedCharacter() {
    return _prefs?.getString(_keyLastSelectedCharacter);
  }

  /// Save last selected character
  Future<bool> saveLastSelectedCharacter(String characterName) async {
    if (_prefs == null) return false;
    return await _prefs!.setString(_keyLastSelectedCharacter, characterName);
  }

  // ============ Statistics ============

  /// Get total play time in seconds
  int getTotalPlayTime() {
    return _prefs?.getInt(_keyTotalPlayTime) ?? 0;
  }

  /// Add play time (in seconds)
  Future<bool> addPlayTime(int seconds) async {
    if (_prefs == null) return false;
    final currentTime = getTotalPlayTime();
    return await _prefs!.setInt(_keyTotalPlayTime, currentTime + seconds);
  }

  /// Get number of games played
  int getGamesPlayed() {
    return _prefs?.getInt(_keyGamesPlayed) ?? 0;
  }

  /// Increment games played counter
  Future<bool> incrementGamesPlayed() async {
    if (_prefs == null) return false;
    final currentCount = getGamesPlayed();
    return await _prefs!.setInt(_keyGamesPlayed, currentCount + 1);
  }

  // ============ Utility Methods ============

  /// Clear all saved data (useful for testing or reset)
  Future<bool> clearAll() async {
    if (_prefs == null) return false;
    final success = await _prefs!.clear();
    if (kDebugMode && success) {
      debugPrint('All save data cleared');
    }
    return success;
  }

  /// Get all saved data as a map (useful for debugging)
  Map<String, dynamic> getAllData() {
    if (_prefs == null) return {};
    return {
      'highScore': getHighScore(),
      'highestLevelCompleted': getHighestLevelCompleted(),
      'soundEnabled': getSoundEnabled(),
      'soundVolume': getSoundVolume(),
      'lastSelectedCharacter': getLastSelectedCharacter(),
      'totalPlayTime': getTotalPlayTime(),
      'gamesPlayed': getGamesPlayed(),
    };
  }

  /// Print all saved data to debug console
  void debugPrintAll() {
    if (kDebugMode) {
      debugPrint('=== SaveManager Data ===');
      final data = getAllData();
      data.forEach((key, value) {
        debugPrint('  $key: $value');
      });
      debugPrint('=======================');
    }
  }
}

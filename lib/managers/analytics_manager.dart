import 'package:flutter/foundation.dart';

/// Manages analytics and crash reporting for the game
/// This is a lightweight implementation that logs events locally.
/// Can be extended to integrate with Firebase Analytics, Crashlytics, or other services.
class AnalyticsManager {
  /// Track when the game starts
  void logGameStart() {
    _logEvent('game_start');
  }

  /// Track when a level is started
  void logLevelStart(int levelNumber) {
    _logEvent('level_start', parameters: {'level': levelNumber});
  }

  /// Track when a level is completed
  void logLevelComplete(int levelNumber, int score, int livesRemaining) {
    _logEvent('level_complete', parameters: {
      'level': levelNumber,
      'score': score,
      'lives_remaining': livesRemaining,
    });
  }

  /// Track when a level is failed
  void logLevelFailed(int levelNumber, int score) {
    _logEvent('level_failed', parameters: {
      'level': levelNumber,
      'score': score,
    });
  }

  /// Track when the game is completed (all levels)
  void logGameComplete(int totalScore) {
    _logEvent('game_complete', parameters: {
      'total_score': totalScore,
    });
  }

  /// Track character selection
  void logCharacterSelected(String characterName) {
    _logEvent('character_selected', parameters: {
      'character': characterName,
    });
  }

  /// Track when player dies
  void logPlayerDeath(int levelNumber, String causeOfDeath) {
    _logEvent('player_death', parameters: {
      'level': levelNumber,
      'cause': causeOfDeath,
    });
  }

  /// Track when player collects a fruit
  void logFruitCollected(int levelNumber) {
    _logEvent('fruit_collected', parameters: {
      'level': levelNumber,
    });
  }

  /// Track when player defeats an enemy
  void logEnemyDefeated(int levelNumber, String enemyType) {
    _logEvent('enemy_defeated', parameters: {
      'level': levelNumber,
      'enemy_type': enemyType,
    });
  }

  /// Track when player reaches a checkpoint
  void logCheckpointReached(int levelNumber) {
    _logEvent('checkpoint_reached', parameters: {
      'level': levelNumber,
    });
  }

  /// Track when game is paused
  void logGamePaused(int levelNumber) {
    _logEvent('game_paused', parameters: {
      'level': levelNumber,
    });
  }

  /// Track when game is resumed
  void logGameResumed(int levelNumber) {
    _logEvent('game_resumed', parameters: {
      'level': levelNumber,
    });
  }

  /// Track when player restarts a level
  void logLevelRestart(int levelNumber) {
    _logEvent('level_restart', parameters: {
      'level': levelNumber,
    });
  }

  /// Track when player returns to main menu
  void logReturnToMainMenu(String from) {
    _logEvent('return_to_main_menu', parameters: {
      'from': from,
    });
  }

  /// Track custom events
  void logCustomEvent(String eventName, {Map<String, dynamic>? parameters}) {
    _logEvent(eventName, parameters: parameters);
  }

  /// Log errors for crash reporting
  void logError(String error, {String? stackTrace, Map<String, dynamic>? context}) {
    if (kDebugMode) {
      print('❌ ERROR: $error');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
      if (context != null) {
        print('Context: $context');
      }
    }

    // In production, this would send to a crash reporting service
    // like Firebase Crashlytics, Sentry, etc.
  }

  /// Log exceptions with context
  void logException(Exception exception, {String? reason, Map<String, dynamic>? context}) {
    if (kDebugMode) {
      print('❌ EXCEPTION: $exception');
      if (reason != null) {
        print('Reason: $reason');
      }
      if (context != null) {
        print('Context: $context');
      }
    }

    // In production, this would send to a crash reporting service
  }

  /// Internal method to log events
  void _logEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final params = parameters != null ? ' | Params: $parameters' : '';
      print('📊 ANALYTICS [$timestamp]: $eventName$params');
    }

    // In production, this would send events to an analytics service
    // Examples:
    // - Firebase Analytics: FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters)
    // - Mixpanel: Mixpanel.track(eventName, properties: parameters)
    // - Custom backend: http.post('https://api.yourapp.com/analytics', body: {...})
  }

  /// Set user properties for analytics segmentation
  void setUserProperty(String name, String value) {
    if (kDebugMode) {
      print('👤 USER PROPERTY: $name = $value');
    }

    // In production: FirebaseAnalytics.instance.setUserProperty(name: name, value: value)
  }

  /// Set user ID for tracking across sessions
  void setUserId(String userId) {
    if (kDebugMode) {
      print('👤 USER ID: $userId');
    }

    // In production: FirebaseAnalytics.instance.setUserId(id: userId)
  }

  /// Track screen views
  void logScreenView(String screenName) {
    if (kDebugMode) {
      print('📱 SCREEN VIEW: $screenName');
    }

    // In production: FirebaseAnalytics.instance.logScreenView(screenName: screenName)
  }
}

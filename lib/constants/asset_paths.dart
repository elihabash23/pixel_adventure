/// Asset path constants for the game
class AssetPaths {
  // Menu assets
  static const String menuButtonsPath = 'assets/images/Menu/Buttons/';
  static const String menuLevelsPath = 'assets/images/Menu/Levels/';
  static const String nextButton = '${menuButtonsPath}Next.png';
  static const String pauseButton = '${menuButtonsPath}Pause.png';
  static const String closeButton = '${menuButtonsPath}Close.png';

  // HUD assets
  static const String hudPath = 'assets/images/HUD/';
  static const String jumpButton = '${hudPath}JumpButton.png';

  // Character assets
  static const String charactersPath = 'assets/images/Main Characters/';

  // Audio assets
  static const String hitSound = 'hit.wav';
  static const String jumpSound = 'jump.wav';
  static const String pickupFruitSound = 'pickupFruit.wav';
  static const String disappearSound = 'disappear.wav';
  static const String hitEnemySound = 'hitEnemy.wav';
  static const String clickSound = 'click.wav';

  // Level assets
  static const String tilesPath = 'assets/tiles/';

  // Fonts
  static const String minecraftEveningsFont = 'MinecraftEvenings';
  static const String atariClassicFont = 'AtariClassic';

  // Helper method to get character jump image path
  static String getCharacterJumpImage(String characterName) {
    return '$charactersPath$characterName/Jump (96x96).png';
  }

  // Helper method to get level image path
  static String getLevelImage(int levelNumber) {
    final String formattedNumber = levelNumber < 10 ? '0$levelNumber' : '$levelNumber';
    return '$menuLevelsPath$formattedNumber.png';
  }

  // Helper method to get TMX level path
  static String getTmxLevel(String levelName) {
    return '$levelName.tmx';
  }
}

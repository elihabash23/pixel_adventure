/// Game physics constants
class GamePhysics {
  static const double gravity = 9.8;
  static const double jumpForce = 260.0;
  static const double terminalVelocity = 300.0;
  static const double chickenBounceHeight = 260.0;
  static const double snailBounceHeight = 260.0;
  static const double wallGravityMultiplier = 0.2; // 1/5 gravity when on wall
}

/// Player constants
class PlayerConstants {
  static const int maxJumps = 2;
  static const double moveSpeed = 100.0;
  static const double fixedDeltaTime = 1 / 60; // 60 FPS
  static const int canMoveDurationMs = 200;
  static const int checkpointWaitDurationSec = 3;
  static const double respawnAnimationOffset = 32.0; // Offset for appearing animation
  static const double checkpointAnimationOffset = 32.0; // Offset for disappearing animation
}

/// Camera constants
class CameraConstants {
  static const double width = 640.0;
  static const double height = 360.0;
}

/// Animation constants
class AnimationConstants {
  static const double stepTime = 0.05;
}

/// Collision detection constants
class CollisionConstants {
  static const double spatialCheckRadius = 500.0;
  static const int tileSize = 16;
}

/// Enemy constants
class EnemyConstants {
  static const double chickenRunSpeed = 80.0;
  static const double snailWalkSpeed = 40.0;
}

/// UI Layout constants
class LayoutConstants {
  static const double minContainerWidth = 550.0;
  static const double maxContainerWidth = 800.0;
  static const double smallScreenHeight = 760.0;
}

/// Game lifecycle constants
class GameLifecycleConstants {
  static const int levelTransitionDelaySec = 1;
}

import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  bool isPlatform;
  bool isWall;
  CollisionBlock({
    position,
    size,
    this.isPlatform = false,
    this.isWall = false,
  }) : super(
            // Whatever is passed in CollisionBlock, this will be passed in PositionComponent
            position: position,
            size: size) {
    //debugMode = true;
  }
}

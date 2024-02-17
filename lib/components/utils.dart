bool checkCollision(player, block) {
  final hitbox = player.hitbox;
  final playerX = player.position.x + hitbox.offsetX;
  final playerY = player.position.y + hitbox.offsetY;
  final playerWidth = hitbox.width;
  final playerHeight = hitbox.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockWidth = block.width;
  final blockHeight = block.height;

  // since flipHorizontallyAroundCenter() flips the x and y which 
  // causes an issue with collisions going to the left
  // player.scale.x < 0 means going to the left
  final fixedX = player.scale.x < 0 ? playerX - (hitbox.offsetX * 2) - playerWidth : playerX;


  final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

  return (
    fixedY < blockY + blockHeight && // if the top of the player is less than the bottom of the block
    playerY + playerHeight > blockY && // if the bottom of the player is greater than the top of the block
    fixedX < blockX + blockWidth && // if the left of the player is less than the right of the block
    fixedX + playerWidth > blockX // if the right of the player is less than the left of the block
  );
}
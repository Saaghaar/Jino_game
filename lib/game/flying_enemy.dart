import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:runner_test1/game/game.dart';

class FlyingEnemy extends SpriteAnimationComponent with HasGameReference<JinoGame>, CollisionCallbacks {

  late SpriteAnimation flyAnimation;

  final int type;

  FlyingEnemy(this.type) :
        super(
        size: Vector2(32, 32), //set the initial size of the character
      );

  @override
  Future<void> onLoad() async {

    // speed of enemies
    final step = 0.1 / game.difficultyManager.speedFactor;

    // inputs of _loadAnimation
    switch (type) {
      case 1: // first enemy: Monster Bat
        flyAnimation = await _loadAnimation('Monster_Bat/Flying.png', 6, step, 46, 30);
        // bat's hitBox
        add( RectangleHitbox.relative(
          Vector2(1.8, 0.80), // % of w & h relative to the size of the character
          parentSize: size,
          position: Vector2(0, 20), // position the hitBox in the sprite sheet
        )
        );
        break;

      case 2: // second enemy: Monster Bird
        flyAnimation = await _loadAnimation('Monster_Bird/Flying.png', 8, step, 32,32);
        // // bird's hitBox
        add( RectangleHitbox.relative(
          Vector2(1.8, 0.80), // % of w & h relative to the size of the character
          parentSize: size,
          position: Vector2(0, 20), // position the hitBox in the sprite sheet
          )
        );
        break;
    }

    animation = flyAnimation; // initial animation

    const groundImageHeight = 1080; // the height of the ground picture
    const realGroundHeight = 80;// the real ground height

    final groundRatio = realGroundHeight / groundImageHeight;
    final groundHeight = game.size.y * groundRatio;

    // enemy's size
    size = Vector2(game.size.x /12 , game.size.x /12);

    // enemy's position
    position = Vector2(
      game.size.x + 50, // start from right outside
      game.size.y - groundHeight - size.y - 60, // on the sky
    );

  }

  // load spirit sheets
  Future<SpriteAnimation> _loadAnimation(String path, int amount, double speed, double x, double y) async {
    return await game.loadSpriteAnimation(
      path, // path of the sprite sheet's file
      SpriteAnimationData.sequenced(
        amount: amount, // frame numbers
        stepTime: speed,
        textureSize: Vector2(x, y),
      ),
    );
  }

  @override
  void update(double dt){
    super.update(dt);

    // start running from right side by stable speed
    position.x -=  game.difficultyManager.baseSpeed * dt;

    // remove the enemy when it goes outside the screen
    if (position.x + size.x < 0){
      game.scoreManager.increaseScore(5); // add 5 score for passing each enemy
      removeFromParent();
    }
  }

}
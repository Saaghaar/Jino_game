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
        break;

      case 2: // second enemy: Monster Bird
        flyAnimation = await _loadAnimation('Monster_Bird/Flying.png', 8, step, 32,32);
        // hitBox: bird's beak
        add(PolygonHitbox([       // (x,y)
          Vector2(-0.37, -0.15), // (4,11)
          Vector2(-0.28, -0.15), // (7,11)
          Vector2(-0.28, 0.21), // (7,23)
          Vector2(-0.37, 0.21), // (4,23)
          Vector2(-0.46, 0.1), // (1,19)
          Vector2(-0.46, -0.03), // (1,15)
        ])..collisionType = CollisionType.passive
          ..debugMode = true);

        // hitBox: bird's body
        add(PolygonHitbox([
          Vector2(-0.28, -0.19), // (7,10)
          Vector2(0.34, -0.19), // (27,10)
          Vector2(0.46, -0.06), // (31,14)
          Vector2(0.46, 0), // (31,16)
          Vector2(0.37, 0.187), // (28,22)
          Vector2(0.37, 0.34), // (28,27)
          Vector2(0.1, 0.34), // (19,27)
          Vector2(-0.09, 0.12), // (13,20)
          Vector2(-0.28, 0.12), // (7,20)
        ])..collisionType = CollisionType.passive
          ..debugMode = true);


        // hitBox: bird's head
        add(PolygonHitbox([
          Vector2(-0.12, -0.18), // (12,10)
          Vector2(-0.12, -0.25), // (12,8)
          Vector2(0, -0.34), // (16,5)
          Vector2(0.19, -0.34), // (22,5)
          Vector2(0.25, -0.31), // (24,6)
          Vector2(0.34, -0.19), // (17,10)
        ])..collisionType = CollisionType.passive
          ..debugMode = true);
        break;
    }
    debugMode = true;

    animation = flyAnimation; // initial animation

    // enemy's size
    size = Vector2(game.size.x /12 , game.size.x /12);

    const groundImageHeight = 1080; // the height of the ground picture
    const realGroundHeight = 80;// the real ground height

    final groundRatio = realGroundHeight / groundImageHeight;
    final groundHeight = game.size.y * groundRatio;

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
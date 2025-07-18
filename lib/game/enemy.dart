import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';

import 'package:runner_test1/game/game.dart'; // importing the game file


class Enemy extends SpriteAnimationComponent with HasGameReference<JinoGame>, CollisionCallbacks {

  late SpriteAnimation runAnimation;
  final int type;

  Enemy(this.type) :
        super(
        size: Vector2(128, 128), //set the initial size of the character
      );

  @override
  Future<void> onLoad() async {
    late SpriteAnimation runAnimation;

    // load enemies animation
    switch (type){
      case 1:
        final runImage = await game.images.load('Monster_Dude/Run.png');
        final runSheet = SpriteSheet(
        image: runImage,
        srcSize: Vector2(32, 32),
        );
        final step = 0.1 / game.difficultyManager.speedFactor;
        runAnimation = runSheet.createAnimation(
        row: 0, from: 0, to: 5, stepTime: step);
        break;

      case 2:
        final runImage = await game.images.load('Monster_Owlet/Run.png');
        final runSheet = SpriteSheet(
          image: runImage,
          srcSize: Vector2(32, 32),
        );
        final step = 0.1 / game.difficultyManager.speedFactor;
        runAnimation = runSheet.createAnimation(
            row: 0, from: 0, to: 5, stepTime: step);
        break;

      case 3:
        final runImage = await game.images.load('Monster_Pink/Run.png');
        final runSheet = SpriteSheet(
          image: runImage,
          srcSize: Vector2(32, 32),
        );
        final step = 0.1 / game.difficultyManager.speedFactor;
        runAnimation = runSheet.createAnimation(
            row: 0, from: 0, to: 5, stepTime: step);
        break;
    }
    // set animation
    animation = runAnimation;

    // enemy's size
    size = Vector2(game.size.x /10 , game.size.x /10);

    const groundImageHeight = 1080; // the height of the ground picture
    const realGroundHeight = 80;// the real ground height

    final groundRatio = realGroundHeight / groundImageHeight;
    final groundHeight = game.size.y * groundRatio;

    // enemy's position
    position = Vector2(
      game.size.x + 50, // start from right outside
      game.size.y - groundHeight - size.y - 35, // on the ground
    );

    // add hitBox to the enemy sprite sheet
    add(RectangleHitbox.relative(
      Vector2(0.5, 0.5), // % of w & h relative to the size of the enemy
      parentSize: size,
      position: Vector2(9, 12), // position the hitBox in the sprite sheet
    ));


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
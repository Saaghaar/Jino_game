import 'package:flame/components.dart';
import 'package:flame/collisions.dart';

import 'package:runner_test1/game/game.dart';
import 'package:runner_test1/game/jino.dart';

enum EnemyState {run, attack}

class Enemy extends SpriteAnimationComponent with HasGameReference<JinoGame>, CollisionCallbacks {

  late SpriteAnimation runAnimation;
  late SpriteAnimation attackAnimation;

  EnemyState state = EnemyState.run;

  final int type;

  Enemy(this.type) :
        super(
        size: Vector2(128, 128), //set the initial size of the character
      );

  @override
  Future<void> onLoad() async {

    // speed of enemies
    final step = 0.1 / game.difficultyManager.speedFactor;

    // inputs of _loadAnimation
    switch (type) {
      case 1: // first enemy: Monster Dude
        runAnimation = await _loadAnimation('Monster_Dude/Run.png', 5, step);
        attackAnimation = await _loadAnimation('Monster_Dude/Attack.png', 5, 0.15);
        break;

      case 2: // second enemy: Monster_Owlet
        runAnimation = await _loadAnimation('Monster_Owlet/Run.png', 5, step);
        attackAnimation = await _loadAnimation('Monster_Owlet/Attack.png', 5, 0.15);
        break;

      case 3: // third enemy: Monster_Pink
        runAnimation = await _loadAnimation('Monster_Pink/Run.png', 5, step);
        attackAnimation = await _loadAnimation('Monster_Pink/Attack.png', 5, 0.2);
        break;
    }

    animation = runAnimation; // initial animation

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
      position: Vector2(15, 15), // position the hitBox in the sprite sheet
    ));
    debugMode = true;
  }

  // load spirit sheets
  Future<SpriteAnimation> _loadAnimation(String path, int amount, double speed) async {
    return await game.loadSpriteAnimation(
      path, // path of the sprite sheet's file
      SpriteAnimationData.sequenced(
        amount: amount, // frame numbers
        stepTime: speed,
        textureSize: Vector2(32, 32),
      ),
    );
  }

  // set enemy state func
  void setState(EnemyState newState) {
    state = newState;
    switch (state) {
      case EnemyState.run:
        animation = runAnimation;
        break;
      case EnemyState.attack:
        animation = attackAnimation;
        break;
    }
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

  // check the hitting
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints,
      PositionComponent other,
      ) {
    super.onCollisionStart(intersectionPoints, other);

    // if enemy hit ti Jino => animation = attack
    if (other is Jino) {
      setState(EnemyState.attack);
      Future.delayed(const Duration(milliseconds: 300), () {
        // if enemy was in the screen yet => animation = run
        if (isMounted) {
          setState(EnemyState.run);
        }
      });
    }
  }

}
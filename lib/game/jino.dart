import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:runner_test1/game/game.dart'; // importing the game file

class Jino extends SpriteAnimationComponent with HasGameReference<JinoGame>, TapCallbacks {

  late SpriteAnimation runAnimation;
  late SpriteAnimation jumpAnimation;

  // variables for jumping
  bool isJumping = false;
  double jumpSpeed = -500;
  double gravity = 1000;
  late double originalY;

  Jino() :
        super(
        size: Vector2(128, 128), //set the initial size of the character
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load idle animation
    final idleImage = await game.images.load('Ducky/idle.png');
    final idleSheet = SpriteSheet(
      image: idleImage,
      srcSize: Vector2(64, 64),
    );
    final idleAnimation = idleSheet.createAnimation(
        row: 0, from: 0, to: 3, stepTime: 0.1);

    // Load run animation
    final runImage = await game.images.load('Ducky/run.png');
    final runSheet = SpriteSheet(
      image: runImage,
      srcSize: Vector2(64, 64),
    );
    runAnimation = runSheet.createAnimation(
        row: 0, from: 0, to: 3, stepTime: 0.1);

    // Load jump animation
    final jumpImage = await game.images.load('Ducky/jump.png');
    final jumpSheet = SpriteSheet(
      image: jumpImage,
      srcSize: Vector2(64, 64),
    );
    jumpAnimation = jumpSheet.createAnimation(
        row: 0, from: 0, to: 3, stepTime: 0.15);


    // Create character and position it
    animation = runAnimation;

    const double groundImageHeight = 1080; // the height of the ground picture
    const double realGroundHeight = 80;   // the real ground height

    final double groundRatio = realGroundHeight / groundImageHeight;
    final groundHeight = game.size.y * groundRatio;

    final characterWidth = (game.size.x / 9) * 1.8; // *1.8 for make the character bigger
    final characterHeight = characterWidth; // assume the character square

    size = Vector2(characterWidth, characterHeight);

    position = Vector2(
        game.size.x * 0.15 - characterWidth / 2,
        game.size.y - groundHeight - characterHeight,
    );


    originalY = y; // Initial value for returning to ground
  }


  // player movement: Jumping
  void jump() {
    if (!isJumping) {
      isJumping = true;
      jumpSpeed = -500;
      animation = jumpAnimation;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Ducky's jumping conditions
    if (isJumping) {
      y += jumpSpeed * dt;
      jumpSpeed += gravity * dt;

      // when Ducky reach to the ground, stop jumping
      if (y >= originalY) {
        y = originalY;
        isJumping = false;
        jumpSpeed = -300;
        animation = runAnimation;
      }
    }
  }

}




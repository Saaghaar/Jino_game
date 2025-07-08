import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:runner_test1/game/jino.dart';
import 'package:runner_test1/game/game.dart'; // importing the game file

class Jino extends SpriteAnimationComponent with HasGameReference<JinoGame> {
  Jino() :
        super(
        size: Vector2(128, 128),
        );

  @override
  Future<void> onLoad() async {
    // Load idle animation
    final idleImage = await game.images.load('idle.png');
    final idleSheet = SpriteSheet(
      image: idleImage,
      srcSize: Vector2(64, 64),
    );
    final idleAnimation = idleSheet.createAnimation(
        row: 0, from: 0, to: 3, stepTime: 0.1);

    // Load run animation
    final runImage = await game.images.load('run.png');
    final runSheet = SpriteSheet(
      image: runImage,
      srcSize: Vector2(64, 64),
    );
    final runAnimation = runSheet.createAnimation(
        row: 0, from: 0, to: 3, stepTime: 0.1);

    // Load jump animation
    final jumpImage = await game.images.load('jump.png');
    final jumpSheet = SpriteSheet(
      image: jumpImage,
      srcSize: Vector2(64, 64),
    );
    final jumpAnimation = jumpSheet.createAnimation(
        row: 0, from: 0, to: 3, stepTime: 0.15);


    // Create character and position it
    animation = runAnimation;

    const double groundImageHeight = 1080; // the height of the ground picture
    const double realGroundHeight = 80;   // the real ground height

    final double groundRatio = realGroundHeight / groundImageHeight;
    final groundHeight = game.size.y * groundRatio;

    final characterWidth = (game.size.x / 9) * 1.8;
    final characterHeight = characterWidth; // assume the character square

    size = Vector2(characterWidth, characterHeight);

    position = Vector2(
        game.size.x * 0.10 - characterWidth / 2,
        game.size.y - groundHeight - characterHeight,
    );
  }
}


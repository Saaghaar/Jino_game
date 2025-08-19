import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/sprite.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/foundation.dart'; // for call back
import 'package:flame_audio/flame_audio.dart'; // for sound effects

import 'package:runner_test1/game/game.dart'; // importing the game file
import 'package:runner_test1/game/enemy.dart';


class Jino extends SpriteAnimationComponent with HasGameReference<JinoGame>, TapCallbacks, CollisionCallbacks{

  late SpriteAnimation runAnimation;
  late SpriteAnimation jumpAnimation;
  late SpriteAnimation hitAnimation;
  late SpriteAnimation deathAnimation;

  // variables for jumping
  bool isJumping = false;
  double jumpSpeed = -600;
  double gravity = 1500;
  late double originalY;

  // variables for being hit
  bool isHit = false;
  double hitCooldown = 0; // time remaining until next collision permission
  final double hitDelay = 0.5; // collision timer
  bool shouldPlayHitOnLand = false; // flag for hitting on air

  // access to JinoGame class
  late JinoGame gameRef;

  // number of hearts
  int health = 3;
  final VoidCallback onHit;

  Jino({
    required this.onHit,
  }) : super(size: Vector2(128, 128)); //set the initial size of the character

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

    // Load hit animation
    final hitImage = await game.images.load('Ducky/hit.png');
    final hitSheet = SpriteSheet(
        image: hitImage,
        srcSize: Vector2(64, 64),
    );
    hitAnimation = hitSheet.createAnimation(
        row: 0, from: 0, to: 1, stepTime: 0.1);

    // Load death animation
    final deathImage = await game.images.load('Ducky/death.png');
    final deathSheet = SpriteSheet(
        image: deathImage,
        srcSize: Vector2(64, 64),
    );
    deathAnimation = deathSheet.createAnimation(
        row: 0, stepTime: 0.1);



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

    // add hitBox to the character sprite sheet
    add(RectangleHitbox.relative(
      Vector2(0.31, 0.19), // % of w & h relative to the size of the character
      parentSize: size,
      position: Vector2(20, 34), // position the hitBox in the sprite sheet
    ));

    originalY = y; // Initial value for returning to ground
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Ducky's jumping conditions
    if (isJumping) {
      y += jumpSpeed * dt;

      // if character is jumping
      if (jumpSpeed < 0) {
        jumpSpeed += gravity * dt; // normal gravity
      } else {
        jumpSpeed += gravity * 2 * dt; // more gravity for faster falls
      }

      // when Ducky reach to the ground, stop jumping
      if (y >= originalY) {
        y = originalY;
        isJumping = false;
        jumpSpeed = -600;
        animation = runAnimation;
      }
    }

    // if hit cooldown is still active
    if (hitCooldown > 0) {
      // decrease the cooldown timer by dt time
      hitCooldown -= dt;
      // if cooldown has finished
      if (hitCooldown <= 0) {
        // allow new hits by resetting isHit
        isHit = false;
        // ensure cooldown doesn't go negative
        hitCooldown = 0;
      }
    }

    // when hit on the air play hit animation after reach to the ground
    if (y >= originalY && shouldPlayHitOnLand) {
      animation = hitAnimation;
      shouldPlayHitOnLand = false;

      // when got hit after 0.5 sec start running
      Future.delayed(const Duration(milliseconds: 500), () {
        animation = runAnimation;
      });
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // add hitting action
    if (other is Enemy && !isHit) {
      isHit = true;
      hitCooldown = hitDelay;

      // decrease heart after hit
      onHit.call();

      // play hit animation
      hit();
    }
  }

  // player movement: Jumping
  void jump() {
    if (!isJumping) {
      isJumping = true;
      jumpSpeed = -600;
      animation = jumpAnimation;

      // jump sound effect 
      FlameAudio.play('jump.wav');
    }
  }

  // player movement: Hitting
  void hit() {
    if (game.health > 0) {

      // hit sound effect
      FlameAudio.play('hit.wav');

      // checking player is on the ground
      if (y >= originalY) {
        animation = hitAnimation;

        // when got hit after 0.5 sec start running
        Future.delayed(const Duration(milliseconds: 500), () {
          animation = runAnimation;
        });
      } else {
        shouldPlayHitOnLand = true;
      }
    }
  }

  // player movement: Death
  void playDeathAnimation() {
    animation = deathAnimation;
  }

}




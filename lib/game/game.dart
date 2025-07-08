import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/parallax.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:runner_test1/game/jino.dart';
import 'package:flame/input.dart';

class JinoGame extends FlameGame with PanDetector{
  late Jino _jino;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Create background
    final parallax = await loadParallaxComponent(
    [
      ParallaxImageData('parallax/layer_sky.png'),
      ParallaxImageData('parallax/layer_cake.png'),
      ParallaxImageData('parallax/layer_clouds.png'),
      ParallaxImageData('parallax/layer_rocks.png'),
      ParallaxImageData('parallax/layer_trees.png'),
      ParallaxImageData('parallax/layer_ground.png'),
    ],
      baseVelocity: Vector2(20, 0), // movement speed
      velocityMultiplierDelta: Vector2(1.5, 1.0), // layer's different speed
    );

    add(parallax);

    _jino = Jino();
    add(_jino);
  }

  // set jumping movement (when user swipes up)
  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (info.delta.global.y < -10) {
      _jino.jump();
    }
  }

}
import 'dart:math';
import 'package:flutter/material.dart';

abstract class Particle {
  void update();
}

@protected
class BurstParticle extends Particle {
  double x;
  double y;
  double speed;
  double angle;
  double radius = 3;
  Color color;

  BurstParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.angle,
    required this.color,
  });

  @override
  void update() {
    x += speed * cos(angle);
    y += speed * sin(angle);
    speed *= 0.95; // Slow down gradually
    radius *= 0.98; // Shrink over time
  }
}

@protected
class ExplosionParticle extends Particle {
  final Offset position; // Position of the explosion
  final List<Color> colors; // List of random colors

  late double x; // Current x position
  late double y; // Current y position
  late double radius; // Size of the particle
  late double speed; // Speed of the particle
  late double angle; // Direction of movement (in radians)
  late Color color; // Color of the particle
  late double lifeSpan; // Remaining life span of the particle

  ExplosionParticle(this.position, this.colors) {
    reset();
  }

  void reset() {
    Random random = Random();
    x = position.dx;
    y = position.dy;
    radius = random.nextDouble() * 6 + 2; // Random size
    speed = random.nextDouble() * 5 + 3; // Random speed
    angle = random.nextDouble() * 2 * pi; // Random direction
    color =
        colors[random.nextInt(colors.length)].withOpacity(0.9); // Random color
    lifeSpan = random.nextDouble() * 1.5 + 0.5; // Random life span
  }

  @override
  void update() {
    if (lifeSpan > 0) {
      x += speed * cos(angle); // Move in the x-direction
      y += speed * sin(angle); // Move in the y-direction
      speed *= 0.97; // Gradual deceleration
      radius *= 0.98; // Shrink the particle over time
      lifeSpan -= 0.03; // Reduce life span
    }
  }

  bool isAlive() => lifeSpan > 0;
}

@protected
class FireworkParticle extends Particle {
  final List<Color> colors;
  final Offset position;
  final Size screenSize;
  late double x;
  late double y;
  late double speed;
  late double burstSpeed;
  late double radius;
  late Color color;
  late bool hasBurst;
  late List<BurstParticle> burstParticles;

  FireworkParticle(this.colors, this.position, this.screenSize) {
    reset();
  }

  void reset() {
    final random = Random();
    x = position.dx;
    y = screenSize.height;
    speed = random.nextDouble() * 3 + 5; // Rocket speed
    burstSpeed = random.nextDouble() * 3 + 1;
    radius = 5;
    color = colors[random.nextInt(colors.length)];
    hasBurst = false;
    burstParticles = [];
  }

  @override
  void update() {
    if (!hasBurst) {
      // Rocket moves upwards
      y -= speed;

      // Check if it's time to burst
      if (y <= position.dy) {
        burst();
      }
    } else {
      // Update burst particles
      for (var particle in burstParticles) {
        particle.update();
      }
    }
  }

  void burst() {
    hasBurst = true;
    final random = Random();
    for (int i = 0; i < 50; i++) {
      burstParticles.add(BurstParticle(
        x: x,
        y: y,
        speed: burstSpeed + random.nextDouble() * 2,
        angle: random.nextDouble() * 2 * pi,
        color: color,
      ));
    }
  }
}

@protected
class FloatingParticle extends Particle {
  List<Color> colors;
  Size screenSize;
  late double x;
  late double y;
  late double size;
  late double speed;
  late double angle; // Angle for horizontal drift
  late Paint paint;

  FloatingParticle(this.colors, this.screenSize) {
    reset();
  }

  void reset() {
    final random = Random();
    x = random.nextDouble() * screenSize.width;
    y = random.nextDouble() * screenSize.height;
    size = random.nextDouble() * 10 + 5; // Random size
    speed = random.nextDouble() * 2 + 1; // Slow falling speed
    angle = random.nextDouble() * pi / 4 -
        pi / 8; // Horizontal sway (-22.5 to 22.5 degrees)
    paint = Paint()
      ..color = colors[Random().nextInt(colors.length)]
      ..style = PaintingStyle.fill;
  }

  @override
  void update() {
    y += speed;
    x += sin(angle); // Sway left and right
    angle += 0.05; // Gradual shift in angle

    // Reset if out of bounds
    if (y > screenSize.height || x < 0 || x > screenSize.width) {
      reset();
    }
  }
}

@protected
class RainParticle extends Particle {
  final Size screenSize;
  final Color color;
  late double x; // Horizontal position
  late double y; // Vertical position
  late double length; // Length of the raindrop
  late double speed; // Falling speed
  late Paint paint;

  RainParticle(this.color, this.screenSize) {
    reset();
  }

  void reset() {
    final random = Random();
    x = random.nextDouble() *
        screenSize.width; // Random horizontal position across the screen
    y = random.nextDouble() * -screenSize.height; // Start above the screen
    length = random.nextDouble() * 15 + 5; // Random length
    speed = random.nextDouble() * 4 + 2; // Random vertical speed
    paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
  }

  @override
  void update() {
    y += speed; // Move downward

    // Reset particle if it moves out of view
    if (y > screenSize.height) {
      reset();
    }
  }
}

@protected
class SnowParticle extends Particle {
  final Color color;
  final Size screenSize;
  late double x; // Horizontal position
  late double y; // Vertical position
  late double radius; // Size of the snowflake
  late double speed; // Falling speed
  late double drift; // Left-right movement
  late double blur;
  late Paint paint;

  SnowParticle(this.color, this.screenSize) {
    reset();
  }

  void reset() {
    final random = Random();
    x = random.nextDouble() * screenSize.width; // Random horizontal position
    y = random.nextDouble() * -screenSize.height; // Start above the screen
    radius = random.nextDouble() * 4 + 2; // Random size (small for snowflakes)
    speed = random.nextDouble() * 2 + 1; // Random falling speed
    drift = random.nextDouble() * 0.5 - 0.25; // Slight left-right drift
    radius = random.nextDouble() * 4 + 2; // Random size (small for snowflakes)
    blur = random.nextDouble() * 5; // Random blur

    paint = Paint()
      ..color = color // Snowflake color with opacity
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
  }

  @override
  void update() {
    y += speed; // Fall down
    x += drift; // Drift left or right

    // Reset snowflake if it goes out of bounds
    if (y > screenSize.height || x < 0 || x > screenSize.width) {
      reset();
    }
  }
}

@protected
class WidgetParticle extends Particle {
  final Size screenSize;
  final List<Widget> widgets;
  late Offset position;
  late double size;
  late double speedX; // Horizontal speed
  late double speedY; // Vertical speed (gravity simulation)
  late double direction; // In radians
  late double rotation;
  late double rotationSpeed;
  late Widget widget;

  WidgetParticle(this.screenSize, this.widgets) {
    reset();
  }

  void reset() {
    final random = Random();
    position = Offset(
      random.nextDouble() * screenSize.width,
      0,
    ); // Random start position
    size = random.nextDouble() * 30 + 20; // Random size
    speedX = random.nextDouble() * 2 - 1; // Horizontal drift (-1 to 1)
    speedY = random.nextDouble() * 3 + 2; // Downward speed (gravity)
    direction = random.nextDouble() * 1 * pi; // Random direction
    rotation = random.nextDouble() * 2 * pi; // Random rotation
    rotationSpeed = random.nextDouble() * 0.1 - 0.05; // Random rotation speed

    // Assign a random widget
    final randomIndex = random.nextInt(widgets.length);

    widget = SizedBox(
      height: size,
      width: size,
      child: widgets[randomIndex],
    );
  }

  @override
  void update() {
    position = Offset(
      position.dx + cos(direction) * speedX,
      position.dy + sin(direction) * speedY,
    );
    rotation += rotationSpeed;

    // Reset if particle goes out of bounds
    if (position.dx < 0 ||
        position.dx > screenSize.width ||
        position.dy > screenSize.height) {
      reset();
    }
  }
}

@protected
class WindParticle extends Particle {
  final Size screenSize;
  final bool isStrongWind;
  late double x, y;
  late double speedX, speedY;
  late double size;
  late double opacity;

  WindParticle(this.screenSize, {this.isStrongWind = false}) {
    reset();
  }

  void reset() {
    final random = Random();
    x = random.nextDouble() * screenSize.width;
    y = random.nextDouble() * screenSize.height;
    speedX = random.nextDouble() * (isStrongWind ? 4 : 2) + 1;
    speedY = random.nextDouble() - 0.5;
    size = random.nextDouble() * 4 + 2;
    opacity = random.nextDouble() * 0.5 + 0.2;
  }

  @override
  void update() {
    x += speedX;
    y += speedY;
    if (x > screenSize.width) x = 0;
    if (y > screenSize.height) {
      y = Random().nextDouble() * screenSize.height;
    }
  }
}

@protected
class WindLine extends Particle {
  final Size screenSize;
  final bool isStrongWind;
  late double x, y;
  late double length;
  late double speedX;
  late double opacity;
  late double waveAmplitude;

  WindLine(this.screenSize, {this.isStrongWind = false}) {
    reset();
  }

  void reset() {
    final random = Random();
    x = random.nextDouble() * screenSize.width;
    y = random.nextDouble() * screenSize.height;
    length = random.nextDouble() * 50 + 20;
    speedX = random.nextDouble() * (isStrongWind ? 6 : 3) + 2;
    opacity = random.nextDouble() * 0.3 + 0.2;
    waveAmplitude = random.nextDouble() * 1;
  }

  @override
  void update() {
    x += speedX;
    if (x > screenSize.width) x = 0;
  }
}


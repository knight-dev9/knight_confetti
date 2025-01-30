part of 'knight_confetti.dart';

class WindConfetti extends StatefulWidget {
  final Duration duration = const Duration(seconds: 10);
  final int totalParticles;
  final int totalLines;
  final bool isStrongWind;

  const WindConfetti({
    super.key,
    this.totalParticles = 50,
    this.totalLines = 10,
    this.isStrongWind = false,
  });

  @override
  State<StatefulWidget> createState() {
    return _WindConfettiState();
  }
}

class _WindConfettiState extends State<WindConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<WindParticle> particles = [];
  List<WindLine> windLines = [];

  double time = 0;

  Size get screenSize {
    return MediaQuery.sizeOf(context);
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..addListener(() {
        setState(() {
          for (var particle in particles) {
            particle.update();
          }
          for (var line in windLines) {
            line.update();
          }
          time += 0.1;
        });
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      time = 0;
      particles.clear();
      for (int i = 0; i < widget.totalParticles; i++) {
        particles.add(WindParticle(
          screenSize,
          isStrongWind: widget.isStrongWind,
        ));
      }
      windLines.clear();
      for (int i = 0; i < widget.totalLines; i++) {
        windLines.add(WindLine(
          screenSize,
          isStrongWind: widget.isStrongWind,
        ));
      }
      _controller.repeat();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: WindPainter(particles, windLines, time),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class WindPainter extends CustomPainter {
  final List<WindParticle> particles;
  final List<WindLine> windLines;
  final double time;

  WindPainter(this.particles, this.windLines, this.time);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    for (var particle in particles) {
      paint.color = Colors.white.withOpacity(particle.opacity);
      canvas.drawCircle(Offset(particle.x, particle.y), particle.size, paint);
    }

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var line in windLines) {
      linePaint.color = Colors.white.withOpacity(line.opacity);
      Path path = Path();
      path.moveTo(line.x, line.y);
      for (double i = 0; i < line.length; i += 5) {
        double offsetX = line.x + i;
        double offsetY =
            line.y + sin((time * 2) + (offsetX * 0.1)) * line.waveAmplitude;
        path.lineTo(offsetX, offsetY);
      }
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

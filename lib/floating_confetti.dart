part of 'knight_confetti.dart';

class FloatingConfetti extends StatefulWidget {
  final Duration duration = const Duration(seconds: 10);
  final int totalParticles;
  final List<Color> colors;

  const FloatingConfetti({
    super.key,
    this.totalParticles = 100,
    this.colors = Colors.primaries,
  });

  @override
  State<StatefulWidget> createState() {
    return _FloatingConfettiState();
  }
}

class _FloatingConfettiState extends State<FloatingConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

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
          for (var particle in _particles) {
            particle.update();
          }
        });
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (int i = 0; i < widget.totalParticles; i++) {
        _particles.add(FloatingParticle(widget.colors, screenSize));
      }
      _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(_particles),
    );
  }
}

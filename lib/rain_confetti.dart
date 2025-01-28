part of 'knight_confetti.dart';

class RainConfetti extends StatefulWidget {
  final Duration duration = const Duration(seconds: 10);
  final int totalParticles;
  final Color color;

  const RainConfetti({
    super.key,
    this.totalParticles = 300,
    this.color = Colors.white,
  });

  @override
  State<StatefulWidget> createState() {
    return _RainConfettiState();
  }
}

class _RainConfettiState extends State<RainConfetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];

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
      // Initialize particles after screen dimensions are known
      final screenSize = MediaQuery.sizeOf(context);

      for (int i = 0; i < widget.totalParticles; i++) {
        // Increase particle count for density
        _particles.add(RainParticle(widget.color, screenSize));
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
    return CustomPaint(painter: ParticlePainter(_particles));
  }
}

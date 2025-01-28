part of 'knight_confetti.dart';

class FloatingConfettiPage extends StatefulWidget {
  final Duration duration;
  final int totalParticles;
  final List<Color> colors;

  const FloatingConfettiPage({
    super.key,
    this.duration = const Duration(seconds: 10),
    this.totalParticles = 100,
    this.colors = Colors.primaries,
  });

  @override
  State<StatefulWidget> createState() {
    return _FloatingConfettiPageState();
  }
}

class _FloatingConfettiPageState extends State<FloatingConfettiPage>
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
      final screenSize = MediaQuery.sizeOf(context);
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

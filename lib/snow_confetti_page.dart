part of 'knight_confetti.dart';

class SnowConfettiPage extends StatefulWidget {
  final Duration duration;
  final int totalParticles;
  final Color color;

  const SnowConfettiPage({
    super.key,
    this.duration = const Duration(seconds: 10),
    this.totalParticles = 150,
    this.color = Colors.white,
  });

  @override
  State<StatefulWidget> createState() {
    return _SnowConfettiPageState();
  }
}

class _SnowConfettiPageState extends State<SnowConfettiPage>
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
      final screenSize = MediaQuery.of(context).size;

      // Generate particles after layout is complete
      for (int i = 0; i < widget.totalParticles; i++) {
        // Increase for denser snowfall
        _particles.add(SnowParticle(widget.color, screenSize));
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

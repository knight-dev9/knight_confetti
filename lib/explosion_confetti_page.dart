part of 'knight_confetti.dart';

class ExplosionConfettiPage extends StatefulWidget {
  final Duration duration;
  final int totalParticles;
  final List<Color> colors;

  const ExplosionConfettiPage({
    super.key,
    this.duration = const Duration(seconds: 2),
    this.totalParticles = 100,
    this.colors = Colors.primaries,
  });

  @override
  State<StatefulWidget> createState() {
    return _ExplosionConfettiPageState();
  }
}

class _ExplosionConfettiPageState extends State<ExplosionConfettiPage>
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
  }

  void _generateParticles(Offset position) {
    _particles.clear();
    for (int i = 0; i < widget.totalParticles; i++) {
      _particles.add(ExplosionParticle(position, widget.colors));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: (details) {
        _generateParticles(details.localPosition);
        _controller.forward(from: 0);
      },
      child: CustomPaint(
        painter: ParticlePainter(_particles),
      ),
    );
  }
}

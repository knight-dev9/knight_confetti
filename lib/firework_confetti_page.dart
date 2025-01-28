part of 'knight_confetti.dart';

class FireworksConfettiPage extends StatefulWidget {
  final Duration duration;
  final int totalParticles;
  final List<Color> colors;

  const FireworksConfettiPage({
    super.key,
    this.duration = const Duration(seconds: 4),
    this.totalParticles = 100,
    this.colors = Colors.primaries,
  });

  @override
  State<StatefulWidget> createState() {
    return _FireworksConfettiPageState();
  }
}

class _FireworksConfettiPageState extends State<FireworksConfettiPage>
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
          for (var firework in _particles) {
            firework.update();
          }
        });
      });

    _controller.repeat();
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
        // Add a new firework at a random position
        final screenSize = MediaQuery.sizeOf(context);
        _particles.add(
          FireworkParticle(widget.colors, details.localPosition, screenSize),
        );
      },
      child: CustomPaint(
        painter: ParticlePainter(_particles),
      ),
    );
  }
}

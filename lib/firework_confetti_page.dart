part of 'knight_confetti.dart';

class FireworksConfettiPage extends StatefulWidget {
  final Duration duration = const Duration(seconds: 4);
  final int totalParticles;
  final List<Color> colors;
  final List<Offset>? positions;
  final Duration delay;

  const FireworksConfettiPage({
    super.key,
    this.totalParticles = 100,
    this.colors = Colors.primaries,
    this.positions,
    this.delay = const Duration(seconds: 2),
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _particles.clear();
      final screenSize = MediaQuery.sizeOf(context);
      if (widget.positions != null && widget.positions!.isNotEmpty) {
        for (int i = 0; i < widget.positions!.length; i++) {
          final position = widget.positions![i];
          _particles.add(FireworkParticle(widget.colors, position, screenSize));
          await Future.delayed(widget.delay);
        }
      }
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
        _particles.add(
          FireworkParticle(
            widget.colors,
            details.localPosition,
            MediaQuery.sizeOf(context),
          ),
        );
      },
      child: CustomPaint(
        painter: ParticlePainter(_particles),
      ),
    );
  }
}

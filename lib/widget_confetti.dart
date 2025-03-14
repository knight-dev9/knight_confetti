part of 'knight_confetti.dart';

class WidgetConfetti extends StatefulWidget {
  final Duration duration = const Duration(seconds: 5);
  final int totalParticles;
  final List<Widget> children;

  const WidgetConfetti({
    super.key,
    this.totalParticles = 60,
    required this.children,
  });

  @override
  State<StatefulWidget> createState() {
    return _WidgetConfettiState();
  }
}

class _WidgetConfettiState extends State<WidgetConfetti>
    with TickerProviderStateMixin {
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
      // Initialize particles after screen dimensions are known
      for (int i = 0; i < widget.totalParticles; i++) {
        // Increase particle count for density
        _particles.add(WidgetParticle(screenSize, widget.children));
      }
      _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Iterable<Widget> _buildParticles() {
    return _particles.map(
      (e) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final particle = e as WidgetParticle;
            return Positioned(
              left: particle.position.dx,
              top: particle.position.dy,
              child: Transform.rotate(
                angle: particle.rotation,
                child: particle.widget,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._buildParticles(),
      ],
    );
  }
}

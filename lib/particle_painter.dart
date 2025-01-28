import 'package:flutter/material.dart';

import 'particle.dart';

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      if (particle is SnowParticle) { // Snow Particle
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.radius,
          particle.paint,
        );
      } else if (particle is RainParticle) { // Rain Particle
        canvas.drawLine(
          Offset(particle.x, particle.y),
          Offset(particle.x, particle.y + particle.length),
          particle.paint,
        );
      } else if (particle is FloatingParticle) { // Floating Particle
        canvas.drawCircle(
          Offset(particle.x, particle.y),
          particle.size / 2,
          particle.paint,
        );
      } else if (particle is ExplosionParticle) { // Explosion Particle
        if (particle.isAlive()) {
          final paint = Paint()
            ..color = particle.color
            ..style = PaintingStyle.fill;
          canvas.drawCircle(
            Offset(particle.x, particle.y),
            particle.radius,
            paint,
          );
        }
      } else if (particle is FireworkParticle) { // Firework Particle
        if (!particle.hasBurst) {
          // Draw the rocket
          final paint = Paint()
            ..color = particle.color
            ..style = PaintingStyle.fill;
          canvas.drawCircle(
            Offset(particle.x, particle.y),
            particle.radius,
            paint,
          );
        } else {
          // Draw burst particles
          for (var particle in particle.burstParticles) {
            final paint = Paint()
              ..color = particle.color.withOpacity(0.8)
              ..style = PaintingStyle.fill;
            canvas.drawCircle(
              Offset(particle.x, particle.y),
              particle.radius,
              paint,
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // Continuously repaint for animation
  }
}

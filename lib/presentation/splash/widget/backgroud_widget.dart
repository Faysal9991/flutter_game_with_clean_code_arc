import 'package:flutter/material.dart';
import 'dart:math' as math;

// Main Splash Screen Widget
class GreenLifeSplashScreen extends StatefulWidget {
  final VoidCallback onComplete;
  
  const GreenLifeSplashScreen({super.key, required this.onComplete});

  @override
  State<GreenLifeSplashScreen> createState() => _GreenLifeSplashScreenState();
}

class _GreenLifeSplashScreenState extends State<GreenLifeSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Fade animation for the text (starts at 3s, duration 1s)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeIn),
      ),
    );
    
    _controller.forward();
    
    // Navigate after 5 seconds total
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.4, -0.6),
            radius: 1.5,
            colors: [
              Color(0xFF1a5c44), // #1a5c44
              Color(0xFF0b2030), // #0b2030
              Color(0xFF07141d), // #07141d
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated Particles Background
            const ParticleBackground(),
            
            // Impact Text at bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 120),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.eco,
                        color: const Color(0xFF00d9ff),
                        size: 24,
                        shadows: [
                          Shadow(
                            color: const Color(0xFF00d9ff).withOpacity(0.8),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'From a single drop, an ecosystem grows...',
                        style: TextStyle(
                          color: const Color(0xFF00d9ff),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: const Color(0xFF00d9ff).withOpacity(0.8),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Particle Background Animation
class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  late List<Particle> particles;
  final math.Random random = math.Random();

  @override
  void initState() {
    super.initState();
    
    // Initialize particles
    particles = List.generate(50, (index) => Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 3 + 1,
      speedX: (random.nextDouble() - 0.5) * 0.001,
      speedY: random.nextDouble() * 0.001 + 0.0005,
      opacity: random.nextDouble() * 0.5 + 0.3,
    ));
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();
    
    _particleController.addListener(() {
      setState(() {
        for (var particle in particles) {
          particle.update();
        }
      });
    });
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ParticlePainter(particles: particles),
      size: Size.infinite,
    );
  }
}

// Particle Data Class
class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
  });

  void update() {
    x += speedX;
    y += speedY;

    // Wrap around screen
    if (x > 1.0) x = 0.0;
    if (x < 0.0) x = 1.0;
    if (y > 1.0) y = 0.0;
  }
}

// Custom Painter for Particles
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = const Color(0xFF00d9ff).withOpacity(particle.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size);

      canvas.drawCircle(
        Offset(particle.x * size.width, particle.y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

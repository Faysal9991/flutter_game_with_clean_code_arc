// lib/widgets/animated_game_background.dart
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/core/constants/app_colors.dart';
import 'package:flutter_faysal_game/presentation/splash/widget/backgroud_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedGameBackground extends StatefulWidget {
  final Widget child;
  final bool showParticles;
  final bool showFloatingIcons;
  final List<Color>? gradientColors;
  final double intensity; // 0.0 to 1.0 for animation intensity
  
  const AnimatedGameBackground({
    super.key,
    required this.child,
    this.showParticles = true,
    this.showFloatingIcons = true,
    this.gradientColors,
    this.intensity = 1.0,
  });

  @override
  State<AnimatedGameBackground> createState() => _AnimatedGameBackgroundState();
}

class _AnimatedGameBackgroundState extends State<AnimatedGameBackground>
    with TickerProviderStateMixin {
  late AnimationController _primaryController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Primary animation controller
    _primaryController = AnimationController(
      duration: Duration(milliseconds: (4000 / widget.intensity).round()),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _primaryController, curve: Curves.easeInOut),
    );

    // Pulse animation
    _pulseController = AnimationController(
      duration: Duration(milliseconds: (1500 / widget.intensity).round()),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final gradientColors = widget.gradientColors ?? [
      AppColors.background.withOpacity(0.6),
      AppColors.primary.withOpacity(0.3),
      AppColors.neonBlue.withOpacity(0.7),
    ];

    return Stack(
      children: [
        // Animated gradient overlay
        AnimatedBuilder(
          animation: _primaryController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    gradientColors[0],
                    gradientColors[1].withOpacity(
                      (gradientColors[1].opacity * _primaryController.value),
                    ),
                    gradientColors[2],
                  ],
                ),
              ),
            );
          },
        ),
        
        // Particle background (optional)
        if (widget.showParticles) const ParticleBackground(),
        
        // Animated glowing orbs
        _buildGlowingOrb(
          animation: _scaleAnimation,
          top: -60,
          right: -60,
          width: 200.r,
          height: 200.r,
          colors: [
            AppColors.primary.withOpacity(0.5),
            AppColors.primary.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        
        _buildGlowingOrb(
          animation: _scaleAnimation,
          bottom: -40,
          left: -40,
          width: 160.r,
          height: 160.r,
          colors: [
            AppColors.neonBlue.withOpacity(0.4),
            AppColors.neonBlue.withOpacity(0.15),
            Colors.transparent,
          ],
          inverse: true,
        ),
        
        _buildGlowingOrb(
          animation: _pulseAnimation,
          top: 80.h,
          left: -20,
          width: 120.r,
          height: 120.r,
          colors: [
            AppColors.neonBlue.withOpacity(0.3),
            AppColors.neonBlue.withOpacity(0.1),
            Colors.transparent,
          ],
        ),
        
        // Floating icons (optional)
        // if (widget.showFloatingIcons) ...[
        //   _buildFloatingIcon(
        //     animation: _primaryController,
        //     icon: Icons.stars_rounded,
        //     color: AppColors.neonBlue,
        //     size: 28.r,
        //     top: 30.h,
        //     left: 20.w,
        //     verticalOffset: 15,
        //     rotation: 0.5,
        //   ),
          
        //   _buildFloatingIcon(
        //     animation: _primaryController,
        //     icon: Icons.emoji_events_rounded,
        //     color: Colors.orange,
        //     size: 24.r,
        //     top: 50.h,
        //     right: 30.w,
        //     verticalOffset: 20,
        //     rotation: -0.3,
        //     inverse: true,
        //   ),
          
        //   _buildFloatingIcon(
        //     animation: _pulseController,
        //     icon: Icons.monetization_on_rounded,
        //     color: AppColors.neonBlue,
        //     size: 20.r,
        //     bottom: 40.h,
        //     right: 50.w,
        //     verticalOffset: 10,
        //   ),
          
        //   _buildFloatingIcon(
        //     animation: _pulseController,
        //     icon: Icons.favorite_rounded,
        //     color: Colors.pink,
        //     size: 18.r,
        //     bottom: 70.h,
        //     left: 40.w,
        //     verticalOffset: 12,
        //     inverse: true,
        //   ),
        // ],
        
        // Child content
        widget.child,
      ],
    );
  }

  Widget _buildGlowingOrb({
    required Animation<double> animation,
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double width,
    required double height,
    required List<Color> colors,
    bool inverse = false,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          top: top,
          bottom: bottom,
          left: left,
          right: right,
          child: Transform.scale(
            scale: inverse 
              ? 1.1 - (animation.value - 0.95)
              : animation.value,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: colors),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingIcon({
    required Animation<double> animation,
    required IconData icon,
    required Color color,
    required double size,
    double? top,
    double? bottom,
    double? left,
    double? right,
    double verticalOffset = 15,
    double rotation = 0,
    bool inverse = false,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final offset = inverse 
          ? verticalOffset * (1 - animation.value)
          : verticalOffset * animation.value;
          
        return Positioned(
          top: top != null ? top + offset : null,
          bottom: bottom != null ? bottom + offset : null,
          left: left,
          right: right,
          child: Transform.rotate(
            angle: rotation * animation.value,
            child: Opacity(
              opacity: 0.3 + (0.1 * animation.value),
              child: Icon(
                icon,
                color: color,
                size: size,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Simplified version for specific use cases
class HeaderAnimatedBackground extends StatelessWidget {
  final Widget child;
  
  const HeaderAnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedGameBackground(
      showParticles: true,
      showFloatingIcons: true,
      intensity: 1.0,
      child: child,
    );
  }
}

class HomeScreenAnimatedBackground extends StatelessWidget {
  final Widget child;
  
  const HomeScreenAnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedGameBackground(
      showParticles: false,
      showFloatingIcons: true,
      intensity: 0.8,
      gradientColors: [
        const Color(0xFF1a5c44),
        const Color(0xFF0b2030).withOpacity(0.4),
        const Color(0xFF07141d).withOpacity(0.7),
      ],
      child: child,
    );
  }
}
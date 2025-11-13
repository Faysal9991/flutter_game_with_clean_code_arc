// presentation/widgets/glass_card.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable glass‑morphic card that pulls its colours from the current
/// ThemeData (cardColor, primaryColor, dividerColor, etc.).
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final EdgeInsetsGeometry? padding;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 28.0,
    this.blurSigma = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // ── Tint (the “glass” fill) ─────────────────────────────────────
    final glassTint = theme.cardColor.withOpacity(isDark ? 0.20 : 0.35);

    // ── Border colour (subtle outline) ─────────────────────────────
    final borderColor = (isDark
            ? theme.dividerColor.withOpacity(0.3)
            : theme.dividerColor.withOpacity(0.3))
        .withOpacity(0.3);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding ?? EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: glassTint,
            borderRadius: BorderRadius.circular(borderRadius.r),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
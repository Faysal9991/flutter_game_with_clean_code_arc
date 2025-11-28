import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  /// NEW COLOR LOGIC USING YOUR PALETTE
  Color _getButtonColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // SIGN IN — Primary Green
    if (text.toLowerCase().contains("sign in")) {
      return AppColors.primaryGreen;
    }

    // SIGN UP / CREATE ACCOUNT — Neon Green
    if (text.toLowerCase().contains("create") ||
        text.toLowerCase().contains("account") ||
        text.toLowerCase().contains("sign up")) {
      return AppColors.neonGreen;
    }

    // SIGN OUT — Neon Purple (warning feel)
    if (text.toLowerCase().contains("sign out")) {
      return AppColors.neonPurple;
    }

    // DEFAULT — Sea Blue
    return AppColors.sea;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = _getButtonColor(context);
    final textColor = isDark ? AppColors.ink : Colors.white;

    return SizedBox(
      height: 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 14,
          shadowColor: bgColor.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),

          /// Neon Glow Effect
          overlayColor: AppColors.glow.withOpacity(0.2),
        ),
        child: isLoading
            ? SizedBox(
                width: 22.r,
                height: 22.r,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2.3,
                ),
              )
            : Text(
                text,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: bgColor.withOpacity(0.8),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

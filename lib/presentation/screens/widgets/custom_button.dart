// presentation/widgets/custom_button.dart
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

  Color _getColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (text.contains('Sign In')) return isDark ? AppColors.asparagus : AppColors.asparagus400;
    if (text.contains('Create') || text.contains('Account')) return isDark ? AppColors.yellowGreen : AppColors.yellowGreen400;
    if (text.contains('Sign Out')) return isDark ? AppColors.bittersweet : AppColors.bittersweet400;
    return isDark ? AppColors.asparagus : AppColors.asparagus;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = _getColor(context);
    final textColor = theme.brightness == Brightness.dark ? AppColors.parchment : Colors.white;

    return SizedBox(
      height: 56.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 10,
          shadowColor: bgColor.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        ),
        child: isLoading
            ? SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator(color: textColor, strokeWidth: 2),
              )
            : Text(
                text,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
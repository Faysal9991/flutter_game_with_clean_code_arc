import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;

  // NEW PROPS
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.readOnly = false,
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // TEXT COLORS
    final textColor = isDark ? AppColors.glow : AppColors.sea;
    final labelColor = isDark ? AppColors.neonBlue : AppColors.primaryGreen;

    // FIELD BACKGROUND
    final fillColor = isDark
        ? AppColors.ink.withOpacity(0.4)
        : AppColors.sky.withOpacity(0.25);

    // BORDER COLORS
    final enabledBorderColor = isDark ? AppColors.neonBlue : AppColors.sky;
    final focusedBorderColor = isDark ? AppColors.neonGreen : AppColors.primaryGreen;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,

      style: TextStyle(
        fontSize: 16.sp,
        color: textColor,
      ),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color: labelColor,
        ),

        prefixIcon: Icon(
          icon,
          size: 20.r,
          color: isDark ? AppColors.neonBlue : AppColors.primaryGreen,
        ),

        suffixIcon: suffixIcon,

        filled: true,
        fillColor: fillColor,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: enabledBorderColor,
            width: 1.5,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 2.4,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.neonPurple,
            width: 1.4,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: AppColors.neonPurple,
            width: 2.4,
          ),
        ),

        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: AppColors.neonPurple,
          fontWeight: FontWeight.w500,
        ),

        contentPadding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 18.w,
        ),
      ),
    );
  }
}

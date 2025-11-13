// presentation/widgets/custom_text_field.dart
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
  
  // ── NEW PROPS ───────────────────────────────────────────────────────
  final bool readOnly;          // makes the field non-editable
  final VoidCallback? onTap;    // opens picker / dialog
  final Widget? suffixIcon;     // e.g. dropdown arrow

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.readOnly = false,      // default
    this.onTap,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        color: isDark ? AppColors.parchment : AppColors.hunterGreen,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          color: isDark ? AppColors.parchment700 : AppColors.hunterGreen700,
        ),
        prefixIcon: Icon(
          icon,
          size: 20.r,
          color: isDark ? AppColors.parchment600 : AppColors.hunterGreen600,
        ),
        suffixIcon: suffixIcon,                 // ← dropdown arrow
        filled: true,
        fillColor: isDark
            ? AppColors.hunterGreen200.withOpacity(0.3)
            : AppColors.parchment800.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: isDark ? AppColors.hunterGreen600 : AppColors.hunterGreen300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.asparagus, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: isDark ? Colors.red.shade400 : Colors.red.shade700,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(
            color: isDark ? Colors.red.shade400 : Colors.red.shade700,
            width: 2.5,
          ),
        ),
        errorStyle: TextStyle(
          fontSize: 12.sp,
          color: isDark ? Colors.red.shade400 : Colors.red.shade700,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
      ),
    );
  }
}
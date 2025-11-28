import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ───────────────────────── Base Text Styles ─────────────────────────
  static TextStyle _baseTextStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 16.sp,
      color: isDark ? AppColors.glow : AppColors.ink,
    );
  }

  static TextStyle _headlineMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 28.sp,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.2,
      color: isDark ? AppColors.glow : AppColors.sea,
    );
  }

  static TextStyle _titleMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 16.sp,
      color: isDark ? AppColors.glow.withOpacity(0.7) : AppColors.sea,
    );
  }

  static TextStyle _bodyMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 16.sp,
      color: isDark ? AppColors.glow : AppColors.ink,
    );
  }

  // ───────────────────────── Light Theme ─────────────────────────────
  static ThemeData light(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: GoogleFonts.roboto().fontFamily,
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primaryGreen,
      cardColor: AppColors.sky.withOpacity(0.15),

      textTheme: TextTheme(
        headlineMedium: _headlineMedium(context),
        titleMedium: _titleMedium(context),
        bodyMedium: _bodyMedium(context),
        labelLarge: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 6,
          shadowColor: AppColors.primaryGreen.withOpacity(0.5),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.sky.withOpacity(0.2),
        labelStyle: GoogleFonts.roboto(
          color: AppColors.sea.withOpacity(0.8),
          fontSize: 14.sp,
        ),
        hintStyle: GoogleFonts.roboto(
          color: AppColors.sea.withOpacity(0.5),
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.sea.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
      ),
    );
  }

  // ───────────────────────── Dark Theme ──────────────────────────────
  static ThemeData dark(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.roboto().fontFamily,
      scaffoldBackgroundColor: AppColors.ink,
      primaryColor: AppColors.primaryGreen,
      cardColor: AppColors.sea.withOpacity(0.6),

      textTheme: TextTheme(
        headlineMedium: _headlineMedium(context),
        titleMedium: _titleMedium(context),
        bodyMedium: _bodyMedium(context),
        labelLarge: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.glow,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.ink,
          textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: 12,
          shadowColor: AppColors.neonGreen.withOpacity(0.3),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.ink.withOpacity(0.35),
        labelStyle: GoogleFonts.roboto(
          color: AppColors.glow.withOpacity(0.7),
          fontSize: 14.sp,
        ),
        hintStyle: GoogleFonts.roboto(
          color: AppColors.glow.withOpacity(0.4),
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.glow.withOpacity(0.3), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.neonBlue, width: 2.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
      ),
    );
  }
}

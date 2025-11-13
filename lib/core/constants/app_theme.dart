// lib/core/constants/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ── Reusable Text Styles (Black/White only) ───────────────────────
  static TextStyle _baseTextStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 16.sp,
      color: isDark ? Colors.white : Colors.black,
    );
  }

  static TextStyle _headlineMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 28.sp,
      fontWeight: FontWeight.w700,
      color: isDark ? Colors.white : Colors.black,
      letterSpacing: 1.2,
    );
  }

  static TextStyle _titleMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 16.sp,
      color: isDark ? Colors.white70 : Colors.black54,
    );
  }

  static TextStyle _bodyMedium(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.roboto(
      fontSize: 16.sp,
      color: isDark ? Colors.white : Colors.black,
    );
  }

  // ── Light Theme ─────────────────────────────────────────────────────
  static ThemeData light(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: GoogleFonts.roboto().fontFamily,
      scaffoldBackgroundColor: Colors.white, // Pure white
      primaryColor: AppColors.primary,
      cardColor: AppColors.parchment.withOpacity(0.98),

      // Text Theme: Black only
      textTheme: TextTheme(
        headlineMedium: _headlineMedium(context),
        titleMedium: _titleMedium(context),
        bodyMedium: _bodyMedium(context),
        labelLarge: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Button text
        ),
      ),

      // Buttons: Use AppColors
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 8,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.parchment800.withOpacity(0.6),
        labelStyle: GoogleFonts.roboto(
          color: Colors.black54,
          fontSize: 14.sp,
        ),
        hintStyle: GoogleFonts.roboto(
          color: Colors.black38,
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.black26, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.asparagus, width: 2.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────────────
  static ThemeData dark(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.roboto().fontFamily,
      scaffoldBackgroundColor: Colors.black, // Pure black
      primaryColor: AppColors.primary,
      cardColor: AppColors.hunterGreen200.withOpacity(0.95),

      // Text Theme: White only
      textTheme: TextTheme(
        headlineMedium: _headlineMedium(context),
        titleMedium: _titleMedium(context),
        bodyMedium: _bodyMedium(context),
        labelLarge: GoogleFonts.roboto(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Button text
        ),
      ),

      // Buttons: Use AppColors
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.roboto(fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          elevation: 8,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.hunterGreen200.withOpacity(0.3),
        labelStyle: GoogleFonts.roboto(
          color: Colors.white70,
          fontSize: 14.sp,
        ),
        hintStyle: GoogleFonts.roboto(
          color: Colors.white54,
          fontSize: 16.sp,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: Colors.white24, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide(color: AppColors.asparagus, width: 2.5),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
      ),
    );
  }
}
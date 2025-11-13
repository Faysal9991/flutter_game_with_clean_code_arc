// lib/core/utils/helpers.dart
import 'dart:math';
import 'package:flutter/material.dart';

class Helpers {
  // ────────────────────────────────────────────────────────────────
  // Global Navigator Key
  // ────────────────────────────────────────────────────────────────
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // ────────────────────────────────────────────────────────────────
  // ID & Math Helpers
  // ────────────────────────────────────────────────────────────────
  static String generateRandomId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(8, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  static double clamp(double value, double min, double max) {
    return value < min ? min : (value > max ? max : value);
  }

  // ────────────────────────────────────────────────────────────────
  // Navigation Helper (NO CONTEXT)
  // ────────────────────────────────────────────────────────────────
  static BuildContext get _context => navigatorKey.currentContext!;

  static Future<T?> push<T extends Object?>(Widget page, {bool replace = false, bool clearStack = false}) {
    final route = MaterialPageRoute<T>(builder: (_) => page);

    if (clearStack) {
      return Navigator.of(_context).pushAndRemoveUntil<T>(route, (r) => false);
    } else if (replace) {
      return Navigator.of(_context).pushReplacement<T, T>(route);
    } else {
      return Navigator.of(_context).push<T>(route);
    }
  }

  static void pop<T extends Object?>([T? result]) {
    if (Navigator.of(_context).canPop()) {
      Navigator.of(_context).pop<T>(result);
    }
  }

  static void popUntil(String routeName) {
    Navigator.of(_context).popUntil(ModalRoute.withName(routeName));
  }

  static Future<T?> pushAndClearStack<T extends Object?>(Widget page) {
    return push(page, clearStack: true);
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Widget page) {
    return push(page, replace: true);
  }

  // ────────────────────────────────────────────────────────────────
  // Snackbar (NO CONTEXT)
  // ────────────────────────────────────────────────────────────────
  static void showSnackBar(
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showError(String message) {
    showSnackBar(message, backgroundColor: Colors.red.shade600);
  }

  static void showSuccess(String message) {
    showSnackBar(message, backgroundColor: Colors.green.shade600);
  }
}
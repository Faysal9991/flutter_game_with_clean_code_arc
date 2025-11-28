// lib/presentation/splash/splash_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_faysal_game/core/utils/logger.dart';
import 'package:flutter_faysal_game/presentation/admin_panel/home_screen.dart';
import 'package:flutter_faysal_game/presentation/screens/authentication/sign_in.dart';
import 'package:flutter_faysal_game/presentation/screens/home/home_screen.dart';
import 'package:flutter_faysal_game/presentation/splash/widget/backgroud_widget.dart';
import 'package:flutter_faysal_game/services/localdata_service.dart';
import 'package:get_it/get_it.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;
  final _storage = GetIt.I<LocalStorageService>();

  @override
  void initState() {
    super.initState();
    _checkUserAndNavigate();
  }

  Future<void> _checkUserAndNavigate() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 3));
    if (!_storage.isLoggedIn) {
      _navigateToSignIn();
      return;
    }

    final user = _storage.user;
    final username = user['username'] ?? user['email']?.split('@').first ?? 'User';
    final uid = user['uid'] ?? 'unknown';

    logger.i("Offline user found: $username (UID: $uid)");
    final isAdmin = _storage.isAdmin;

    if (!mounted) return;

    final destination = isAdmin ? const AdminHomeScreen() : const HomeScreen();
    logger.d("Navigating to: $destination");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  void _navigateToSignIn() {
    if (!mounted) return;
    setState(() => _showSplash = false);
  }

  @override
  Widget build(BuildContext context) {
    return _showSplash
        ? GreenLifeSplashScreen(
            onComplete: _navigateToSignIn, // ← NOW WORKS
          )
        : const SignInScreen();
  }
}
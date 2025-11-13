// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_faysal_game/core/utils/helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // ← ADD for preloading

import 'core/di/injection_container.dart';
import 'core/constants/app_theme.dart'; // ← ADD: Your custom theme
import 'firebase_options.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/screens/authentication/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize DI
  await configureDependencies();

  // Optional: Preload Roboto to avoid flash
  await GoogleFonts.pendingFonts([GoogleFonts.roboto()]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
          ],
          child: MaterialApp(
            navigatorKey: Helpers.navigatorKey,
            title: 'Corporate Battle Arena',
            debugShowCheckedModeBanner: false,
           theme: AppTheme.light(context),
  darkTheme: AppTheme.dark(context),
  themeMode: ThemeMode.dark, // ← NOW USING YOUR CUSTOM THEME
            home: const SignInScreen(),
          ),
        );
      },
    );
  }
}
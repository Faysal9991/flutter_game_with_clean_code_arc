import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_faysal_game/presentation/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart';
import 'firebase_options.dart';
import 'presentation/screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await configureDependencies(); // GetIt + Injectable setup
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
  ],
  child: MaterialApp(
    title: 'Flame Game Auth',
    theme: ThemeData.dark(),
    home: const HomeScreen(),
  ),
);

  }
}

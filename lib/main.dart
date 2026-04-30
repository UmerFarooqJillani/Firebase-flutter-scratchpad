import 'package:firebase_scratchpad/features/authentication/presentation/signup_screen.dart';
import 'package:firebase_scratchpad/services/firebase/firebase_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // reads firebase_options.dart
  // connects to correct Firebase project
  // starts native Firebase SDK
  await FirebaseInitializer.initialize();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // home: Scaffold(body: Center(child: Text("data"))),
      home: SignupScreen(),
    );
  }
}

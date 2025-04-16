import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/login.dart'; // importa la pantalla que creamos
import 'screens/home.dart'; // ← nueva pantalla principal

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Login(), // ← Aquí pones la pantalla de login
      routes: {'/home': (context) => const Home()},
    );
  }
}

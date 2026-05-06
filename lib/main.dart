import 'package:flutter/material.dart';
import 'data/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Regulations of Some Company',
debugShowCheckedModeBanner: false,
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 28, 200, 16),
  ),
  primaryColor: const Color.fromARGB(255, 28, 200, 16),
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 41, 200, 16),
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

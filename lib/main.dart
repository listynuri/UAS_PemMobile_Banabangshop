import 'package:flutter/material.dart';
import 'splash_screen.dart'; // 👈 tambahin ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Customer Book',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFFF9BC1), // bright pastel pink accent
          onPrimary: Colors.white,
          secondary: Color(0xFF8FD3C7), // pastel green
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFFFFF8FB),
          onBackground: Colors.black,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF8FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF9BC1),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(), // splash appears first
    );
  }
}

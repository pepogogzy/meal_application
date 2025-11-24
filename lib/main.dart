import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF746C), // Red
          primary: const Color(0xFFFF746C), // Red
          secondary: const Color(0xFFDCA1A1), // Brown
          tertiary: const Color(0xFFFFEE8C), // Yellow
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFFFDF7), // Warm off-white
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),

        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: const Color(0xFFFF746C), // Red
          foregroundColor: Colors.white,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: const Color(0xFFFFEE8C).withOpacity(0.3), // Light yellow
          labelStyle: const TextStyle(
            color: Color(0xFF6B4423), // Dark brown text
            fontWeight: FontWeight.w600,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF746C), // Red
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFFEE8C).withOpacity(0.1), // Very light yellow
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFDCA1A1), // Brown border when focused
              width: 2,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

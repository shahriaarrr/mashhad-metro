import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mashhad_metro/pages/home.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mashhad Metro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Arad",
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.bold,
          ),
          displayMedium: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.bold,
          ),
          displaySmall: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.w600,
          ),
          titleSmall: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.normal,
          ),
          labelLarge: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.w600,
          ),
          labelMedium: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.normal,
          ),
          labelSmall: TextStyle(
            fontFamily: "Arad",
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

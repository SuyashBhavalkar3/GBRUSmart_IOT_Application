import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'home_dashboard/screens/home_dashboard_screen.dart';

void main() {
  runApp(
    // Wrap the entire app in a ProviderScope to enable Riverpod state management.
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Motor Mitra Smart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1FAA59),
          primary: const Color(0xFF1FAA59),
        ),
      ),
      home: const HomeDashboardScreen(),
    );
  }
}

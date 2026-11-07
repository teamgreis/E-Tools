import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_page.dart';

class EToolsApp extends StatelessWidget {
  const EToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFF7656D6);
    return MaterialApp(
      title: 'E-Tools',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/screens/home_shell.dart';

class SteamCopiaApp extends StatelessWidget {
  const SteamCopiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SteamClone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF171A21),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B2838),
          brightness: Brightness.dark,
          surface: const Color(0xFF1B2838),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF171A21),
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: HomeShell(
        onLogout: () async {},
      ),
    );
  }
}

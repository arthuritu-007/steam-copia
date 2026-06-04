import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/app.dart';
import 'package:frontend/api/cart_provider.dart';
import 'package:frontend/api/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const SteamCopiaApp(),
    ),
  );
}

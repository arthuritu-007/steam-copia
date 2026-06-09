import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/app.dart';
import 'package:frontend/api/cart_provider.dart';
import 'package:frontend/api/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://twvdwbnujpbheoehnjpk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR3dmR3Ym51anBiaGVvZWhuanBrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA0MDQ1NjYsImV4cCI6MjA5NTk4MDU2Nn0.bHhLiOX3_Z7ZZg7YRL6m_81O6H-g2JwNxl1KehRUllA',
  );
  final authProvider = AuthProvider();
  authProvider.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const SteamCopiaApp(),
    ),
  );
}

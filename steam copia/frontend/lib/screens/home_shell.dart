import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:frontend/screens/store_screen.dart';
import 'package:frontend/screens/cart_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/api/auth_provider.dart';
import 'package:frontend/api/cart_provider.dart';

class HomeShell extends StatefulWidget {
  final Future<void> Function() onLogout;
  const HomeShell({super.key, required this.onLogout});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    final pages = [
      const StoreScreen(),
      const StoreScreen(), // Using StoreScreen for Catalogo as well for now
      if (auth.isLoggedIn) const LibraryScreen() else const LoginPlaceholder(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF171A21),
        title: Row(
          children: [
            const Text(
              'STEAMCLON',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF66C0F4),
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 20),
            _navItem('TIENDA', 0),
            _navItem('CATÁLOGO', 1),
            if (auth.isLoggedIn) _navItem('BIBLIOTECA', 2),
          ],
        ),
        actions: [
          if (auth.isLoggedIn) ...[
            Center(
              child: Text(
                auth.username ?? '',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            IconButton(
              onPressed: () => auth.logout(),
              icon: const Icon(Icons.logout, size: 18, color: Colors.white54),
            ),
          ] else
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LoginScreen(onLoggedIn: () {
                      Navigator.pop(context);
                      auth.login('Usuario'); // Mock username
                    }),
                  ),
                );
              },
              child: const Text('INICIAR SESIÓN', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ),
          
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white70),
              ),
              if (cart.count > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2838),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white24),
                    ),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      cart.count.toString(),
                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: _index, children: pages),
    );
  }

  Widget _navItem(String label, int index) {
    bool selected = _index == index;
    return TextButton(
      onPressed: () => setState(() => _index = index),
      style: TextButton.styleFrom(
        foregroundColor: selected ? Colors.white : Colors.grey,
        backgroundColor: selected ? Colors.white.withOpacity(0.1) : null,
        shape: const RoundedRectangleBorder(),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class LoginPlaceholder extends StatelessWidget {
  const LoginPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          const Text(
            'Inicia sesión para ver tu biblioteca',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(onLoggedIn: () {
                    Navigator.pop(context);
                    auth.login('Usuario');
                  }),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66C0F4),
              foregroundColor: Colors.black,
            ),
            child: const Text('INICIAR SESIÓN'),
          ),
        ],
      ),
    );
  }
}

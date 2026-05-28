import 'package:flutter/material.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:frontend/screens/store_screen.dart';

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
    final pages = [
      const StoreScreen(),
      const StoreScreen(), // Using StoreScreen for Catalogo as well for now
      const LibraryScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
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
            _navItem('BIBLIOTECA', 2),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined),
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

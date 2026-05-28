import 'package:flutter/material.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:frontend/screens/store_screen.dart';
import 'package:frontend/screens/cart_screen.dart';

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
                  child: const Text(
                    '2',
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
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

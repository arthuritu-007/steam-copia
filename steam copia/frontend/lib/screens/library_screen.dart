import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/api/cart_provider.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/screens/game_details_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.ownedGames;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mi biblioteca',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF66C0F4),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tienes ${items.length} juegos en tu biblioteca.',
                style: const TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white10),
        Expanded(
          child: items.isEmpty
              ? const Center(
                  child: Text(
                    'Aún no tienes juegos.\n¡Ve a la tienda y añade algunos!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white38),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _buildLibraryItem(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLibraryItem(LibraryItem item) {
    return Card(
      color: const Color(0xFF1B2838),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 100,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Center(
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 8, color: Colors.white54),
            ),
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Adquirido el ${item.acquiredAt.split('T')[0]}',
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameDetailsScreen(slug: item.slug, gameId: item.gameId),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF66C0F4),
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
          child: const Text('JUGAR'),
        ),
      ),
    );
  }
}

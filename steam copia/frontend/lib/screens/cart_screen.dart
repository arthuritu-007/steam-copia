import 'package:flutter/material.dart';
import 'package:frontend/api/cart_provider.dart';
import 'package:frontend/api/models.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartProvider _cart = CartProvider(); // Using local instance for simplicity if no provider pkg

  @override
  Widget build(BuildContext context) {
    // In a real app with provider, we would use context.watch<CartProvider>()
    // For now, let's use a simple approach to show the UI based on your capture
    
    return Scaffold(
      backgroundColor: const Color(0xFF171A21),
      appBar: AppBar(
        title: const Text('Mi carrito'),
        backgroundColor: const Color(0xFF1B2838),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Mi carrito',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF66C0F4),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCartItem('Cyberpunk 2077', 'RPG', 29.99, 'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg'),
                _buildCartItem('Elden Ring', 'Action RPG', 49.99, 'https://cdn.akamai.steamstatic.com/steam/apps/1245620/header.jpg'),
                const SizedBox(height: 8),
                const Text(
                  'Los artículos de tu carrito se guardan en sesión. Inicia sesión para finalizar.',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ),
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildCartItem(String title, String category, double price, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2838),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Image.network(imgUrl, width: 80, height: 45, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
                  child: Text(category, style: const TextStyle(color: Colors.blue, fontSize: 10)),
                ),
              ],
            ),
          ),
          Text('\$$price', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.close, color: Colors.white54, size: 18),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF1B2838),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumen del pedido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _summaryRow('Artículos (2):', '\$79.98'),
          _summaryRow('Descuentos:', '\$0.00', color: Colors.green),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Text('\$79.98 USD', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.check, size: 18),
              label: const Text('Finalizar compra'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF66C0F4),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Seguir comprando', style: TextStyle(color: Colors.white54)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54)),
          Text(value, style: TextStyle(color: color ?? Colors.white)),
        ],
      ),
    );
  }
}

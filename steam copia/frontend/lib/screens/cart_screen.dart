import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/api/cart_provider.dart';
import 'package:frontend/api/auth_provider.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/screens/login_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();
    
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
                if (cart.items.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text('Tu carrito está vacío', style: TextStyle(color: Colors.white38)),
                    ),
                  )
                else
                  ...cart.items.map((game) => _buildCartItem(game, cart)),
                const SizedBox(height: 8),
                if (!auth.isLoggedIn && cart.items.isNotEmpty)
                  const Text(
                    'Los artículos de tu carrito se guardan en sesión. Inicia sesión para finalizar.',
                    style: TextStyle(color: Colors.white38, fontSize: 11),
                  ),
              ],
            ),
          ),
          if (cart.items.isNotEmpty) _buildSummary(cart, auth),
        ],
      ),
    );
  }

  Widget _buildCartItem(GameSummary game, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2838),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Center(
              child: Text(
                game.title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 8, color: Colors.white54),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(game.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(2)),
                  child: Text(game.shortDescription, style: const TextStyle(color: Colors.blue, fontSize: 10)),
                ),
              ],
            ),
          ),
          Text('\$${(game.priceCents / 100).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () => cart.removeItem(game.id),
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

  Widget _buildSummary(CartProvider cart, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF1B2838),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumen del pedido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _summaryRow('Artículos (${cart.count}):', '\$${cart.total.toStringAsFixed(2)}'),
          _summaryRow('Descuentos:', '\$0.00', color: Colors.green),
          const Divider(color: Colors.white10, height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('\$${cart.total.toStringAsFixed(2)} USD', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                if (!auth.isLoggedIn) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LoginScreen(onLoggedIn: () {
                        Navigator.pop(context);
                        auth.login('Usuario');
                      }),
                    ),
                  );
                } else {
                  cart.purchase();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('¡Compra realizada! Los juegos están en tu biblioteca.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              icon: Icon(auth.isLoggedIn ? Icons.check : Icons.lock_outline, size: 18),
              label: Text(auth.isLoggedIn ? 'Finalizar compra' : 'Inicia sesión para pagar'),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/api/repository_provider.dart';
import 'package:frontend/api/cart_provider.dart';
import 'package:frontend/api/auth_provider.dart';
import 'package:frontend/screens/login_screen.dart';

class GameDetailsScreen extends StatefulWidget {
  final String slug;
  final String gameId;
  const GameDetailsScreen({
    super.key,
    required this.slug,
    required this.gameId,
  });

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  Future<GameDetails>? _future;

  @override
  void initState() {
    super.initState();
    _future = RepositoryProvider.games.getGameDetails(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF171A21),
      appBar: AppBar(
        title: const Text('Detalle del Juego'),
        backgroundColor: const Color(0xFF1B2838),
      ),
      body: FutureBuilder<GameDetails>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final g = snapshot.data!;
          bool isFree = g.priceCents == 0;
          bool isOwned = cart.isOwned(g.id);
          bool isInCart = cart.items.any((item) => item.id == g.id);

          return ListView(
            padding: const EdgeInsets.all(0),
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Text(
                      g.title,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white24),
                    ),
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g.shortDescription,
                      style: const TextStyle(color: Color(0xFF66C0F4), fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B2838),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('PRECIO', style: TextStyle(color: Colors.white54, fontSize: 10)),
                              Text(
                                isFree ? 'GRATIS' : '\$${(g.priceCents / 100).toStringAsFixed(2)} ${g.currency}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                          if (isOwned)
                            ElevatedButton.icon(
                              onPressed: null,
                              icon: const Icon(Icons.check),
                              label: const Text('EN LA BIBLIOTECA'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.withOpacity(0.2),
                                foregroundColor: Colors.green,
                              ),
                            )
                          else if (!auth.isLoggedIn)
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
                              child: const Text('INICIA SESIÓN PARA COMPRAR'),
                            )
                          else if (isInCart)
                            ElevatedButton.icon(
                              onPressed: () => cart.removeItem(g.id),
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('EN EL CARRITO (QUITAR)'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.withOpacity(0.2),
                                foregroundColor: Colors.orange,
                              ),
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                cart.addItem(GameSummary(
                                  id: g.id,
                                  slug: g.slug,
                                  title: g.title,
                                  shortDescription: g.shortDescription,
                                  priceCents: g.priceCents,
                                  currency: g.currency,
                                  releaseDate: g.releaseDate,
                                  headerImageUrl: g.headerImageUrl,
                                ));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Añadido al carrito')),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF66C0F4),
                                foregroundColor: Colors.black,
                              ),
                              child: Text(isFree ? 'AÑADIR A LA BIBLIOTECA' : 'AÑADIR AL CARRITO'),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'ACERCA DE ESTE JUEGO',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const Divider(color: Colors.white10),
                    const SizedBox(height: 8),
                    Text(
                      g.longDescription,
                      style: const TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

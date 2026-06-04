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
                  color: Colors.black.withAlpha(128),
                  child: Center(
                    child: Text(
                      g.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white24,
                      ),
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
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      g.shortDescription,
                      style: const TextStyle(
                        color: Color(0xFF66C0F4),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'DESCRIPCIÓN',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      g.longDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    DefaultTabController(
                      length: 2,
                      child: Column(
                        children: [
                          const TabBar(
                            tabs: [
                              Tab(text: 'COMPRAR'),
                              Tab(text: 'COMUNIDAD'),
                            ],
                            indicatorColor: Color(0xFF66C0F4),
                            labelColor: Color(0xFF66C0F4),
                            unselectedLabelColor: Colors.white54,
                          ),
                          SizedBox(
                            height: 400,
                            child: TabBarView(
                              children: [
                                _buildPurchaseSection(
                                  g,
                                  isFree,
                                  isOwned,
                                  isInCart,
                                  auth,
                                  cart,
                                ),
                                _CommunitySection(gameId: g.id),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildPurchaseSection(
    GameDetails g,
    bool isFree,
    bool isOwned,
    bool isInCart,
    AuthProvider auth,
    CartProvider cart,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
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
                const Text(
                  'PRECIO',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                Text(
                  isFree
                      ? 'GRATIS'
                      : '${g.currency} ${(g.priceCents / 100).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (isOwned)
              const Text(
                'EN TU BIBLIOTECA',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            else if (isInCart)
              const Text(
                'EN EL CARRITO',
                style: TextStyle(
                  color: Color(0xFF66C0F4),
                  fontWeight: FontWeight.bold,
                ),
              )
            else
              ElevatedButton(
                onPressed: () {
                  if (!auth.isLoggedIn) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          onLoggedIn: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  } else {
                    cart.addItem(
                      GameSummary(
                        id: g.id,
                        slug: g.slug,
                        title: g.title,
                        shortDescription: g.shortDescription,
                        priceCents: g.priceCents,
                        currency: g.currency,
                        releaseDate: g.releaseDate,
                        headerImageUrl: g.headerImageUrl,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF67c1f5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text('AÑADIR AL CARRITO'),
              ),
          ],
        ),
      ),
    );
  }
}

class _CommunitySection extends StatefulWidget {
  final String gameId;
  const _CommunitySection({required this.gameId});

  @override
  State<_CommunitySection> createState() => _CommunitySectionState();
}

class _CommunitySectionState extends State<_CommunitySection> {
  final _postController = TextEditingController();
  Future<List<CommunityPost>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _future = RepositoryProvider.games.listCommunityPosts(widget.gameId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Column(
      children: [
        if (auth.isLoggedIn)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _postController,
                    decoration: InputDecoration(
                      hintText: 'Publica algo en la comunidad...',
                      filled: true,
                      fillColor: Colors.black26,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    if (_postController.text.trim().isEmpty) return;
                    try {
                      await RepositoryProvider.games.createCommunityPost(
                        widget.gameId,
                        _postController.text.trim(),
                      );
                      _postController.clear();
                      _reload();
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  icon: const Icon(Icons.send, color: Color(0xFF66C0F4)),
                ),
              ],
            ),
          )
        else
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Inicia sesión para participar en la comunidad',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        Expanded(
          child: FutureBuilder<List<CommunityPost>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return const Center(
                  child: Text('No hay publicaciones aún. ¡Sé el primero!'),
                );
              }
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final p = posts[index];
                  return Card(
                    color: const Color(0xFF2A475E),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                p.username,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF66C0F4),
                                ),
                              ),
                              Text(
                                '${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year} ${p.createdAt.hour}:${p.createdAt.minute.toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            p.content,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

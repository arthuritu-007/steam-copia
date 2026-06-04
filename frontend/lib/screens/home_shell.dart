import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/screens/library_screen.dart';
import 'package:frontend/screens/store_screen.dart';
import 'package:frontend/screens/cart_screen.dart';
import 'package:frontend/screens/login_screen.dart';
import 'package:frontend/screens/game_details_screen.dart';
import 'package:frontend/api/auth_provider.dart';
import 'package:frontend/api/cart_provider.dart';
import 'package:frontend/screens/admin_panel_screen.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/api/repository_provider.dart';

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
    final cs = Theme.of(context).colorScheme;

    if (_index == 3 && auth.userRole != 'ADMIN') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _index = 0);
      });
    }

    final pages = [
      const StoreScreen(),
      if (auth.isLoggedIn) const LibraryScreen() else const LoginPlaceholder(),
      const CommunityHubScreen(),
      if (auth.userRole == 'ADMIN')
        const AdminPanelScreen()
      else
        const SizedBox.shrink(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'STEAMCLON',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: cs.primary,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 20),
            _navItem('TIENDA', 0),
            _navItem('BIBLIOTECA', 1),
            _navItem('COMUNIDAD', 2),
            if (auth.userRole == 'ADMIN') _navItem('ADMIN', 3),
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
                    builder: (_) => LoginScreen(
                      onLoggedIn: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                'INICIAR SESIÓN',
                style: TextStyle(fontSize: 12),
              ),
            ),

          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white70,
                ),
              ),
              if (cart.count > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.white24),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      cart.count.toString(),
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
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
        backgroundColor: selected ? Colors.white.withAlpha(26) : null,
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
                  builder: (_) => LoginScreen(
                    onLoggedIn: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              );
            },
            child: const Text('INICIAR SESIÓN'),
          ),
        ],
      ),
    );
  }
}

enum _CommunitySort { popular, recent }

class CommunityHubScreen extends StatefulWidget {
  const CommunityHubScreen({super.key});

  @override
  State<CommunityHubScreen> createState() => _CommunityHubScreenState();
}

class _CommunityHubScreenState extends State<CommunityHubScreen> {
  Future<List<GameSummary>>? _future;
  final _productSearch = TextEditingController();
  String _activeFeedTab = 'Todo';
  _CommunitySort _sort = _CommunitySort.recent;

  @override
  void initState() {
    super.initState();
    _future = RepositoryProvider.games.listGames();
  }

  @override
  void dispose() {
    _productSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 980;
        if (!isWide) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeader(cs),
              const SizedBox(height: 12),
              _buildTopPanels(cs),
              const SizedBox(height: 12),
              _buildFeed(cs),
            ],
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 220, child: _buildSidebar(cs)),
                const SizedBox(width: 16),
                Expanded(
                  child: ListView(
                    children: [
                      _buildHeader(cs),
                      const SizedBox(height: 12),
                      _buildTopPanels(cs),
                      const SizedBox(height: 12),
                      _buildFeed(cs),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidebar(ColorScheme cs) {
    final items = [
      'Destacados',
      'Lista de descubrimientos',
      'Lista de deseados',
      'Tienda de puntos',
      'Noticias',
      'Gráficos',
    ];

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          ...items.map(
            (t) => InkWell(
              onTap: () {
                setState(() {
                  _activeFeedTab = t == 'Noticias' ? 'Noticias' : 'Todo';
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(
                  t,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividad de la comunidad',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'Contenido oficial y de la comunidad para todos los juegos y software.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _productSearch,
                  decoration: const InputDecoration(
                    hintText: 'Buscar productos',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) {
                    setState(() {
                      _future = RepositoryProvider.games.listGames(
                        q: _productSearch.text,
                      );
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar gente',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (_) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopPanels(ColorScheme cs) {
    return FutureBuilder<List<GameSummary>>(
      future: _future,
      builder: (context, snapshot) {
        final games = snapshot.data ?? [];
        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 980;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: isWide
                      ? (constraints.maxWidth - 24) / 3
                      : constraints.maxWidth,
                  child: _gamesPanel(
                    cs,
                    'Jugados recientemente',
                    games.take(4).toList(),
                  ),
                ),
                SizedBox(
                  width: isWide
                      ? (constraints.maxWidth - 24) / 3
                      : constraints.maxWidth,
                  child: _gamesPanel(
                    cs,
                    'Vistos recientemente',
                    games.skip(1).take(4).toList(),
                  ),
                ),
                SizedBox(
                  width: isWide
                      ? (constraints.maxWidth - 24) / 3
                      : constraints.maxWidth,
                  child: _panel(cs, 'Centros populares', const [
                    'Acción',
                    'Indie',
                    'RPG',
                    'Estrategia',
                  ]),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _gamesPanel(ColorScheme cs, String title, List<GameSummary> games) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ...games.map(
            (g) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailsScreen(
                      slug: g.slug,
                      gameId: g.id,
                      initialTabIndex: 1,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(60),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(color: Colors.white10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: g.headerImageUrl == null
                          ? null
                          : Image.network(
                              g.headerImageUrl!,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox.shrink(),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        g.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(ColorScheme cs, String title, List<String> items) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(60),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: Colors.white10),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      t,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeed(ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                _feedTab(cs, 'Todo'),
                _feedTab(cs, 'Capturas'),
                _feedTab(cs, 'Vídeos'),
                _feedTab(cs, 'Noticias'),
                const Spacer(),
                TextButton(
                  onPressed: () =>
                      setState(() => _sort = _CommunitySort.popular),
                  child: const Text('MÁS POPULARES'),
                ),
                const SizedBox(width: 6),
                TextButton(
                  onPressed: () =>
                      setState(() => _sort = _CommunitySort.recent),
                  child: const Text('MÁS RECIENTES'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: FutureBuilder<List<GameSummary>>(
              future: _future,
              builder: (context, gamesSnapshot) {
                final games = gamesSnapshot.data ?? const <GameSummary>[];
                return FutureBuilder<List<_CommunityFeedItem>>(
                  future: _loadFeedItems(games),
                  builder: (context, feedSnapshot) {
                    if (feedSnapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final items =
                        feedSnapshot.data ?? const <_CommunityFeedItem>[];
                    if (items.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'No hay actividad aún.\nEntra a un juego y publica en la pestaña Comunidad.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        for (int i = 0; i < items.length; i++) ...[
                          _feedCard(cs, items[i]),
                          if (i != items.length - 1) const SizedBox(height: 12),
                        ],
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedTab(ColorScheme cs, String label) {
    final selected = _activeFeedTab == label;
    return InkWell(
      onTap: () => setState(() => _activeFeedTab = label),
      borderRadius: BorderRadius.circular(2),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, top: 2, bottom: 2),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white54,
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Future<List<_CommunityFeedItem>> _loadFeedItems(
    List<GameSummary> games,
  ) async {
    final base = _activeFeedTab == 'Noticias'
        ? games.where((g) => g.isFeatured).toList()
        : games;
    final selectedGames = base.take(6).toList();
    final lists = await Future.wait(
      selectedGames.map(
        (g) => RepositoryProvider.games.listCommunityPosts(g.id),
      ),
    );

    final items = <_CommunityFeedItem>[];
    for (int i = 0; i < selectedGames.length; i++) {
      final g = selectedGames[i];
      final posts = lists[i];
      for (final p in posts.take(2)) {
        items.add(_CommunityFeedItem(game: g, post: p));
      }
    }

    if (_sort == _CommunitySort.recent) {
      items.sort((a, b) => b.post.createdAt.compareTo(a.post.createdAt));
    } else {
      items.sort((a, b) => b.game.rating.compareTo(a.game.rating));
    }

    return items.take(12).toList();
  }

  Widget _feedCard(ColorScheme cs, _CommunityFeedItem item) {
    final g = item.game;
    final p = item.post;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailsScreen(
              slug: g.slug,
              gameId: g.id,
              initialTabIndex: 1,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(35),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2A475E), Color(0xFF0E1A2B)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              clipBehavior: Clip.antiAlias,
              child: g.headerImageUrl == null
                  ? const SizedBox.shrink()
                  : Image.network(
                      g.headerImageUrl!,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                      loadingBuilder: (context, child, progress) =>
                          progress == null
                          ? child
                          : Container(color: Colors.black.withAlpha(60)),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    g.title,
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        p.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.content,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Marcado como “Me gusta”'),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up_alt_outlined,
                              color: cs.primary,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Me gusta',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameDetailsScreen(
                                slug: g.slug,
                                gameId: g.id,
                                initialTabIndex: 1,
                              ),
                            ),
                          );
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.white54,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Comentar',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommunityFeedItem {
  final GameSummary game;
  final CommunityPost post;

  _CommunityFeedItem({required this.game, required this.post});
}

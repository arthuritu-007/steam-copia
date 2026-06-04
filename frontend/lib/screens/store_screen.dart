import 'package:flutter/material.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/api/repository_provider.dart';
import 'package:frontend/screens/game_details_screen.dart';

enum _StoreView { explore, recommendations, categories, category, playWays }

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _search = TextEditingController();
  Future<List<GameSummary>>? _future;
  final _featuredController = PageController(viewportFraction: 1);
  int _featuredIndex = 0;
  _StoreView _view = _StoreView.explore;
  String? _category;
  bool _filterFree = false;
  bool _filterTopSeller = false;
  bool _filterNew = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _search.dispose();
    _featuredController.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = RepositoryProvider.games.listGames(q: _search.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async => _reload(),
      child: ListView(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1B2838), Color(0xFF171A21)],
              ),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: _buildStoreSubnav(cs),
                ),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FutureBuilder<List<GameSummary>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 80),
                        child: Center(child: Text(snapshot.error.toString())),
                      );
                    }

                    final games = snapshot.data ?? [];
                    if (games.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(
                          child: Text('No hay juegos para mostrar'),
                        ),
                      );
                    }

                    switch (_view) {
                      case _StoreView.explore:
                        return _buildExplore(cs, games);
                      case _StoreView.recommendations:
                        return _buildRecommendations(cs, games);
                      case _StoreView.categories:
                        return _buildCategories(cs, games);
                      case _StoreView.category:
                        return _buildCategory(cs, games);
                      case _StoreView.playWays:
                        return _buildPlayWays(cs, games);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplore(ColorScheme cs, List<GameSummary> games) {
    final featured = games.where((g) => g.isFeatured).toList();
    final featuredGames = featured.isEmpty
        ? games.take(5).toList()
        : featured.take(6).toList();
    final discounts = games.take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Destacados y recomendados',
          trailing: TextButton(
            onPressed: () => setState(() => _view = _StoreView.recommendations),
            child: const Text('VER MÁS'),
          ),
        ),
        const SizedBox(height: 8),
        _buildFeaturedCarousel(cs, featuredGames),
        const SizedBox(height: 18),
        _buildWidePromo(cs),
        const SizedBox(height: 18),
        _buildSectionHeader(
          title: 'Descuentos y eventos',
          trailing: TextButton(
            onPressed: () {
              setState(() {
                _view = _StoreView.playWays;
                _filterTopSeller = true;
                _filterNew = false;
              });
            },
            child: const Text('VER MÁS'),
          ),
        ),
        const SizedBox(height: 8),
        _buildGamesGrid(discounts),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRecommendations(ColorScheme cs, List<GameSummary> games) {
    final recommended = [...games]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    final top = recommended.take(16).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _view = _StoreView.explore),
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
            ),
            const SizedBox(width: 4),
            const Text(
              'Recomendaciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => setState(() => _view = _StoreView.categories),
              child: const Text('CATEGORÍAS'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildGamesGrid(top),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategories(ColorScheme cs, List<GameSummary> games) {
    final categories = games.map((g) => g.shortDescription).toSet().toList()
      ..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _view = _StoreView.explore),
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
            ),
            const SizedBox(width: 4),
            const Text(
              'Categorías',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...categories.map(
              (c) => OutlinedButton(
                onPressed: () => setState(() {
                  _category = c;
                  _view = _StoreView.category;
                }),
                child: Text(c.toUpperCase()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategory(ColorScheme cs, List<GameSummary> games) {
    final category = _category;
    final filtered = category == null
        ? games
        : games.where((g) => g.shortDescription == category).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _view = _StoreView.categories),
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
            ),
            const SizedBox(width: 4),
            Text(
              category == null ? 'Categoría' : category,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: () =>
                  setState(() => _view = _StoreView.recommendations),
              child: const Text('RECOMENDAR'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildGamesGrid(filtered),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPlayWays(ColorScheme cs, List<GameSummary> games) {
    final filtered = games.where((g) {
      if (_filterFree && g.priceCents != 0) return false;
      if (_filterTopSeller && !g.isTopSeller) return false;
      if (_filterNew && !g.isNew) return false;
      return true;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => setState(() => _view = _StoreView.explore),
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
            ),
            const SizedBox(width: 4),
            const Text(
              'Formas de jugar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilterChip(
              label: const Text('GRATIS'),
              selected: _filterFree,
              onSelected: (v) => setState(() => _filterFree = v),
            ),
            FilterChip(
              label: const Text('MÁS VENDIDOS'),
              selected: _filterTopSeller,
              onSelected: (v) => setState(() => _filterTopSeller = v),
            ),
            FilterChip(
              label: const Text('NUEVOS'),
              selected: _filterNew,
              onSelected: (v) => setState(() => _filterNew = v),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildGamesGrid(filtered),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGamesGrid(List<GameSummary> games) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980
            ? 4
            : (constraints.maxWidth >= 680 ? 3 : 2);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            childAspectRatio: 0.78,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) => _buildGameCard(games[index]),
        );
      },
    );
  }

  Widget _buildStoreSubnav(ColorScheme cs) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _subnavChip(
                  'Explorar',
                  selected: _view == _StoreView.explore,
                  onTap: () {
                    setState(() => _view = _StoreView.explore);
                  },
                ),
                _subnavChip(
                  'Recomendaciones',
                  selected: _view == _StoreView.recommendations,
                  onTap: () {
                    setState(() => _view = _StoreView.recommendations);
                  },
                ),
                _subnavChip(
                  'Categorías',
                  selected:
                      _view == _StoreView.categories ||
                      _view == _StoreView.category,
                  onTap: () {
                    setState(() => _view = _StoreView.categories);
                  },
                ),
                _subnavChip(
                  'Formas de jugar',
                  selected: _view == _StoreView.playWays,
                  onTap: () {
                    setState(() => _view = _StoreView.playWays);
                  },
                ),
                _subnavChip(
                  'Más',
                  selected: false,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Más opciones: usa Categorías, Recomendaciones o el buscador.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 340,
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _reload(),
            decoration: InputDecoration(
              hintText: 'Buscar en la tienda',
              suffixIcon: IconButton(
                onPressed: _reload,
                icon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _subnavChip(
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: selected ? Colors.white : Colors.white70,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          backgroundColor: selected
              ? Colors.black.withAlpha(60)
              : Colors.black.withAlpha(30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildSectionHeader({required String title, Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        ...?(trailing == null ? null : [trailing]),
      ],
    );
  }

  Widget _buildFeaturedCarousel(ColorScheme cs, List<GameSummary> featured) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 6,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _featuredController,
                  itemCount: featured.length,
                  onPageChanged: (i) => setState(() => _featuredIndex = i),
                  itemBuilder: (context, index) {
                    final g = featured[index];
                    return InkWell(
                      onTap: () => _openGame(g),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: _headerImage(g.headerImageUrl, g.title),
                          ),
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              color: cs.surface,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(child: _miniShot()),
                                      const SizedBox(width: 8),
                                      Expanded(child: _miniShot()),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(child: _miniShot()),
                                      const SizedBox(width: 8),
                                      Expanded(child: _miniShot()),
                                    ],
                                  ),
                                  const Spacer(),
                                  Text(
                                    g.shortDescription,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: _pricePill(cs, g),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      final next = _featuredIndex > 0
                          ? _featuredIndex - 1
                          : featured.length - 1;
                      _featuredController.animateToPage(
                        next,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      size: 34,
                      color: Colors.white70,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () {
                      final next = (_featuredIndex + 1) % featured.length;
                      _featuredController.animateToPage(
                        next,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                    icon: const Icon(
                      Icons.chevron_right,
                      size: 34,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: cs.surface.withAlpha(240),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                featured.length,
                (i) => Container(
                  width: 18,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _featuredIndex ? cs.primary : Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniShot() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(60),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: Colors.white10),
      ),
    );
  }

  Widget _pricePill(ColorScheme cs, GameSummary g) {
    if (g.priceCents == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(2),
        ),
        child: const Text(
          'GRATIS',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(60),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        '\$${(g.priceCents / 100).toStringAsFixed(2)}',
        style: TextStyle(
          color: cs.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildWidePromo(ColorScheme cs) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 88,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2A475E), Color(0xFF1B2838)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text(
                  'DESTACADO DE TEMPORADA',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 88,
            width: 220,
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(40),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.white10),
            ),
            child: const Center(
              child: Text(
                'Explora eventos',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(GameSummary game) {
    final isFree = game.priceCents == 0;

    final cs = Theme.of(context).colorScheme;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(128),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: _headerImage(game.headerImageUrl, game.title),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      return Icon(
                        index < game.rating.floor()
                            ? Icons.star
                            : (index < game.rating
                                  ? Icons.star_half
                                  : Icons.star_border),
                        color: Colors.orange,
                        size: 12,
                      );
                    }),
                    const SizedBox(width: 4),
                    Text(
                      game.rating.toString(),
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isFree)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Text(
                          'GRATIS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Text(
                        '\$${(game.priceCents / 100).toStringAsFixed(2)}',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      _openGame(game);
                    },
                    child: Text(
                      isFree ? 'Jugar ahora' : 'Ver detalle',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerImage(String? url, String title) {
    if (url == null || url.isEmpty) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A475E), Color(0xFF0E1A2B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A475E), Color(0xFF0E1A2B)],
          ),
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(color: Colors.black.withAlpha(80));
      },
    );
  }

  void _openGame(GameSummary game) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            GameDetailsScreen(slug: game.slug, gameId: game.id),
      ),
    );
  }
}

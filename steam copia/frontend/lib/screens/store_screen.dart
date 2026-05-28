import 'package:flutter/material.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/api/repository_provider.dart';
import 'package:frontend/screens/game_details_screen.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final _search = TextEditingController();
  Future<List<GameSummary>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _reload() {
    setState(() {
      _future = RepositoryProvider.games.listGames(q: _search.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Repository Selector (Debug/Development tool)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          color: Colors.black26,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Modo:',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              SegmentedButton<RepositoryMode>(
                showSelectedIcon: false,
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(fontSize: 10),
                ),
                segments: const [
                  ButtonSegment(value: RepositoryMode.api, label: Text('API')),
                  ButtonSegment(
                    value: RepositoryMode.hardcode,
                    label: Text('Hardcode'),
                  ),
                  ButtonSegment(
                    value: RepositoryMode.arraylist,
                    label: Text('ArrayList'),
                  ),
                ],
                selected: {RepositoryProvider.mode},
                onSelectionChanged: (Set<RepositoryMode> newSelection) {
                  setState(() {
                    RepositoryProvider.setMode(newSelection.first);
                    _reload();
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              children: [
                _buildBanner(),
                _buildCategories(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FutureBuilder<List<GameSummary>>(
                    future: _future,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      }
                      final games = snapshot.data ?? [];
                      if (games.isEmpty) {
                        return const Center(
                          child: Text('No hay juegos publicados'),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Todos los juegos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF66C0F4),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: games.length,
                            itemBuilder: (context, index) =>
                                _buildGameCard(games[index]),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xFF1B2838), const Color(0xFF171A21)],
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Bienvenido a SteamClon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF66C0F4),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu tienda de videojuegos favorita. Miles de títulos, un solo lugar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A475E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: const Text('Ver catálogo completo'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories() {
    final categories = ['Destacados', 'Nuevos', 'Más vendidos', 'Gratis'];
    return Container(
      height: 40,
      color: const Color(0xFF171A21),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                categories[index],
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGameCard(GameSummary game) {
    bool isFree = game.priceCents == 0;
    return Card(
      color: const Color(0xFF1B2838),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => GameDetailsScreen(slug: game.slug, gameId: game.id),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.black26,
                child: game.headerImageUrl != null
                    ? Image.network(game.headerImageUrl!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.gamepad,
                        size: 50,
                        color: Colors.white24,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    game.shortDescription,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        color: isFree
                            ? Colors.green.withOpacity(0.2)
                            : const Color(0xFF000000).withOpacity(0.3),
                        child: Text(
                          isFree
                              ? 'GRATIS'
                              : '\$${(game.priceCents / 100).toStringAsFixed(2)}',
                          style: TextStyle(
                            color: isFree
                                ? Colors.lightGreenAccent
                                : const Color(0xFF66C0F4),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        isFree ? 'Jugar ahora' : 'Ver detalle',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
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

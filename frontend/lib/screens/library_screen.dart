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
  final _filter = TextEditingController();
  String? _selectedGameId;

  @override
  void dispose() {
    _filter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.ownedGames;
    final cs = Theme.of(context).colorScheme;

    if (_selectedGameId == null && items.isNotEmpty) {
      _selectedGameId = items.first.gameId;
    }

    final query = _filter.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? items
        : items.where((g) => g.title.toLowerCase().contains(query)).toList();

    final selected = items.isEmpty
        ? null
        : items.firstWhere(
            (it) => it.gameId == _selectedGameId,
            orElse: () => items.first,
          );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;
        final sidebar = _buildSidebar(cs, filtered, selected?.gameId);
        final details = _buildDetails(cs, selected);

        if (!isWide) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [details, const SizedBox(height: 12), sidebar],
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 280, child: sidebar),
                const SizedBox(width: 16),
                Expanded(child: SingleChildScrollView(child: details)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSidebar(
    ColorScheme cs,
    List<LibraryItem> items,
    String? selectedId,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _filter,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                hintText: 'Buscar en la biblioteca',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: items.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'No hay resultados',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final it = items[index];
                      final selected = it.gameId == selectedId;
                      return InkWell(
                        onTap: () =>
                            setState(() => _selectedGameId = it.gameId),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          color: selected ? Colors.white.withAlpha(18) : null,
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(60),
                                  borderRadius: BorderRadius.circular(2),
                                  border: Border.all(color: Colors.white10),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  it.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Colors.white70,
                                    fontWeight: selected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails(ColorScheme cs, LibraryItem? selected) {
    if (selected == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white10),
        ),
        child: const Center(
          child: Text(
            'Aún no tienes juegos.\nVe a la tienda y añade algunos.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white54),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white10),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _headerImage(selected.headerImageUrl, selected.title),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withAlpha(160),
                            Colors.black.withAlpha(40),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          selected.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDetailsScreen(
                              slug: selected.slug,
                              gameId: selected.gameId,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('INICIAR'),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tiempo de uso: ${(selected.playtimeMinutes / 60).toStringAsFixed(1)} h',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      selected.lastPlayedAt == null
                          ? 'Última vez: —'
                          : 'Última vez: ${selected.lastPlayedAt!.split('T')[0]}',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    _tab('Actividad', selected: true),
                    const SizedBox(width: 10),
                    _tab(
                      'Centro de la comunidad',
                      selected: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDetailsScreen(
                              slug: selected.slug,
                              gameId: selected.gameId,
                              initialTabIndex: 1,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _tab(
                      'Tienda',
                      selected: false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameDetailsScreen(
                              slug: selected.slug,
                              gameId: selected.gameId,
                              initialTabIndex: 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.white10),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Actividad',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(40),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white10),
                ),
                padding: const EdgeInsets.all(12),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Comparte algo sobre este juego con tus amigos...',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tab(String label, {required bool selected, VoidCallback? onTap}) {
    final text = Text(
      label,
      style: TextStyle(
        color: selected ? Colors.white : Colors.white54,
        fontWeight: selected ? FontWeight.bold : FontWeight.w600,
        fontSize: 12,
      ),
    );
    if (onTap == null) return text;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(2),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: text,
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
}

import 'package:flutter/material.dart';
import 'package:frontend/api/api_client.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/api/repository_provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final _api = ApiClient();
  Future<List<LibraryItem>>? _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      // For now, if we are in API mode, use real API.
      // If in hardcode/arraylist mode, we'll just show some mock data for library.
      if (RepositoryProvider.mode == RepositoryMode.api) {
        _future = _api.getLibrary();
      } else {
        _future = _getMockLibrary();
      }
    });
  }

  Future<List<LibraryItem>> _getMockLibrary() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      LibraryItem(
        gameId: '1',
        slug: 'cyberpunk-2077',
        title: 'Cyberpunk 2077',
        playtimeMinutes: 120,
        acquiredAt: '2023-01-01',
        headerImageUrl:
            'https://cdn.akamai.steamstatic.com/steam/apps/1091500/header.jpg',
        lastPlayedAt: '2023-12-01',
      ),
      LibraryItem(
        gameId: '4',
        slug: 'elden-ring',
        title: 'Elden Ring',
        playtimeMinutes: 450,
        acquiredAt: '2022-03-01',
        headerImageUrl:
            'https://cdn.akamai.steamstatic.com/steam/apps/1245620/header.jpg',
        lastPlayedAt: '2023-11-20',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mi biblioteca',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF66C0F4),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tienes 2 juegos en tu biblioteca.',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white10),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => _reload(),
            child: FutureBuilder<List<LibraryItem>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                final items = snapshot.data ?? [];

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount:
                      items.length + 1, // +1 for the "Add game" placeholder
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return _buildAddGamePlaceholder();
                    }
                    return _buildLibraryCard(items[index]);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLibraryCard(LibraryItem item) {
    return Card(
      color: const Color(0xFF1B2838),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black26,
              child: const Center(
                child: Icon(Icons.gamepad, size: 40, color: Colors.white24),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  'RPG', // Mock category
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_outlined, size: 16),
                        SizedBox(width: 4),
                        Text('JUGAR', style: TextStyle(fontSize: 12)),
                      ],
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

  Widget _buildAddGamePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Colors.white10, size: 30),
          SizedBox(height: 8),
          Text(
            'Agregar juego',
            style: TextStyle(color: Colors.white10, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/api/api_client.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/api/repository_provider.dart';

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
  final _api = ApiClient();
  Future<GameDetails>? _future;
  bool _buying = false;

  @override
  void initState() {
    super.initState();
    _future = RepositoryProvider.games.getGameDetails(widget.slug);
  }

  Future<void> _buy() async {
    setState(() => _buying = true);
    try {
      if (RepositoryProvider.mode == RepositoryMode.api) {
        await _api.purchase([widget.gameId]);
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
      
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(
        content: Text('¡Compra realizada con éxito!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.redAccent,
      ));
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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

          return ListView(
            padding: const EdgeInsets.all(0),
            children: [
              if (g.headerImageUrl != null)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    g.headerImageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black26,
                      child: const Icon(Icons.broken_image, size: 100, color: Colors.white24),
                    ),
                  ),
                )
              else
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black26,
                    child: const Icon(Icons.gamepad, size: 100, color: Colors.white24),
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
                          ElevatedButton(
                            onPressed: _buying ? null : _buy,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2A475E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                            child: _buying
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : Text(isFree ? 'OBTENER' : 'COMPRAR'),
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

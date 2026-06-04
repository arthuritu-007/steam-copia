import 'package:flutter/material.dart';
import 'package:frontend/api/repository_provider.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _userIdController = TextEditingController();
  final _gameIdController = TextEditingController();
  final _postIdController = TextEditingController();
  final _giftUserIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _gameIdController.dispose();
    _postIdController.dispose();
    _giftUserIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Administración')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: cs.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PANEL DE ADMINISTRACIÓN',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Moderación y acciones rápidas',
                        style: TextStyle(
                          color: Colors.white.withAlpha(179),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  final cardWidth = isWide
                      ? (constraints.maxWidth - 16) / 2
                      : constraints.maxWidth;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _buildSection(
                          context: context,
                          title: 'Gestión de usuarios',
                          subtitle: 'Baneo y desbloqueo por ID',
                          children: [
                            TextField(
                              controller: _userIdController,
                              decoration: const InputDecoration(
                                labelText: 'ID del usuario',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _banUser,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Banear'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _unbanUser,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Quitar baneo'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSection(
                          context: context,
                          title: 'Regalar juego',
                          subtitle:
                              'Añade un juego a la biblioteca de un usuario',
                          children: [
                            TextField(
                              controller: _giftUserIdController,
                              decoration: const InputDecoration(
                                labelText: 'ID del usuario',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _gameIdController,
                              decoration: const InputDecoration(
                                labelText: 'ID del juego',
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _giftGame,
                                child: const Text('Regalar'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _buildSection(
                          context: context,
                          title: 'Moderación de comunidad',
                          subtitle: 'Elimina publicaciones por ID',
                          children: [
                            TextField(
                              controller: _postIdController,
                              decoration: const InputDecoration(
                                labelText: 'ID del post',
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _deletePost,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: const Text('Eliminar publicación'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Future<void> _banUser() async {
    try {
      await RepositoryProvider.games.banUser(_userIdController.text);
      _showMsg('Usuario baneado');
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _unbanUser() async {
    try {
      await RepositoryProvider.games.unbanUser(_userIdController.text);
      _showMsg('Baneo quitado');
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _giftGame() async {
    try {
      await RepositoryProvider.games.giftGame(
        _giftUserIdController.text,
        _gameIdController.text,
      );
      _showMsg('Juego regalado con éxito');
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _deletePost() async {
    try {
      await RepositoryProvider.games.deletePost(_postIdController.text);
      _showMsg('Post eliminado');
    } catch (e) {
      _showError(e);
    }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showError(dynamic e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
    );
  }
}

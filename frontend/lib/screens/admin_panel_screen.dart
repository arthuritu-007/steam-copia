import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:frontend/api/api_client.dart';
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

  // Create game controllers
  final _newGameTitleController = TextEditingController();
  final _newGameSlugController = TextEditingController();
  final _newGameShortDescController = TextEditingController();
  final _newGameLongDescController = TextEditingController();
  final _newGamePriceController = TextEditingController();
  final _newGameImageController = TextEditingController();
  String? _pickedImageUrl;
  String? _pickedImageName;

  @override
  void dispose() {
    _userIdController.dispose();
    _gameIdController.dispose();
    _postIdController.dispose();
    _giftUserIdController.dispose();
    _newGameTitleController.dispose();
    _newGameSlugController.dispose();
    _newGameShortDescController.dispose();
    _newGameLongDescController.dispose();
    _newGamePriceController.dispose();
    _newGameImageController.dispose();
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
                      SizedBox(
                        width: isWide ? constraints.maxWidth : cardWidth,
                        child: _buildSection(
                          context: context,
                          title: 'Agregar juego',
                          subtitle: 'Crea un nuevo juego en la tienda',
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _newGameTitleController,
                                    decoration: const InputDecoration(labelText: 'Título'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _newGameSlugController,
                                    decoration: const InputDecoration(labelText: 'Slug (ej: elden-ring)'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _newGameShortDescController,
                              decoration: const InputDecoration(labelText: 'Descripción corta'),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _newGameLongDescController,
                              decoration: const InputDecoration(labelText: 'Descripción larga'),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _newGamePriceController,
                                    decoration: const InputDecoration(labelText: 'Precio (en centavos, ej: 2999)'),
                                    keyboardType: TextInputType.number,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF32353C),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.white10),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.image, color: Colors.white54, size: 20),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              _pickedImageName ?? 'Seleccionar imagen',
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: _pickedImageName != null ? Colors.white : Colors.white38,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          if (_pickedImageName != null)
                                            const Icon(Icons.check_circle, color: Colors.green, size: 16),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _createGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                child: const Text('Crear juego'),
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

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    final supabase = Supabase.instance.client;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    try {
      await supabase.storage.from('game-images').uploadBinary(
        fileName,
        file.bytes!,
        fileOptions: FileOptions(contentType: file.extension != null ? 'image/${file.extension}' : 'image/jpeg'),
      );
      final url = supabase.storage.from('game-images').getPublicUrl(fileName);
      setState(() {
        _pickedImageUrl = url;
        _pickedImageName = file.name;
      });
    } catch (e) {
      _showError('Error al subir imagen: $e');
    }
  }

  Future<void> _createGame() async {
    final title = _newGameTitleController.text.trim();
    final slug = _newGameSlugController.text.trim();
    final shortDesc = _newGameShortDescController.text.trim();
    final longDesc = _newGameLongDescController.text.trim();
    final priceText = _newGamePriceController.text.trim();

    if (title.isEmpty || slug.isEmpty || shortDesc.isEmpty || longDesc.isEmpty || priceText.isEmpty) {
      _showError('Completa todos los campos obligatorios');
      return;
    }
    final price = int.tryParse(priceText);
    if (price == null || price < 0) {
      _showError('El precio debe ser un número entero en centavos (ej: 2999)');
      return;
    }
    try {
      final api = ApiClient();
      await api.createGame(
        slug: slug,
        title: title,
        shortDescription: shortDesc,
        longDescription: longDesc,
        priceCents: price,
        currency: 'USD',
        headerImageUrl: _pickedImageUrl,
      );
      _newGameTitleController.clear();
      _newGameSlugController.clear();
      _newGameShortDescController.clear();
      _newGameLongDescController.clear();
      _newGamePriceController.clear();
      _newGameImageController.clear();
      setState(() {
        _pickedImageUrl = null;
        _pickedImageName = null;
      });
      _showMsg('Juego creado con éxito');
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

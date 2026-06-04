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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF171A21),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'PANEL DE ADMINISTRACIÓN',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 32),
          
          _buildSection(
            title: 'GESTIÓN DE USUARIOS',
            children: [
              TextField(
                controller: _userIdController,
                decoration: const InputDecoration(labelText: 'ID del Usuario', labelStyle: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _banUser(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('BANEAR USUARIO'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _unbanUser(),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('QUITAR BANEO'),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            title: 'REGALAR JUEGO',
            children: [
              TextField(
                controller: _gameIdController,
                decoration: const InputDecoration(labelText: 'ID del Juego', labelStyle: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _giftGame(),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF66C0F4)),
                child: const Text('REGALAR JUEGO AL USUARIO'),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          _buildSection(
            title: 'MODERACIÓN DE COMUNIDAD',
            children: [
              TextField(
                controller: _postIdController,
                decoration: const InputDecoration(labelText: 'ID del Post', labelStyle: TextStyle(color: Colors.white54)),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _deletePost(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('ELIMINAR PUBLICACIÓN'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1B2838),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF66C0F4))),
          const Divider(color: Colors.white10, height: 24),
          ...children,
        ],
      ),
    );
  }

  Future<void> _banUser() async {
    try {
      await RepositoryProvider.games.banUser(_userIdController.text);
      _showMsg('Usuario baneado');
    } catch (e) { _showError(e); }
  }

  Future<void> _unbanUser() async {
    try {
      await RepositoryProvider.games.unbanUser(_userIdController.text);
      _showMsg('Baneo quitado');
    } catch (e) { _showError(e); }
  }

  Future<void> _giftGame() async {
    try {
      await RepositoryProvider.games.giftGame(_userIdController.text, _gameIdController.text);
      _showMsg('Juego regalado con éxito');
    } catch (e) { _showError(e); }
  }

  Future<void> _deletePost() async {
    try {
      await RepositoryProvider.games.deletePost(_postIdController.text);
      _showMsg('Post eliminado');
    } catch (e) { _showError(e); }
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showError(dynamic e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
  }
}

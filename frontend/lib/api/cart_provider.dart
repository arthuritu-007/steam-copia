import 'package:flutter/material.dart';
import 'models.dart';

class CartProvider extends ChangeNotifier {
  final List<GameSummary> _items = [];
  final List<LibraryItem> _ownedGames = [];

  List<GameSummary> get items => List.unmodifiable(_items);
  List<LibraryItem> get ownedGames => List.unmodifiable(_ownedGames);

  int get count => _items.length;

  double get total => _items.fold(0, (sum, item) => sum + (item.priceCents / 100));

  void addItem(GameSummary game) {
    if (!_items.any((item) => item.id == game.id) && 
        !_ownedGames.any((item) => item.gameId == game.id)) {
      _items.add(game);
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  bool isOwned(String gameId) {
    return _ownedGames.any((item) => item.gameId == gameId);
  }

  void purchase() {
    for (var game in _items) {
      _ownedGames.add(LibraryItem(
        gameId: game.id,
        slug: game.slug,
        title: game.title,
        headerImageUrl: game.headerImageUrl,
        acquiredAt: DateTime.now().toIso8601String(),
        playtimeMinutes: 0,
        lastPlayedAt: null,
      ));
    }
    _items.clear();
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

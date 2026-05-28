import 'package:flutter/material.dart';
import 'models.dart';

class CartProvider extends ChangeNotifier {
  final List<GameSummary> _items = [];

  List<GameSummary> get items => List.unmodifiable(_items);

  int get count => _items.length;

  double get total => _items.fold(0, (sum, item) => sum + (item.priceCents / 100));

  void addItem(GameSummary game) {
    if (!_items.any((item) => item.id == game.id)) {
      _items.add(game);
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

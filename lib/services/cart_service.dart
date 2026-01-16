import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartService extends ChangeNotifier {
  CartService._internal();
  static final CartService instance = CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(CartItem item) {
    final existing = _items.where((i) => i.id == item.id).toList();
    if (existing.isNotEmpty) {
      existing.first.quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void increment(String id) {
    final it = _items.where((i) => i.id == id).toList();
    if (it.isNotEmpty) {
      it.first.quantity++;
      notifyListeners();
    }
  }

  void decrement(String id) {
    final it = _items.where((i) => i.id == id).toList();
    if (it.isNotEmpty) {
      final item = it.first;
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _items.remove(item);
      }
      notifyListeners();
    }
  }

  int get totalItems => _items.fold(0, (s, i) => s + i.quantity);

  int get totalPrice => _items.fold(0, (s, i) => s + i.quantity * i.price);

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

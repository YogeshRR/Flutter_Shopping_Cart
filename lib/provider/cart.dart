import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  int quantity;
  double price;

  CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get cartItemCount {
    return _items.length;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItemFromCart(String productId) {
    if (_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 0) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          title: existingCartItem.title,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  double get totalAmount {
    var totalAmountCalculated = 0.0;
    _items.forEach((key, productItem) {
      totalAmountCalculated += productItem.price * productItem.quantity;
    });
    return totalAmountCalculated;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
                title: existingCartItem.title,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}

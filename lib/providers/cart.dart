import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.price,
      @required this.quantity,
      @required this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cart {
    return {..._cartItems};
  }

  void addToCart(String prodId, double price, String title) {
    if (_cartItems.containsKey(prodId)) {
      _cartItems.update(
          prodId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity + 1));
    } //Increse Quantity
    else {
      _cartItems.putIfAbsent(
          prodId,
          () => CartItem(
              id: DateTime.now().toString(),
              price: price,
              quantity: 1,
              title: title));
    } //Add To Cart
    notifyListeners();
  }

  int get cartItemCount {
    return _cartItems == null ? 0 : _cartItems.length;
  }

  double get paymentAmt {
    var sum = 0.0;
    _cartItems.forEach((key, item) {
      sum += item.price * item.quantity;
    });
    return sum;
  }

  void removeItem(String prodId) {
    _cartItems.remove(prodId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }

  void removeSingleItem(String prodId) {
    if (!_cartItems.containsKey(prodId)) {
      return;
    }
    if (_cartItems[prodId].quantity > 1) {
      _cartItems.update(
          prodId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1));
    } else {
      _cartItems.remove(prodId);
    }
    notifyListeners();
  }
}

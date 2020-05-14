import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  void _setFavorite(bool val) {
    isFavorite = val;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url =
        'https://flutter-shop-62b24.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    final oldChoice = isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavorite(oldChoice);
      }
    } catch (error) {
      _setFavorite(oldChoice);
    }
  }
}

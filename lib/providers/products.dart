import 'package:flutter/material.dart';
import '../models/exceptionHandling.dart';
import './product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  //Provider
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((prodId) => prodId.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filteredProducts =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://flutter-shop-62b24.firebaseio.com/products.json?auth=$authToken&$filteredProducts';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final fUrl =
          'https://flutter-shop-62b24.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favProd = await http.get(fUrl);
      final favoriteData = json.decode(favProd.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-shop-62b24.firebaseio.com/products.json?auth=$authToken';
    try {
      final res = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId
          }));
      final newProduct = new Product(
          id: json.decode(res.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      //_items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product existingProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-shop-62b24.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': existingProduct.title,
            'description': existingProduct.description,
            'imageUrl': existingProduct.imageUrl,
            'price': existingProduct.price
          }));
      _items[prodIndex] = existingProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-shop-62b24.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw ExceptionHandler('Delete Product Failed');
    }
    existingProduct = null;
  }
}

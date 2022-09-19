import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  late String userId;
  late String authToken;

  getData(String uId, String authTok, List<Product> products) {
    userId = uId;
    authToken = authTok;
    _items = products;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere(
      (prod) => prod.id == id,
    );
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    var filteredString =
    filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    Uri url = Uri.parse(
        'https://shopa-6ea99-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filteredString');
    try {
      var res = await http.get(url);
      final extractedDate = json.decode(res.body) as Map<String, dynamic>?;
      if (extractedDate == null) {
        return;
      }
      url = Uri.parse(
          'https://shopa-6ea99-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      var fevRes = await http.get(url);
      final fevData = json.decode(fevRes.body);

      List<Product> loadedProducts = [];
      extractedDate.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              isFavorite:
              fevData[prodId] == null ? false : fevData[prodId] ?? false),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      //throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final Uri url = Uri.parse(
        'https://shopa-6ea99-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final res = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
          }));
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final Uri url = Uri.parse(
          'https://shopa-6ea99-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final Uri url = Uri.parse(
        'https://shopa-6ea99-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[prodIndex];
    _items.removeAt(prodIndex);
    notifyListeners();

    final res = await http.delete(url);
    if (res.statusCode >= 400) {
      _items.insert(prodIndex, existingProduct);
      notifyListeners();
      throw HttpException('COULD NOT DELETE PRODUCT!!');
    }
    existingProduct = null;
  }
}

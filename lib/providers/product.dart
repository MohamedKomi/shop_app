import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  late bool isFavorite;

  Product(
      {required this.id,
        required this.title,
        required this.description,
        required this.imageUrl,
        required this.price,
        this.isFavorite = false});

  void _setNewValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final Uri url = Uri.parse('https://shopa-6ea99-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    try {
      final res = await http.put(url, body: json.encode(isFavorite));
      if (res.statusCode >= 400) {
        _setNewValue(oldStatus);
      }
    } catch (e) {
      _setNewValue(oldStatus);
    }
  }
}

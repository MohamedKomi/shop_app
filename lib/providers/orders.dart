import 'package:flutter/material.dart';
import 'package:test_a/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  late String userId;
  late String authToken;

  getData(String uId, String authTok, List<OrderItem>? orders) {
    userId = uId;
    authToken = authTok;
    _orders = orders!;
  }

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    Uri url = Uri.parse(
        'https://shopa-6ea99-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      var res = await http.get(url);
      final extractedDate = json.decode(res.body) as Map<String, dynamic>?;
      if (extractedDate == null) {
        return;
      }

      List<OrderItem> loadedOrders = [];
      extractedDate.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final Uri url = Uri.parse(
        'https://shopa-6ea99-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    try {
      final timeStamp = DateTime.now();

      final res = await http.post(
        url,
        body: json.encode(
          {
            'dateTime': timeStamp.toIso8601String(),
            'amount': total,
            'products': cartProduct
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price
                    })
                .toList(),
          },
        ),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(res.body)['name'],
          amount: total,
          products: cartProduct,
          dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:http/http.dart' as http;

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
  final String? authToken;
  final String? userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken',
    );

    final dateTime = DateTime.now();
    await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': dateTime.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));
    _orders.insert(
      0,
      OrderItem(
        id: dateTime.toString(),
        amount: total,
        products: cartProducts,
        dateTime: dateTime,
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
      'https://myshop-838c2-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken',
    );
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((key, value) {
      loadedOrders.add(OrderItem(
        id: key,
        amount: value['amount'],
        products: (value['products'] as List<dynamic>)
            .map(
              (items) => CartItem(
                id: items['id'],
                title: items['title'],
                quantity: items['quantity'],
                price: items['price'],
              ),
            )
            .toList(),
        dateTime: DateTime.parse(
          value['dateTime'],
        ),
      ));
    });
    _orders = loadedOrders;

    notifyListeners();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.dateTime,
      required this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var dateTimeCurrent = DateTime.now();
    var url = Uri.parse(
        'https://fluttershopapp-c2f4d-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'amount': total,
            'dateTime': dateTimeCurrent.toIso8601String(),
            'products': cartProducts
                .map(
                  (cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'price': cartProduct.price,
                  },
                )
                .toList(),
          },
        ),
      );

      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: DateTime.now(),
            products: cartProducts),
      );
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }
}

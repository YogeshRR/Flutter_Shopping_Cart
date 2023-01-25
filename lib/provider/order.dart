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

  Future<void> fetchProductsAndSet() async {
    var url = Uri.parse(
        'https://fluttershopapp-c2f4d-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == <String, dynamic>{}) {
        return;
      }
      extractedData.forEach(
        (orderId, orderData) {
          loadedOrders.add(OrderItem(
              id: orderId,
              amount: orderData['amount'],
              dateTime: DateTime.parse(orderData['dateTime']),
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
                  )
                  .toList()));
        },
      );
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
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

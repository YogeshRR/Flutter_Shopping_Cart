import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    this.isFavourite = false,
    required this.price,
    required this.title,
  });

  Future<void> toogleFavorite() async {
    var oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    try {
      var url = Uri.parse(
          'https://fluttershopapp-c2f4d-default-rtdb.firebaseio.com/products/$id.json');
      var response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavourite': isFavourite,
          },
        ),
      );
      if (response.statusCode >= 400) {
        isFavourite = oldStatus;
        notifyListeners();
      }
    } catch (error) {
      isFavourite = oldStatus;
      notifyListeners();
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  String token;

  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

  Products(this._items, this.token);

  //List<Product> _items = [];
  bool _showFavorite = false;

  Product findProductById(String Id) {
    return items.firstWhere(
      (product) => product.id == Id,
    );
  }

  List<Product> get items {
    // if (_showFavorite == true) {
    //   return _items.where((productItem) => productItem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavourite).toList();
  }

  // void showFavorite() {
  //   _showFavorite = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavorite = false;
  //   notifyListeners();
  // }

  Future<void> fetchProductsAndSet() async {
    var url = Uri.parse(
        'https://fluttershopapp-c2f4d-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      final response = await http.get(url);
      //print(json.decode(response.body));
      var extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      List<Product> loadedData = [];
      if (extractedData == <String, dynamic>{}) {
        return;
      }
      extractedData.forEach(
        (productId, prodData) {
          loadedData.add(
            Product(
              description: prodData['description'],
              id: productId,
              imageUrl: prodData['imageUrl'],
              price: prodData['price'],
              title: prodData['title'],
              isFavourite: prodData['isFavourite'],
            ),
          );
        },
      );
      _items = loadedData;
      print(_items);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://fluttershopapp-c2f4d-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'description': product.description,
            'isFavourite': product.isFavourite
          },
        ),
      );

      var _newProduct = Product(
          description: product.description,
          id: json.decode(response.body)['name'],
          imageUrl: product.imageUrl,
          title: product.title,
          price: product.price);
      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> updateProduct(String productId, Product editableProduct) async {
    var selectedIndex = _items.indexWhere((prod) => prod.id == productId);
    if (selectedIndex >= 0) {
      var url = Uri.parse(
          'https://fluttershopapp-c2f4d-default-rtdb.firebaseio.com/products/$productId.json');
      http.patch(url,
          body: json.encode({
            'title': editableProduct.title,
            'description': editableProduct.description,
            'price': editableProduct.price,
            'imageUrl': editableProduct.imageUrl,
          }));
      _items[selectedIndex] = editableProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    var url = Uri.parse(
        'https://fluttershopapp-c2f4d-default-rtdb.firebaseio.com/products/$productId');
    var productItemIndex = _items.indexWhere((prod) => prod.id == productId);
    Product? existingProduct = _items.elementAt(productItemIndex);
    _items.removeAt(productItemIndex);
    notifyListeners();
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(productItemIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete Product');
    } else {
      existingProduct = null;
    }
  }
}

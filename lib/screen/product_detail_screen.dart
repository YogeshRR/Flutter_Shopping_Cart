import 'package:flutter/material.dart';
//import '../model/product.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_detail.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/ProductDetailScreen';
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findProductById(
      productId,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network(
                loadedProduct.imageUrl,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text('\$${loadedProduct.price}'),
            const SizedBox(
              height: 10,
            ),
            Text(
              loadedProduct.description,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}

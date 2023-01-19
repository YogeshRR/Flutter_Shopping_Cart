import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/products_detail.dart';
import '../widget/product_item.dart';

class Product_grid extends StatelessWidget {
  bool isFavorite;
  Product_grid({
    Key? key,
    required this.isFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productdata = Provider.of<Products>(context);
    final products = isFavorite ? productdata.favoriteItems : productdata.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        // create: (BuildContext context) => products[i],
        child: const ProductItem(
            //   // id: products[i].id,
            //   // imageurl: products[i].imageUrl,
            //   // title: products[i].title,
            ),
      ),
      padding: const EdgeInsets.all(
        10,
      ),
      itemCount: products.length,
    );
  }
}

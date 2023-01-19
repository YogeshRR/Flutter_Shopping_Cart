import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../screen/cart_screen.dart';
import '../provider/cart.dart';
import '../widget/badge.dart';
import '../widget/product_grid.dart';

enum FavoriteOptions {
  Favorite,
  All,
}

class ProductOverViewScreen extends StatefulWidget {
  ProductOverViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  bool _isFavorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My shop',
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FavoriteOptions selectedValue) {
              setState(() {
                if (selectedValue == FavoriteOptions.Favorite) {
                  _isFavorite = true;
                } else {
                  _isFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FavoriteOptions.Favorite,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FavoriteOptions.All,
                child: Text('All Items'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.cartItemCount.toString(),
              color: Colors.red,
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Product_grid(
        isFavorite: _isFavorite,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screen/product_edit_screen.dart';

import '../provider/products_detail.dart';
import '../widget/app_drawer.dart';
import '../widget/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/UserProductScreen';
  const UserProductsScreen({Key? key}) : super(key: key);
  Future<void> refreshProducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchProductsAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Products Screen',
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                EditProductScreen.routeName,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, index) => Column(
              children: [
                UserProductItem(
                  id: productsData.items[index].id,
                  imageUrl: productsData.items[index].imageUrl,
                  title: productsData.items[index].title,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

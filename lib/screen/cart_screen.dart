import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/widget/CartListItem.dart';

import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/Cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cartTotal = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Screen'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartTotal.totalAmount}',
                      style: TextStyle(
                        color:
                            Theme.of(context).primaryTextTheme.headline6?.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      Provider.of<Order>(context, listen: false).addOrder(
                        cartTotal.items.values.toList(),
                        cartTotal.totalAmount,
                      );
                      //cartTotal.addItem(productId, price, title)
                      cartTotal.clearCart();
                    },
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: ((ctx, i) => CartListItem(
                  id: cartTotal.items.values.toList()[i].id,
                  productId: cartTotal.items.keys.toList()[i],
                  price: cartTotal.items.values.toList()[i].price,
                  quantity: cartTotal.items.values.toList()[i].quantity,
                  title: cartTotal.items.values.toList()[i].title)),
              itemCount: cartTotal.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

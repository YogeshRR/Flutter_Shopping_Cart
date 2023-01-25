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
                  OrderButton(cartTotal: cartTotal),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartTotal,
  }) : super(key: key);

  final Cart cartTotal;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cartTotal.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                widget.cartTotal.items.values.toList(),
                widget.cartTotal.totalAmount,
              );
              setState(() {
                _isLoading = false;
              });
              //cartTotal.addItem(productId, price, title)
              widget.cartTotal.clearCart();
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : Text(
              'ORDER NOW',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}

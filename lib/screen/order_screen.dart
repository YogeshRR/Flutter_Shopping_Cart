import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../provider/order.dart' show Order;
import '../widget/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orderScreen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail Screen'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Order>(context, listen: false).fetchProductsAndSet(),
        builder: (context, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (dataSnapShot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('Some Error Occured'),
            );
          } else {
            return Consumer<Order>(
              builder: (context, orderData, child) => ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (context, index) =>
                    OrderItem(order: orderData.orders[index]),
              ),
            );
          }
        },
      ),
    );
  }
}

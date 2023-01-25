import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/app_drawer.dart';
import '../provider/order.dart' show Order;
import '../widget/order_item.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/orderScreen';
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Order>(context, listen: false).fetchProductsAndSet();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail Screen'),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (context, index) =>
                  OrderItem(order: orderData.orders[index]),
            ),
    );
  }
}

//ListView.builder(itemCount: orderData.orders.length, itemBuilder: (ctx, i => OrderItem),),

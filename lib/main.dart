import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/auth_user.dart';

import '../screen/product_edit_screen.dart';
import './provider/order.dart';
import './screen/cart_screen.dart';
import './provider/cart.dart';
import './screen/products_overview_screen.dart';
import './screen/product_detail_screen.dart';
import './provider/products_detail.dart';
import '../screen/order_screen.dart';
import '../screen/user_products_screen.dart';
import '../screen/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: ((ctx) => Auth()),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products([], ''),
          update: (ctx, auth, previousProduct) =>
              Products(previousProduct!.items, auth.token as String),
        ),
        ChangeNotifierProvider(
          create: (ctd) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.orange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductOverViewScreen() : const AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrderScreen.routeName: (context) => const OrderScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}

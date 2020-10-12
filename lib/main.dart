import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/screens/cart_screen.dart';

import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.yellow,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductsOverviewScreen(),
        routes: {
          '/product-detail': (ctx) => ProductDetail(),
          '/user-products': (ctx) => UserProduct(),
          '/edit-product': (ctx) => EditProduct(),
          '/cart': (ctx) => CartScreen(),
        },
      ),
    );
  }
}

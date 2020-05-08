import 'package:flutter/material.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop  ',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato'),
      home: ProductsOverviewScreen(),
      routes: {ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen()},
    );
  }
}

import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  //final String title;
  //final double price;
  //ProductDetailsScreen(this.title,this.price);
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 2,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      cart.paymentAmt.toString(),
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  cart.cartItemCount != 0
                      ? FlatButton(
                          child: Text('Continue To Payment'),
                          onPressed: () {
                            Provider.of<Orders>(context, listen: false)
                                .addOrder(
                                    cart.cart.values.toList(), cart.paymentAmt);
                            cart.clearCart();
                          },
                          textColor: Theme.of(context).primaryColor,
                        )
                      : Column(
                          children: <Widget>[Text('No Items added yet')],
                        )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartItem(
                cart.cart.values.toList()[i].id,
                cart.cart.keys.toList()[i],
                cart.cart.values.toList()[i].price,
                cart.cart.values.toList()[i].quantity,
                cart.cart.values.toList()[i].title),
            itemCount: cart.cartItemCount,
          ))
        ],
      ),
    );
  }
}

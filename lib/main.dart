import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

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
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, prevProducts) => Products(auth.token,
                auth.userId, prevProducts == null ? [] : prevProducts.items),
            create: null,
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, prevOrders) => Orders(auth.token,
                prevOrders == null ? [] : prevOrders.orders, auth.userId),
            create: null,
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop  ',
            theme: ThemeData(
                primarySwatch: Colors.lightBlue,
                accentColor: Colors.deepOrangeAccent,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransition(),
                  TargetPlatform.iOS: CustomPageTransition()
                })),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, authRes) =>
                        authRes.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen()
            },
          ),
        ));
  }
}

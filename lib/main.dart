import 'package:flutter/material.dart';
import 'package:myshop/animations/custom_route.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/orders.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:myshop/screens/auth_screen.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:myshop/screens/products_overview_screen.dart';
import 'package:myshop/screens/splash_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /**
     * when we are creating a new instance of an object, we should use create method.
     * when we are re-using the existing object, then we should use .value constructor.
     */
    return MultiProvider(
      providers: [
        //Create is the best practice.
        ChangeNotifierProvider(
          create: ((context) => Auth()),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (context, auth, previous) =>
              Products(auth.token, previous!.items, auth.userId),
          create: (BuildContext context) => Products(null, [], null),
        ),
        //Both are same.
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, value, previous) => Orders(
            value.token!,
            value.userId,
            previous == null ? [] : previous.orders,
          ),
          create: (context) => Orders(null, null, []),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? const ProductsOverViewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (context) =>
                const ProductDetailScreen(),
            CartScreen.routeName: (context) => const CartScreen(),
            OrdersScreen.routeName: (context) => const OrdersScreen(),
            UserProductsScreen.routeName: (context) =>
                const UserProductsScreen(),
            EditProductScreen.routeName: (context) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}

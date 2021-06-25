import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    /* this is provided by the provider package.
    so, when ever there is change, only the child widgets that have change will get re-build, but not the entire application.*/
    return ChangeNotifierProvider(
      /* the provider version in the dependencies is higher than 3, then use "create".*/
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        /*
        below we mention all the route to pass data from any screen to any screen.
        */
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
        },
      ),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

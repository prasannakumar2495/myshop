import 'package:flutter/material.dart';
import 'package:myshop/screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewScreen(),
    );
  }
}

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold();
//   }
// }

import 'package:flutter/material.dart';

import '../widgets/products_grid_view.dart';

class ProductsOverViewScreen extends StatelessWidget {
  const ProductsOverViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),
      body: const ProductsGridView(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid_view.dart';

enum FilterOptions {
  mFavourites,
  mAll,
}

class ProductsOverViewScreen extends StatefulWidget {
  const ProductsOverViewScreen({super.key});

  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  var _showOnlyFavourites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              debugPrint('$selectedValue');
              setState(() {
                if (selectedValue == FilterOptions.mFavourites) {
                  _showOnlyFavourites = true;
                } else {
                  _showOnlyFavourites = false;
                }
              });
            },
            itemBuilder: ((context) => [
                  const PopupMenuItem(
                    value: FilterOptions.mFavourites,
                    child: Text('Only Favourites'),
                  ),
                  const PopupMenuItem(
                    value: FilterOptions.mAll,
                    child: Text('Show All'),
                  ),
                ]),
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: ProductsGridView(
        showOnlyFavourites: _showOnlyFavourites,
      ),
    );
  }
}

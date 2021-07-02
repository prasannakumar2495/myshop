import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  // we are implementing this, to use these values instead of using 0&1 because they make more sense.
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MyShop',
        ),
        // We added the 3 dots button.
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favorites) {
                productsContainer.showFavoritesOnly();
              } else {
                productsContainer.showAll();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                ),
                value: FilterOptions.All,
              ),
            ],
            icon: Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
      body: ProductsGrid(),
    );
  }
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/screens/cart_screen.dart';
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
                  //Here we are adding the list that should be displayed.
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
          Consumer<Cart>(
            builder: ((context, value, child) => Badge(
                  position: BadgePosition.topEnd(
                    top: 2,
                    end: 1,
                  ),
                  badgeContent: Text(value.itemCount.toString()),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                )),
          ),
        ],
      ),
      body: ProductsGridView(
        showOnlyFavourites: _showOnlyFavourites,
      ),
    );
  }
}

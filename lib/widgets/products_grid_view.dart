import 'package:flutter/material.dart';
import 'package:myshop/providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductsGridView extends StatelessWidget {
  final bool showOnlyFavourites;
  const ProductsGridView({
    Key? key,
    required this.showOnlyFavourites,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showOnlyFavourites ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      /**
      * using .value constructor is prefered, when we have any lists.
      * bcz, .create constructor will give errors when, the list is beyound screen size.

      * when we are creating a new instance of an object, we should use create method.
      * when we are re-using the existing object, then we should use .value constructor.
      */
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            //create: (context) => products[index],
            value: products[index],
            child: const ProductItem(
                // id: products[index].id,
                // title: products[index].title,
                // imageUrl: products[index].imageUrl,
                ),
          )),
    );
  }
}

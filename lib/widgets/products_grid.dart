import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*we are informing the provider, to notify when the changed data type is "Products".*/
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(
        10,
      ),
      /* the number of items that will be created, based on the leght of the loadedproducts. */
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(
        products[i].id,
        products[i].title,
        products[i].imageUrl,
      ),
      /* the below will define the structure of the grid. */
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // this is to mention the number of columns.
        crossAxisCount: 2,
        // this is to define the size of the widgets.
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

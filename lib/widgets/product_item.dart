import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem({
    super.key,
    // required this.id,
    // required this.title,
    // required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    //we don't add the listener here, bcz we want to listen to clicks on the favourite button.
    //Later in the course we added listen:false, bcz we are using Consumer.

    // return ClipRRect(
    //   borderRadius: BorderRadius.circular(10),
    //   child: GridTile(
    //     footer: GridTileBar(
    //       leading: IconButton(
    //         color: Theme.of(context).colorScheme.secondary,
    //         icon: Icon(
    //           product.isFavorite ? Icons.favorite : Icons.favorite_border,
    //         ),
    //         onPressed: (() {
    //           product.toggleFavouriteStatus();
    //         }),
    //       ),
    //       backgroundColor: Colors.black87,
    //       title: Text(
    //         product.title,
    //         textAlign: TextAlign.center,
    //       ),
    //       trailing: IconButton(
    //         color: Theme.of(context).colorScheme.secondary,
    //         icon: const Icon(Icons.shopping_cart),
    //         onPressed: (() {}),
    //       ),
    //     ),
    //     child: GestureDetector(
    //       onTap: () {
    //         Navigator.of(context).pushNamed(
    //           ProductDetailScreen.routeName,
    //           arguments: product.id,
    //         );
    //       },
    //       child: Image.network(
    //         product.imageUrl,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   ),
    // );

    /**
     * there is another way of listening to changes. (i.e:) using consumer.
     * the advantage of using Consumer is, we can apply it to the part of the application, which will under go change but not the entire screen.
         */
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: Consumer<Product>(
            /** we are applying consumer here, bcz Favourite icon is the only one that will be changed.*/
            builder: (context, product, child) => IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: (() {
                product.toggleFavouriteStatus(context);
              }),
            ),
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.shopping_cart),
            onPressed: (() {
              cart.addItem(
                product.id!,
                product.price,
                product.title,
              );
              //Showing SnackBar
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Added item to cart!',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: (() {
                      cart.removeSingleItem(product.id!);
                    }),
                  ),
                ),
              );
            }),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
